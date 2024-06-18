Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E053414EC75;
	Tue, 18 Jun 2024 12:50:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718715015; cv=none; b=l160SyngGY7pzz+932jm2zK53cASmxveN4EDJqz4BssBx4MyhEp/mNqMZoFq72X2d6IEHsHe1uI0WM796BXUqTanRfxoCooSTSW26X1NlSvYZbOxdKuzCN9UYYZofE5fntR3wLBthx4NNr6ni/qWJPwyd3VdrrwhzAkuBqS3ork=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718715015; c=relaxed/simple;
	bh=wjmqLYjN3+kLe0vQBW2uquwIBCZBtt/+xj/VvRecZx0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u3CU1a5C/DST84FYnQL5ssSh4ZgKbrLSS7soPY2HMalat4VRWqKghdE4x2e5nvf8g0ovq6GHazDUtZ68gYOQbMIUtMtJ2mCBo1p/EgmlaNe7HeN3hevzouWVOp2AJyl9ou5tPwQhzcdEX9hR1ttCHqH1UHBPFQ30qfUKK4xOxoI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eE+n2DLT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eE+n2DLT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A4C6C3277B;
	Tue, 18 Jun 2024 12:50:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718715014;
	bh=wjmqLYjN3+kLe0vQBW2uquwIBCZBtt/+xj/VvRecZx0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eE+n2DLTgj7E7OBKkrrJc4hD0/f+o1h+owKrreKdrg4AqPGINROAeDRpfRm4HaHSl
	 3xkiGOWxyHz3xp2Zv98bHQT5zhiVw6fPVQgYJyR4kROrUgM4uVRyR+WYMgQUEROvJ0
	 YYqCaOlTUEmGX/Noxy0Cx0SxpypQEN5Ecct67U4Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 165/770] NFSD: Remove argument length checking in nfsd_dispatch()
Date: Tue, 18 Jun 2024 14:30:18 +0200
Message-ID: <20240618123413.643558506@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240618123407.280171066@linuxfoundation.org>
References: <20240618123407.280171066@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Chuck Lever <chuck.lever@oracle.com>

[ Upstream commit 5650682e16f41722f735b7beeb2dbc3411dfbeb6 ]

Now that the argument decoders for NFSv2 and NFSv3 use the
xdr_stream mechanism, the version-specific length checking logic in
nfsd_dispatch() is no longer necessary.

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfssvc.c | 34 ----------------------------------
 1 file changed, 34 deletions(-)

diff --git a/fs/nfsd/nfssvc.c b/fs/nfsd/nfssvc.c
index 423410cc02145..6c1d70935ea81 100644
--- a/fs/nfsd/nfssvc.c
+++ b/fs/nfsd/nfssvc.c
@@ -988,37 +988,6 @@ nfsd(void *vrqstp)
 	return 0;
 }
 
-/*
- * A write procedure can have a large argument, and a read procedure can
- * have a large reply, but no NFSv2 or NFSv3 procedure has argument and
- * reply that can both be larger than a page.  The xdr code has taken
- * advantage of this assumption to be a sloppy about bounds checking in
- * some cases.  Pending a rewrite of the NFSv2/v3 xdr code to fix that
- * problem, we enforce these assumptions here:
- */
-static bool nfs_request_too_big(struct svc_rqst *rqstp,
-				const struct svc_procedure *proc)
-{
-	/*
-	 * The ACL code has more careful bounds-checking and is not
-	 * susceptible to this problem:
-	 */
-	if (rqstp->rq_prog != NFS_PROGRAM)
-		return false;
-	/*
-	 * Ditto NFSv4 (which can in theory have argument and reply both
-	 * more than a page):
-	 */
-	if (rqstp->rq_vers >= 4)
-		return false;
-	/* The reply will be small, we're OK: */
-	if (proc->pc_xdrressize > 0 &&
-	    proc->pc_xdrressize < XDR_QUADLEN(PAGE_SIZE))
-		return false;
-
-	return rqstp->rq_arg.len > PAGE_SIZE;
-}
-
 /**
  * nfsd_dispatch - Process an NFS or NFSACL Request
  * @rqstp: incoming request
@@ -1037,9 +1006,6 @@ int nfsd_dispatch(struct svc_rqst *rqstp, __be32 *statp)
 	struct kvec *resv = &rqstp->rq_res.head[0];
 	__be32 *p;
 
-	if (nfs_request_too_big(rqstp, proc))
-		goto out_decode_err;
-
 	/*
 	 * Give the xdr decoder a chance to change this if it wants
 	 * (necessary in the NFSv4.0 compound case)
-- 
2.43.0



