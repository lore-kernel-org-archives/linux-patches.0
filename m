Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 769B115FCF5;
	Tue, 18 Jun 2024 12:51:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718715079; cv=none; b=mUNLkh+7YlCBS90+VQM7uKgMh4FfCANpvAZASWnvxVfo5jykYkbCs+J3Mho0oTg8K0f2HZYB3Dx/nFQnR/tKQkEh7XjZ8ugn/njlL243jHt+i+QefPYCtRNZB6dAIgzVMLOr9bpe2almd4728k7KzocmT3LHUEP069W6Csw4q7Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718715079; c=relaxed/simple;
	bh=t+jW8+P0OaYU0RwAKbFMBNbKQH00V4iJtbgiPrSy9HQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HQglLn2Ci/HSPUJKuAsTqO0qJ5exmpNvYyfxa+XbpI0ZSpEZWRJhokgci68HqbFaW9COUhHv3xeXnU23PD0kDH+0+7qPHLakegy0rIMO6QKnE2LNsWL7E90TaLEmv2gmzRBQLYd2uA3d4fCkcK4G95IF2uP5RRmWgtla15PAOIs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RXxOl/7f; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RXxOl/7f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1ED7C3277B;
	Tue, 18 Jun 2024 12:51:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718715079;
	bh=t+jW8+P0OaYU0RwAKbFMBNbKQH00V4iJtbgiPrSy9HQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RXxOl/7fp5ZS29pRywlHLPVQSPmHMFJgAKc3E+VfXUAnuCGPv0ym3h/S4rUuRNRpd
	 m4S9ScG1S8FCTm/0TV6lQl7yg/+gu31CMBd3I+3Y8hin8TUDe26DL8nCGjkZG7QRmz
	 NxXhpekIHXchosXD1cjNKWt/JFkyT928f1kIW3Uo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"J. Bruce Fields" <bfields@redhat.com>,
	Christoph Hellwig <hch@lst.de>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 188/770] nfs: use change attribute for NFS re-exports
Date: Tue, 18 Jun 2024 14:30:41 +0200
Message-ID: <20240618123414.529964054@linuxfoundation.org>
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

[ Upstream commit 3cc55f4434b421d37300aa9a167ace7d60b45ccf ]

When exporting NFS, we may as well use the real change attribute
returned by the original server instead of faking up a change attribute
from the ctime.

Note we can't do that by setting I_VERSION--that would also turn on the
logic in iversion.h which treats the lower bit specially, and that
doesn't make sense for NFS.

So instead we define a new export operation for filesystems like NFS
that want to manage the change attribute themselves.

Signed-off-by: J. Bruce Fields <bfields@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/export.c          | 18 ++++++++++++++++++
 fs/nfsd/nfsfh.h          |  5 ++++-
 include/linux/exportfs.h |  1 +
 3 files changed, 23 insertions(+), 1 deletion(-)

diff --git a/fs/nfs/export.c b/fs/nfs/export.c
index 7412bb164fa77..f2b34cfe286c2 100644
--- a/fs/nfs/export.c
+++ b/fs/nfs/export.c
@@ -167,10 +167,28 @@ nfs_get_parent(struct dentry *dentry)
 	return parent;
 }
 
+static u64 nfs_fetch_iversion(struct inode *inode)
+{
+	struct nfs_server *server = NFS_SERVER(inode);
+
+	/* Is this the right call?: */
+	nfs_revalidate_inode(server, inode);
+	/*
+	 * Also, note we're ignoring any returned error.  That seems to be
+	 * the practice for cache consistency information elsewhere in
+	 * the server, but I'm not sure why.
+	 */
+	if (server->nfs_client->rpc_ops->version >= 4)
+		return inode_peek_iversion_raw(inode);
+	else
+		return time_to_chattr(&inode->i_ctime);
+}
+
 const struct export_operations nfs_export_ops = {
 	.encode_fh = nfs_encode_fh,
 	.fh_to_dentry = nfs_fh_to_dentry,
 	.get_parent = nfs_get_parent,
+	.fetch_iversion = nfs_fetch_iversion,
 	.flags = EXPORT_OP_NOWCC|EXPORT_OP_NOSUBTREECHK|
 		EXPORT_OP_CLOSE_BEFORE_UNLINK|EXPORT_OP_REMOTE_FS|
 		EXPORT_OP_NOATOMIC_ATTR,
diff --git a/fs/nfsd/nfsfh.h b/fs/nfsd/nfsfh.h
index cb20c2cd34695..f58933519f380 100644
--- a/fs/nfsd/nfsfh.h
+++ b/fs/nfsd/nfsfh.h
@@ -12,6 +12,7 @@
 #include <linux/sunrpc/svc.h>
 #include <uapi/linux/nfsd/nfsfh.h>
 #include <linux/iversion.h>
+#include <linux/exportfs.h>
 
 static inline __u32 ino_t_to_u32(ino_t ino)
 {
@@ -264,7 +265,9 @@ fh_clear_wcc(struct svc_fh *fhp)
 static inline u64 nfsd4_change_attribute(struct kstat *stat,
 					 struct inode *inode)
 {
-	if (IS_I_VERSION(inode)) {
+	if (inode->i_sb->s_export_op->fetch_iversion)
+		return inode->i_sb->s_export_op->fetch_iversion(inode);
+	else if (IS_I_VERSION(inode)) {
 		u64 chattr;
 
 		chattr =  stat->ctime.tv_sec;
diff --git a/include/linux/exportfs.h b/include/linux/exportfs.h
index 9f4d4bcbf251d..fe848901fcc3a 100644
--- a/include/linux/exportfs.h
+++ b/include/linux/exportfs.h
@@ -213,6 +213,7 @@ struct export_operations {
 			  bool write, u32 *device_generation);
 	int (*commit_blocks)(struct inode *inode, struct iomap *iomaps,
 			     int nr_iomaps, struct iattr *iattr);
+	u64 (*fetch_iversion)(struct inode *);
 #define	EXPORT_OP_NOWCC			(0x1) /* don't collect v3 wcc data */
 #define	EXPORT_OP_NOSUBTREECHK		(0x2) /* no subtree checking */
 #define	EXPORT_OP_CLOSE_BEFORE_UNLINK	(0x4) /* close files before unlink */
-- 
2.43.0



