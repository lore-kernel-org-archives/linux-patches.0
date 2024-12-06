Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 585CD1527AC;
	Fri,  6 Dec 2024 15:13:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733498016; cv=none; b=pk6jtpleH2WV/klciYODXXhtFQGrXhYtNMBEUzNIZIJZVhNhVa4evWJQEjrhcvzs/Atx+XCIuLWK1j3C62k8cN54LzNPFeOd1CAdzLA3uHXiDGbG3KJvKoOg0bxMspg3i5ZSqj6H4XfiJeVg27p8TeaWxcrs7tFNgQ/7DWJJKno=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733498016; c=relaxed/simple;
	bh=tHLRb/4Cj2kYU9BvUIupbo/cXimwcTJuUB6SkCZJL2A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DLK2C6NKsNpqlpOiF+tiH9bpBL/UmlYFA8X9MqDJqI0x1Q22j/xz7pkIDQ66MISKtx3A1CnSz4c9JlFyZP+G++zKfBJbXj73vwucxWcmHi3X9VJQRULCUR7mBc19iXL6U2xLTTRBp2zIL/o322T5knk8mm6MTlo4x09aAB6rY5c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RZKvn4su; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RZKvn4su"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF00CC4CED1;
	Fri,  6 Dec 2024 15:13:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733498016;
	bh=tHLRb/4Cj2kYU9BvUIupbo/cXimwcTJuUB6SkCZJL2A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RZKvn4suLj31qqbPEh6EJf3O+ts0ysryJ+SzG22g/pmBFXbjN6cgWbKs1OPfGQfTM
	 X+nR5sHukY9abREsT2cP8WcV7ArFHAvlYP7gES7m55XMaS4ZwaZxHTyS7rju/KISdw
	 Ry7Yhix+ZMxKQIOp5SIejAyUWUp2R3PZKUBAZ+xY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daejun Park <daejun7.park@samsung.com>,
	Chao Yu <chao@kernel.org>,
	Daeho Jeong <daehojeong@google.com>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Bin Lan <bin.lan.cn@windriver.com>
Subject: [PATCH 6.6 462/676] f2fs: fix null reference error when checking end of zone
Date: Fri,  6 Dec 2024 15:34:41 +0100
Message-ID: <20241206143711.414447979@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143653.344873888@linuxfoundation.org>
References: <20241206143653.344873888@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daejun Park <daejun7.park@samsung.com>

commit c82bc1ab2a8a5e73d9728e80c4c2ed87e8921a38 upstream.

This patch fixes a potentially null pointer being accessed by
is_end_zone_blkaddr() that checks the last block of a zone
when f2fs is mounted as a single device.

Fixes: e067dc3c6b9c ("f2fs: maintain six open zones for zoned devices")
Signed-off-by: Daejun Park <daejun7.park@samsung.com>
Reviewed-by: Chao Yu <chao@kernel.org>
Reviewed-by: Daeho Jeong <daehojeong@google.com>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
[ Resolve minor conflicts ]
Signed-off-by: Bin Lan <bin.lan.cn@windriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/f2fs/data.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/fs/f2fs/data.c
+++ b/fs/f2fs/data.c
@@ -924,6 +924,7 @@ alloc_new:
 #ifdef CONFIG_BLK_DEV_ZONED
 static bool is_end_zone_blkaddr(struct f2fs_sb_info *sbi, block_t blkaddr)
 {
+	struct block_device *bdev = sbi->sb->s_bdev;
 	int devi = 0;
 
 	if (f2fs_is_multi_device(sbi)) {
@@ -934,8 +935,9 @@ static bool is_end_zone_blkaddr(struct f
 			return false;
 		}
 		blkaddr -= FDEV(devi).start_blk;
+		bdev = FDEV(devi).bdev;
 	}
-	return bdev_zoned_model(FDEV(devi).bdev) == BLK_ZONED_HM &&
+	return bdev_is_zoned(bdev) &&
 		f2fs_blkz_is_seq(sbi, devi, blkaddr) &&
 		(blkaddr % sbi->blocks_per_blkz == sbi->blocks_per_blkz - 1);
 }


