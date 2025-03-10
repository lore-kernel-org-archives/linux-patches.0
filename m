Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0FC5227EA0;
	Mon, 10 Mar 2025 17:59:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741629559; cv=none; b=Mh9OUQ0lOQ/PW6aFMEm49YXNHm0W1blwIh0jFSuBHuAu1JY3WpiuoHHgbRP1rT0SZmzGVojeblAUY5HRHkwFriB2MUrQxdJ8HQ9Wz6dGWqjVKOkyRqsr/xehSP5QkRNu67TkFomSY+94Ox1aWBVCk67K4ZOLQiy/0AGCKbIwCTU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741629559; c=relaxed/simple;
	bh=U4qs+FUTItryTATlQ7ziMl1+pSQXkAiePlJOLpyA5js=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FrXv4ZtL/6Lk51Vyt7MaMrFST0EwvvKsbz7L0bmQb8DkFa6gxibGTn5C3hyLJZpgOIddOpd4L+oX9htjkfOUx+rtc+bJC3AMjhFw0dQnjd2rex+7luuRsVXWGRx8/74fjVsEz5S2a0tXI236HgJrvRtcHAWATK8zxdWKmhPfWtQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZEGHRccP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZEGHRccP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 362BFC4CEE5;
	Mon, 10 Mar 2025 17:59:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741629559;
	bh=U4qs+FUTItryTATlQ7ziMl1+pSQXkAiePlJOLpyA5js=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZEGHRccPxBt+5FOH2b+QMvlr+b4FXuYDqFMKMUN/H3b0lOmrEh5KaWmniItP2EiG5
	 zf1GrSEaLYAdm56bG9rqiXMz2pJiXIhBicQa2iOzawSIKO5bDZag35SDuujlKTIXU1
	 3zmNkPEXuBotyG87ZVlT7qimiroFQVIRDC0sP6Hc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dai Ngo <dai.ngo@oracle.com>,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 5.15 336/620] NFSD: fix hang in nfsd4_shutdown_callback
Date: Mon, 10 Mar 2025 18:03:02 +0100
Message-ID: <20250310170558.873324252@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170545.553361750@linuxfoundation.org>
References: <20250310170545.553361750@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dai Ngo <dai.ngo@oracle.com>

commit 036ac2778f7b28885814c6fbc07e156ad1624d03 upstream.

If nfs4_client is in courtesy state then there is no point to send
the callback. This causes nfsd4_shutdown_callback to hang since
cl_cb_inflight is not 0. This hang lasts about 15 minutes until TCP
notifies NFSD that the connection was dropped.

This patch modifies nfsd4_run_cb_work to skip the RPC call if
nfs4_client is in courtesy state.

Signed-off-by: Dai Ngo <dai.ngo@oracle.com>
Fixes: 66af25799940 ("NFSD: add courteous server support for thread with only delegation")
Cc: stable@vger.kernel.org
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfsd/nfs4callback.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/fs/nfsd/nfs4callback.c
+++ b/fs/nfsd/nfs4callback.c
@@ -1410,8 +1410,11 @@ nfsd4_run_cb_work(struct work_struct *wo
 		nfsd4_process_cb_update(cb);
 
 	clnt = clp->cl_cb_client;
-	if (!clnt) {
-		/* Callback channel broken, or client killed; give up: */
+	if (!clnt || clp->cl_state == NFSD4_COURTESY) {
+		/*
+		 * Callback channel broken, client killed or
+		 * nfs4_client in courtesy state; give up.
+		 */
 		nfsd41_destroy_cb(cb);
 		return;
 	}


