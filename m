Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 931042080C0;
	Tue, 21 Oct 2025 20:00:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761076821; cv=none; b=uB+y/2VaVVJmdXWkMVsQNqxkosO6NL1CxjSqeyBTh69NC8rtGI2xk7SFjy8GsCIviNRHAJCJLjI18qRQSQ67ddaUE+zDDbdRDp7N0qBZSqbWqQ25I2GpwIbMZ2zVX7Nw1z4G8v7hvwfcFcbk3cYD9DOGmvNs85dAwKnsSxsT44Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761076821; c=relaxed/simple;
	bh=WR87Yq4vI1PrROXFdVB9WDk4OeiAjNwFyrdJEiplDog=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HWDW6YdjwyNmw4UlsqLSID1A/5j1/fGE1BGutCbIXvitwrK62qbM0FW/xai24SkCGgdMRIOrxyDXoVvGHQvzdEeWELSY7NPmmFJsAznFJlE9//tTIMMoVttXQRmfag7ecJIkRUBrxLn9Cgas5lHmtmAWfdcoOMiK+c2cS6BfV+E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XNpvoPMZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XNpvoPMZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1F76C4CEF1;
	Tue, 21 Oct 2025 20:00:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761076821;
	bh=WR87Yq4vI1PrROXFdVB9WDk4OeiAjNwFyrdJEiplDog=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XNpvoPMZ7Gw6u97kiNe04KEQG6bcjsvzaBmDZL7p18NKLbWeqUFjdnYHVLQNf8MDP
	 U3aTNutpgfgrzvi1iVR+/DAzn0XkNOa1mYRFR4H7kqkrMRAM0VSG3owZew0zJ/v40b
	 6Ss1kc3p9Fs2J+kY5+rmq3yPFnp6bFbFIGHFeISI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH 6.12 007/136] f2fs: fix wrong block mapping for multi-devices
Date: Tue, 21 Oct 2025 21:49:55 +0200
Message-ID: <20251021195036.136797926@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251021195035.953989698@linuxfoundation.org>
References: <20251021195035.953989698@linuxfoundation.org>
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
@@ -1508,8 +1508,8 @@ static bool f2fs_map_blocks_cached(struc
 		struct f2fs_dev_info *dev = &sbi->devs[bidx];
 
 		map->m_bdev = dev->bdev;
-		map->m_pblk -= dev->start_blk;
 		map->m_len = min(map->m_len, dev->end_blk + 1 - map->m_pblk);
+		map->m_pblk -= dev->start_blk;
 	} else {
 		map->m_bdev = inode->i_sb->s_bdev;
 	}


