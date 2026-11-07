Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063433;
	b=4f5A9zsH6O2IWl1icHFU2ua+lQUg/0lHrxD/5Ldr0/lKksU14+CmZS0GUK9IOdPQv6mK
	 wNsJ99QtBkpE/GPveUTWjj/umna98hytbfIWFz2Gb2ZmBDPcbOytOqcIwrMBEQoVOcU1x
	 WFvcYjNRhMfWhXOcyTqTnpHrP85RRxyP5iesUNl9VlpZSt1m6zGS6Nuq9cNxeGzQiTUfl
	 y898BUNYjWYLaEvXRYpw+zQiaf/cZSBLj6A2JtWhPew+0hZEAwQp2n8Jpyui40VC0AoPJ
	 Yj3JLlVpK+xUHtANMRMrAEwnIXcQ9gemzWCp7vOn7yfwtpQYmRnCdtnmNKPERE5eR6Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063433;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=7BHYj3l/75yqdiBRSN7avV4zuNBiJER9SZXNUolnv3c=;
	b=3D4v9CrvJuWxa/rtBvfQapEDL9cqVCi2gWR0/wRcdnwN8uxDvXprFIzEbYY+inIibbhf
	 Vf35hMgJ6G8S6Ku9XYAVjX49T3/czJCWqu85RovuxGDJz4Im0uEfsnzkGs411BTqC1qO9
	 jScNljMTs5w7RBNfMGra7r+h16FprZkGrfgTNUUVGQHB5D4BPdTu0Qcdm9WQTQRoXd4zT
	 8R8Z9wSFVrQ2cHsXIusO5HJzS44+SnVzV2PoNQNeQyJtdW/pL5BOOcx/WSQRD2kwouPUx
	 HJqM54GDT6lmRuC3bjcpRs1csGVo+pSZu2VAJyJ1yRyw23FR1beC+lLNoqIuwtzIS3Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FyLVNV06;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C819E606D801;
	Sat,  7 Nov 2026 14:57:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FyLVNV06
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 704901F0089F;
	Sat,  7 Nov 2026 14:57:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063432;
	bh=7BHYj3l/75yqdiBRSN7avV4zuNBiJER9SZXNUolnv3c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FyLVNV06/i8gcX6k38AuDHktiWXAEr4aUtJYxML/XzCXGqMgjGU3H3OQ3KxEf2obQ
	 Kakdj6egEISkMTq3VhP1FlbEoNvrogC7CdjvmyBBX3ECU4wi9cXnAZEozg8WzBk66x
	 bTU2WTmlmGA6y+nyC0wi68UandfMUl3Gfn/XIvbk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gyokhan Kochmarla <gyokhan@amazon.de>,
	Gao Xiang <xiang@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 596/869] erofs: use on-disk blkszbits for lz4 max pcluster bound
Date: Sat,  7 Nov 2026 08:54:38 -0500
Message-ID: <20261107134913.296947209@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 48a0c84cec755..858fe65ba84d0 100644
--- a/fs/erofs/decompressor.c
+++ b/fs/erofs/decompressor.c
@@ -23,7 +23,7 @@ static int z_erofs_load_lz4_config(struct super_block *sb,
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



