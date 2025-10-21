Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4051C350A0D;
	Tue, 21 Oct 2025 20:06:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761077167; cv=none; b=u6D1rCTcgi375I/BCNKlzB86wMTvOMp8m7tLnrxRJREKcUjKONqpDwhFib/VoUrXJoa7TPAm+Val+Moq7RbphtNp+IuaYj0pkWkXybZaetMGpJFWq1FL1GUBtgD+hjoBQ5IkhB9uf1VBvzHRS0kyPvXmcyYjPUzxUzSM66HqMTI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761077167; c=relaxed/simple;
	bh=QL1SqG1fM6t8UT3bSbamwMxIivgobjePrkA6K7bXzxQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q+fauDiZArpltKDerP1kPchW2p7gyx2hjRmSxTCe/bfT72+k7px+4zyBDrjRWdAc224bhC7Jnf+I2L5TRc9odfUePbITjP0+4EWU+eiI7QnG+U9/nyTZ0vkUenz/VLHrvCDfXQkE2q4fyReHWhI8+2vpbGdT2sqzI0pdYAgJ1lE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iWgcykZ6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iWgcykZ6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3A83C4CEF1;
	Tue, 21 Oct 2025 20:06:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761077167;
	bh=QL1SqG1fM6t8UT3bSbamwMxIivgobjePrkA6K7bXzxQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iWgcykZ6PKpg5/VG1KPr6C6JZRsuSgH2SfsUvp/S6U/M6h3E8hs3wgRX4C/IKU+yw
	 mnKwxLrz2d1RU0EO/rTNd1SuQGPc0HdBaYGCDpTIvlKU1fQKnTA/Dt/A82me4oyV6z
	 PdkjpodCB1RZ/KHf8etSPUSrkQ1IW5jr5cL5lBqc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH 6.17 020/159] f2fs: fix wrong block mapping for multi-devices
Date: Tue, 21 Oct 2025 21:49:57 +0200
Message-ID: <20251021195043.675417895@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251021195043.182511864@linuxfoundation.org>
References: <20251021195043.182511864@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jaegeuk Kim <jaegeuk@kernel.org>

commit 9d5c4f5c7a2c7677e1b3942772122b032c265aae upstream.

Assuming the disk layout as below,

disk0: 0            --- 0x00035abfff
disk1: 0x00035ac000 --- 0x00037abfff
disk2: 0x00037ac000 --- 0x00037ebfff

and we want to read data from offset=13568 having len=128 across the block
devices, we can illustrate the block addresses like below.

0 .. 0x00037ac000 ------------------- 0x00037ebfff, 0x00037ec000 -------
          |          ^            ^                                ^
          |   fofs   0            13568                            13568+128
          |       ------------------------------------------------------
          |   LBA    0x37e8aa9    0x37ebfa9                        0x37ec029
          --- map    0x3caa9      0x3ffa9

In this example, we should give the relative map of the target block device
ranging from 0x3caa9 to 0x3ffa9 where the length should be calculated by
0x37ebfff + 1 - 0x37ebfa9.

In the below equation, however, map->m_pblk was supposed to be the original
address instead of the one from the target block address.

 - map->m_len = min(map->m_len, dev->end_blk + 1 - map->m_pblk);

Cc: stable@vger.kernel.org
Fixes: 71f2c8206202 ("f2fs: multidevice: support direct IO")
Reviewed-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/f2fs/data.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/f2fs/data.c
+++ b/fs/f2fs/data.c
@@ -1504,8 +1504,8 @@ static bool f2fs_map_blocks_cached(struc
 		struct f2fs_dev_info *dev = &sbi->devs[bidx];
 
 		map->m_bdev = dev->bdev;
-		map->m_pblk -= dev->start_blk;
 		map->m_len = min(map->m_len, dev->end_blk + 1 - map->m_pblk);
+		map->m_pblk -= dev->start_blk;
 	} else {
 		map->m_bdev = inode->i_sb->s_bdev;
 	}


