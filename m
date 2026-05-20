Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A87023EE1FD;
	Wed, 20 May 2026 17:14:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779297247; cv=none; b=kyPBp7oQFZbdHkcx0kU90sPhq54o8ZgznGc+djn86bYN8HrQrh0CyzIbXaI+O1zq81QiHFWNUa8wztK0IeFN/4JKd5s2ctFjqs/He4fk+m/qtL3kjoYZ7j96BfeVey7CcINrRnnCysVdztY7ItmZL5VPg85gFAG0auQ2mLTm/rU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779297247; c=relaxed/simple;
	bh=INvXKMtqUd4gos2h2JapjZipHRuBjBPO/SgdFz5nA4k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HEXwG6YhCdNo4+/1xbu4eSJr9fQRKShgRLkK339Xw4IRje4QQACnBC3pUQXXcs/S4Y++KAhdDQsOaS0bB3GTo9DNXKsjsRm8dIOeUhMrCYy4BpD1RhIGjUZpTXY+sJ9jmtnBljy8tfPFQ+xCLYBHYcl64BLhA7Ixt2rvznTr+W8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2Z/92upq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2Z/92upq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B4701F000E9;
	Wed, 20 May 2026 17:14:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779297246;
	bh=CtK4SItDllRjhRhdPLBjoYwsem5+S+1yPE+WPbiXkL8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2Z/92upqaSGanMAKQK+zNhkMMp4Qzv/J+2I0aO3U9OCB846sJ4fs4Aizq9mfDM+EO
	 zLGWJ38k/CWbrBoozg9VBXuRXMlXKf99aSrPlODQgVCwDmhBUhyPAUYdNWelBTQWt0
	 CCVFb/7uUYc7MSfj/b5y934QElylNV/o7/E1MOes=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Olga Kornievskaia <okorniev@redhat.com>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 7.0 1107/1146] nfsd: update mtime/ctime on CLONE in presense of delegated attributes
Date: Wed, 20 May 2026 18:22:37 +0200
Message-ID: <20260520162213.297865000@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Olga Kornievskaia <okorniev@redhat.com>

commit 2863bac7f49c4acd80a048ce52506a2b9c8db015 upstream.

When delegated attributes are given on open, the file is opened with
NOCMTIME and modifying operations do not update mtime/ctime as to not get
out-of-sync with the client's delegated view. However, for CLONE operation,
the server should update its view of mtime/ctime and reflect that in any
GETATTR queries.

Fixes: e5e9b24ab8fa ("nfsd: freeze c/mtime updates with outstanding WRITE_ATTRS delegation")
Cc: stable@vger.kernel.org
Signed-off-by: Olga Kornievskaia <okorniev@redhat.com>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfsd/nfs4proc.c  |    3 +++
 fs/nfsd/nfs4state.c |   44 +++++++++++++++++++++++++++++---------------
 fs/nfsd/state.h     |    1 +
 3 files changed, 33 insertions(+), 15 deletions(-)

--- a/fs/nfsd/nfs4proc.c
+++ b/fs/nfsd/nfs4proc.c
@@ -1413,6 +1413,9 @@ nfsd4_clone(struct svc_rqst *rqstp, stru
 			dst, clone->cl_dst_pos, clone->cl_count,
 			EX_ISSYNC(cstate->current_fh.fh_export));
 
+	if (!status && (READ_ONCE(dst->nf_file->f_mode) & FMODE_NOCMTIME) != 0)
+		nfsd_update_cmtime_attr(dst->nf_file, 0);
+
 	nfsd_file_put(dst);
 	nfsd_file_put(src);
 out:
--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -1226,10 +1226,6 @@ static void put_deleg_file(struct nfs4_f
 
 static void nfsd4_finalize_deleg_timestamps(struct nfs4_delegation *dp, struct file *f)
 {
-	struct iattr ia = { .ia_valid = ATTR_ATIME | ATTR_CTIME | ATTR_MTIME | ATTR_DELEG };
-	struct inode *inode = file_inode(f);
-	int ret;
-
 	/* don't do anything if FMODE_NOCMTIME isn't set */
 	if ((READ_ONCE(f->f_mode) & FMODE_NOCMTIME) == 0)
 		return;
@@ -1247,17 +1243,7 @@ static void nfsd4_finalize_deleg_timesta
 		return;
 
 	/* Stamp everything to "now" */
-	inode_lock(inode);
-	ret = notify_change(&nop_mnt_idmap, f->f_path.dentry, &ia, NULL);
-	inode_unlock(inode);
-	if (ret) {
-		struct inode *inode = file_inode(f);
-
-		pr_notice_ratelimited("nfsd: Unable to update timestamps on inode %02x:%02x:%lu: %d\n",
-					MAJOR(inode->i_sb->s_dev),
-					MINOR(inode->i_sb->s_dev),
-					inode->i_ino, ret);
-	}
+	nfsd_update_cmtime_attr(f, ATTR_ATIME);
 }
 
 static void nfs4_unlock_deleg_lease(struct nfs4_delegation *dp)
@@ -9550,3 +9536,31 @@ out_delegees:
 	put_nfs4_file(fp);
 	return ERR_PTR(status);
 }
+
+/**
+ * nfsd_update_cmtime_attr - update file's delegated ctime/mtime,
+ *                           and optionally other attributes (ie ATTR_ATIME).
+ * @f: pointer to an opened file
+ * @flags: any additional flags that should be updated
+ *
+ * Given upon opening a file delegated attributes were issues, update
+ * @f attributes to current times.
+ */
+void nfsd_update_cmtime_attr(struct file *f, unsigned int flags)
+{
+	int ret;
+	struct inode *inode = file_inode(f);
+	struct iattr attr = {
+		.ia_valid = ATTR_CTIME | ATTR_MTIME | ATTR_DELEG | flags,
+	};
+
+	inode_lock(inode);
+	ret = notify_change(&nop_mnt_idmap, f->f_path.dentry, &attr, NULL);
+	inode_unlock(inode);
+	if (ret)
+		pr_notice_ratelimited("nfsd: Unable to update timestamps on "
+				      "inode %02x:%02x:%lu: %d\n",
+				      MAJOR(inode->i_sb->s_dev),
+				      MINOR(inode->i_sb->s_dev),
+				      inode->i_ino, ret);
+}
--- a/fs/nfsd/state.h
+++ b/fs/nfsd/state.h
@@ -834,6 +834,7 @@ extern void nfsd4_shutdown_copy(struct n
 void nfsd4_put_client(struct nfs4_client *clp);
 void nfsd4_async_copy_reaper(struct nfsd_net *nn);
 bool nfsd4_has_active_async_copies(struct nfs4_client *clp);
+void nfsd_update_cmtime_attr(struct file *f, unsigned int flags);
 extern struct nfs4_client_reclaim *nfs4_client_to_reclaim(struct xdr_netobj name,
 				struct xdr_netobj princhash, struct nfsd_net *nn);
 extern bool nfs4_has_reclaimed_state(struct xdr_netobj name, struct nfsd_net *nn);


