Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C34EA358378;
	Fri,  4 Sep 2026 06:09:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788502143; cv=none; b=pT0nYzmUU8C3OJwnwCgSBtKSWlDO7GnasoKj6xLIyHa99jt2vyvRGnXj9OyKI1ddoXmOVckWPlFHv4npOpKVioEI1KFH7IlV2VHPaNrq95IxczzcAO9Cu/K9UfYH491ol/5CsFoUiL/tAE0l0gwlMryes9Udn6qrKzvv4XHoMDs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788502143; c=relaxed/simple;
	bh=8mcniTb2EamEAOcZz+lVNrCQBKVDByQqCxFBQgR2+5A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eQXDsRVygMWrAfnMJGHl/K9LpKAvBiI2jY4E5Wqh9EMznjr1wihiERe3p6ALBFwKFFzWeO3r3sLNiXA/if9W2VE8TCYYiKEU7+ljcj57hr0GOpZVc3YFBEgClKpTDETo2ESu+hZpWdUJ3rk8hteHQLUjRElMD/Dot8tfVNFUPBU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vij1EF3w; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vij1EF3w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 272F41F00A3D;
	Fri,  4 Sep 2026 06:09:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788502142;
	bh=ODxhMDxTaeFHeSpsTsRCMB/sMZqXzDFPoOjn7sYCvLQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vij1EF3wqSjRs3bpm4/eEVsAU8mYzcLwyNtS9fSbbBv8EXK7y9sK2EaMaLg14iyqw
	 nuMNXvUh/Zuk6rnc0dpU+2ZsvHuNPe2lIIF7vuKPQnIS400/Jma9plQRF8wIp+p+oz
	 hTwv9EjI8JkGB6A+ZOpRw5/LJZDQqZwUGr/C5V1s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <cel@kernel.org>
Subject: [PATCH 6.12 105/403] nfsd: reject reclaim LOCK after RECLAIM_COMPLETE
Date: Fri,  4 Sep 2026 06:58:28 +0200
Message-ID: <20260904045737.217839375@linuxfoundation.org>
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
@@ -8145,6 +8145,9 @@ nfsd4_lock(struct svc_rqst *rqstp, struc
 	status = nfserr_no_grace;
 	if (!locks_in_grace(net) && lock->lk_reclaim)
 		goto out;
+	if (lock->lk_reclaim &&
+	    test_bit(NFSD4_CLIENT_RECLAIM_COMPLETE, &cstate->clp->cl_flags))
+		goto out;
 
 	if (lock->lk_reclaim)
 		flags |= FL_RECLAIM;


