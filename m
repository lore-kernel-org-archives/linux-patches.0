Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C5932D542A;
	Mon, 27 Oct 2025 19:07:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761592077; cv=none; b=PZp56dxIb3S1IN4cTNkLf4Ovs7kaCoS0J2mhnMfNSo3ZefepaQlbspvMVWSdXRH/+n6KfstfG6kcq/PMScZLY5lTLgFE59Dm0n39ugPRMchVHlqtvluy8ZyyglGu4QuAWhr8ibRM7pdqAH293+8htuoP7h/D6Ut8uD1+MbDZSY4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761592077; c=relaxed/simple;
	bh=ckVBycvBadnkq0zotHTljDEC7Q61GjFsgW9o2XmOTyM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Iec/SidZbJ8xosgEHOvu7x+G11KhEQ1TcRY+ngPjE8Gv5/kXl9wgOGTI3f3rMa5dKBMH6Z6EDWm64KH7UGUE4+d8P8G2ozgIGC3v1qVg8lQmYBNkFZgNsaFbvn53/9k1ME+WfFO70PP/JtvrpCCcyikfQZmG0g4NBeNZPJtE+Fw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mhXDnS4+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mhXDnS4+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D080C4CEF1;
	Mon, 27 Oct 2025 19:07:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761592077;
	bh=ckVBycvBadnkq0zotHTljDEC7Q61GjFsgW9o2XmOTyM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mhXDnS4+UZfKdYvqJIWgzBakDiAw+4himc/gIy7/1AZ0bk6Qa6RAfsz3CpdH2W1z4
	 9IOZ01Pu9eIcJ/AfpdtDKaanTLAhExZRMGysYz12Anywf4rH80XWnFvbEyieuzzckv
	 4M/4Ik8m3f8Z//h3NQ/ir8aPH7JyqUVCdzZkX++8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 109/123] f2fs: fix wrong block mapping for multi-devices
Date: Mon, 27 Oct 2025 19:36:29 +0100
Message-ID: <20251027183449.307956902@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183446.381986645@linuxfoundation.org>
References: <20251027183446.381986645@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jaegeuk Kim <jaegeuk@kernel.org>

[ Upstream commit 9d5c4f5c7a2c7677e1b3942772122b032c265aae ]

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
[ applied fix to f2fs_map_blocks() instead of f2fs_map_blocks_cached() ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/f2fs/data.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/f2fs/data.c
+++ b/fs/f2fs/data.c
@@ -1505,9 +1505,9 @@ int f2fs_map_blocks(struct inode *inode,
 			bidx = f2fs_target_device_index(sbi, map->m_pblk);
 
 			map->m_bdev = FDEV(bidx).bdev;
-			map->m_pblk -= FDEV(bidx).start_blk;
 			map->m_len = min(map->m_len,
 				FDEV(bidx).end_blk + 1 - map->m_pblk);
+			map->m_pblk -= FDEV(bidx).start_blk;
 
 			if (map->m_may_create)
 				f2fs_update_device_state(sbi, inode->i_ino,


