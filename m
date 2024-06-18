Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 029231AD4B9;
	Tue, 18 Jun 2024 13:20:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718716834; cv=none; b=OGwcUm5Rtt1p0oeWS85q4+zun778I7Ga7yIbLRu+8IaBrMQ2RW16tl91PWh1S0YJbeAgfMPblTJdmIIxRHX/xb4x43UeTlC0ythUQaF2nzDTWRjYsVDGGODTGZqHl39ScsrKFr5tpfxGofSCg4/W2dLk/OtM3xrXUXFeR5e9PBE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718716834; c=relaxed/simple;
	bh=x8BBWA2HS1PKjR+nmRofcvvuKpQWcVzXa5/bSJu8mV8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b+rCQFR944vizY3l8K+HA8twq/P2fMwUMmIuL+NYpby6r5DxhyEuo4AEyNRbqf8a4xCi5H7T7uQDsEFopcTeHFB1zLf6r8MTHyaPPMUHqLET03ihcqi24+NW/mynRQTBNLYLJZxX/LrdxNjYFYFthEkCUniXEKxSLMleFjG7Bbg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=a14YJI7H; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="a14YJI7H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B509C3277B;
	Tue, 18 Jun 2024 13:20:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718716833;
	bh=x8BBWA2HS1PKjR+nmRofcvvuKpQWcVzXa5/bSJu8mV8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=a14YJI7HuCHJEIytFGcPUXJms11PL+OYJK/u61bJZKEiaiOnag4jW1Cu8p5yOTB+C
	 CqlRVXbd2z9xF3DSj/6vPQVMsDdYVQjGF6DeYW6nrLJTKhksWHH0sL2l6Tdx9FS1CI
	 laRSrG44XhS99+oIln81wGWFsXAh44xK4iZ923zQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Anna Schumaker <Anna.Schumaker@Netapp.com>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 751/770] nfsd: allow reaping files still under writeback
Date: Tue, 18 Jun 2024 14:40:04 +0200
Message-ID: <20240618123436.258824397@linuxfoundation.org>
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

From: Jeff Layton <jlayton@kernel.org>

[ Upstream commit dcb779fcd4ed5984ad15991d574943d12a8693d1 ]

On most filesystems, there is no reason to delay reaping an nfsd_file
just because its underlying inode is still under writeback. nfsd just
relies on client activity or the local flusher threads to do writeback.

The main exception is NFS, which flushes all of its dirty data on last
close. Add a new EXPORT_OP_FLUSH_ON_CLOSE flag to allow filesystems to
signal that they do this, and only skip closing files under writeback on
such filesystems.

Also, remove a redundant NULL file pointer check in
nfsd_file_check_writeback, and clean up nfs's export op flag
definitions.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
Acked-by: Anna Schumaker <Anna.Schumaker@Netapp.com>
[ cel: adjusted to apply to v5.10.y ]
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/export.c          |  9 ++++++---
 fs/nfsd/filecache.c      | 12 +++++++++++-
 include/linux/exportfs.h |  1 +
 3 files changed, 18 insertions(+), 4 deletions(-)

diff --git a/fs/nfs/export.c b/fs/nfs/export.c
index b347e3ce0cc8e..993be63ab3015 100644
--- a/fs/nfs/export.c
+++ b/fs/nfs/export.c
@@ -182,7 +182,10 @@ const struct export_operations nfs_export_ops = {
 	.fh_to_dentry = nfs_fh_to_dentry,
 	.get_parent = nfs_get_parent,
 	.fetch_iversion = nfs_fetch_iversion,
-	.flags = EXPORT_OP_NOWCC|EXPORT_OP_NOSUBTREECHK|
-		EXPORT_OP_CLOSE_BEFORE_UNLINK|EXPORT_OP_REMOTE_FS|
-		EXPORT_OP_NOATOMIC_ATTR,
+	.flags = EXPORT_OP_NOWCC		|
+		 EXPORT_OP_NOSUBTREECHK		|
+		 EXPORT_OP_CLOSE_BEFORE_UNLINK	|
+		 EXPORT_OP_REMOTE_FS		|
+		 EXPORT_OP_NOATOMIC_ATTR	|
+		 EXPORT_OP_FLUSH_ON_CLOSE,
 };
diff --git a/fs/nfsd/filecache.c b/fs/nfsd/filecache.c
index 1d4c0387c4192..080d796547854 100644
--- a/fs/nfsd/filecache.c
+++ b/fs/nfsd/filecache.c
@@ -401,13 +401,23 @@ nfsd_file_check_writeback(struct nfsd_file *nf)
 	struct file *file = nf->nf_file;
 	struct address_space *mapping;
 
-	if (!file || !(file->f_mode & FMODE_WRITE))
+	/* File not open for write? */
+	if (!(file->f_mode & FMODE_WRITE))
 		return false;
+
+	/*
+	 * Some filesystems (e.g. NFS) flush all dirty data on close.
+	 * On others, there is no need to wait for writeback.
+	 */
+	if (!(file_inode(file)->i_sb->s_export_op->flags & EXPORT_OP_FLUSH_ON_CLOSE))
+		return false;
+
 	mapping = file->f_mapping;
 	return mapping_tagged(mapping, PAGECACHE_TAG_DIRTY) ||
 		mapping_tagged(mapping, PAGECACHE_TAG_WRITEBACK);
 }
 
+
 static bool nfsd_file_lru_add(struct nfsd_file *nf)
 {
 	set_bit(NFSD_FILE_REFERENCED, &nf->nf_flags);
diff --git a/include/linux/exportfs.h b/include/linux/exportfs.h
index fe848901fcc3a..218fc5c54e901 100644
--- a/include/linux/exportfs.h
+++ b/include/linux/exportfs.h
@@ -221,6 +221,7 @@ struct export_operations {
 #define EXPORT_OP_NOATOMIC_ATTR		(0x10) /* Filesystem cannot supply
 						  atomic attribute updates
 						*/
+#define EXPORT_OP_FLUSH_ON_CLOSE	(0x20) /* fs flushes file data on close */
 	unsigned long	flags;
 };
 
-- 
2.43.0



