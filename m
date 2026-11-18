Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795038913;
	b=wVUNpCyimDPAvtmnLqB7XffYdy+PuHTMA/65AvbnUoIbMMGXF4rZo1/BGgnE73EezD5u
	 McibW6pSpbCDe3s0CThIhGgNDkNCeHuuVmmShHeOR5xO/n/+1t6wNrE6KI+59SSXnmCMO
	 RfH2DEXG2tgw+iRwaft9XT6Y20iLTbNatyYQO1J9In5exKf/gJZJLppIv6FxtqlyZFNXv
	 T+XLCIG0Yh4UQOnTlXTufXFcdaOrrMW8eM7aGBcDaN45+9WHpjs/2nbMRQ4PSX3BO35KK
	 Z7menZNbajyJY55bf/kZw2Cl0VAHIYN06cXw0t+lgE6TWVxVzPiEs469OuSTbDValbg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795038913;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=DHB9MvfVG0Y1nQ9eHUNPGAQr0qtjkD1VuTMWUM/Nrac=;
	b=f3YzS1WuBNx/4td2Dt5j/JgG/LVgnNpoet0t5akiimQK8HpyNn9FgfTtOqYg9lNkZjL9
	 4FGrR6q+aBuQzLTVMetRTDfnHjnzTUwcJgvq2cWrOhBr7dWreFEd/IMBFaQngBY6mIxIz
	 mIpXKufZ3xMqyokY/yUTsaTY258FJ7vaoHgFXEJIkgvkWnrXRY3sUrixEL9HdtqvIcbiK
	 3lwWGL4FDNxTjub2Y+5BP5wTd6PAMik81b37iSNDQzS2941g0TWqhmM5c9N1asUIZq3gg
	 Y+8qzcL5MIvBD5R/sOr7nSa6EBFBEs6VJAFOFfBYeGZlaygWuCDe80ZD4CeV3S3yP6w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XS509i8F;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D26C606A320;
	Wed, 18 Nov 2026 21:55:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XS509i8F
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 876591F000C5;
	Wed, 18 Nov 2026 21:55:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795038913;
	bh=DHB9MvfVG0Y1nQ9eHUNPGAQr0qtjkD1VuTMWUM/Nrac=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XS509i8FkE7ske/P2qaGjCFERa5X+aZhcN/iD2LYgqIwGc7xpdubf/37RvpAWzeAl
	 2f91JjtrELjf0wZ3GUNBd19+hD+ZF8A6kWWiBP+NVWd4n63xbaFHHeGKQYklbk95m7
	 esM7iB4QUSZ+SElm53C8MelYrKBufVh0T29s47Bc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jake Labelle <southampton.jake.labelle@gmail.com>,
	Ryusuke Konishi <konishi.ryusuke@gmail.com>,
	Viacheslav Dubeyko <slava@dubeyko.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1875/3318] nilfs2: validate directory position after llseek in readdir
Date: Wed, 18 Nov 2026 15:41:37 +0100
Message-ID: <20261118150418.229293132@linuxfoundation.org>
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
[ sashal: Placed nilfs_validate_entry() after nilfs_set_de_type() to preserve the existing file-type code. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nilfs2/dir.c | 34 ++++++++++++++++++++++++++++++++++
 1 file changed, 34 insertions(+)

diff --git a/fs/nilfs2/dir.c b/fs/nilfs2/dir.c
index 49ca762baa8f1..0a8bd8fd91b07 100644
--- a/fs/nilfs2/dir.c
+++ b/fs/nilfs2/dir.c
@@ -265,11 +265,27 @@ static void nilfs_set_de_type(struct nilfs_dir_entry *de, struct inode *inode)
 	de->file_type = nilfs_type_by_mode[(mode & S_IFMT)>>S_SHIFT];
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
@@ -288,6 +304,24 @@ static int nilfs_readdir(struct file *file, struct dir_context *ctx)
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



