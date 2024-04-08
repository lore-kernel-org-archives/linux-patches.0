Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D911D2DF73;
	Mon,  8 Apr 2024 13:57:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712584667; cv=none; b=OhyQc5uY1aDLgOlBcud6mGZYKRK4cBbylb60+HH2nj3SBZv2m2BHI1yvm9+oZCXfPFhfNezbZBlA8AaZtCm3Nj/sJ916mjRSoETbrj1SfERje6PwOsovmuGaVlTtqWlGVJOb1S+f/nMdpGVcpZEr5xLkKjjWuT0hnwrwjERwnMA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712584667; c=relaxed/simple;
	bh=sXpLGAkmVhPDr7XWxl38LotfgWIfkVTapoO/YiJfDds=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dgFMBN1US8+ujPzrqULiK77L9eBvqf9XfI4VSDwZ9swROlepycMaac/yc7sABrM5rLaEV+jY34aBRYl6/7itP3gCVQbeqNm3dZXYOH6n6JCEfc6zmvNfLkw2RmAFRaS0kHJAr4NAwNB9oPwuweSJY8jGal6UV8EgyqZaSbq2ecI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eDt0Urr7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eDt0Urr7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 634FEC433F1;
	Mon,  8 Apr 2024 13:57:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712584667;
	bh=sXpLGAkmVhPDr7XWxl38LotfgWIfkVTapoO/YiJfDds=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eDt0Urr7tPgSN6MF0pg9VOWPEDj5qZsabkYBcv03GbQ+Db3eVEsG94/DmMGrLc3wH
	 q6zVKiS38s1UnB4mfDbUz2oXTXjOdBkT86Q6BGV9c13uAI0Oj9uZ8c5ouFtR4HCqYc
	 Q7fSqQp1B80yHEmgnnKc30dN4WKAaJzcNzFl7Ehs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	NeilBrown <neilb@suse.de>,
	Jeff Layton <jlayton@kernel.org>
Subject: [PATCH 5.15 487/690] NFSD: Add a nfsd4_file_hash_remove() helper
Date: Mon,  8 Apr 2024 14:55:53 +0200
Message-ID: <20240408125417.287035840@linuxfoundation.org>
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

From: Chuck Lever <chuck.lever@oracle.com>

[ Upstream commit 3341678f2fd6106055cead09e513fad6950a0d19 ]

Refactor to relocate hash deletion operation to a helper function
that is close to most other nfs4_file data structure operations.

The "noinline" annotation will become useful in a moment when the
hlist_del_rcu() is replaced with a more complex rhash remove
operation. It also guarantees that hash remove operations can be
traced with "-p function -l remove_nfs4_file_locked".

This also simplifies the organization of forward declarations: the
to-be-added rhashtable and its param structure will be defined
/after/ put_nfs4_file().

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Reviewed-by: NeilBrown <neilb@suse.de>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
---
 fs/nfsd/nfs4state.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/fs/nfsd/nfs4state.c b/fs/nfsd/nfs4state.c
index 1cb3ea90eb4ca..f723d7d5e1557 100644
--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -84,6 +84,7 @@ static bool check_for_locks(struct nfs4_file *fp, struct nfs4_lockowner *lowner)
 static void nfs4_free_ol_stateid(struct nfs4_stid *stid);
 void nfsd4_end_grace(struct nfsd_net *nn);
 static void _free_cpntf_state_locked(struct nfsd_net *nn, struct nfs4_cpntf_state *cps);
+static void nfsd4_file_hash_remove(struct nfs4_file *fi);
 
 /* Locking: */
 
@@ -591,7 +592,7 @@ put_nfs4_file(struct nfs4_file *fi)
 	might_lock(&state_lock);
 
 	if (refcount_dec_and_lock(&fi->fi_ref, &state_lock)) {
-		hlist_del_rcu(&fi->fi_hash);
+		nfsd4_file_hash_remove(fi);
 		spin_unlock(&state_lock);
 		WARN_ON_ONCE(!list_empty(&fi->fi_clnt_odstate));
 		WARN_ON_ONCE(!list_empty(&fi->fi_delegations));
@@ -4749,6 +4750,11 @@ find_or_add_file(struct nfs4_file *new, struct svc_fh *fh)
 	return insert_file(new, fh, hashval);
 }
 
+static noinline_for_stack void nfsd4_file_hash_remove(struct nfs4_file *fi)
+{
+	hlist_del_rcu(&fi->fi_hash);
+}
+
 /*
  * Called to check deny when READ with all zero stateid or
  * WRITE with all zero or all one stateid
-- 
2.43.0



