Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C0C91AC769;
	Tue, 18 Jun 2024 13:18:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718716691; cv=none; b=hg6Ujy8dLbEMSq/yqDMk+gNOsiVvWxCQICLtLOVHUE9ZrlpshFlR+BUbfwyXJ/ZM8BbL15CkC57kOQ0InCmW0KnlDItPvJ93aB7ZxdUoBojFruLcLyu9+/eHSOWS8odsyOtCwaW0UZHHLTd4WkHy9rGZw5iP2A0wsthFufIcsYg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718716691; c=relaxed/simple;
	bh=X4wu9B2UuNy/fvWEmuC1I6n45XlpB2jpzWWcc+Xn93s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lrBBnzfS8CcQjNUFLSm6z/ROiMUJK++LDBegeJen3e+IvjEWiBDpXCgSaC8GKpI55kbUmBXf3LXI404eUMeqBstsHe5lmKzlv+OEql8ktIE7wZCBtmjpMtIztdLMrHQfkslqlBlQqniNGjApPl2cqUUK/fNAnGu1pZHUdHWXOPc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lEH8SP8/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lEH8SP8/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C69CDC3277B;
	Tue, 18 Jun 2024 13:18:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718716691;
	bh=X4wu9B2UuNy/fvWEmuC1I6n45XlpB2jpzWWcc+Xn93s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lEH8SP8/MpCmP14qFr2BODDg90zzAIpOLvb42ABfrX+XJd/H5PJjae0PK2bAVG9ul
	 uC3ol7tSuqU/R4DMWwMc9pBSp/95QMNWaYyPzdtI5sqkqKJBw+NcaUBTbdW+qn8yN2
	 dZswgcqsxlVeHfS3yz7ZtvzgFDm7CATiCOz/LJ5o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	NeilBrown <neilb@suse.de>,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 731/770] nfsd: allow nfsd_file_get to sanely handle a NULL pointer
Date: Tue, 18 Jun 2024 14:39:44 +0200
Message-ID: <20240618123435.484573843@linuxfoundation.org>
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

From: Jeff Layton <jlayton@kernel.org>

[ Upstream commit 70f62231cdfd52357836733dd31db787e0412ab2 ]

...and remove some now-useless NULL pointer checks in its callers.

Suggested-by: NeilBrown <neilb@suse.de>
Signed-off-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/filecache.c | 5 ++---
 fs/nfsd/nfs4state.c | 4 +---
 2 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/fs/nfsd/filecache.c b/fs/nfsd/filecache.c
index 68c7c82f8b3bb..206742bbbd682 100644
--- a/fs/nfsd/filecache.c
+++ b/fs/nfsd/filecache.c
@@ -451,7 +451,7 @@ static bool nfsd_file_lru_remove(struct nfsd_file *nf)
 struct nfsd_file *
 nfsd_file_get(struct nfsd_file *nf)
 {
-	if (likely(refcount_inc_not_zero(&nf->nf_ref)))
+	if (nf && refcount_inc_not_zero(&nf->nf_ref))
 		return nf;
 	return NULL;
 }
@@ -1106,8 +1106,7 @@ nfsd_file_do_acquire(struct svc_rqst *rqstp, struct svc_fh *fhp,
 	rcu_read_lock();
 	nf = rhashtable_lookup(&nfsd_file_rhash_tbl, &key,
 			       nfsd_file_rhash_params);
-	if (nf)
-		nf = nfsd_file_get(nf);
+	nf = nfsd_file_get(nf);
 	rcu_read_unlock();
 
 	if (nf) {
diff --git a/fs/nfsd/nfs4state.c b/fs/nfsd/nfs4state.c
index 6c11f2701af88..2733eb33d5df2 100644
--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -602,9 +602,7 @@ put_nfs4_file(struct nfs4_file *fi)
 static struct nfsd_file *
 __nfs4_get_fd(struct nfs4_file *f, int oflag)
 {
-	if (f->fi_fds[oflag])
-		return nfsd_file_get(f->fi_fds[oflag]);
-	return NULL;
+	return nfsd_file_get(f->fi_fds[oflag]);
 }
 
 static struct nfsd_file *
-- 
2.43.0



