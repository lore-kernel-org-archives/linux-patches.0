Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D56673F9F2F;
	Fri,  4 Sep 2026 05:10:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788498648; cv=none; b=fNyibetUlLfotAp1MuqHB+BLQ+toz8YxC38BbNUIYz16ygUAsT6u2MebDEcaGFyW0s6VsFT+xQPJ57/K4mUtO9p04UgLolKBIwY1jXFfXRC0eKKMO3cWIrSt4cZ9hMAVHc589UX7BHWGqUBxiaOPLOadrlQpBhmHR7mlOHBcOtU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788498648; c=relaxed/simple;
	bh=HKu5aYLK3ufpQsGYHGBYwaqyPAhvsYg0AlmlFHHGc0I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sEzrOhZkEvHrSfU/yc/8iROMvO4Y7eL+HrMTr6VBIN9h1KDle8S5lv0ZfZfXFkzIhuEeCTJBma8t2ZvpM3rHXW/vN8A6VHksyAT0Dj2gY0h3ELJ1FIufj6+1AnSbDxUEgi2/J/CYupZdL6bfXst4wIAIwvcDLvq7aIlCUjW092M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GzM0tKb9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GzM0tKb9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 079471F00A3D;
	Fri,  4 Sep 2026 05:10:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788498646;
	bh=t1oJqUqRbPhNLBovv++26xrZpqySy202GTR7yMpHOgU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GzM0tKb9e1fnaN5qiAUtxupgMtv8mKc9F7sAw9A12MQDtwKRfFOWXEC+bmxaj3cxv
	 7M7o7EFvv4RSOMsVWgHQuO9gpQsPnG0fLxbhuZxvbvk/uozw0vdDR7bsdPPsxVwTRR
	 Rf5yPPD4nuk1fKsO/fzk3EMopbiBVr+GkKb41RL4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Mason <clm@meta.com>,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 7.2 138/713] NFSD: check truncate permission under inode lock
Date: Fri,  4 Sep 2026 06:51:46 +0200
Message-ID: <20260904045806.924136590@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045803.810145556@linuxfoundation.org>
References: <20260904045803.810145556@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chuck Lever <chuck.lever@oracle.com>

commit b778e0e0a16759f22a70579c3cf8d254a40d4a7f upstream.

nfsd_setattr() checks whether a size update needs NFSD_MAY_TRUNC
before it takes inode_lock(). The comparison uses the file size sampled
by that unlocked read, but the actual ATTR_SIZE update is applied later
under inode_lock() by notify_change().

This leaves a TOCTOU window for append-only files. If a client sends a
SETATTR that does not shrink the file at the time of the unlocked
sample, a concurrent append can extend the file before nfsd_setattr()
takes inode_lock(). notify_change() then applies a real truncation
without the NFSD_MAY_TRUNC check that rejects IS_APPEND(inode). The VFS
truncate syscall paths perform their own append-only checks before
calling notify_change(), so NFSD must make this decision against the
locked size it is about to change.

Split the write-count acquisition from the truncation permission check.
Keep get_write_access() before the locked setattr work, then recheck
whether the requested size is below i_size_read(inode) after inode_lock()
has been acquired and before notify_change(ATTR_SIZE). This also avoids
the plain unlocked inode->i_size load.

Fixes: 783112f7401f ("nfsd: special case truncates some more")
Cc: stable@vger.kernel.org
Assisted-by: kres:claude-opus-4-7
Reported-by: Chris Mason <clm@meta.com>
Signed-off-by: Jeff Layton <jlayton@kernel.org>
Link: https://patch.msgid.link/20260530-nfsd-fixes-v2-6-f27e8eb4d974@kernel.org
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfsd/vfs.c |   30 ++++++++++++++++++------------
 1 file changed, 18 insertions(+), 12 deletions(-)

--- a/fs/nfsd/vfs.c
+++ b/fs/nfsd/vfs.c
@@ -419,21 +419,22 @@ nfsd_sanitize_attrs(struct inode *inode,
 }
 
 static __be32
-nfsd_get_write_access(struct svc_rqst *rqstp, struct svc_fh *fhp,
-		struct iattr *iap)
+nfsd_may_truncate(struct svc_rqst *rqstp, struct svc_fh *fhp,
+		  struct iattr *iap)
 {
 	struct inode *inode = d_inode(fhp->fh_dentry);
 
-	if (iap->ia_size < inode->i_size) {
-		__be32 err;
+	if (iap->ia_size >= i_size_read(inode))
+		return nfs_ok;
 
-		err = nfsd_permission(&rqstp->rq_cred,
-				      fhp->fh_export, fhp->fh_dentry,
-				      NFSD_MAY_TRUNC | NFSD_MAY_OWNER_OVERRIDE);
-		if (err)
-			return err;
-	}
-	return nfserrno(get_write_access(inode));
+	return nfsd_permission(&rqstp->rq_cred, fhp->fh_export, fhp->fh_dentry,
+			       NFSD_MAY_TRUNC | NFSD_MAY_OWNER_OVERRIDE);
+}
+
+static __be32
+nfsd_get_write_access(struct svc_fh *fhp)
+{
+	return nfserrno(get_write_access(d_inode(fhp->fh_dentry)));
 }
 
 static int __nfsd_setattr(struct dentry *dentry, struct iattr *iap)
@@ -560,12 +561,17 @@ nfsd_setattr(struct svc_rqst *rqstp, str
 	 * setattr call.
 	 */
 	if (size_change) {
-		err = nfsd_get_write_access(rqstp, fhp, iap);
+		err = nfsd_get_write_access(fhp);
 		if (err)
 			return err;
 	}
 
 	inode_lock(inode);
+	if (size_change) {
+		err = nfsd_may_truncate(rqstp, fhp, iap);
+		if (err)
+			goto out_unlock;
+	}
 	err = fh_fill_pre_attrs(fhp);
 	if (err)
 		goto out_unlock;


