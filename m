Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28AA37C6C9;
	Mon,  8 Apr 2024 13:59:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712584762; cv=none; b=BgbyzBZhCv09NRZTtcKRuwC1m5lKuRRJ+SDoDzqXemSzxgM3Wh2ouF8T4Uj+wHKLT4rwyOjrwfD1zsTqAw48WDtBKuC97WSQFf0Lol1Quc8/rn2eSky8JOncD+JS/ml3Io6eSlE1zprnDIYm07rgCHpSxkcGR5KiMNMTihcuw10=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712584762; c=relaxed/simple;
	bh=nvq5sTeHTklv/PegVXUCfggxMWFlo0j95auTV+/9t88=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sC8k0W65IUqDxQ6T37V2wGzmIJvlrhapz9Yo+mEQ2eoGAfIDUlbYMnGnmoPPgT9/vP1RqzQnRjNS8j/GFbp+jKAhz2SovZE/iwaBGph3trT/CVFC6Ut4YP+8KBWLTdpk5Mv77l9iPDMXPrqCdfLRG6hum1AmVu91XwvVfx54z8I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NLPZDRVY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NLPZDRVY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6CD7C433C7;
	Mon,  8 Apr 2024 13:59:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712584762;
	bh=nvq5sTeHTklv/PegVXUCfggxMWFlo0j95auTV+/9t88=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NLPZDRVYNbQbGBY+vPb/MW6bLumxSGGjNy4dy4y+cG1IpjEUCVKW0rf8BfM00HWdO
	 atU1xe2IjWI2oQA2UjU8RJtM1OdaSuERMy7J+yu9BbGWd4cejZgFCSGB213IbbVZbO
	 /e9+g0HwO3KhonJ3quATJS2kK8rXa67YtW9xkyf0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	NeilBrown <neilb@suse.de>,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 5.15 518/690] nfsd: allow nfsd_file_get to sanely handle a NULL pointer
Date: Mon,  8 Apr 2024 14:56:24 +0200
Message-ID: <20240408125418.407564270@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125359.506372836@linuxfoundation.org>
References: <20240408125359.506372836@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jeff Layton <jlayton@kernel.org>

[ Upstream commit 70f62231cdfd52357836733dd31db787e0412ab2 ]

...and remove some now-useless NULL pointer checks in its callers.

Suggested-by: NeilBrown <neilb@suse.de>
Signed-off-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
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
index 5c261cc807e8e..628e564e530bf 100644
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



