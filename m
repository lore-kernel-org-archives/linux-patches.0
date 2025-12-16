Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BBEB345CD2;
	Tue, 16 Dec 2025 11:45:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765885512; cv=none; b=ADRmZKAuK2GuZCJ+daDkgAmnbMphBJSzWxr4W8NW610v1cSo5Pk146gJW0GqNhCKMY4jmLNoEoZ79fUjqefomZ8jAmF1b5MSIoprbCC36p4GYU9j2ddtJNA3hrQ5+WLmvhKx9mpCUg2zT4aZb22q1CxbAXqURjCmcERoPIT7/Nk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765885512; c=relaxed/simple;
	bh=P7UVbYEf9ULO6V51dHmJyThxMSTtFHc5qb6D12prAWo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X+HGKOkghBa9dTj25o2BEDaUlP+ZjWbSXzGG5UT5/g/1cUl5Ke/mRn+VrKvdiwogTY/J2/SzhD57hyQCsaBXTZlrxUKePbOSJZv62EovPn7PXNTnTNKmMy/2Bza8zeaFADWJjXAdnyuVcAL8Tkbc7ThqLOkfw07dMgTs1pih1FA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=h2AsgSeG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="h2AsgSeG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 282D0C4CEF1;
	Tue, 16 Dec 2025 11:45:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765885512;
	bh=P7UVbYEf9ULO6V51dHmJyThxMSTtFHc5qb6D12prAWo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=h2AsgSeGWVzGqaB/B655xTPqEeBMDqBDBcaW9DCFF3q69qhuE53Y+zM6VBrKrgDjo
	 PdER3geGlVxO66FvR/cz03/yc0TC8WQHC/M49B30AnCrJgzKX+/WA+BH6vv/xb/qYU
	 PNSvzJMEPL3xGmTOuwVoznMCSWo5hUTY+/KJmGko=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tingmao Wang <m@maowtm.org>,
	Dominique Martinet <asmadeus@codewreck.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 161/507] fs/9p: Dont open remote file with APPEND mode when writeback cache is used
Date: Tue, 16 Dec 2025 12:10:02 +0100
Message-ID: <20251216111351.354241213@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111345.522190956@linuxfoundation.org>
References: <20251216111345.522190956@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tingmao Wang <m@maowtm.org>

[ Upstream commit a63dd8fd137933551bfd9aeeeaa942f04c7aad65 ]

When page cache is used, writebacks are done on a page granularity, and it
is expected that the underlying filesystem (such as v9fs) should respect
the write position.  However, currently v9fs will passthrough O_APPEND to
the server even on cached mode.  This causes data corruption if a sync or
fstat gets between two writes to the same file.

This patch removes the APPEND flag from the open request we send to the
server when writeback caching is involved.  I believe keeping server-side
APPEND is probably fine for uncached mode (even if two fds are opened, one
without O_APPEND and one with it, this should still be fine since they
would use separate fid for the writes).

Signed-off-by: Tingmao Wang <m@maowtm.org>
Fixes: 4eb3117888a9 ("fs/9p: Rework cache modes and add new options to Documentation")
Message-ID: <20251102235631.8724-1-m@maowtm.org>
Signed-off-by: Dominique Martinet <asmadeus@codewreck.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/9p/vfs_file.c       | 11 ++++++++---
 fs/9p/vfs_inode.c      |  3 +--
 fs/9p/vfs_inode_dotl.c |  2 +-
 3 files changed, 10 insertions(+), 6 deletions(-)

diff --git a/fs/9p/vfs_file.c b/fs/9p/vfs_file.c
index eb0b083da269b..d1db03093d4c3 100644
--- a/fs/9p/vfs_file.c
+++ b/fs/9p/vfs_file.c
@@ -43,14 +43,18 @@ int v9fs_file_open(struct inode *inode, struct file *file)
 	struct v9fs_session_info *v9ses;
 	struct p9_fid *fid;
 	int omode;
+	int o_append;
 
 	p9_debug(P9_DEBUG_VFS, "inode: %p file: %p\n", inode, file);
 	v9ses = v9fs_inode2v9ses(inode);
-	if (v9fs_proto_dotl(v9ses))
+	if (v9fs_proto_dotl(v9ses)) {
 		omode = v9fs_open_to_dotl_flags(file->f_flags);
-	else
+		o_append = P9_DOTL_APPEND;
+	} else {
 		omode = v9fs_uflags2omode(file->f_flags,
 					v9fs_proto_dotu(v9ses));
+		o_append = P9_OAPPEND;
+	}
 	fid = file->private_data;
 	if (!fid) {
 		fid = v9fs_fid_clone(file_dentry(file));
@@ -58,9 +62,10 @@ int v9fs_file_open(struct inode *inode, struct file *file)
 			return PTR_ERR(fid);
 
 		if ((v9ses->cache & CACHE_WRITEBACK) && (omode & P9_OWRITE)) {
-			int writeback_omode = (omode & ~P9_OWRITE) | P9_ORDWR;
+			int writeback_omode = (omode & ~(P9_OWRITE | o_append)) | P9_ORDWR;
 
 			p9_debug(P9_DEBUG_CACHE, "write-only file with writeback enabled, try opening O_RDWR\n");
+
 			err = p9_client_open(fid, writeback_omode);
 			if (err < 0) {
 				p9_debug(P9_DEBUG_CACHE, "could not open O_RDWR, disabling caches\n");
diff --git a/fs/9p/vfs_inode.c b/fs/9p/vfs_inode.c
index 399d455d50d62..2fe2d1cb20ff1 100644
--- a/fs/9p/vfs_inode.c
+++ b/fs/9p/vfs_inode.c
@@ -790,7 +790,7 @@ v9fs_vfs_atomic_open(struct inode *dir, struct dentry *dentry,
 	p9_omode = v9fs_uflags2omode(flags, v9fs_proto_dotu(v9ses));
 
 	if ((v9ses->cache & CACHE_WRITEBACK) && (p9_omode & P9_OWRITE)) {
-		p9_omode = (p9_omode & ~P9_OWRITE) | P9_ORDWR;
+		p9_omode = (p9_omode & ~(P9_OWRITE | P9_OAPPEND)) | P9_ORDWR;
 		p9_debug(P9_DEBUG_CACHE,
 			"write-only file with writeback enabled, creating w/ O_RDWR\n");
 	}
@@ -1403,4 +1403,3 @@ static const struct inode_operations v9fs_symlink_inode_operations = {
 	.getattr = v9fs_vfs_getattr,
 	.setattr = v9fs_vfs_setattr,
 };
-
diff --git a/fs/9p/vfs_inode_dotl.c b/fs/9p/vfs_inode_dotl.c
index 5b5fda617b805..a84ee2a04dbbd 100644
--- a/fs/9p/vfs_inode_dotl.c
+++ b/fs/9p/vfs_inode_dotl.c
@@ -286,7 +286,7 @@ v9fs_vfs_atomic_open_dotl(struct inode *dir, struct dentry *dentry,
 	}
 
 	if ((v9ses->cache & CACHE_WRITEBACK) && (p9_omode & P9_OWRITE)) {
-		p9_omode = (p9_omode & ~P9_OWRITE) | P9_ORDWR;
+		p9_omode = (p9_omode & ~(P9_OWRITE | P9_DOTL_APPEND)) | P9_ORDWR;
 		p9_debug(P9_DEBUG_CACHE,
 			"write-only file with writeback enabled, creating w/ O_RDWR\n");
 	}
-- 
2.51.0



