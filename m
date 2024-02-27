Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7695A54FA5;
	Tue, 27 Feb 2024 13:31:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709040694; cv=none; b=IEaNBUlwd7O70+SIiZlOWk9Ir23wHouQ/YFby1oEAvJkLYVtFLMXb6ixxxOvd11PEJMg4+g0hnmWr3SL51yD417xz4kQ9I5dGCgSXkiNIB6Fq1dnp7gcIFpt95TDuQKYwcugNHV3upMCb7siq/rbxmqlOW9AggO/E0mRr9dNl4c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709040694; c=relaxed/simple;
	bh=TlKYbNnoWIjCdRIS3uSmzqUjupgd4bfZJ7fY/1Wd4pg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nHn0qssc9ctBtlTEg9v40FjbDbE8caUqa1KFSwFUB/C4EVSUeWQP/+CfsbufOoeSi2IQ+t5UzEuKQuEWkaoiyw7S0V9as6q+IzhL6dX/c8VQAwBWyC1tRqzlXEy999upiQkfYPZ5xqgefhlpQT9H5ohp/t5A+pkPHfq5fn3abQA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=crRn9aWP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="crRn9aWP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05240C433C7;
	Tue, 27 Feb 2024 13:31:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709040694;
	bh=TlKYbNnoWIjCdRIS3uSmzqUjupgd4bfZJ7fY/1Wd4pg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=crRn9aWPv/sy0gRt0R8cmYBbT2GROflBNQajEXoVLc5pAq6UlHRsI2rfIdzXxYO7R
	 fED7WDFySQe6MM+8dJ/OiNzlNZoXFLp68HXpQEEqwPKfDujl1l1OdlPP4DYQE8Le0V
	 48VMfKFUxbh9M1ulIUH+J39M60WCDIwb5KFURYPc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 076/334] fs/ntfs3: Improve alternative boot processing
Date: Tue, 27 Feb 2024 14:18:54 +0100
Message-ID: <20240227131632.990541398@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131630.636392135@linuxfoundation.org>
References: <20240227131630.636392135@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>

[ Upstream commit c39de951282df9a60ef70664e4378d88006b2670 ]

Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs3/super.c | 35 +++++++++++++++++------------------
 1 file changed, 17 insertions(+), 18 deletions(-)

diff --git a/fs/ntfs3/super.c b/fs/ntfs3/super.c
index 9153dffde950c..09d61c6c90aaf 100644
--- a/fs/ntfs3/super.c
+++ b/fs/ntfs3/super.c
@@ -866,6 +866,7 @@ static int ntfs_init_from_boot(struct super_block *sb, u32 sector_size,
 	u16 fn, ao;
 	u8 cluster_bits;
 	u32 boot_off = 0;
+	sector_t boot_block = 0;
 	const char *hint = "Primary boot";
 
 	/* Save original dev_size. Used with alternative boot. */
@@ -873,11 +874,11 @@ static int ntfs_init_from_boot(struct super_block *sb, u32 sector_size,
 
 	sbi->volume.blocks = dev_size >> PAGE_SHIFT;
 
-	bh = ntfs_bread(sb, 0);
+read_boot:
+	bh = ntfs_bread(sb, boot_block);
 	if (!bh)
-		return -EIO;
+		return boot_block ? -EINVAL : -EIO;
 
-check_boot:
 	err = -EINVAL;
 
 	/* Corrupted image; do not read OOB */
@@ -1108,26 +1109,24 @@ static int ntfs_init_from_boot(struct super_block *sb, u32 sector_size,
 	}
 
 out:
-	if (err == -EINVAL && !bh->b_blocknr && dev_size0 > PAGE_SHIFT) {
+	brelse(bh);
+
+	if (err == -EINVAL && !boot_block && dev_size0 > PAGE_SHIFT) {
 		u32 block_size = min_t(u32, sector_size, PAGE_SIZE);
 		u64 lbo = dev_size0 - sizeof(*boot);
 
-		/*
-	 	 * Try alternative boot (last sector)
-		 */
-		brelse(bh);
-
-		sb_set_blocksize(sb, block_size);
-		bh = ntfs_bread(sb, lbo >> blksize_bits(block_size));
-		if (!bh)
-			return -EINVAL;
-
+		boot_block = lbo >> blksize_bits(block_size);
 		boot_off = lbo & (block_size - 1);
-		hint = "Alternative boot";
-		dev_size = dev_size0; /* restore original size. */
-		goto check_boot;
+		if (boot_block && block_size >= boot_off + sizeof(*boot)) {
+			/*
+			 * Try alternative boot (last sector)
+			 */
+			sb_set_blocksize(sb, block_size);
+			hint = "Alternative boot";
+			dev_size = dev_size0; /* restore original size. */
+			goto read_boot;
+		}
 	}
-	brelse(bh);
 
 	return err;
 }
-- 
2.43.0



