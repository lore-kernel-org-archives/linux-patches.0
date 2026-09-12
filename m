Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B32E247D94D;
	Sat, 12 Sep 2026 13:05:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789218342; cv=none; b=CSbSbOcFB9Hl5tuU25b7GykCWvYctppiyq3FnAiLK90Ldngj0HHW3DUuXKnjoLIF5uL20p0ito8U6vwy7lX1CxICzggutVezMBSajwtsPsnFhXIYUWVZObMprTsuKA7RfyMe60h/rFPPA/o7JepsvhpHCpsOJ7AXpJZDprzu2fg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789218342; c=relaxed/simple;
	bh=QpOxDTgzzoBqD6BWPo7/1PS99nA/QJJcVitlaOj8WnA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tkrMwM5NaakjLPl7EQ5Ub2S37iWhNdWidoZ6IpgGYryRfEbUUsnK6RYVJkHg6+awbv2sATUD9qpz5N6SFmC3ojpu4iinNi3AkgxE5VbDryq3Zhteqhjz9sA2dPQ7KwoS3pRdhP5XLHTRtSljFJU2rORrYdYLvMku4Rk2bIzMV8w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vcXEmSNE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vcXEmSNE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B81F1F000FF;
	Sat, 12 Sep 2026 13:05:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789218341;
	bh=ccFp4jdXoKcxmthN5FsV1apvYafpusbFMvbWdOIGzXI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vcXEmSNEwvfOJvEiXRVFYYuNi8GEAVhocd8XESdDCLjixgatBl/MuqX1K/9oyn8y8
	 +vMWPJyeaqOGUWTVwSYVRzVrj289FMD/lTg8XwJwI5IPtRY+Q/m1Wv5XBE3J5/KW6C
	 1F3WhRLBR7BWCDHi3aFfsDBOxFwb6RqyPNwDdvvc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhan Xusheng <zhanxusheng@xiaomi.com>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1126/1376] fs/ntfs3: fix integer overflow in MFT cluster validation
Date: Sat, 12 Sep 2026 08:59:12 +0200
Message-ID: <20260912065632.660715159@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhan Xusheng <zhanxusheng1024@gmail.com>

[ Upstream commit c510c63873103a5da6a498fe537bdb5d6f8d03a2 ]

In ntfs_init_from_boot(), the boot sector's MFT cluster numbers are
validated against the volume size with:

	if (mlcn  * sct_per_clst >= sectors ||
	    mlcn2 * sct_per_clst >= sectors)
		goto out;

mlcn and mlcn2 are u64 fields read directly from the boot sector.
sct_per_clst is bounded above by 4096 (true_sectors_per_clst() plus
the is_power_of_2() check below it), but the multiplication is done
in u64 and wraps when mlcn (or mlcn2) is large enough -- e.g. mlcn
near 2^62 with sct_per_clst == 4 wraps to 0, which compares below
any non-zero 'sectors', so the check is bypassed and the malformed
record is accepted.

The accepted mlcn is then used unchanged in

	sbi->mft.lbo = mlcn << cluster_bits;

In practice the resulting reads fail at the block layer (sb_bread()
returns NULL via grow_buffers()'s check_mul_overflow() guard), so
today this manifests as mount failing in odd places rather than as
something more dangerous, but the validation step is still wrong
and there is no reason for callers to rely on the block layer to
catch a value that should never have been accepted in the first
place.

Use check_mul_overflow() to compute the two sector positions and
fail the mount if either multiplication wraps; this preserves the
existing semantics (mlcn * sct_per_clst >= sectors) instead of
switching to division (mlcn >= sectors / sct_per_clst), which
would tighten the check at edge cases where 'sectors' is not a
multiple of sct_per_clst.  The check_*_overflow() style is the
one ntfs3 already uses for similar on-disk arithmetic in
fs/ntfs3/run.c.

Fixes: 82cae269cfa9 ("fs/ntfs3: Add initialization of super block")
Signed-off-by: Zhan Xusheng <zhanxusheng@xiaomi.com>
Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs3/super.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/fs/ntfs3/super.c b/fs/ntfs3/super.c
index 1af1500ec24b6..b0c46840f75fa 100644
--- a/fs/ntfs3/super.c
+++ b/fs/ntfs3/super.c
@@ -57,6 +57,7 @@
 #include <linux/minmax.h>
 #include <linux/module.h>
 #include <linux/nls.h>
+#include <linux/overflow.h>
 #include <linux/proc_fs.h>
 #include <linux/seq_file.h>
 #include <linux/statfs.h>
@@ -877,7 +878,7 @@ static int ntfs_init_from_boot(struct super_block *sb, u32 sector_size,
 	struct ntfs_sb_info *sbi = sb->s_fs_info;
 	int err;
 	u32 mb, gb, boot_sector_size, sct_per_clst, record_size;
-	u64 sectors, clusters, mlcn, mlcn2, dev_size0;
+	u64 sectors, clusters, mlcn, mlcn2, mft_pos, mft2_pos, dev_size0;
 	struct NTFS_BOOT *boot;
 	struct buffer_head *bh;
 	struct MFT_REC *rec;
@@ -946,7 +947,15 @@ static int ntfs_init_from_boot(struct super_block *sb, u32 sector_size,
 	mlcn2 = le64_to_cpu(boot->mft2_clst);
 	sectors = le64_to_cpu(boot->sectors_per_volume);
 
-	if (mlcn * sct_per_clst >= sectors || mlcn2 * sct_per_clst >= sectors) {
+	/*
+	 * Convert mlcn/mlcn2 to sector positions before comparing with
+	 * 'sectors'.  All three are u64 values that come from the boot
+	 * sector, so use check_mul_overflow() to keep a wraparound from
+	 * silently bypassing the comparison.
+	 */
+	if (check_mul_overflow(mlcn, (u64)sct_per_clst, &mft_pos) ||
+	    check_mul_overflow(mlcn2, (u64)sct_per_clst, &mft2_pos) ||
+	    mft_pos >= sectors || mft2_pos >= sectors) {
 		ntfs_err(
 			sb,
 			"%s: start of MFT 0x%llx (0x%llx) is out of volume 0x%llx.",
-- 
2.53.0



