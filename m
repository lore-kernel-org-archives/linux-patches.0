Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BE331C3BF1;
	Wed, 19 Feb 2025 08:58:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739955480; cv=none; b=f2aFn6aJRTptHThYMJcEBaXO769+Czpn18klxLgNzZJC3YpuTtIXv6Tf2KWXzcJW/fxiG3xjoGL0IIYOi8KmITDsXaBVvkLYTpeMqsSzdn29rKZkSz2ZxMBWEup0XtMSxu0H/N4HlV3vct+qAT1l07NevC3O6xPUZKM/kqfwRT0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739955480; c=relaxed/simple;
	bh=ls0CfXKmCY4o8/kbWnF+/n5bc8AOORMwj9LNyaHofDk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Dzz1zr0DEW9qSy+VWgmBSTe9RG5qxFAIVebPd3g/xReZxI/SvMMmC2Od2tuOm9AMktRz6tDwzKROfapLV8ZuM7lgmjAccACOh24/oJml3tJAIO3wpnPpfu+SsXyK7R4gm6uw+UI1t+SY21svhTp3dan4KxlAeyK9mpGCFgub+oA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2T80Hu3E; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2T80Hu3E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13D97C4CED1;
	Wed, 19 Feb 2025 08:57:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739955480;
	bh=ls0CfXKmCY4o8/kbWnF+/n5bc8AOORMwj9LNyaHofDk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2T80Hu3E9bLga315pTCzrnyjRjde7Hwz0uz+urRKytOwUHFvcpO3GXdGDU6NfmoJz
	 r9P4cdxQ7RvB65AV/iJDissBVY11E3pqoXadZhkqqWU3452UWGixSkATCfz/1n6Zih
	 uN7UAWfWIoNvdTmbGd3fAvf6j+UgQdRDgN0YCbVA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dai Ngo <dai.ngo@oracle.com>,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 6.6 002/152] NFSD: fix hang in nfsd4_shutdown_callback
Date: Wed, 19 Feb 2025 09:26:55 +0100
Message-ID: <20250219082550.116921034@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082550.014812078@linuxfoundation.org>
References: <20250219082550.014812078@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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


