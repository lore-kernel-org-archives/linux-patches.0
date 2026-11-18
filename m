Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795036649;
	b=ItuMdphDjx1F++WW9K+/4NRl2BXDVlsquuLWBbx00bJhxfL7RqD06vXTQsotdKrxsMhh
	 jyrZaVKcWZUvqx/kjXeN6QPQT3PDHAJpQCz+TejPo+OBcE3D5Yjrp7O82dmNFkHmf79rG
	 1Kq1LONVDYipOOdNcdvz/guF8cmIz6BC3lazfcBC3LBWYISl5NjxdQX3vO5OYmXDRLVYp
	 2k6rA5DBXUcPvEozbtF3cyDESSHEs+el9Q84UhoipZPFt28vDKKCZIgBJsT8QWi6qisWt
	 zzNsL8yWGwXIUSgkxUQWM0OGp1zIoVL0xQgtgt6fS62iFdVepAZVjfm4mJdI+GiWzGg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795036649;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=RG+Wd6f/XDRVr/9Cl2TmOF0rJqZntcUoF6OduIMbrs0=;
	b=oe3jszDfCFu3h3xE82bByhi+wyHc7G3aYSaIkCyKpryxO0dfFRqqfxDrA/Bo8Wzs1H0e
	 QYvkAJm5hd5MapeeI4gulZVUtQPwD1UXyubAzIvQe4OF0dC2lnpE0K4/S7vu/6sLZ4qed
	 8HjTUYvH/XgSQ8GG4pjkyuDYYzzoK7TnoEEasszioR+3thP6aUwDVMtoKZtK2vY1DbG02
	 44cHpDKIaNaP4sAuENPMvSujVFg4TUrRkYC2ik4BCGIlvXoqibzU4BEWFKsMBX5Rj4hlB
	 oI1PNWAlZDeMan5+1nLhJuwRKbgfaySEv5AsGf6dkMOTjjHbHuT/l5E1FK5N0izzULQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eorqeM50;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B71F0606A32A;
	Wed, 18 Nov 2026 21:17:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eorqeM50
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1862C1F000C4;
	Wed, 18 Nov 2026 21:17:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795036649;
	bh=RG+Wd6f/XDRVr/9Cl2TmOF0rJqZntcUoF6OduIMbrs0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eorqeM50L1AO0w5i04k8+uE5/8NAFkhV7FYR4NCJMUK7OQRnUnQLYhfxMZpRnGv8s
	 x2J/HJL7Khes1IVgIiX9M4Sgs0LddRZlw7O9zwchcgZ9b+9UVonHsfha6QFaWlsQul
	 9thwWzdwDv7OgwFCwhAVvW1nXRzyW61ffTPKvNx4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gyokhan Kochmarla <gyokhan@amazon.de>,
	Gao Xiang <xiang@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1135/3318] erofs: use on-disk blkszbits for lz4 max pcluster bound
Date: Wed, 18 Nov 2026 15:29:17 +0100
Message-ID: <20261118150354.101333670@linuxfoundation.org>
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

From: Gyokhan Kochmarla <gyokhan@amazon.de>

[ Upstream commit 90b7e4a7a16443d9f6807b5c1dde52074d9f74c0 ]

z_erofs_load_lz4_config() rejects a valid LZ4 image when the kernel's
page size differs from the image's block size. It bounds the on-disk
max_pclusterblks with erofs_blknr(sb, Z_EROFS_PCLUSTER_MAX_SIZE), which
expands to Z_EROFS_PCLUSTER_MAX_SIZE >> sb->s_blocksize_bits.

At the point this runs, sb->s_blocksize_bits still holds PAGE_SHIFT:
erofs_fc_fill_super() seeds s_blocksize_bits to PAGE_SHIFT before
reading the superblock, and only corrects it down to the on-disk
blkszbits after erofs_read_superblock() returns. The LZ4 config is
parsed inside erofs_read_superblock(), before that correction, so the
bound is computed with the wrong shift.

On a 64K-page kernel mounting a 4K-block image (e.g. one built with
mkfs.erofs -C 262144 on a 4K-page host), the bound evaluates to
1 MiB >> 16 = 16 blocks instead of the correct 1 MiB >> 12 = 256
blocks. The image's legitimate max_pclusterblks of 64 then fails the
check, mount returns -EINVAL, and booting from such an image as the
root filesystem panics:

  erofs (device dm-0): too large lz4 pclusterblks 64
  Kernel panic - not syncing: VFS: Unable to mount root fs

sbi->blkszbits already holds the on-disk block size at this point, so
compute the bound from it directly. This makes the check independent of
the host page size and of superblock-parse ordering.

commit 3acea5fc3354 ("erofs: avoid hardcoded blocksize for subpage block
support") already handled the same ordering hazard for the superblock
checksum path by using sbi->blkszbits in erofs_superblock_csum_verify();
the lz4 config path was missed.

Fixes: 3acea5fc3354 ("erofs: avoid hardcoded blocksize for subpage block support")
Cc: stable@vger.kernel.org
Assisted-by: Kirocrew:gpt-5.6-sol
Signed-off-by: Gyokhan Kochmarla <gyokhan@amazon.de>
Reviewed-by: Gao Xiang <xiang@kernel.org>
Signed-off-by: Gao Xiang <xiang@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/erofs/decompressor.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/erofs/decompressor.c b/fs/erofs/decompressor.c
index c4a6391eb1fa9..fa04d199a379d 100644
--- a/fs/erofs/decompressor.c
+++ b/fs/erofs/decompressor.c
@@ -34,7 +34,7 @@ static int z_erofs_load_lz4_config(struct super_block *sb,
 		if (!sbi->lz4.max_pclusterblks) {
 			sbi->lz4.max_pclusterblks = 1;	/* reserved case */
 		} else if (sbi->lz4.max_pclusterblks >
-			   erofs_blknr(sb, Z_EROFS_PCLUSTER_MAX_SIZE)) {
+			   Z_EROFS_PCLUSTER_MAX_SIZE >> sbi->blkszbits) {
 			erofs_err(sb, "too large lz4 pclusterblks %u",
 				  sbi->lz4.max_pclusterblks);
 			return -EINVAL;
-- 
2.53.0



