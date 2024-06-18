Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20D661AB8F6;
	Tue, 18 Jun 2024 13:16:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718716605; cv=none; b=ulCwfLx4UlHiYHduxBdmVKpoEqYEf1ImEDmpzYnV9MH7t+0eNsHH56rWqW/MzgvYYFC72pkLS4jqJTtFXCENc90CMxfjBvEbce7ULb9aQdGcnm8ORe2UYkgyHnFuzoltBjRSNxRjHnUPrP7/8jlst371ARjhYU7hQQdBR1YIvW4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718716605; c=relaxed/simple;
	bh=qlORsvdpq7CXdfzXL8tcdeBv0zvTkZfJv+ZmHoyNVoA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DmahhSCGaV7dZ9vJ2CI4M11YFr37bIaDM5gAIomF4pYh64ZhYVD69RlBAapyRn/vbE/gWhbbKds46ClVj/Kn78BvJfYWtdWRuN0hSrkwxAymD5p+0EhBFo0peaarrpsc4y1cn2LgEo5+BZiHXLpUTd/6J4yczT1VM6BGnIOxWgs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oRFBXA5F; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oRFBXA5F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A07AAC3277B;
	Tue, 18 Jun 2024 13:16:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718716605;
	bh=qlORsvdpq7CXdfzXL8tcdeBv0zvTkZfJv+ZmHoyNVoA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oRFBXA5FPsc35a54H8Sa5YpTnPYF+pDYnETeG6cUN8TXYu+8hYUW3LOopGDuUYuzd
	 BjzDSbOoKF64P8tdm/MrNp7zSR9gzTor55JI+NWUhdcyHbKAbtiAJ5J3S9xbKzPPjQ
	 NSOV5O3wSe5fHZzpWKVzIu70iNVr3t0YjfiFGVrk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	NeilBrown <neilb@suse.de>,
	Jeff Layton <jlayton@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 702/770] NFSD: Refactor find_file()
Date: Tue, 18 Jun 2024 14:39:15 +0200
Message-ID: <20240618123434.372054850@linuxfoundation.org>
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

[ Upstream commit 15424748001a9b5ea62b3e6ad45f0a8b27f01df9 ]

find_file() is now the only caller of find_file_locked(), so just
fold these two together.

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Reviewed-by: NeilBrown <neilb@suse.de>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs4state.c | 36 +++++++++++++++---------------------
 1 file changed, 15 insertions(+), 21 deletions(-)

diff --git a/fs/nfsd/nfs4state.c b/fs/nfsd/nfs4state.c
index d2664aa4bde0d..69329dc159f64 100644
--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -4682,31 +4682,24 @@ move_to_close_lru(struct nfs4_ol_stateid *s, struct net *net)
 		nfs4_put_stid(&last->st_stid);
 }
 
-/* search file_hashtbl[] for file */
-static struct nfs4_file *
-find_file_locked(const struct svc_fh *fh, unsigned int hashval)
+static noinline_for_stack struct nfs4_file *
+nfsd4_file_hash_lookup(const struct svc_fh *fhp)
 {
-	struct nfs4_file *fp;
+	unsigned int hashval = file_hashval(fhp);
+	struct nfs4_file *fi;
 
-	hlist_for_each_entry_rcu(fp, &file_hashtbl[hashval], fi_hash,
-				lockdep_is_held(&state_lock)) {
-		if (fh_match(&fp->fi_fhandle, &fh->fh_handle)) {
-			if (refcount_inc_not_zero(&fp->fi_ref))
-				return fp;
+	rcu_read_lock();
+	hlist_for_each_entry_rcu(fi, &file_hashtbl[hashval], fi_hash,
+				 lockdep_is_held(&state_lock)) {
+		if (fh_match(&fi->fi_fhandle, &fhp->fh_handle)) {
+			if (refcount_inc_not_zero(&fi->fi_ref)) {
+				rcu_read_unlock();
+				return fi;
+			}
 		}
 	}
-	return NULL;
-}
-
-static struct nfs4_file * find_file(struct svc_fh *fh)
-{
-	struct nfs4_file *fp;
-	unsigned int hashval = file_hashval(fh);
-
-	rcu_read_lock();
-	fp = find_file_locked(fh, hashval);
 	rcu_read_unlock();
-	return fp;
+	return NULL;
 }
 
 /*
@@ -4757,9 +4750,10 @@ nfs4_share_conflict(struct svc_fh *current_fh, unsigned int deny_type)
 	struct nfs4_file *fp;
 	__be32 ret = nfs_ok;
 
-	fp = find_file(current_fh);
+	fp = nfsd4_file_hash_lookup(current_fh);
 	if (!fp)
 		return ret;
+
 	/* Check for conflicting share reservations */
 	spin_lock(&fp->fi_lock);
 	if (fp->fi_share_deny & deny_type)
-- 
2.43.0



