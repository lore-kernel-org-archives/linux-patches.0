Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8698221545;
	Mon, 23 Jun 2025 21:24:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750713854; cv=none; b=G+HAPgmnfePpKpHTooPvE+rtRcoaF1BNB+WkqZ5QpQLwOlm0KxZShG8SNYBtdjHjWNEHVu7wAEJ8qlUSZVWMk8yw1ApG5CJDcoiSk3CVD0LTm4zA1kA8FGs9dmlp6BHdQpTd9vbtvRY17S0iek30yQrHhgo1++WRbDrqZ8SQggE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750713854; c=relaxed/simple;
	bh=avVWpvHB7P3k10xqp0tgZ4i6UzlM2dF0smNA5SyuEZY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cqgQF4Kv3RQa55XlU6ah2v3jHpx9fYUSg7DP9pFgvHKtSkXaRyYoNuzyhdV6dHBK1KRfCoii1tyd0CRHxNox2tl8rYxzNsLCDfwMEMLYTjHRCne0mzyOeewafUNqqYW8BKbrYhXZmYceRpS8yoNCLzr6wbWnYwWrfaxYZziu5LY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=q1TQOvu4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="q1TQOvu4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5629EC4CEEA;
	Mon, 23 Jun 2025 21:24:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750713854;
	bh=avVWpvHB7P3k10xqp0tgZ4i6UzlM2dF0smNA5SyuEZY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=q1TQOvu4vMxA3zG+1BDYAR0h3j1esYnT2TZsGFmBoDIIeshS1Bp6uNYODDMW2uYBw
	 YIW2MBUTks8RfES4e3nB9rLcF+XKfsqWjTWkhFEp0IBIvIegJP0YGdznt6bNYeIwh6
	 b/m+fR/UGKN1x/mf3WHdGOme109n8p5wdfQMe/jo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH 5.10 190/355] f2fs: fix to do sanity check on sit_bitmap_size
Date: Mon, 23 Jun 2025 15:06:31 +0200
Message-ID: <20250623130632.391556726@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130626.716971725@linuxfoundation.org>
References: <20250623130626.716971725@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Chao Yu <chao@kernel.org>

commit 5db0d252c64e91ba1929c70112352e85dc5751e7 upstream.

w/ below testcase, resize will generate a corrupted image which
contains inconsistent metadata, so when mounting such image, it
will trigger kernel panic:

touch img
truncate -s $((512*1024*1024*1024)) img
mkfs.f2fs -f img $((256*1024*1024))
resize.f2fs -s -i img -t $((1024*1024*1024))
mount img /mnt/f2fs

------------[ cut here ]------------
kernel BUG at fs/f2fs/segment.h:863!
Oops: invalid opcode: 0000 [#1] SMP PTI
CPU: 11 UID: 0 PID: 3922 Comm: mount Not tainted 6.15.0-rc1+ #191 PREEMPT(voluntary)
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
RIP: 0010:f2fs_ra_meta_pages+0x47c/0x490

Call Trace:
 f2fs_build_segment_manager+0x11c3/0x2600
 f2fs_fill_super+0xe97/0x2840
 mount_bdev+0xf4/0x140
 legacy_get_tree+0x2b/0x50
 vfs_get_tree+0x29/0xd0
 path_mount+0x487/0xaf0
 __x64_sys_mount+0x116/0x150
 do_syscall_64+0x82/0x190
 entry_SYSCALL_64_after_hwframe+0x76/0x7e
RIP: 0033:0x7fdbfde1bcfe

The reaseon is:

sit_i->bitmap_size is 192, so size of sit bitmap is 192*8=1536, at maximum
there are 1536 sit blocks, however MAIN_SEGS is 261893, so that sit_blk_cnt
is 4762, build_sit_entries() -> current_sit_addr() tries to access
out-of-boundary in sit_bitmap at offset from [1536, 4762), once sit_bitmap
and sit_bitmap_mirror is not the same, it will trigger f2fs_bug_on().

Let's add sanity check in f2fs_sanity_check_ckpt() to avoid panic.

Cc: stable@vger.kernel.org
Signed-off-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/f2fs/super.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/fs/f2fs/super.c
+++ b/fs/f2fs/super.c
@@ -3017,6 +3017,7 @@ int f2fs_sanity_check_ckpt(struct f2fs_s
 	block_t user_block_count, valid_user_blocks;
 	block_t avail_node_count, valid_node_count;
 	unsigned int nat_blocks, nat_bits_bytes, nat_bits_blocks;
+	unsigned int sit_blk_cnt;
 	int i, j;
 
 	total = le32_to_cpu(raw_super->segment_count);
@@ -3118,6 +3119,13 @@ int f2fs_sanity_check_ckpt(struct f2fs_s
 		return 1;
 	}
 
+	sit_blk_cnt = DIV_ROUND_UP(main_segs, SIT_ENTRY_PER_BLOCK);
+	if (sit_bitmap_size * 8 < sit_blk_cnt) {
+		f2fs_err(sbi, "Wrong bitmap size: sit: %u, sit_blk_cnt:%u",
+			 sit_bitmap_size, sit_blk_cnt);
+		return 1;
+	}
+
 	cp_pack_start_sum = __start_sum_addr(sbi);
 	cp_payload = __cp_payload(sbi);
 	if (cp_pack_start_sum < cp_payload + 1 ||


