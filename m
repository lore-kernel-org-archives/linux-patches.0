Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C1EE1F3BA2;
	Wed, 17 Sep 2025 12:44:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758113053; cv=none; b=g1i//9Smb1lWtuH9F6qZHs8bepyKHVaMmh6kzFq1wIR+gRQzvcbcwHM+J1kdGixqaFkvqeqCCNHh33b5dVikeBIzm2TEMhE8K6NLxlK8VkxYeeKI/rz4TLmwnXVSnrA6hPV7eJVP+dX2ILh0W0bvk/i+MXqljgB6BtITRLR+qpQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758113053; c=relaxed/simple;
	bh=EeOig5+j15B66zIS0aRrUUkHDiOYt6pSpW6NaHB3L54=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=iIXtEiMKGtNhVEnW+07y7Q7IsHz505Ah0e1k/xANQTurEVmSTpNUyDk5kLTw9MXa3zCIX6mwRSmOYF3mYKbyYYnEme3rw/dmV3pLd/OeqOoWP4ECYRLDmjZdxj0Js5LGycv6diPBY/D/dgEe8GU/1bNVf7a3z/Q34iLblQ2yF0g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Iw7wGZYl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Iw7wGZYl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F168C4CEF0;
	Wed, 17 Sep 2025 12:44:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758113053;
	bh=EeOig5+j15B66zIS0aRrUUkHDiOYt6pSpW6NaHB3L54=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Iw7wGZYlPEWteIoZeF/LlKDJ1LMmelmRSf0JyvR1MmfY5EKvuKk1fIbVbrYE3jUNt
	 yjjx3hsuuPWfELdLDD5F5bfYKTrHnT4EeK68IScpExGnpOPqDtcmjV1kvcHbzP6YBO
	 o+P7ZkiRcXKt6zsfmYM/z4VYv6fqF2drNfBbOxt8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Markuze <amarkuze@redhat.com>,
	Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>,
	Ilya Dryomov <idryomov@gmail.com>
Subject: [PATCH 6.16 102/189] ceph: fix race condition where r_parent becomes stale before sending message
Date: Wed, 17 Sep 2025 14:33:32 +0200
Message-ID: <20250917123354.357078552@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250917123351.839989757@linuxfoundation.org>
References: <20250917123351.839989757@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Markuze <amarkuze@redhat.com>

commit bec324f33d1ed346394b2eee25bf6dbf3511f727 upstream.

When the parent directory's i_rwsem is not locked, req->r_parent may become
stale due to concurrent operations (e.g. rename) between dentry lookup and
message creation. Validate that r_parent matches the encoded parent inode
and update to the correct inode if a mismatch is detected.

[ idryomov: folded a follow-up fix from Alex to drop extra reference
  from ceph_get_reply_dir() in ceph_fill_trace():

  ceph_get_reply_dir() may return a different, referenced inode when
  r_parent is stale and the parent directory lock is not held.
  ceph_fill_trace() used that inode but failed to drop the reference
  when it differed from req->r_parent, leaking an inode reference.

  Keep the directory inode in a local variable and iput() it at
  function end if it does not match req->r_parent. ]

Cc: stable@vger.kernel.org
Signed-off-by: Alex Markuze <amarkuze@redhat.com>
Reviewed-by: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ceph/inode.c |   81 +++++++++++++++++++++++++++++++++++++++++++++++---------
 1 file changed, 69 insertions(+), 12 deletions(-)

--- a/fs/ceph/inode.c
+++ b/fs/ceph/inode.c
@@ -55,6 +55,52 @@ static int ceph_set_ino_cb(struct inode
 	return 0;
 }
 
+/*
+ * Check if the parent inode matches the vino from directory reply info
+ */
+static inline bool ceph_vino_matches_parent(struct inode *parent,
+					    struct ceph_vino vino)
+{
+	return ceph_ino(parent) == vino.ino && ceph_snap(parent) == vino.snap;
+}
+
+/*
+ * Validate that the directory inode referenced by @req->r_parent matches the
+ * inode number and snapshot id contained in the reply's directory record.  If
+ * they do not match – which can theoretically happen if the parent dentry was
+ * moved between the time the request was issued and the reply arrived – fall
+ * back to looking up the correct inode in the inode cache.
+ *
+ * A reference is *always* returned.  Callers that receive a different inode
+ * than the original @parent are responsible for dropping the extra reference
+ * once the reply has been processed.
+ */
+static struct inode *ceph_get_reply_dir(struct super_block *sb,
+					struct inode *parent,
+					struct ceph_mds_reply_info_parsed *rinfo)
+{
+	struct ceph_vino vino;
+
+	if (unlikely(!rinfo->diri.in))
+		return parent; /* nothing to compare against */
+
+	/* If we didn't have a cached parent inode to begin with, just bail out. */
+	if (!parent)
+		return NULL;
+
+	vino.ino  = le64_to_cpu(rinfo->diri.in->ino);
+	vino.snap = le64_to_cpu(rinfo->diri.in->snapid);
+
+	if (likely(ceph_vino_matches_parent(parent, vino)))
+		return parent; /* matches – use the original reference */
+
+	/* Mismatch – this should be rare.  Emit a WARN and obtain the correct inode. */
+	WARN_ONCE(1, "ceph: reply dir mismatch (parent valid %llx.%llx reply %llx.%llx)\n",
+		  ceph_ino(parent), ceph_snap(parent), vino.ino, vino.snap);
+
+	return ceph_get_inode(sb, vino, NULL);
+}
+
 /**
  * ceph_new_inode - allocate a new inode in advance of an expected create
  * @dir: parent directory for new inode
@@ -1523,6 +1569,7 @@ int ceph_fill_trace(struct super_block *
 	struct ceph_vino tvino, dvino;
 	struct ceph_fs_client *fsc = ceph_sb_to_fs_client(sb);
 	struct ceph_client *cl = fsc->client;
+	struct inode *parent_dir = NULL;
 	int err = 0;
 
 	doutc(cl, "%p is_dentry %d is_target %d\n", req,
@@ -1536,10 +1583,17 @@ int ceph_fill_trace(struct super_block *
 	}
 
 	if (rinfo->head->is_dentry) {
-		struct inode *dir = req->r_parent;
-
-		if (dir) {
-			err = ceph_fill_inode(dir, NULL, &rinfo->diri,
+		/*
+		 * r_parent may be stale, in cases when R_PARENT_LOCKED is not set,
+		 * so we need to get the correct inode
+		 */
+		parent_dir = ceph_get_reply_dir(sb, req->r_parent, rinfo);
+		if (unlikely(IS_ERR(parent_dir))) {
+			err = PTR_ERR(parent_dir);
+			goto done;
+		}
+		if (parent_dir) {
+			err = ceph_fill_inode(parent_dir, NULL, &rinfo->diri,
 					      rinfo->dirfrag, session, -1,
 					      &req->r_caps_reservation);
 			if (err < 0)
@@ -1548,14 +1602,14 @@ int ceph_fill_trace(struct super_block *
 			WARN_ON_ONCE(1);
 		}
 
-		if (dir && req->r_op == CEPH_MDS_OP_LOOKUPNAME &&
+		if (parent_dir && req->r_op == CEPH_MDS_OP_LOOKUPNAME &&
 		    test_bit(CEPH_MDS_R_PARENT_LOCKED, &req->r_req_flags) &&
 		    !test_bit(CEPH_MDS_R_ABORTED, &req->r_req_flags)) {
 			bool is_nokey = false;
 			struct qstr dname;
 			struct dentry *dn, *parent;
 			struct fscrypt_str oname = FSTR_INIT(NULL, 0);
-			struct ceph_fname fname = { .dir	= dir,
+			struct ceph_fname fname = { .dir	= parent_dir,
 						    .name	= rinfo->dname,
 						    .ctext	= rinfo->altname,
 						    .name_len	= rinfo->dname_len,
@@ -1564,10 +1618,10 @@ int ceph_fill_trace(struct super_block *
 			BUG_ON(!rinfo->head->is_target);
 			BUG_ON(req->r_dentry);
 
-			parent = d_find_any_alias(dir);
+			parent = d_find_any_alias(parent_dir);
 			BUG_ON(!parent);
 
-			err = ceph_fname_alloc_buffer(dir, &oname);
+			err = ceph_fname_alloc_buffer(parent_dir, &oname);
 			if (err < 0) {
 				dput(parent);
 				goto done;
@@ -1576,7 +1630,7 @@ int ceph_fill_trace(struct super_block *
 			err = ceph_fname_to_usr(&fname, NULL, &oname, &is_nokey);
 			if (err < 0) {
 				dput(parent);
-				ceph_fname_free_buffer(dir, &oname);
+				ceph_fname_free_buffer(parent_dir, &oname);
 				goto done;
 			}
 			dname.name = oname.name;
@@ -1595,7 +1649,7 @@ retry_lookup:
 				      dname.len, dname.name, dn);
 				if (!dn) {
 					dput(parent);
-					ceph_fname_free_buffer(dir, &oname);
+					ceph_fname_free_buffer(parent_dir, &oname);
 					err = -ENOMEM;
 					goto done;
 				}
@@ -1610,12 +1664,12 @@ retry_lookup:
 				    ceph_snap(d_inode(dn)) != tvino.snap)) {
 				doutc(cl, " dn %p points to wrong inode %p\n",
 				      dn, d_inode(dn));
-				ceph_dir_clear_ordered(dir);
+				ceph_dir_clear_ordered(parent_dir);
 				d_delete(dn);
 				dput(dn);
 				goto retry_lookup;
 			}
-			ceph_fname_free_buffer(dir, &oname);
+			ceph_fname_free_buffer(parent_dir, &oname);
 
 			req->r_dentry = dn;
 			dput(parent);
@@ -1794,6 +1848,9 @@ retry_lookup:
 					    &dvino, ptvino);
 	}
 done:
+	/* Drop extra ref from ceph_get_reply_dir() if it returned a new inode */
+	if (unlikely(!IS_ERR_OR_NULL(parent_dir) && parent_dir != req->r_parent))
+		iput(parent_dir);
 	doutc(cl, "done err=%d\n", err);
 	return err;
 }


