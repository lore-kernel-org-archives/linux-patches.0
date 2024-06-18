Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91414157A49;
	Tue, 18 Jun 2024 13:05:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718715926; cv=none; b=lL0SOBpVlU4Ln5wRjwfluiu0bj+thPvP8+4oNClhYYBMpyORdlcqN1RM8Wi1AqpYCzav9MVpBJ6ER89qNkOcbpVJYoK7DTnWWo3GH03f+exEjWUlKapyMv7iJCxrE8z6BCHKzbQ5BZFs82AD06KdbtVhkm7C+o95hmNYwOvhuwA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718715926; c=relaxed/simple;
	bh=8EnfzSJ9t4sst4a22kjkVfdeXIf9EkudHn02+Mgoelg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lm+hIaeBxuIGifmvrDX3I1RCHQ6dCbyTc6vqfYsXa3sETiw5t2gQ8nIritd+A/VeDAMHlunQnRnzb0LJpckiHLLqXItPijVpYZs7a1EUP7T3Q7Utbxd9yVOm3gqoLwBVc3KsWcPRV1951tQUDXnSQRaDt/PlPbSzVNgDOQVNA9I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=g79mmhMm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="g79mmhMm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1AC67C3277B;
	Tue, 18 Jun 2024 13:05:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718715926;
	bh=8EnfzSJ9t4sst4a22kjkVfdeXIf9EkudHn02+Mgoelg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=g79mmhMmfBwyskFGoisrS2CKqA2juA8Rrqv/bs4Plu+bzMfvRY1gKPRExkZfI95AF
	 X8TNdmqQ7Kmcih4aR1UHFSp1j+kFO5KPM1efzn3lzyoKpqjcZkGsojyyUVLA2lUrkM
	 Qz1S+Td+cZTprMGFmicRLiaSm1PfveEhkqcgHUl4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 473/770] NFSD: Streamline the rare "found" case
Date: Tue, 18 Jun 2024 14:35:26 +0200
Message-ID: <20240618123425.570815991@linuxfoundation.org>
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

[ Upstream commit add1511c38166cf1036765f8c4aa939f0275a799 ]

Move a rarely called function call site out of the hot path.

This is an exceptionally small improvement because the compiler
inlines most of the functions that nfsd_cache_lookup() calls.

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfscache.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/fs/nfsd/nfscache.c b/fs/nfsd/nfscache.c
index 34087a7e4f93c..0b3f12aa37ff5 100644
--- a/fs/nfsd/nfscache.c
+++ b/fs/nfsd/nfscache.c
@@ -448,11 +448,8 @@ int nfsd_cache_lookup(struct svc_rqst *rqstp)
 	b = nfsd_cache_bucket_find(rqstp->rq_xid, nn);
 	spin_lock(&b->cache_lock);
 	found = nfsd_cache_insert(b, rp, nn);
-	if (found != rp) {
-		nfsd_reply_cache_free_locked(NULL, rp, nn);
-		rp = found;
+	if (found != rp)
 		goto found_entry;
-	}
 
 	nfsd_stats_rc_misses_inc();
 	rqstp->rq_cacherep = rp;
@@ -470,8 +467,10 @@ int nfsd_cache_lookup(struct svc_rqst *rqstp)
 
 found_entry:
 	/* We found a matching entry which is either in progress or done. */
+	nfsd_reply_cache_free_locked(NULL, rp, nn);
 	nfsd_stats_rc_hits_inc();
 	rtn = RC_DROPIT;
+	rp = found;
 
 	/* Request being processed */
 	if (rp->c_state == RC_INPROG)
-- 
2.43.0



