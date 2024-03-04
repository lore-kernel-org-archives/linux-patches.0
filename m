Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53C3E1EB5A;
	Mon,  4 Mar 2024 21:49:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709588986; cv=none; b=Amp9I8jxyKiJy2e/00frdxNhjBAX2dZQrXtnYRm5O02NJ10Qd9vZtEnaam0SF9XHWDoJlc0C3Iwk/mQ8PdREXCqKyQi4J3oxd50Rwh9SFwr9s3GlhV73V4l+iLSlajNnFwl9xL56DE84fIOXHInRiike2KPoBvHpRd8iUxYCEcg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709588986; c=relaxed/simple;
	bh=G3/zD0RvUt+GwNVpCiqANitI+a4u6d/19WqKy2GMl0Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tTD4nvnVkgcN6xZGPXEU/2O+jH13rbqh7Aaq6kgXpVwc6Ma2+t/1KJz1XHTE9SvdOfrP2bfxmhWX8EmHvaW1kFky8TjcV7QAD5zsja7k8vRfSZztHMT1mnOT9J690D0RTH8LqUJQYDLj5H3akKt56QqI96BI8pntRD/xMpzcNrk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VkGdKcOv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VkGdKcOv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC0C5C433C7;
	Mon,  4 Mar 2024 21:49:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709588986;
	bh=G3/zD0RvUt+GwNVpCiqANitI+a4u6d/19WqKy2GMl0Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VkGdKcOv5TgDXhRuzM0SAD0oANWYERrJb+pHSEwD3DS3Ggua/ogMVy4B0gRg3Vm7p
	 i1hljgg9MKu3Y4Sh85TTkHusl2Zy7m+wWSrVHy+nwxPPn413swhnyaJzjQgmRLoLRf
	 bmHkK2zDig7OAJkL3F25I1gb1JPIjMx2trP6/hZY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	NeilBrown <neilb@suse.de>,
	Jeff Layton <jlayton@kernel.org>
Subject: [PATCH 6.1 158/215] NFSD: Refactor find_file()
Date: Mon,  4 Mar 2024 21:23:41 +0000
Message-ID: <20240304211602.011227934@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240304211556.993132804@linuxfoundation.org>
References: <20240304211556.993132804@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chuck Lever <chuck.lever@oracle.com>

[ Upstream commit 15424748001a9b5ea62b3e6ad45f0a8b27f01df9 ]

find_file() is now the only caller of find_file_locked(), so just
fold these two together.

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Reviewed-by: NeilBrown <neilb@suse.de>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfsd/nfs4state.c |   36 +++++++++++++++---------------------
 1 file changed, 15 insertions(+), 21 deletions(-)

--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -4683,31 +4683,24 @@ move_to_close_lru(struct nfs4_ol_stateid
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
@@ -4758,9 +4751,10 @@ nfs4_share_conflict(struct svc_fh *curre
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


