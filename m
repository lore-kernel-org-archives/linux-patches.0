Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 314C4264614;
	Tue,  8 Apr 2025 11:14:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744110844; cv=none; b=arDhrpvDABvbt3qYf+TsRBihkTkEsx1AfUHZ1vXu5L/cGtMuhsbBn8E8cJltuJCnnkeQILWIS26Pz+Trng5f4IceLBtqiyKOQO71umTZ0H/QKzf81VT7NBj8BnptAHFpW637aaczS8d+s9I8N0GRObpI0DcKLKAoy9/SYstk88A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744110844; c=relaxed/simple;
	bh=mEcSSldGQi4EZQslDYFX9Ee6DK8TqdSlWdnJWwmx8SI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=or5OlRuWXz4gni/NfHE515hEAZRYwuK3vCzE+J49btuWkqCOBPL/CngAeZ9lX4QLBUpHOtIwRLoOZxIh6muI8JjEqLLD9T+U/CZz4ctfNdncmnP0DVh9pQ/LN+zvqinecltGSyRsD1NRJi0qqUyaKh9AGg/sDC2lUDqSBPov7KM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=B033pVOo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="B033pVOo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B65B8C4CEE5;
	Tue,  8 Apr 2025 11:14:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744110844;
	bh=mEcSSldGQi4EZQslDYFX9Ee6DK8TqdSlWdnJWwmx8SI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=B033pVOoCI/6UJPDA00atTr0Fkz2oX+Ac84FNUn86Jlm2NtAN0GgOgipR4zBUZx8w
	 p+VN4Y5Naaij1qDJNoaERwrKkcUoxoUaZv+3uEtKCuPnuudBKQEyBNH/81iWJk0tkC
	 CocRXO6X/ul+aRJEmud9rkyd/dy4uFFb80zqLs4Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 176/731] f2fs: fix to avoid running out of free segments
Date: Tue,  8 Apr 2025 12:41:13 +0200
Message-ID: <20250408104918.370588629@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chao Yu <chao@kernel.org>

[ Upstream commit f7f8932ca6bb22494ef6db671633ad3b4d982271 ]

If checkpoint is disabled, GC can not reclaim any segments, we need
to detect such condition and bail out from fallocate() of a pinfile,
rather than letting allocator running out of free segment, which may
cause f2fs to be shutdown.

reproducer:
mkfs.f2fs -f /dev/vda 16777216
mount -o checkpoint=disable:10% /dev/vda /mnt/f2fs
for ((i=0;i<4096;i++)) do { dd if=/dev/zero of=/mnt/f2fs/$i bs=1M count=1; } done
sync
for ((i=0;i<4096;i+=2)) do { rm /mnt/f2fs/$i; } done
sync
touch /mnt/f2fs/pinfile
f2fs_io pinfile set /mnt/f2fs/pinfile
f2fs_io fallocate 0 0 4201644032 /mnt/f2fs/pinfile

cat /sys/kernel/debug/f2fs/status
output:
  - Free: 0 (0)

Fixes: f5a53edcf01e ("f2fs: support aligned pinned file")
Signed-off-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/file.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/fs/f2fs/file.c b/fs/f2fs/file.c
index 1bb70499ab598..44a658662462d 100644
--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -1836,6 +1836,18 @@ static int f2fs_expand_inode_data(struct inode *inode, loff_t offset,
 next_alloc:
 		f2fs_down_write(&sbi->pin_sem);
 
+		if (unlikely(is_sbi_flag_set(sbi, SBI_CP_DISABLED))) {
+			if (has_not_enough_free_secs(sbi, 0, 0)) {
+				f2fs_up_write(&sbi->pin_sem);
+				err = -ENOSPC;
+				f2fs_warn_ratelimited(sbi,
+					"ino:%lu, start:%lu, end:%lu, need to trigger GC to "
+					"reclaim enough free segment when checkpoint is enabled",
+					inode->i_ino, pg_start, pg_end);
+				goto out_err;
+			}
+		}
+
 		if (has_not_enough_free_secs(sbi, 0, f2fs_sb_has_blkzoned(sbi) ?
 			ZONED_PIN_SEC_REQUIRED_COUNT :
 			GET_SEC_FROM_SEG(sbi, overprovision_segments(sbi)))) {
-- 
2.39.5



