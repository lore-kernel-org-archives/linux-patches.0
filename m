Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793216575;
	b=SURanmThwkCUKzmSHv90K/COVVqBJadHDMcIJyNRNLNY6ddz3upzYTv0wDnyGfiodUVd
	 m2UnrrNgvl62Lh1SzTB0R3KanyP2a1a+QjrRhQdWMGtjpS69RcWstPd5Mp2UV4cEaZnI8
	 vEUL+HJi8+Ccvcmi58OTnoB21NFmDndejwxti+x1p3QYvZbVYZ3xGjqaxSaGIloo7GFga
	 XSW2EbvdSNiIqXXxEWJ/zR8p3gE6WGdH89iUPwt6En4Ia+HkryqlOOnkYkDgD25wznWJr
	 KUKYjSAJj7zZGUnawWi2wB3l9ZtqoA3KFJQmuH/B8zSlTUO2Ya9iuVrH2qi3hp4K8bw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793216575;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=y9+gBLarCMYsVZiyj0ej4LVh0R+UYH7S40TPeagiv4E=;
	b=YVWRL9dOjxEQoxfPYiddtHgXRrqtMjlspHWeYJVpcx4VR5V+OEamOQ4XCgCzkXm2MOSE
	 cDwOeR94zPLoJkkMckzY1gijXpwFGbg3MexBA2lHFsMhjebCBYjfwhQDCb7lAUfbIckWZ
	 N5aWfw8a7bRWM23iYkgGwJlhBFQ+dC7o8ebLkgajBY7zbBXqEsuGEZyh5K5w8s7zFtHWB
	 ke8HvUtVRrkRNg1nsarOTYQy4Rybbv1ot7JN8NNy/lcDwGOZ+tuqkV5GduMkGxcUEL1zs
	 X822TBRsNM5Gl4q4xBm7h2sOs8XgL4zskg/ZFv/gANZiHYkJIO/oBNZBJ70h48BvoUw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=16PTmocX;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0656A606A31D;
	Wed, 28 Oct 2026 19:42:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=16PTmocX
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A9D61F01825;
	Wed, 28 Oct 2026 19:42:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793216574;
	bh=y9+gBLarCMYsVZiyj0ej4LVh0R+UYH7S40TPeagiv4E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=16PTmocXEdNmqqfuWxqhEHNJ26c/0thJGQC1KA15mcsdLjxifRK2RYr7MJC7Sd4eI
	 3DCo/mjNFOSTXgmsaXBKc+LHwx3Wwf1KuAxfkZL9ePsbqXWJG3RIhinYYewP25DEGi
	 QNOgX2K0WzjNPbPc9dCRQGlh7X9cj7mDtiiUPafI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhan Xusheng <zhanxusheng@xiaomi.com>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1550/1887] fs/ntfs3: fix integer overflow in MFT cluster validation
Date: Wed, 28 Oct 2026 18:00:46 +0100
Message-ID: <20261028170534.739906564@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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
 fs/ntfs3/super.c | 16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

diff --git a/fs/ntfs3/super.c b/fs/ntfs3/super.c
index 35dd0018e2bd4..9bf327a7cc7b9 100644
--- a/fs/ntfs3/super.c
+++ b/fs/ntfs3/super.c
@@ -33,6 +33,7 @@
 #include <linux/minmax.h>
 #include <linux/module.h>
 #include <linux/nls.h>
+#include <linux/overflow.h>
 #include <linux/seq_file.h>
 #include <linux/statfs.h>
 
@@ -685,7 +686,7 @@ static int ntfs_init_from_boot(struct super_block *sb, u32 sector_size,
 	struct ntfs_sb_info *sbi = sb->s_fs_info;
 	int err;
 	u32 mb, gb, boot_sector_size, sct_per_clst, record_size;
-	u64 sectors, clusters, mlcn, mlcn2;
+	u64 sectors, clusters, mlcn, mlcn2, mft_pos, mft2_pos;
 	struct NTFS_BOOT *boot;
 	struct buffer_head *bh;
 	struct MFT_REC *rec;
@@ -730,10 +731,15 @@ static int ntfs_init_from_boot(struct super_block *sb, u32 sector_size,
 	mlcn2 = le64_to_cpu(boot->mft2_clst);
 	sectors = le64_to_cpu(boot->sectors_per_volume);
 
-	if (mlcn * sct_per_clst >= sectors)
-		goto out;
-
-	if (mlcn2 * sct_per_clst >= sectors)
+	/*
+	 * Convert mlcn/mlcn2 to sector positions before comparing with
+	 * 'sectors'.  All three are u64 values that come from the boot
+	 * sector, so use check_mul_overflow() to keep a wraparound from
+	 * silently bypassing the comparison.
+	 */
+	if (check_mul_overflow(mlcn, (u64)sct_per_clst, &mft_pos) ||
+	    check_mul_overflow(mlcn2, (u64)sct_per_clst, &mft2_pos) ||
+	    mft_pos >= sectors || mft2_pos >= sectors)
 		goto out;
 
 	/* Check MFT record size. */
-- 
2.53.0



