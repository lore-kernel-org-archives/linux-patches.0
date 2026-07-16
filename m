Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B74B22301;
	Thu, 16 Jul 2026 13:59:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784210364; cv=none; b=F4Zb95U2rzrBZVEZECuZFOOM19T0aAvfMrOon0Oxmw9NIbrnNC4yGfoo4aCZkT4Kyf+LrErnNHG2WLZz/41+Da+wgR59VJxdRin/jPFLzkszpzfPZhMkQGF/CZPXC8tpFTHvWb+zhkOJt9gLZkP3MRGQATDVLoX/RNjEccFIrD0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784210364; c=relaxed/simple;
	bh=gMrXG9owEeg0DUvpuxX08bCVqKzm/sThx47wFWAoMms=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NzA2IIaPH0qr0hb6rThfagA1qPJS46DkBu8+q4b4juMAwjqp6g40LNG7iO0dakWiXWlbkw4gipndlFKZDAYy/M/Us8TuvgMy50xwsgO3L3C7kHvMPee3j929PVRo5ARVKGh9lbryT3aV2+inqQGTveD79X+0Tay2oO3tECK+5xY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qzOJl5Ym; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qzOJl5Ym"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C4DF1F000E9;
	Thu, 16 Jul 2026 13:59:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784210363;
	bh=M7W6J8Q2jk23CRCcTt03wGTpVA+QxqpDN/Fuce7toP8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qzOJl5YmOfqLeWqcjhKGQQQYv/6IubWUOB2OpWwtF+8/B7/Aca1yfQuE9RKSusE3W
	 8Mxw1/0i17W3S67VZaPKktpKaYgH6ibWTQOyg2WHQJYzr17xo0gV3/m0cjPuw754BI
	 rlDUGXtho2zju1OTTUZNgVZ/qMvZLXPvqefHIEDA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Olga Kornievskaia <okorniev@redhat.com>,
	Chuck Lever <chuck.lever@oracle.com>,
	Chuck Lever <cel@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 002/480] nfsd: update mtime/ctime on CLONE in presense of delegated attributes
Date: Thu, 16 Jul 2026 15:25:49 +0200
Message-ID: <20260716133044.730451542@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133044.672218725@linuxfoundation.org>
References: <20260716133044.672218725@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
[ cel: 9be4b7e74eb7 and 3daab3112f03 are missing from linux-6.18.y ]
Signed-off-by: Chuck Lever <cel@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs4proc.c  |  3 +++
 fs/nfsd/nfs4state.c | 44 +++++++++++++++++++++++++++++---------------
 fs/nfsd/state.h     |  1 +
 3 files changed, 33 insertions(+), 15 deletions(-)

diff --git a/fs/nfsd/nfs4proc.c b/fs/nfsd/nfs4proc.c
index 9d876f9d98be20..5bfe49502a06f4 100644
--- a/fs/nfsd/nfs4proc.c
+++ b/fs/nfsd/nfs4proc.c
@@ -1350,6 +1350,9 @@ nfsd4_clone(struct svc_rqst *rqstp, struct nfsd4_compound_state *cstate,
 			dst, clone->cl_dst_pos, clone->cl_count,
 			EX_ISSYNC(cstate->current_fh.fh_export));
 
+	if (!status && (READ_ONCE(dst->nf_file->f_mode) & FMODE_NOCMTIME) != 0)
+		nfsd_update_cmtime_attr(dst->nf_file, 0);
+
 	nfsd_file_put(dst);
 	nfsd_file_put(src);
 out:
diff --git a/fs/nfsd/nfs4state.c b/fs/nfsd/nfs4state.c
index b02fe9926b093c..a063a4a83ec22d 100644
--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -1226,10 +1226,6 @@ static void put_deleg_file(struct nfs4_file *fp)
 
 static void nfsd4_finalize_deleg_timestamps(struct nfs4_delegation *dp, struct file *f)
 {
-	struct iattr ia = { .ia_valid = ATTR_ATIME | ATTR_CTIME | ATTR_MTIME | ATTR_DELEG };
-	struct inode *inode = file_inode(f);
-	int ret;
-
 	/* don't do anything if FMODE_NOCMTIME isn't set */
 	if ((READ_ONCE(f->f_mode) & FMODE_NOCMTIME) == 0)
 		return;
@@ -1247,17 +1243,7 @@ static void nfsd4_finalize_deleg_timestamps(struct nfs4_delegation *dp, struct f
 		return;
 
 	/* Stamp everything to "now" */
-	inode_lock(inode);
-	ret = notify_change(&nop_mnt_idmap, f->f_path.dentry, &ia, NULL);
-	inode_unlock(inode);
-	if (ret) {
-		struct inode *inode = file_inode(f);
-
-		pr_notice_ratelimited("Unable to update timestamps on inode %02x:%02x:%lu: %d\n",
-					MAJOR(inode->i_sb->s_dev),
-					MINOR(inode->i_sb->s_dev),
-					inode->i_ino, ret);
-	}
+	nfsd_update_cmtime_attr(f, ATTR_ATIME);
 }
 
 static void nfs4_unlock_deleg_lease(struct nfs4_delegation *dp)
@@ -9434,3 +9420,31 @@ nfsd4_deleg_getattr_conflict(struct svc_rqst *rqstp, struct dentry *dentry,
 	nfs4_put_stid(&dp->dl_stid);
 	return status;
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
diff --git a/fs/nfsd/state.h b/fs/nfsd/state.h
index aaf513ed910459..2eed2c5b3cd0c2 100644
--- a/fs/nfsd/state.h
+++ b/fs/nfsd/state.h
@@ -831,6 +831,7 @@ extern void nfsd4_shutdown_callback(struct nfs4_client *);
 extern void nfsd4_shutdown_copy(struct nfs4_client *clp);
 void nfsd4_async_copy_reaper(struct nfsd_net *nn);
 bool nfsd4_has_active_async_copies(struct nfs4_client *clp);
+void nfsd_update_cmtime_attr(struct file *f, unsigned int flags);
 extern struct nfs4_client_reclaim *nfs4_client_to_reclaim(struct xdr_netobj name,
 				struct xdr_netobj princhash, struct nfsd_net *nn);
 extern bool nfs4_has_reclaimed_state(struct xdr_netobj name, struct nfsd_net *nn);
-- 
2.53.0



