Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FFEB37F306;
	Fri,  4 Sep 2026 06:13:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788502438; cv=none; b=Hgi8ysoUPxF7rJXD2JjLSEJhmHA3sqsr0fZ6NKmzH4ThWFG4XnHd73yVpF57zWj0uI+ejSQWXlg6dHT0L+r4oY3kEbiFQJqERfHL6IsSRJNaUGa9IH+CzsL+2xEDffEsntiBSjKRXpzO6ydI0gWvvnshHo4xWVEU5sCv00Fu3ys=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788502438; c=relaxed/simple;
	bh=P0K4PkBMRBhM/e9ZegBEy4Bw3RN478W/rp86iadHuU4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W1nwzqRR2FP0ynElxr3GmgeCwjcr6Jx11gIcf/kFLjhGtdGHJ6JR3r8cBbl797xEnZpU27nc+PV2iShRSOYTrtEuR0YNqgpt2UiCVJxJwoOBeVPxlauFjRPvp8XTi+hNlLYSVxfIDU/3hsbuMY7unCvZFFGus9Qpd5fA5tvjQMY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ojuspOa3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ojuspOa3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62CF51F00A3D;
	Fri,  4 Sep 2026 06:13:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788502436;
	bh=PO+0LwatQ7zE51oKCOT9ZUYomF5Cz9fc+1wl6sSZCZc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ojuspOa3tIuzA9BkF/P9MB0QKLhNPIh+M86iVrxCb6rpUjR4WsLhbme4PmapiVePZ
	 bdhXToinS7vHVlGjJ47Fuf1Z6hGaarSc31+hL42iY0qFPqgDj/Zv7r7wX64H4E9lfR
	 CyCT/iCbBItupuGsKQAZG2mWVTb+vbWv5F3bPc7E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Mason <clm@meta.com>,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 6.12 207/403] SUNRPC: Guard svcauth_gss_release() dispatch on rq_auth_stat
Date: Fri,  4 Sep 2026 07:00:10 +0200
Message-ID: <20260904045739.563008917@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045734.806166532@linuxfoundation.org>
References: <20260904045734.806166532@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chris Mason <clm@meta.com>

commit f8870b9b75afb77986bc65940a231d54068ff2b1 upstream.

svcauth_gss_release() reads gc_proc and switches on gc_svc before
consulting rq_auth_stat.  On the SVC_DENIED path after a failed
svcauth_gss_accept(), those fields may hold stale values from a
prior request or uninitialized slab residue: svcauth_gss_accept()
allocates gss_svc_data with non-zeroing kmalloc and clears only
gsd_databody_offset and rsci per request, not clcred.

Because RPC_GSS_PROC_DATA is zero, a zeroed or stale-zero gc_proc
passes the existing guard and falls through into the gc_svc switch,
which can dispatch to svcauth_gss_wrap_integ() or
svcauth_gss_wrap_priv().  Both wrap helpers call
svcauth_gss_prepare_to_wrap() before any rsci->mechctx dereference,
and that helper already returns early when rq_auth_stat is not
rpc_auth_ok, so the downstream NULL dereference is blocked.  The
dispatch itself remains structurally wrong: it reads scalars that
the caller has no contract to have initialized after a failed
authentication.

Mirror the existing rq_auth_stat gate in
svcauth_gss_prepare_to_wrap() one frame up, so
svcauth_gss_release() skips the clcred dispatch entirely when
authentication has not succeeded.  The cleanup tail that releases
rq_client, rq_gssclient, cr_group_info, and rsci still runs.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: stable@vger.kernel.org
Signed-off-by: Chris Mason <clm@meta.com>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Link: https://patch.msgid.link/20260528-tier2-v1-4-d026a1415e0b@oracle.com
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sunrpc/auth_gss/svcauth_gss.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/net/sunrpc/auth_gss/svcauth_gss.c
+++ b/net/sunrpc/auth_gss/svcauth_gss.c
@@ -1946,6 +1946,8 @@ svcauth_gss_release(struct svc_rqst *rqs
 
 	if (!gsd)
 		goto out;
+	if (rqstp->rq_auth_stat != rpc_auth_ok)
+		goto out;
 	gc = &gsd->clcred;
 	if (gc->gc_proc != RPC_GSS_PROC_DATA)
 		goto out;


