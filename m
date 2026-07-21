Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8739415F23;
	Tue, 21 Jul 2026 21:54:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784670867; cv=none; b=TP4S4WLEixiF16Ibj8qAzUzdpN6yX7M45VJly7eYRkoauPajYua42X8NqeV6wTVnk+E6fdan6p1hg9TEg0ml+XOS+SrdUyWx9eNorf4NeypywYoFZ91tTIF8rANQ0+BOuyO29QLpvbJDtmLdcdiMfu/3aY/HAHnrVVySBltpBDE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784670867; c=relaxed/simple;
	bh=mqEAP2HVD0MFyhPIpwpiEoi/mVGZ94aJ6ZN8hA62+1A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gAyMvf+BSWz4tapk8UGSQZdN/s9bj5Ln1+/dKggrjkoo19iwK7vGwGGcFapLiZwEDSuiKL51678T8f1xG5oXLC5du9nlgjQx59LY1zwn598M+BsOv9lEgnAQmkfBC2sAAb1vXEjRIDNoL3/iUfeOOW5E0YpmEPvG3GeFpVb4BPU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SjolB96W; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SjolB96W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F92B1F000E9;
	Tue, 21 Jul 2026 21:54:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784670865;
	bh=7ZdZyGeGBPqvHMuwl6O33nEaMWzImgH5AdHZGhZr6go=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SjolB96WObu/EeyyQYF4bDlxLuinKEAMka0CHON/JpZg0DMXpTkjLYWx2DJTvEh8m
	 O5IFdT2/jXKv0encpw3VEyANg8H9SNZCp7+2aGfMXiAsmhRzH5QRjl7Zn/jQiAFDml
	 FmUN7yI52CFmCsfNArgXoPB0Lkgf8JxXaL18wAJo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bryam Vargas <hexlabsecurity@proton.me>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 030/843] f2fs: bound i_inline_xattr_size for non-inline-xattr inodes
Date: Tue, 21 Jul 2026 17:14:25 +0200
Message-ID: <20260721152406.648417237@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152405.946368001@linuxfoundation.org>
References: <20260721152405.946368001@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bryam Vargas <hexlabsecurity@proton.me>

[ Upstream commit 378acf3cf19b6af6cba55e8dd1154c4e1504bae8 ]

When the flexible_inline_xattr feature is enabled, do_read_inode() loads
the on-disk i_inline_xattr_size unconditionally:

	if (f2fs_sb_has_flexible_inline_xattr(sbi))
		fi->i_inline_xattr_size = le16_to_cpu(ri->i_inline_xattr_size);

but sanity_check_inode() only range-checks it when the inode also has the
FI_INLINE_XATTR flag set.  An inode that carries an inline dentry or inline
data but not FI_INLINE_XATTR -- the normal layout for an inline
directory -- therefore keeps a fully attacker-controlled
i_inline_xattr_size from a crafted image.

get_inline_xattr_addrs() returns that value with no flag gating, so it
feeds the inode geometry:

	MAX_INLINE_DATA()  = 4 * (CUR_ADDRS_PER_INODE - i_inline_xattr_size - 1)
	NR_INLINE_DENTRY() = MAX_INLINE_DATA() * BITS_PER_BYTE / (...)
	addrs_per_page()   = CUR_ADDRS_PER_INODE - i_inline_xattr_size

A large i_inline_xattr_size drives MAX_INLINE_DATA() and NR_INLINE_DENTRY()
negative, so make_dentry_ptr_inline() sets d->max (int) to a negative
value.  The inline directory walk then compares an unsigned long bit_pos
against that negative d->max, which is promoted to a huge unsigned bound,
and reads far past the inline area:

	while (bit_pos < d->max)		/* fs/f2fs/dir.c */
		... test_bit_le(bit_pos, d->bitmap) / d->dentry[bit_pos] ...

Mounting a crafted image and reading such a directory triggers an
out-of-bounds read in f2fs_fill_dentries(); the same underflow also
corrupts ADDRS_PER_INODE for regular files.

Validate i_inline_xattr_size against MAX_INLINE_XATTR_SIZE whenever the
flexible_inline_xattr feature is enabled -- i.e. whenever the value is
loaded from disk and consumed -- and keep the lower MIN_INLINE_XATTR_SIZE
bound gated on inodes that actually carry an inline xattr, so legitimate
inodes with i_inline_xattr_size == 0 are still accepted.

Cc: stable@vger.kernel.org
Fixes: 6afc662e68b5 ("f2fs: support flexible inline xattr size")
Signed-off-by: Bryam Vargas <hexlabsecurity@proton.me>
Reviewed-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/f2fs/inode.c |   13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

--- a/fs/f2fs/inode.c
+++ b/fs/f2fs/inode.c
@@ -258,14 +258,15 @@ static bool sanity_check_inode(struct in
 		return false;
 	}
 
-	if (f2fs_has_extra_attr(inode) &&
-		f2fs_sb_has_flexible_inline_xattr(sbi) &&
-		f2fs_has_inline_xattr(inode) &&
-		(!fi->i_inline_xattr_size ||
-		fi->i_inline_xattr_size > MAX_INLINE_XATTR_SIZE)) {
+	if (f2fs_sb_has_flexible_inline_xattr(sbi) &&
+		(fi->i_inline_xattr_size > MAX_INLINE_XATTR_SIZE ||
+		(f2fs_has_inline_xattr(inode) &&
+		fi->i_inline_xattr_size <
+			sizeof(struct f2fs_xattr_header) / sizeof(__le32)))) {
 		set_sbi_flag(sbi, SBI_NEED_FSCK);
-		f2fs_warn(sbi, "%s: inode (ino=%lx) has corrupted i_inline_xattr_size: %d, max: %zu",
+		f2fs_warn(sbi, "%s: inode (ino=%lx) has corrupted i_inline_xattr_size: %d, min: %zu, max: %zu",
 			  __func__, inode->i_ino, fi->i_inline_xattr_size,
+			  sizeof(struct f2fs_xattr_header) / sizeof(__le32),
 			  MAX_INLINE_XATTR_SIZE);
 		return false;
 	}


