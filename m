Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0939F25EFAD;
	Tue, 11 Mar 2025 15:29:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741706956; cv=none; b=n7MU4eZe3NuPCFa6/JsmFk8HjbxWS4fYQJ2bim+CrRfdWRPj1zfxLgJrksJVSFfKfz5VazSw2TDVsnfsOsKcPfTpYC2up5Hr5Hc6vvLA41hMt1HoY57z+VsOUG0hJm4IGk/k/djzMH1+O+k6ru/aJK2y5eg2ygX3wR9kAUW8Ob0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741706956; c=relaxed/simple;
	bh=x9yY7GSriOhCB5RT9Vq2QMe0mnxi8k0dr2wh0/EpM/Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lWZHiRDM4ZM6G6cE1+P17gQZW0raazFiGFGYaJxk2SJ5RjhhckIjMgFzXy/q6ughuL9A2uyn1xaDT67bwnPZCit63QHUCLaPv5L7jsAmeEDGMTzrcI/73kTcZNiGGEbAS67zSLTnzp0JvjEo1Vfp0LXDudfRRHpTZ0ryArUrYUw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=frh34i0I; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="frh34i0I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 832DFC4CEE9;
	Tue, 11 Mar 2025 15:29:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741706955;
	bh=x9yY7GSriOhCB5RT9Vq2QMe0mnxi8k0dr2wh0/EpM/Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=frh34i0IXBl2k5efAy6BbhK1pj+r4rtjhcM+0H14rxRNb0nFI4nA3R7a1epMgK++W
	 +FmVrHU5Nhghak1FB+9q2b/kgj71/Vlurim+pgHp1cp512Pv5BdlpnBLawQi/tSurw
	 t5alEUoxyVMDzio/YQZ4tuPeIoqZMF+RjunodONM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dai Ngo <dai.ngo@oracle.com>,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 5.10 226/462] NFSD: fix hang in nfsd4_shutdown_callback
Date: Tue, 11 Mar 2025 15:58:12 +0100
Message-ID: <20250311145807.290803346@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250311145758.343076290@linuxfoundation.org>
References: <20250311145758.343076290@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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


