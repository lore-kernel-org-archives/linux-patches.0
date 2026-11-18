Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795047399;
	b=Mk+4w5bTplcTAfzOiz9vBzBHUvjO4PIHRNTV7J/EnxsadWN1vTT8m43QFOx7VR4gGfCz
	 UZZMnAuNJT6yVxEHJrqUKTks54Qc8/MtOqvFNh+jcpYAeBBuFKFt8RVfeJQpGcKh9Sn26
	 NoX12aOdJv4bb4LPoAbUXJC7sf+cVPiuKwF5I6/dFIiJQ6ng84so5cDxf4tP3DC488iRG
	 upCEgOBZ//b0z+nIgrfJlo961gt6qvr29IzHnSrRbUT/kM94O6zNDuAz5BJfYoVB1KwgF
	 pih6Dp52jyYdwmsX8EZLibVBqTxZr+u5VlxMDuM5BUn9XnRoiDjnaPmzleHIKgxpzBw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795047399;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=zJaK5673NEyhokSSPzmMYESl3eXQQ8fS7Pwzeafskqc=;
	b=QgjmosdO8r/NUQe7idxSLXh4Ire+bnG5Ri7Z1P2LgilJXIV+Q/0p9ARZk6uV/psC6DqZ
	 82PFwcamusnylDvnxVAkLTrMquMVcwTWpAer6Hs1zDPiAo70jZsM/9/qp13N6qN/dHZiO
	 2xWzoDR855Z2heC63tu/AlilEIEuUpgbl2BBgs7Cu5D8a3nTKVGZwis29WcjjX+2Byfvw
	 Qs4nZDxeisGqDTP80KmUCQ6oE/ZCk4d0pez4qc2gI7KTKV8oEz32kJDdttQW4GR71CJI3
	 ABr9MWS6SGFUXXOMX3p5Zitr04wjB6tv832HgXHIy0USKbjS2E460H7GQ2QEy9diArw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Gvq9Xw65;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2202606A31C;
	Thu, 19 Nov 2026 00:16:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Gvq9Xw65
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3076B1F000C4;
	Thu, 19 Nov 2026 00:16:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795047399;
	bh=zJaK5673NEyhokSSPzmMYESl3eXQQ8fS7Pwzeafskqc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Gvq9Xw65p68vR5FRBw2POsoTr71b1u+AdZyqcPIm5NRuEyUNi2Zl6naoI4eJbghpV
	 vfpZL7T+LTygOPdtb5jMNd+ynZ5rAQFXk5C39BRl1zhEbo/nR8i84z97hGQQc3PGUi
	 4FGBtmYUOO7FN3lgJ5gPrr7b4hWiif8rVnCjTuQw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jake Labelle <southampton.jake.labelle@gmail.com>,
	Ryusuke Konishi <konishi.ryusuke@gmail.com>,
	Viacheslav Dubeyko <slava@dubeyko.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1624/2857] nilfs2: validate directory position after llseek in readdir
Date: Wed, 18 Nov 2026 15:44:18 +0100
Message-ID: <20261118150259.817378060@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
[ sashal: adjusted helper insertion context to follow nilfs_set_de_type() instead of nilfs_next_entry() ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nilfs2/dir.c | 34 ++++++++++++++++++++++++++++++++++
 1 file changed, 34 insertions(+)

diff --git a/fs/nilfs2/dir.c b/fs/nilfs2/dir.c
index 0f3753af16741..0c68db4e4bd53 100644
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



