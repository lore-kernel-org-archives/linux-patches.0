Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3D32AD48
	for <patches@lists.linux.dev>; Wed,  4 Jan 2023 16:23:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC8BFC433F0;
	Wed,  4 Jan 2023 16:23:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672849389;
	bh=cUTqUiLTyJfhUuMlGrcEzSekqc4IF9ChGr86Kb6jeQI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cAUsPhrIXsS/5xAcqKtNPLqRKCjIUNI8mmPPYQYPl/eoAP6IyhIyd5YUS58vUssAw
	 t1k4Nj/OAeGy+gyNBxjA30w0l793GuafXPfQLFLJhw9wUJv85N99SfdX5IFst8cZFt
	 MPTl8USIweNq5LbFXH1qTrwbAMpWx8EgGhFLXUQE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Biggers <ebiggers@google.com>,
	Theodore Tso <tytso@mit.edu>
Subject: [PATCH 6.1 180/207] ext4: fix unaligned memory access in ext4_fc_reserve_space()
Date: Wed,  4 Jan 2023 17:07:18 +0100
Message-Id: <20230104160517.575954877@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230104160511.905925875@linuxfoundation.org>
References: <20230104160511.905925875@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Eric Biggers <ebiggers@google.com>

commit 8415ce07ecf0cc25efdd5db264a7133716e503cf upstream.

As is done elsewhere in the file, build the struct ext4_fc_tl on the
stack and memcpy() it into the buffer, rather than directly writing it
to a potentially-unaligned location in the buffer.

Fixes: aa75f4d3daae ("ext4: main fast-commit commit path")
Cc: <stable@vger.kernel.org> # v5.10+
Signed-off-by: Eric Biggers <ebiggers@google.com>
Link: https://lore.kernel.org/r/20221106224841.279231-6-ebiggers@kernel.org
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/fast_commit.c |   39 +++++++++++++++++++++------------------
 1 file changed, 21 insertions(+), 18 deletions(-)

--- a/fs/ext4/fast_commit.c
+++ b/fs/ext4/fast_commit.c
@@ -675,6 +675,15 @@ static void ext4_fc_submit_bh(struct sup
 
 /* Ext4 commit path routines */
 
+/* memcpy to fc reserved space and update CRC */
+static void *ext4_fc_memcpy(struct super_block *sb, void *dst, const void *src,
+				int len, u32 *crc)
+{
+	if (crc)
+		*crc = ext4_chksum(EXT4_SB(sb), *crc, src, len);
+	return memcpy(dst, src, len);
+}
+
 /* memzero and update CRC */
 static void *ext4_fc_memzero(struct super_block *sb, void *dst, int len,
 				u32 *crc)
@@ -700,12 +709,13 @@ static void *ext4_fc_memzero(struct supe
  */
 static u8 *ext4_fc_reserve_space(struct super_block *sb, int len, u32 *crc)
 {
-	struct ext4_fc_tl *tl;
+	struct ext4_fc_tl tl;
 	struct ext4_sb_info *sbi = EXT4_SB(sb);
 	struct buffer_head *bh;
 	int bsize = sbi->s_journal->j_blocksize;
 	int ret, off = sbi->s_fc_bytes % bsize;
 	int pad_len;
+	u8 *dst;
 
 	/*
 	 * After allocating len, we should have space at least for a 0 byte
@@ -729,16 +739,18 @@ static u8 *ext4_fc_reserve_space(struct
 		return sbi->s_fc_bh->b_data + off;
 	}
 	/* Need to add PAD tag */
-	tl = (struct ext4_fc_tl *)(sbi->s_fc_bh->b_data + off);
-	tl->fc_tag = cpu_to_le16(EXT4_FC_TAG_PAD);
+	dst = sbi->s_fc_bh->b_data + off;
+	tl.fc_tag = cpu_to_le16(EXT4_FC_TAG_PAD);
 	pad_len = bsize - off - 1 - EXT4_FC_TAG_BASE_LEN;
-	tl->fc_len = cpu_to_le16(pad_len);
-	if (crc)
-		*crc = ext4_chksum(sbi, *crc, tl, EXT4_FC_TAG_BASE_LEN);
-	if (pad_len > 0)
-		ext4_fc_memzero(sb, tl + 1, pad_len, crc);
+	tl.fc_len = cpu_to_le16(pad_len);
+	ext4_fc_memcpy(sb, dst, &tl, EXT4_FC_TAG_BASE_LEN, crc);
+	dst += EXT4_FC_TAG_BASE_LEN;
+	if (pad_len > 0) {
+		ext4_fc_memzero(sb, dst, pad_len, crc);
+		dst += pad_len;
+	}
 	/* Don't leak uninitialized memory in the unused last byte. */
-	*((u8 *)(tl + 1) + pad_len) = 0;
+	*dst = 0;
 
 	ext4_fc_submit_bh(sb, false);
 
@@ -750,15 +762,6 @@ static u8 *ext4_fc_reserve_space(struct
 	return sbi->s_fc_bh->b_data;
 }
 
-/* memcpy to fc reserved space and update CRC */
-static void *ext4_fc_memcpy(struct super_block *sb, void *dst, const void *src,
-				int len, u32 *crc)
-{
-	if (crc)
-		*crc = ext4_chksum(EXT4_SB(sb), *crc, src, len);
-	return memcpy(dst, src, len);
-}
-
 /*
  * Complete a fast commit by writing tail tag.
  *


