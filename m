Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C50067E58C;
	Mon,  8 Apr 2024 13:57:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712584670; cv=none; b=VRtCp1MYebbtBW3eLF1FLDI1HrlMZGxOXlimcuMRhZW57IA0PqW4na+bQqXaxj5xwd89IMT2gAJXuh6skd28t24IfxXZPJIpDo/SiBy+9L0U/Oh1x0w3Xxf/n2sgdJPPihloGdLrAKqHVlDk2SZHuIeojSGWRFqlCQBdJlMf2Eg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712584670; c=relaxed/simple;
	bh=Kfos+pI/Ix/J+pClD9gVm/bNXxdW837qb9N7xi6iwdc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WxwXGLn/0+EGKohBc/6ucNf8RjRlETIm7B5HA6GyYoD1ScS6Ks1gREekX/1ZDfNdaa6dUeu0q/Kd+FYpmybvJGdXJHYrTPJ6YgQELo9UC/W9T5lVjSO2/Yw4V1ADmnk/O4F2a25cTGJJBTehBFu9fFNhYQF4DmnzjBmKNLXzqTM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=u5f+lEyc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="u5f+lEyc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5029CC433F1;
	Mon,  8 Apr 2024 13:57:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712584670;
	bh=Kfos+pI/Ix/J+pClD9gVm/bNXxdW837qb9N7xi6iwdc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=u5f+lEycn9Sz+KygCYZB3qSB84rbTot66iK1Z824m+1V7W2kjuPXPcuyT/fjrxB6f
	 Npr/SPjlOPg2dlFo5u5N+OE2S2JJitUnhsv7X0VepSalXFn0tmDiuMDPVcXxoCjuM0
	 zUnClCBo8T8lEpGVbgYzK0tIahNTXXln6k6ta2fk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	NeilBrown <neilb@suse.de>
Subject: [PATCH 5.15 488/690] NFSD: Clean up find_or_add_file()
Date: Mon,  8 Apr 2024 14:55:54 +0200
Message-ID: <20240408125417.324307489@linuxfoundation.org>
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

[ Upstream commit 9270fc514ba7d415636b23bcb937573a1ce54f6a ]

Remove the call to find_file_locked() in insert_nfs4_file(). Tracing
shows that over 99% of these calls return NULL. Thus it is not worth
the expense of the extra bucket list traversal. insert_file() already
deals correctly with the case where the item is already in the hash
bucket.

Since nfsd4_file_hash_insert() is now just a wrapper around
insert_file(), move the meat of insert_file() into
nfsd4_file_hash_insert() and get rid of it.

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Reviewed-by: NeilBrown <neilb@suse.de>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
---
 fs/nfsd/nfs4state.c | 64 ++++++++++++++++++++-------------------------
 1 file changed, 28 insertions(+), 36 deletions(-)

diff --git a/fs/nfsd/nfs4state.c b/fs/nfsd/nfs4state.c
index f723d7d5e1557..192e721525665 100644
--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -4698,24 +4698,42 @@ find_file_locked(const struct svc_fh *fh, unsigned int hashval)
 	return NULL;
 }
 
-static struct nfs4_file *insert_file(struct nfs4_file *new, struct svc_fh *fh,
-				     unsigned int hashval)
+static struct nfs4_file * find_file(struct svc_fh *fh)
 {
 	struct nfs4_file *fp;
+	unsigned int hashval = file_hashval(fh);
+
+	rcu_read_lock();
+	fp = find_file_locked(fh, hashval);
+	rcu_read_unlock();
+	return fp;
+}
+
+/*
+ * On hash insertion, identify entries with the same inode but
+ * distinct filehandles. They will all be in the same hash bucket
+ * because nfs4_file's are hashed by the address in the fi_inode
+ * field.
+ */
+static noinline_for_stack struct nfs4_file *
+nfsd4_file_hash_insert(struct nfs4_file *new, const struct svc_fh *fhp)
+{
+	unsigned int hashval = file_hashval(fhp);
 	struct nfs4_file *ret = NULL;
 	bool alias_found = false;
+	struct nfs4_file *fi;
 
 	spin_lock(&state_lock);
-	hlist_for_each_entry_rcu(fp, &file_hashtbl[hashval], fi_hash,
+	hlist_for_each_entry_rcu(fi, &file_hashtbl[hashval], fi_hash,
 				 lockdep_is_held(&state_lock)) {
-		if (fh_match(&fp->fi_fhandle, &fh->fh_handle)) {
-			if (refcount_inc_not_zero(&fp->fi_ref))
-				ret = fp;
-		} else if (d_inode(fh->fh_dentry) == fp->fi_inode)
-			fp->fi_aliased = alias_found = true;
+		if (fh_match(&fi->fi_fhandle, &fhp->fh_handle)) {
+			if (refcount_inc_not_zero(&fi->fi_ref))
+				ret = fi;
+		} else if (d_inode(fhp->fh_dentry) == fi->fi_inode)
+			fi->fi_aliased = alias_found = true;
 	}
 	if (likely(ret == NULL)) {
-		nfsd4_file_init(fh, new);
+		nfsd4_file_init(fhp, new);
 		hlist_add_head_rcu(&new->fi_hash, &file_hashtbl[hashval]);
 		new->fi_aliased = alias_found;
 		ret = new;
@@ -4724,32 +4742,6 @@ static struct nfs4_file *insert_file(struct nfs4_file *new, struct svc_fh *fh,
 	return ret;
 }
 
-static struct nfs4_file * find_file(struct svc_fh *fh)
-{
-	struct nfs4_file *fp;
-	unsigned int hashval = file_hashval(fh);
-
-	rcu_read_lock();
-	fp = find_file_locked(fh, hashval);
-	rcu_read_unlock();
-	return fp;
-}
-
-static struct nfs4_file *
-find_or_add_file(struct nfs4_file *new, struct svc_fh *fh)
-{
-	struct nfs4_file *fp;
-	unsigned int hashval = file_hashval(fh);
-
-	rcu_read_lock();
-	fp = find_file_locked(fh, hashval);
-	rcu_read_unlock();
-	if (fp)
-		return fp;
-
-	return insert_file(new, fh, hashval);
-}
-
 static noinline_for_stack void nfsd4_file_hash_remove(struct nfs4_file *fi)
 {
 	hlist_del_rcu(&fi->fi_hash);
@@ -5641,7 +5633,7 @@ nfsd4_process_open2(struct svc_rqst *rqstp, struct svc_fh *current_fh, struct nf
 	 * and check for delegations in the process of being recalled.
 	 * If not found, create the nfs4_file struct
 	 */
-	fp = find_or_add_file(open->op_file, current_fh);
+	fp = nfsd4_file_hash_insert(open->op_file, current_fh);
 	if (fp != open->op_file) {
 		status = nfs4_check_deleg(cl, open, &dp);
 		if (status)
-- 
2.43.0



