Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 900251F7580;
	Mon, 23 Jun 2025 22:14:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750716878; cv=none; b=MPbR9PflQEn2hXr7UtJLNyMTM/r0NGAXLfOlEfuLgHWBrhTThpIP4NU/yVdsWrDWME47IzcHGWnBbEow0jlAt2HNXZ3kF3A+3dHeBD4sDZEtz4rNIci6tu8MyOGpLQYVyvrDRZbXXwAv1oTbR7XeAmqJ2Fii3KQFe7aBYGk3RIs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750716878; c=relaxed/simple;
	bh=I45C3qjn0yrhPWC6PWNd9hcAcK1ik5gOrjPwcGGzN3k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nU4DhgyS5J5IfHCtw6uTH1slpSECF7YRHs3V4ZnTdWhx8gLZNcEZEJdX/b24BS4JWGKlTIS3ENpFe0zTvnwuf9Ijy9vc+NJl5UUadT1SMvjofvPPhcjySbUKR4KLTL1oJxyAeUIMw8vtPwiaQgY6Pb6PxUJ3Lfoh0yM2HprBONg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uy/4v6xa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uy/4v6xa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3CEEC4CEED;
	Mon, 23 Jun 2025 22:14:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750716877;
	bh=I45C3qjn0yrhPWC6PWNd9hcAcK1ik5gOrjPwcGGzN3k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uy/4v6xaI8NNnb1z2am6qeVaqK6Oy+WGzFyZ0ZElHSDRasYJBi6KbLqlU0w3117qv
	 4SMsb0jFW1v51BDF/Okpfi3yHml3n/7KKHkKlnNG8HA0AMub6o0wQSmyRT06ymrL4X
	 tjhtzR5uGdjnvDxEMAdSul+mk9IYgFTXysI3khb4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH 6.1 341/508] f2fs: fix to do sanity check on sit_bitmap_size
Date: Mon, 23 Jun 2025 15:06:26 +0200
Message-ID: <20250623130653.729715407@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130645.255320792@linuxfoundation.org>
References: <20250623130645.255320792@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -3499,6 +3499,7 @@ int f2fs_sanity_check_ckpt(struct f2fs_s
 	block_t user_block_count, valid_user_blocks;
 	block_t avail_node_count, valid_node_count;
 	unsigned int nat_blocks, nat_bits_bytes, nat_bits_blocks;
+	unsigned int sit_blk_cnt;
 	int i, j;
 
 	total = le32_to_cpu(raw_super->segment_count);
@@ -3610,6 +3611,13 @@ skip_cross:
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


