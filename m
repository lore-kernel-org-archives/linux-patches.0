Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063215;
	b=1iV35JAR0xCQafNnxD8VQRhVO4pRDkfDseeL+mRQq4WZt4cbMnhPq0c+EYQgLPNfyzfB
	 lArd0p6b3/RAwqQen6xhw0PRAs3VZKGwqsaghxKAYMuFlqloI+kGTVwquLCYc24vqoH9I
	 EsRUj6eN7ny4+emc0gcx1P9nzxU7u+waVcY0b957vC+zbnVuflypp1MVftBmI9dJNEmHY
	 2/OeONKw0c3ivzaAGNwO8MN5j5sSMd9JK36vJqRJeBa2MXyJi8YGemxZhap4eKH9U9Q6z
	 MYPQoM5ckIYaIpK+q9ey6rxcjP6MnpUdfzMEkRRxremN5UqdfkYwXN7QeRI/ko4Pe0Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063215;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=AAMpqzpPYv2V7adUf53t6QVisq4fQW1x9iHGOGp5opA=;
	b=RoPAHCItZWgVasSUAGP5X+md6RJXYayvSHEI9JY/HoWebSJQ35V069yz8vxPWxeJaSj0
	 3/C12h43nDoAFvV5clLDuPAuqKsf5L8DNIjlXuf2OKVtAeVrwCjrNFKipG4r+NY7krFwR
	 D0CsDC8aEm9SvrZf8SC4gc8oONuOMzKG33IMyZkz27nMwjjqj+NnGSWlxk5mld1I4d4+a
	 f15MNwy1kZdUoLdgD8rF3FejnIqeapUvbb0AiTPxZ6Ea2mxMGL0EA76MG01cIXwBXcQNv
	 Ft1NUPjqkwiK4dF1ldVXGIKAORU6tMU2A+7uh7JY36qhuEnTX955Dc1cp1FzWLuat/g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mcVkGAdY;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE5DA606A326;
	Sat,  7 Nov 2026 14:53:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mcVkGAdY
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6712F1F0089F;
	Sat,  7 Nov 2026 14:53:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063214;
	bh=AAMpqzpPYv2V7adUf53t6QVisq4fQW1x9iHGOGp5opA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mcVkGAdYQVZ7qEH1MgdIk73kyUv6/W3aVTXlVxsmZ8aj4+9eZ5oyyZFm/XudUrq+3
	 fLgP1Wr9oCMacZKnsRaM8W+aEdjMksDag5KBaCAhHjHF62B0NZVVrzZg5iZli9rMEf
	 /xd76FEvGfZQ7kqB5SdwoKe+1ct2IPcYw9Ywdey8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jake Labelle <southampton.jake.labelle@gmail.com>,
	Ryusuke Konishi <konishi.ryusuke@gmail.com>,
	Viacheslav Dubeyko <slava@dubeyko.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 424/869] nilfs2: validate directory position after llseek in readdir
Date: Sat,  7 Nov 2026 08:51:46 -0500
Message-ID: <20261107134908.090723947@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jake Labelle <southampton.jake.labelle@gmail.com>

[ Upstream commit de7f49c12566cc5c7437a2f26c6c754b9d4d5648 ]

nilfs_readdir() uses ctx->pos, which userspace can set to an arbitrary
value via llseek, as an offset into the directory folio and parses
whatever bytes sit there as a directory entry.  A position pointing
into the middle of an entry -- or at unused bytes of a corrupted image
that the page validator never inspected -- makes dir_emit() copy up to
255 (name_len) bytes from a bogus entry, possibly reading past the end
of the folio and returning unrelated memory contents to userspace.

Snap unaligned positions onto a valid entry boundary by walking the
rec_len chain from the chunk start before parsing, as ext2 does in
ext2_validate_entry().

[ryusuke: fixed offset wrap-around in nilfs_validate_entry() and
 conformed AI tag to guidelines]

Fixes: 2ba466d74ed7 ("nilfs2: directory entry operations")
Assisted-by: Claude:claude-mythos-5
Signed-off-by: Jake Labelle <southampton.jake.labelle@gmail.com>
Cc: stable@vger.kernel.org
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Signed-off-by: Viacheslav Dubeyko <slava@dubeyko.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nilfs2/dir.c | 34 ++++++++++++++++++++++++++++++++++
 1 file changed, 34 insertions(+)

diff --git a/fs/nilfs2/dir.c b/fs/nilfs2/dir.c
index 6ca3d74be1e16..3e137c9ca1382 100644
--- a/fs/nilfs2/dir.c
+++ b/fs/nilfs2/dir.c
@@ -231,11 +231,27 @@ static struct nilfs_dir_entry *nilfs_next_entry(struct nilfs_dir_entry *p)
 					  nilfs_rec_len_from_disk(p->rec_len));
 }
 
+static inline unsigned int
+nilfs_validate_entry(char *base, unsigned int offset, unsigned int mask)
+{
+	struct nilfs_dir_entry *de = (struct nilfs_dir_entry *)(base + offset);
+	struct nilfs_dir_entry *p =
+		(struct nilfs_dir_entry *)(base + (offset & mask));
+
+	while ((char *)p < (char *)de) {
+		if (p->rec_len == 0)
+			break;
+		p = nilfs_next_entry(p);
+	}
+	return (char *)p - base;
+}
+
 static int nilfs_readdir(struct file *file, struct dir_context *ctx)
 {
 	loff_t pos = ctx->pos;
 	struct inode *inode = file_inode(file);
 	struct super_block *sb = inode->i_sb;
+	unsigned int chunk_size = nilfs_chunk_size(inode);
 	unsigned int offset = pos & ~PAGE_MASK;
 	unsigned long n = pos >> PAGE_SHIFT;
 	unsigned long npages = dir_pages(inode);
@@ -254,6 +270,24 @@ static int nilfs_readdir(struct file *file, struct dir_context *ctx)
 			ctx->pos += PAGE_SIZE - offset;
 			return -EIO;
 		}
+		/*
+		 * ctx->pos comes from userspace via llseek and may point
+		 * into the middle of an entry -- or at unvalidated bytes
+		 * of a crafted image. offset is only nonzero here on the
+		 * very first iteration (subsequent pages always start at
+		 * offset 0, which -- like any chunk boundary -- is always
+		 * a legitimate entry start, since no rec_len chain crosses
+		 * a chunk boundary). Snap a non-chunk-aligned offset onto
+		 * a real entry boundary by walking the chain from the
+		 * enclosing chunk's start, as ext2 does; otherwise
+		 * dir_emit() copies name_len bytes from a fake entry,
+		 * reading past the end of the folio.
+		 */
+		if (offset & (chunk_size - 1)) {
+			offset = nilfs_validate_entry(kaddr, offset,
+					~(chunk_size - 1));
+			ctx->pos = ((loff_t)n << PAGE_SHIFT) + offset;
+		}
 		de = (struct nilfs_dir_entry *)(kaddr + offset);
 		limit = kaddr + nilfs_last_byte(inode, n) -
 			NILFS_DIR_REC_LEN(1);
-- 
2.53.0



