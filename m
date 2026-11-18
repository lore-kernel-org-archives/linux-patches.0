Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795036303;
	b=SAmZQh+hd17H4YmkY6w0eo6D91LTfDoPFArFOaEv1ClhEEUAqN6Xq2lTPGauglddrLPX
	 sS/KffIpsMNsvDYuvc/rnpUpbgzLo057/QU9tVT67jLTorvPmT/tlVf6t9F7opEPGo4ww
	 HKWzjz+yOK6C2Qhf9KIyiwl4EK3z5onv+6GTzl9E8W9Hi1XMSaAIoXiDAuB48gjhgrJPC
	 IbzRjUcrQmLC+N1R/dagEuxZkuMkdwbHKao3GCxViJn91CfXAOoZNJlV/qvFWm0JQLVTs
	 ZClIMUi+KfsKKR1ySlvS7FUKfo+LAuOwscNAwvSl4larJPW+p7UfaaJZThxZMOyfFRA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795036303;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=eECJAqHY46LSBUYHvn+xT8hqM8Fbt91PhIe6KURR49A=;
	b=iXoNU3o/ufpVDMA/6rjB+gGW5FxMRUGz3RvHvtJyiM4EC6kKIYKG1mgTTk5RdjSkE4f7
	 EKc3uzlR1es7oydGGdpNxcLeODVOcIS35E2Su2B/Z1ICxRHwA9543FQNWsVKuJsFJy+fl
	 A5IZSrsV5EO/MoNWMQHEKLnkuAlw47015S/AssxzLVpffTEir/WuIGgLGwHL53AhGj6lS
	 4MEGK01oz6LO+wKz2nz+p8gjbHqYiazJ+g/uOEcOa1H1OQIwkcDQvmMeJrnJDmhT/h8q5
	 8v03wWI8BGMal5gZVoMEYpav9eklJU7BbLfVkJ9KYTExGDqaWPHL4LGFOT/UDc2P/yQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AbMlhgky;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67610606A330;
	Wed, 18 Nov 2026 21:11:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AbMlhgky
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7757B1F000C6;
	Wed, 18 Nov 2026 21:11:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795036303;
	bh=eECJAqHY46LSBUYHvn+xT8hqM8Fbt91PhIe6KURR49A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AbMlhgkyuA7t167ulUwKu8qwaCmqD8lhPMrVfKYmihi21J5sb+ZabXmXroMTJEA2o
	 18VV0urwOL5DScjTpGxrKulXvDHXRUH0JLog/a5Oe+deZxo5fxKme4ZUvTX0/quMjO
	 +R6eD+3gh8Vl54kFQz3/tPvYu76TDab+d1iWQXCg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrey Albershteyn <aalbersh@kernel.org>,
	Eric Biggers <ebiggers@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1009/3318] fsverity: hoist statx reporting of fs-verity flag
Date: Wed, 18 Nov 2026 15:27:11 +0100
Message-ID: <20261118150350.150042579@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andrey Albershteyn <aalbersh@kernel.org>

[ Upstream commit f9e450420da2624c93ce9585deebfabb87932774 ]

All filesystems, supporting fsverity, report this status by checking
inode flag. Also, BTRFS was missing stat->attributes_mask, which is
fixed now.

Fixes: 146054090b08 ("btrfs: initial fsverity support")
Cc: stable@vger.kernel.org
Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
Acked-by: Eric Biggers <ebiggers@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Link: https://patch.msgid.link/20261002223705.2175542-7-aalbersh@kernel.org
Signed-off-by: Eric Biggers <ebiggers@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/inode.c | 3 ---
 fs/ext4/inode.c  | 5 +----
 fs/f2fs/file.c   | 5 +----
 fs/stat.c        | 6 +++++-
 4 files changed, 7 insertions(+), 12 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index c8034d86f844f..b6d40f0f0fb28 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -8918,7 +8918,6 @@ static int btrfs_getattr(struct mnt_idmap *idmap,
 	struct inode *inode = d_inode(path->dentry);
 	u32 blocksize = btrfs_sb(inode->i_sb)->sectorsize;
 	u32 bi_flags = BTRFS_I(inode)->flags;
-	u32 bi_ro_flags = BTRFS_I(inode)->ro_flags;
 
 	stat->result_mask |= STATX_BTIME;
 	stat->btime.tv_sec = BTRFS_I(inode)->i_otime_sec;
@@ -8931,8 +8930,6 @@ static int btrfs_getattr(struct mnt_idmap *idmap,
 		stat->attributes |= STATX_ATTR_IMMUTABLE;
 	if (bi_flags & BTRFS_INODE_NODUMP)
 		stat->attributes |= STATX_ATTR_NODUMP;
-	if (bi_ro_flags & BTRFS_INODE_RO_VERITY)
-		stat->attributes |= STATX_ATTR_VERITY;
 
 	stat->attributes_mask |= (STATX_ATTR_APPEND |
 				  STATX_ATTR_COMPRESSED |
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 7f9358612f453..b59857780c8fe 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -5786,15 +5786,12 @@ int ext4_getattr(struct mnt_idmap *idmap, const struct path *path,
 		stat->attributes |= STATX_ATTR_IMMUTABLE;
 	if (flags & EXT4_NODUMP_FL)
 		stat->attributes |= STATX_ATTR_NODUMP;
-	if (flags & EXT4_VERITY_FL)
-		stat->attributes |= STATX_ATTR_VERITY;
 
 	stat->attributes_mask |= (STATX_ATTR_APPEND |
 				  STATX_ATTR_COMPRESSED |
 				  STATX_ATTR_ENCRYPTED |
 				  STATX_ATTR_IMMUTABLE |
-				  STATX_ATTR_NODUMP |
-				  STATX_ATTR_VERITY);
+				  STATX_ATTR_NODUMP);
 
 	generic_fillattr(idmap, request_mask, inode, stat);
 	return 0;
diff --git a/fs/f2fs/file.c b/fs/f2fs/file.c
index 793b4c89a9df5..b0b2dc7304687 100644
--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -1000,15 +1000,12 @@ int f2fs_getattr(struct mnt_idmap *idmap, const struct path *path,
 		stat->attributes |= STATX_ATTR_IMMUTABLE;
 	if (flags & F2FS_NODUMP_FL)
 		stat->attributes |= STATX_ATTR_NODUMP;
-	if (IS_VERITY(inode))
-		stat->attributes |= STATX_ATTR_VERITY;
 
 	stat->attributes_mask |= (STATX_ATTR_COMPRESSED |
 				  STATX_ATTR_APPEND |
 				  STATX_ATTR_ENCRYPTED |
 				  STATX_ATTR_IMMUTABLE |
-				  STATX_ATTR_NODUMP |
-				  STATX_ATTR_VERITY);
+				  STATX_ATTR_NODUMP);
 
 	generic_fillattr(idmap, request_mask, inode, stat);
 
diff --git a/fs/stat.c b/fs/stat.c
index 5375be5f97ccf..7c20f34207d20 100644
--- a/fs/stat.c
+++ b/fs/stat.c
@@ -127,8 +127,12 @@ int vfs_getattr_nosec(const struct path *path, struct kstat *stat,
 	if (IS_DAX(inode))
 		stat->attributes |= STATX_ATTR_DAX;
 
+	if (IS_VERITY(inode))
+		stat->attributes |= STATX_ATTR_VERITY;
+
 	stat->attributes_mask |= (STATX_ATTR_AUTOMOUNT |
-				  STATX_ATTR_DAX);
+				  STATX_ATTR_DAX |
+				  STATX_ATTR_VERITY);
 
 	idmap = mnt_idmap(path->mnt);
 	if (inode->i_op->getattr)
-- 
2.53.0



