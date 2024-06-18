Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6869B13CF82;
	Tue, 18 Jun 2024 13:16:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718716596; cv=none; b=JkB7mLhN3kjN5Za6tJYZECW/w994DU7ZRrk42IujRY7hxp+HeW/E2pLwig78sQbZs7LnMlyzNSxo4VDofIhvecvqYT6XtQy6V/E+OwB4kQgx359pArcJBRBRqNIN9gBD3l61zEwFl3wh3gwEemXImOV/6JQnf9hLD1br2/Hru+c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718716596; c=relaxed/simple;
	bh=79jLO1r0C0X3utND7b7ORxe7QVdZbnMB9iAo3qCbiK0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kOURAH7QL0pzHztgu2fy6/AB8xWWa+q9fefhfNSsuOPaanKxkBY2CuSkrrFhWaiRS4nn7S00t1N+BcMrIQKBe5MUSW3E9OwVGyziSy5rzqVZym0tlHcS4fWPZ2IpaegO/nFwT07yPCnNG3vPICC6Lvi52rLCLYE55tOYbKXFieE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lI2X7RMM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lI2X7RMM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0B46C3277B;
	Tue, 18 Jun 2024 13:16:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718716596;
	bh=79jLO1r0C0X3utND7b7ORxe7QVdZbnMB9iAo3qCbiK0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lI2X7RMMXANpEDJIuDlNmGrPwWoEKInKnO+3rQ87vumC5+f3l6AhodkypBnx8dwNv
	 YI6zQt6Wt1SKxGfvod18QS0CsMEalqeofPHUMSxB4CSmIqRhpWMDgGALrLN/VdTl9z
	 NE4UTwPwf4ZbUZJ/EcTWPcsuDuZ+NRRdud7gJAmo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	NeilBrown <neilb@suse.de>,
	Jeff Layton <jlayton@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 699/770] NFSD: Clean up nfsd4_init_file()
Date: Tue, 18 Jun 2024 14:39:12 +0200
Message-ID: <20240618123434.257732444@linuxfoundation.org>
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

[ Upstream commit 81a21fa3e7fdecb3c5b97014f0fc5a17d5806cae ]

Name this function more consistently. I'm going to use nfsd4_file_
and nfsd4_file_hash_ for these helpers.

Change the @fh parameter to be const pointer for better type safety.

Finally, move the hash insertion operation to the caller. This is
typical for most other "init_object" type helpers, and it is where
most of the other nfs4_file hash table operations are located.

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Reviewed-by: NeilBrown <neilb@suse.de>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs4state.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/fs/nfsd/nfs4state.c b/fs/nfsd/nfs4state.c
index 90505095d7e0c..d6e0052b3f682 100644
--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -4277,11 +4277,9 @@ static struct nfs4_file *nfsd4_alloc_file(void)
 }
 
 /* OPEN Share state helper functions */
-static void nfsd4_init_file(struct svc_fh *fh, unsigned int hashval,
-				struct nfs4_file *fp)
-{
-	lockdep_assert_held(&state_lock);
 
+static void nfsd4_file_init(const struct svc_fh *fh, struct nfs4_file *fp)
+{
 	refcount_set(&fp->fi_ref, 1);
 	spin_lock_init(&fp->fi_lock);
 	INIT_LIST_HEAD(&fp->fi_stateids);
@@ -4299,7 +4297,6 @@ static void nfsd4_init_file(struct svc_fh *fh, unsigned int hashval,
 	INIT_LIST_HEAD(&fp->fi_lo_states);
 	atomic_set(&fp->fi_lo_recalls, 0);
 #endif
-	hlist_add_head_rcu(&fp->fi_hash, &file_hashtbl[hashval]);
 }
 
 void
@@ -4717,7 +4714,8 @@ static struct nfs4_file *insert_file(struct nfs4_file *new, struct svc_fh *fh,
 			fp->fi_aliased = alias_found = true;
 	}
 	if (likely(ret == NULL)) {
-		nfsd4_init_file(fh, hashval, new);
+		nfsd4_file_init(fh, new);
+		hlist_add_head_rcu(&new->fi_hash, &file_hashtbl[hashval]);
 		new->fi_aliased = alias_found;
 		ret = new;
 	}
-- 
2.43.0



