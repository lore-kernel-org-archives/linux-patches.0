Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D86EE13B792;
	Tue, 18 Jun 2024 12:54:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718715295; cv=none; b=SV011e+4UwFNqO091WuBEcED4a3glst8/byB1JdK876Cw9T+BgXvH/5lQvNXeH8HSOqg/0EIFHo7T5gPZM5JL3qdIVoAeCuOwtDj3CjR27ueIUF2kduFpvG7/tscCcS4idSVHvYxlrBxgyDoPi9Mux0+cmThgwl/8nISvhdqq0Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718715295; c=relaxed/simple;
	bh=WN38W+y8H41c+jEjX+/pwNim72yO2pCOPWdXJ95nPfQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ExklciWogHrLT3qXhy98CGrQPWQZkyaDaLjDIrqrTaG6BrzRrANPc35JFd3Q/lsz+KNlOTfdpmQfcYqv/WIWtS0Shk1TpdYb3HzpLXHnDK5bbqc4XlMnGGzTpJ8MEwgSvaaTZbi2NRx4wmFJBmK6rlB5KkYWL8NIKuKvPJGWcis=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=16uktx5x; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="16uktx5x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27185C3277B;
	Tue, 18 Jun 2024 12:54:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718715295;
	bh=WN38W+y8H41c+jEjX+/pwNim72yO2pCOPWdXJ95nPfQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=16uktx5x1UU/YmD6a2uKFcJZ+a8Y9seV8Y/eGmx9RUNKveCKI2mV1MXSHKCGNvq/r
	 XLfmSyxWceFeE7u0CI2EHbXBYTruyNrKpv7NeOm1sF2CuShMS+HnB4KURZ4e7v/cs7
	 iKfXKaUQ7QuLWP0QCtk59HVKKmddeHlOPlp8rRZ4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"J. Bruce Fields" <bfields@redhat.com>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 260/770] nfsd: hash nfs4_files by inode number
Date: Tue, 18 Jun 2024 14:31:53 +0200
Message-ID: <20240618123417.310139834@linuxfoundation.org>
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

From: J. Bruce Fields <bfields@redhat.com>

[ Upstream commit f9b60e2209213fdfcc504ba25a404977c5d08b77 ]

The nfs4_file structure is per-filehandle, not per-inode, because the
spec requires open and other state to be per filehandle.

But it will turn out to be convenient for nfs4_files associated with the
same inode to be hashed to the same bucket, so let's hash on the inode
instead of the filehandle.

Filehandle aliasing is rare, so that shouldn't have much performance
impact.

(If you have a ton of exported filesystems, though, and all of them have
a root with inode number 2, could that get you an overlong hash chain?
Perhaps this (and the v4 open file cache) should be hashed on the inode
pointer instead.)

Signed-off-by: J. Bruce Fields <bfields@redhat.com>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs4state.c | 27 ++++++++++++---------------
 fs/nfsd/state.h     |  1 -
 2 files changed, 12 insertions(+), 16 deletions(-)

diff --git a/fs/nfsd/nfs4state.c b/fs/nfsd/nfs4state.c
index a42a505b3e417..8d2d6e90bfc5e 100644
--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -554,14 +554,12 @@ static unsigned int ownerstr_hashval(struct xdr_netobj *ownername)
 #define FILE_HASH_BITS                   8
 #define FILE_HASH_SIZE                  (1 << FILE_HASH_BITS)
 
-static unsigned int nfsd_fh_hashval(struct knfsd_fh *fh)
+static unsigned int file_hashval(struct svc_fh *fh)
 {
-	return jhash2(fh->fh_base.fh_pad, XDR_QUADLEN(fh->fh_size), 0);
-}
+	struct inode *inode = d_inode(fh->fh_dentry);
 
-static unsigned int file_hashval(struct knfsd_fh *fh)
-{
-	return nfsd_fh_hashval(fh) & (FILE_HASH_SIZE - 1);
+	/* XXX: why not (here & in file cache) use inode? */
+	return (unsigned int)hash_long(inode->i_ino, FILE_HASH_BITS);
 }
 
 static struct hlist_head file_hashtbl[FILE_HASH_SIZE];
@@ -4106,7 +4104,7 @@ static struct nfs4_file *nfsd4_alloc_file(void)
 }
 
 /* OPEN Share state helper functions */
-static void nfsd4_init_file(struct knfsd_fh *fh, unsigned int hashval,
+static void nfsd4_init_file(struct svc_fh *fh, unsigned int hashval,
 				struct nfs4_file *fp)
 {
 	lockdep_assert_held(&state_lock);
@@ -4116,7 +4114,7 @@ static void nfsd4_init_file(struct knfsd_fh *fh, unsigned int hashval,
 	INIT_LIST_HEAD(&fp->fi_stateids);
 	INIT_LIST_HEAD(&fp->fi_delegations);
 	INIT_LIST_HEAD(&fp->fi_clnt_odstate);
-	fh_copy_shallow(&fp->fi_fhandle, fh);
+	fh_copy_shallow(&fp->fi_fhandle, &fh->fh_handle);
 	fp->fi_deleg_file = NULL;
 	fp->fi_had_conflict = false;
 	fp->fi_share_deny = 0;
@@ -4460,13 +4458,13 @@ move_to_close_lru(struct nfs4_ol_stateid *s, struct net *net)
 
 /* search file_hashtbl[] for file */
 static struct nfs4_file *
-find_file_locked(struct knfsd_fh *fh, unsigned int hashval)
+find_file_locked(struct svc_fh *fh, unsigned int hashval)
 {
 	struct nfs4_file *fp;
 
 	hlist_for_each_entry_rcu(fp, &file_hashtbl[hashval], fi_hash,
 				lockdep_is_held(&state_lock)) {
-		if (fh_match(&fp->fi_fhandle, fh)) {
+		if (fh_match(&fp->fi_fhandle, &fh->fh_handle)) {
 			if (refcount_inc_not_zero(&fp->fi_ref))
 				return fp;
 		}
@@ -4474,8 +4472,7 @@ find_file_locked(struct knfsd_fh *fh, unsigned int hashval)
 	return NULL;
 }
 
-struct nfs4_file *
-find_file(struct knfsd_fh *fh)
+static struct nfs4_file * find_file(struct svc_fh *fh)
 {
 	struct nfs4_file *fp;
 	unsigned int hashval = file_hashval(fh);
@@ -4487,7 +4484,7 @@ find_file(struct knfsd_fh *fh)
 }
 
 static struct nfs4_file *
-find_or_add_file(struct nfs4_file *new, struct knfsd_fh *fh)
+find_or_add_file(struct nfs4_file *new, struct svc_fh *fh)
 {
 	struct nfs4_file *fp;
 	unsigned int hashval = file_hashval(fh);
@@ -4519,7 +4516,7 @@ nfs4_share_conflict(struct svc_fh *current_fh, unsigned int deny_type)
 	struct nfs4_file *fp;
 	__be32 ret = nfs_ok;
 
-	fp = find_file(&current_fh->fh_handle);
+	fp = find_file(current_fh);
 	if (!fp)
 		return ret;
 	/* Check for conflicting share reservations */
@@ -5208,7 +5205,7 @@ nfsd4_process_open2(struct svc_rqst *rqstp, struct svc_fh *current_fh, struct nf
 	 * and check for delegations in the process of being recalled.
 	 * If not found, create the nfs4_file struct
 	 */
-	fp = find_or_add_file(open->op_file, &current_fh->fh_handle);
+	fp = find_or_add_file(open->op_file, current_fh);
 	if (fp != open->op_file) {
 		status = nfs4_check_deleg(cl, open, &dp);
 		if (status)
diff --git a/fs/nfsd/state.h b/fs/nfsd/state.h
index 54cab651ac1d0..61a2d95d79233 100644
--- a/fs/nfsd/state.h
+++ b/fs/nfsd/state.h
@@ -669,7 +669,6 @@ extern struct nfs4_client_reclaim *nfs4_client_to_reclaim(struct xdr_netobj name
 				struct xdr_netobj princhash, struct nfsd_net *nn);
 extern bool nfs4_has_reclaimed_state(struct xdr_netobj name, struct nfsd_net *nn);
 
-struct nfs4_file *find_file(struct knfsd_fh *fh);
 void put_nfs4_file(struct nfs4_file *fi);
 extern void nfs4_put_copy(struct nfsd4_copy *copy);
 extern struct nfsd4_copy *
-- 
2.43.0



