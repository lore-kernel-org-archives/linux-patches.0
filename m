Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB9B335C69C;
	Sat, 12 Sep 2026 19:23:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789241006; cv=none; b=D75BW69jdNGxbXjxPZuh4FbLQSvlESYrgUKySJ8hBdpC1oAVaZ+4sfD4MFXibDk3Gi+goSwQlpTo5KbrmzCET8/CHoBDLveigEkSnW5X3AeNVI/2E212lxtTyBKDx5vlxaf+Ona7qLJTrogCL49Rwz0+XEbvTuKPAB7vaPS8qHo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789241006; c=relaxed/simple;
	bh=IjJDVyLjTZzPtbrpdgcOntt9WLDGIUCjq97gAoBP4rk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pCzQf7yexGdly9KKTXNIdctv/zQZVGLaC9iYC1IcSoR8gmblFjo6kXpGC3HNV2dG+45PV8R8OeGBk8iQRJt5v+UtYSmQL2gT57Iqn45WPSsOKcBAD57SPxS5cHniIBaDD8/mwKy4Dc/tFi2D7nBDHAJIsqyVczJkfJ+V9eULk6c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aG7N1e6H; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aG7N1e6H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B6EE1F000FF;
	Sat, 12 Sep 2026 19:23:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789241004;
	bh=P/9XP2U5y5Y7st3iRV+hdp3b3T5CF4xPHUnL4KrrQSU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aG7N1e6HiS/vl0hPh4pcJyAZLKjiVaXCCiv8IRi9mdMrV/APYSl8ZBjkGYarqtDRR
	 jIujuOCi9c0n9e4YHuu/E4bVreIpgrjlgeGJBHxCqtsZNwzFht12T0WbapOXAm7UNI
	 fU3YVv0ZtxrOCJrYltP+JEJsvEKaFdzYuCPz0kmY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <cel@kernel.org>
Subject: [PATCH 5.10 046/798] nfsd: reject reclaim LOCK after RECLAIM_COMPLETE
Date: Sat, 12 Sep 2026 08:54:34 +0200
Message-ID: <20260912065518.018276934@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jeff Layton <jlayton@kernel.org>

commit 2327ba1d9546727a35b17888777e991f68a9b305 upstream.

nfsd4_lock() only checks the namespace-wide grace flag when deciding
whether to accept a reclaim LOCK. It does not check the per-client
NFSD4_CLIENT_RECLAIM_COMPLETE bit. An NFSv4.1+ client that has
already sent RECLAIM_COMPLETE can submit lk_reclaim=1 while grace is
still active (e.g. lockd holds the grace list open), and the server
accepts it instead of returning NFS4ERR_NO_GRACE as required by
RFC 8881 section 18.51.3.

The OPEN path already enforces both tiers: the grace check plus the
per-client RECLAIM_COMPLETE check in nfs4_check_open_reclaim(). Add
the equivalent per-client check to the LOCK path.

Fixes: 3b3e7b72239a ("nfsd: reject reclaim request when client has already sent RECLAIM_COMPLETE")
Cc: stable@vger.kernel.org
Assisted-by: Claude:claude-opus-4-8
Signed-off-by: Jeff Layton <jlayton@kernel.org>
[ cel: Correct the RFC citations in the commit message ]
Link: https://patch.msgid.link/20260611-nfsd-testing-v2-14-5b90e276f2d9@kernel.org
Signed-off-by: Chuck Lever <cel@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfsd/nfs4state.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -7628,6 +7628,9 @@ nfsd4_lock(struct svc_rqst *rqstp, struc
 	status = nfserr_no_grace;
 	if (!locks_in_grace(net) && lock->lk_reclaim)
 		goto out;
+	if (lock->lk_reclaim &&
+	    test_bit(NFSD4_CLIENT_RECLAIM_COMPLETE, &cstate->clp->cl_flags))
+		goto out;
 
 	if (lock->lk_reclaim)
 		fl_flags |= FL_RECLAIM;


