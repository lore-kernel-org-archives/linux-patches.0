Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795047167;
	b=rIT6tUDIvoDz021ktV6ECoicxwHKnZWnqA4r4Z8D1NXfCY5tY81sNrsX1In9FjmBu3Gg
	 vC7lQJ+11ruSk2YkA2GnfHrCmFE0J9AGR0908JtaOwpgz8nOxBMNbSjwRKbhgWHQ7p+6d
	 K6NYHELJukAbvBJrIPq6ky2G9SCSaZSInQgItCdd1LmqFzIj7T1eYpMRRyiRqIcC+E4ht
	 2NG1PMW1VrSWPJPuBz/KkVcGlzoYLOPyDyBIhmS6Q959TTqbp+agTWLoRlzsz6NicQkOG
	 SI2N6GzSj/3Eo779YHjCWjpbft/X+uOSfmmmy91pxwAsOBdwSULmEbgeLZW/gNKzwtQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795047167;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=UvaypOBF/RJBeKjumrMS49VDfmhZby85I1P7zu4WO2o=;
	b=D/SwkDk5WoOdrt9Q+kb0cED7f5gNMgtOQKvvynzqthvx7YjxwfrVYLYpMsZ4kpcs7XTu
	 Cr4wlp1ME84Fust85l1JcVT5I3oW6T6HcGrB35fDyPLIsG+YYCsRsj7AAOKP9UcYKbYUd
	 0obJiUip2xABIY0NIcD/EEjAwMDHszaZq8JAowS/SJ0qfdIbORBJFXanKztf5n3VSi08i
	 XVH/6CVNjR1HnH0FaQIcFvWcHGdRw3owa0HstBar5zDN0cnlKohr8ZzsoEN7fjEpk8IWn
	 h8r4yjseGW5E9fcJeTv35G37evTC7uVM96VigGyyKXL6rGjZrIUQDMFUGM84cnCiLRg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oeAw7lv3;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BDF2606A31C;
	Thu, 19 Nov 2026 00:12:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oeAw7lv3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 994121F000C4;
	Thu, 19 Nov 2026 00:12:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795047167;
	bh=UvaypOBF/RJBeKjumrMS49VDfmhZby85I1P7zu4WO2o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oeAw7lv3k6tBqIYfrNMVA75ZFxsxQURuK6PDi7M70wJhRV0FDFMBiCo3sBzOHrOk2
	 BH03blxsoQ1fgw8G4h1m2WZs/UyxI2g7Cx6oWLqpQ81TKzqdNWlDrZn0EPq4LIQkZg
	 9QyxzugFgyUtA0QKP/d7dqyNzT/gDaWSTRP7Wrro=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhiguo Niu <zhiguo.niu@unisoc.com>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1541/2857] f2fs: fix to adjust appropirate defragment pg_end
Date: Wed, 18 Nov 2026 15:42:55 +0100
Message-ID: <20261118150256.807621892@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

From: Zhiguo Niu <zhiguo.niu@unisoc.com>

[ Upstream commit 197080156f27b6bf8cf198e9313dfbb94769c736 ]

A length that exceeds the real size of the inode may be
specified from user, although these out-of-range areas
are not mapped, but they still need to be check in
while loop, which is unnecessary.

Signed-off-by: Zhiguo Niu <zhiguo.niu@unisoc.com>
Reviewed-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Stable-dep-of: 92154fe28c37 ("f2fs: fix defragment writeback range truncation on 32-bit")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/file.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/fs/f2fs/file.c b/fs/f2fs/file.c
index b5a6f37dbc04a..6a43efe936d18 100644
--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -2746,12 +2746,13 @@ static int f2fs_defragment_range(struct f2fs_sb_info *sbi,
 	bool fragmented = false;
 	int err;
 
-	pg_start = range->start >> PAGE_SHIFT;
-	pg_end = (range->start + range->len) >> PAGE_SHIFT;
-
 	f2fs_balance_fs(sbi, true);
 
 	inode_lock(inode);
+	pg_start = range->start >> PAGE_SHIFT;
+	pg_end = min_t(pgoff_t,
+				(range->start + range->len) >> PAGE_SHIFT,
+				DIV_ROUND_UP(i_size_read(inode), PAGE_SIZE));
 
 	if (is_inode_flag_set(inode, FI_COMPRESS_RELEASED) ||
 		f2fs_is_atomic_file(inode)) {
@@ -2767,8 +2768,9 @@ static int f2fs_defragment_range(struct f2fs_sb_info *sbi,
 	}
 
 	/* writeback all dirty pages in the range */
-	err = filemap_write_and_wait_range(inode->i_mapping, range->start,
-						range->start + range->len - 1);
+	err = filemap_write_and_wait_range(inode->i_mapping,
+						pg_start << PAGE_SHIFT,
+						(pg_end << PAGE_SHIFT) - 1);
 	if (err)
 		goto out;
 
-- 
2.53.0



