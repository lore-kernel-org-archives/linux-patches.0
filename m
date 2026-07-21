Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E2783E49E7;
	Tue, 21 Jul 2026 17:20:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784654427; cv=none; b=Ykg6zvqOEqw17zSy11JK/cma0q6Wm6XQ6XosmOvN8va4EgPp3d0aBMSRq+ibYxDTm+CKxOowQnE8R/dKaeSsruGWwRnUy3aCPthEP2wUNKhtUA4l6YcANyjgqkU2TNy+mMWA/HMViqKLmfEX+HZFqxIx6C0/Z23kgL1f2pUEmhA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784654427; c=relaxed/simple;
	bh=9Tqn5RDjpvQyHIU/RiHioRC00ytRw/8hsyxj1uPNQ0U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZYS6Fogv4/IPeyTUJI/WMLTGWWTE6Wl1D6XisqL4nlul70jE8hF8RYAYhzEpbEHUYmnIHEyXugztb3GbqZa4gfU9vk+uXU4ofIE2n7MgMWVJhTJMbEnFx52N5a3ful4YC48tUydT4/fUtXyGb94nzzpVYlksrKM1gFh5A0UlorE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XI452NIv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XI452NIv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C1231F000E9;
	Tue, 21 Jul 2026 17:20:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784654426;
	bh=jvwZBdsuP37+qQrIthaHSRh2boGc3aE8k/bLIBTdFog=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XI452NIvAzGxzxeP1gYZO6EnPUwrPmaoMSSnTqZOphj+sAg+NC0BeswcoR9tzxabm
	 nJPjfNouprQPGswox0GqeKdjZGegLpEOHZJVo7LFI9N/u/mKukpnI6Ldzsp0zgfa1r
	 QIHfGyLw2wmf/Mm9pcF6X9ShgQIaYy1v2dOPIuSY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuan Tan <yuantan098@gmail.com>,
	Yifan Wu <yifanwucs@gmail.com>,
	Juefei Pu <tomapufckgml@gmail.com>,
	Xin Liu <bird@lzu.edu.cn>,
	Chuck Lever <cel@kernel.org>,
	Jeff Layton <jlayton@kernel.org>,
	Luxiao Xu <rakukuip@gmail.com>,
	Ren Wei <n05ec@lzu.edu.cn>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 7.1 1663/2077] sunrpc: harden rq_procinfo lifecycle to prevent double-free
Date: Tue, 21 Jul 2026 17:22:16 +0200
Message-ID: <20260721152631.970147053@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Luxiao Xu <rakukuip@gmail.com>

commit 18d216788bef06332ff8901670ecf1ed8f6eb614 upstream.

The svc_release_rqst() function executes the callback inside
rqstp->rq_procinfo->pc_release. However, if a worker thread begins
processing a new request and encounters an early error path (e.g.,
unsupported protocol, short frame, or bad auth) before a valid
rq_procinfo is installed, a stale release hook can be re-triggered
against reused state from the previous RPC, resulting in a double-free
or use-after-free vulnerability.

Harden the lifecycle of rq_procinfo by:
1. Ensuring svc_release_rqst() always clears rq_procinfo after the
   optional pc_release() call, regardless of whether the hook exists.
2. Explicitly clearing rq_procinfo at request entry in svc_process()
   before any early decode or drop paths.
3. Ensuring svc_process_bc() does the same at backchannel entry.

This guarantees that error flows will not encounter a non-NULL stale
rq_procinfo pointer when there is nothing to release.

Fixes: d9adbb6e10bf ("sunrpc: delay pc_release callback until after the reply is sent")
Cc: stable@vger.kernel.org
Reported-by: Yuan Tan <yuantan098@gmail.com>
Reported-by: Yifan Wu <yifanwucs@gmail.com>
Reported-by: Juefei Pu <tomapufckgml@gmail.com>
Reported-by: Xin Liu <bird@lzu.edu.cn>
Suggested-by: Chuck Lever <cel@kernel.org>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Luxiao Xu <rakukuip@gmail.com>
Signed-off-by: Ren Wei <n05ec@lzu.edu.cn>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sunrpc/svc.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- a/net/sunrpc/svc.c
+++ b/net/sunrpc/svc.c
@@ -1598,6 +1598,12 @@ static void svc_release_rqst(struct svc_
 
 	if (procp && procp->pc_release)
 		procp->pc_release(rqstp);
+
+	/*
+	 * A subsequent svc_release_rqst() on this rqstp must not
+	 * re-invoke pc_release against released state.
+	 */
+	rqstp->rq_procinfo = NULL;
 }
 
 /**
@@ -1616,6 +1622,9 @@ void svc_process(struct svc_rqst *rqstp)
 		svc_xprt_deferred_close(rqstp->rq_xprt);
 #endif
 
+	/* Discard a stale release hook from a previous RPC. */
+	rqstp->rq_procinfo = NULL;
+
 	/*
 	 * Setup response xdr_buf.
 	 * Initially it has just one page
@@ -1672,6 +1681,7 @@ void svc_process_bc(struct rpc_rqst *req
 	int proc_error;
 
 	/* Build the svc_rqst used by the common processing routine */
+	rqstp->rq_procinfo = NULL;
 	rqstp->rq_xid = req->rq_xid;
 	rqstp->rq_prot = req->rq_xprt->prot;
 	rqstp->rq_bc_net = req->rq_xprt->xprt_net;


