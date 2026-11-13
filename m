Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794585633;
	b=WF+Ya5dv4AuW283nRGaIYfG0EHArx3yvnT6nBoNbfoRCvDC2weDCg4DjwbAFYiYju5HD
	 Hn6Ptp0CgAzNMbpsDEQq+em+YcKepJlhC7W7hRaG7OpkFA9YuDLKkRFVqxl7sUscHVi86
	 Djz3DqlfMCAN6Pl88pmV3jYvtVoilVEGFhyHkpkC9uIH4YR/hPHPEAynQF7/O5m7CynC8
	 iuifSlQ3XV5iJIOwfdMH9m1SG4lVljIJtlYLJP6MsYyEu4ZWvbDXNMjeUaJ87BGH15X2J
	 rsaNC5tYe8TdHM0yT188zrZPMyFxARkBm99rzwqFWTkVLfuWGHYh2WFwL3MAx37eQmA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794585633;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=KrasTiHz+dNXe9LxFkkmHa44EegO9EFPyCWwXw/alU8=;
	b=SOHNH2S/CnQNQVDF3vdyEmCWXhiqJPoGfJU4Ilo1L68HjWJp6eyC5OiayybLdiun89dy
	 xXtpcomXKk9OZOORYdMjeKjaP21/1d2xwgMfWnWhLT5yOn7adJzqVuLBkBaDoD1L8Uszq
	 e1AHiZLjSGvuau5TNfJlOFyAxJNot3A2+dYScSQbwtKfaUmQ/SZbbsxt4zi28yLf/xSUY
	 xBgNiH8ofXLqqOSt6QVGnJ3hbLXMYJ4cTFSNqIddyZ0BIqfE/yQI4yVh5Q4Spq9A7eHlx
	 BYYRxAxHZgTR5SOn2daL+Lpsu4jhoAUneROFiWhfQfeaSqftMi1OaA5ouowZ7zdpxcw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ie2e0Q7v;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E88660A2639;
	Fri, 13 Nov 2026 16:00:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ie2e0Q7v
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48B2F1F000C8;
	Fri, 13 Nov 2026 16:00:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794585633;
	bh=KrasTiHz+dNXe9LxFkkmHa44EegO9EFPyCWwXw/alU8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ie2e0Q7vhS3ENyOUOHB9HjLf+7dwRUYqTq5IIROMCytt2HHKk3XN/YcRx/yGgGMT6
	 JOwrUa/ScTbcBmJFxUrFSNwkPPmcd+sXovfp2ayRryXWJN3cipMr4wifIQ5qmiNRqm
	 MLx6dPrCMTS7mnsc2eM85ZhcJLIQgHWpG0DLZvBo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matheus Alves de Almeida <matheus.aalmeida@inf.ufrgs.br>,
	Andrew Morton <akpm@linux-foundation.org>,
	OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
	Pedro Falcato <pfalcato@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 253/507] fat: hold truncate_lock in fat_write_failed()
Date: Fri, 13 Nov 2026 10:49:17 -0500
Message-ID: <20261113153803.132538892@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153753.358973689@linuxfoundation.org>
References: <20261113153753.358973689@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matheus Alves de Almeida <matheus.aalmeida@inf.ufrgs.br>

[ Upstream commit 7b90009546f5d3f3ac9428040cd7ffbdfd60f2eb ]

The current fat_write_failed() implementation calls into
fat_truncate_blocks() without holding truncate_lock.

A failed or short extending write racing with FIBMAP can spuriously make a
FAT filesystem read-only.  FIBMAP bounds its lookup by i_blocks, so it can
walk allocated clusters beyond i_size while fat_write_failed() is removing
them.  If the chain is shortened during the walk, the mapper can report a
bogus "request beyond EOF" error, triggering the default read-only error
policy.  Hold truncate_lock for write around the block cleanup to
serialize it with _fat_bmap().

For comparison, fat_setattr() correctly holds truncate_lock during
truncation:

	down_write(&MSDOS_I(inode)->truncate_lock);
	truncate_setsize(inode, attr->ia_size);
	fat_truncate_blocks(inode, attr->ia_size);
	up_write(&MSDOS_I(inode)->truncate_lock);

Make it so ->truncate_lock is held exclusive while truncating.

Link: https://lore.kernel.org/20261021162105.62525-1-matheus.aalmeida@inf.ufrgs.br
Fixes: 16fab2015099 ("fat: permit to return phy block number by fibmap in fallocated region")
Fixes: 459f6ed3b8c7 ("fat: convert to use the new truncate convention.")
Signed-off-by: Matheus Alves de Almeida <matheus.aalmeida@inf.ufrgs.br>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: <stable@vger.kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/fat/inode.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/fat/inode.c b/fs/fat/inode.c
index f775a004cae1e..065658642e7fd 100644
--- a/fs/fat/inode.c
+++ b/fs/fat/inode.c
@@ -216,7 +216,9 @@ static void fat_write_failed(struct address_space *mapping, loff_t to)
 
 	if (to > inode->i_size) {
 		truncate_pagecache(inode, inode->i_size);
+		down_write(&MSDOS_I(inode)->truncate_lock);
 		fat_truncate_blocks(inode, inode->i_size);
+		up_write(&MSDOS_I(inode)->truncate_lock);
 	}
 }
 
-- 
2.53.0



