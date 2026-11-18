Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795059988;
	b=MWJHRLdPVskciRhAdgfjdLFtBi83d5alM/CjLLenym8kImJOWjs93V0XfUbTB+yUuzj7
	 EWJNXgryNntSjDrpriZYpCe7LrBXXshgldBSd4UYuDVOCATxO5nsX6GEyF3vZSpRcZZNU
	 teyFRVP6ilzUulx13vTsjdR6mcnvGUfsBC14lA4BRpEMrVXtobE4yq4cTwTqflga3ZLJc
	 exMfW1ZtAPSYHwQKjHFJj3a1RGus5sDPQrVcOWbP3b8iyz1S5V5Z58wAvltQVFCiTeszz
	 ZV99vulhq8HSI3hVi8GkGR+DyD62eqc8GBjAWfWW6XYfgotFxFnqunE8/jkFY45xMHQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795059988;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=hA6/B4WBfcDNSJFywSwcuZyTnZbPP3RlTHSHi5mIVcQ=;
	b=sNnmBhfE6/zWUXO4Zk0x5GuqKm3FWztwDaxf6j+qHwgUrPzfx40oEqLPuKAXy5vKeT3N
	 ab/QboMzzOUMbfHrmA9dfNvwTyCC1XvaHV2YOA6aKIjRNzgiNVgLMvn5WQlqYLQTI+ifB
	 Ky9dY6eu5FypC7KjelZV9zuRrf+sGLkpJOid7CkuTlJMH+xfi2e1YZwVelrYfAqs0LuQb
	 223m68HpwENIa/YbNqWhbZRafxl3dwyWlnVB2j259bnoILSBdnjqjFUznYcOWaKq4ycgV
	 s4WT6RCUoX3dPgoX8ql65lM/wHQopB8UQ5ss0krlNoDwMI3Cu9EI1Br7u+EXIsxsRpA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EVBX+rDx;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 930A1606A330;
	Thu, 19 Nov 2026 03:46:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EVBX+rDx
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5C761F000CB;
	Thu, 19 Nov 2026 03:46:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795059988;
	bh=hA6/B4WBfcDNSJFywSwcuZyTnZbPP3RlTHSHi5mIVcQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EVBX+rDxvDcn5VlClE+6EUi/23WrZmJN7jSaD06+pBrOYKHtyjEefpN7sAO/IGqSI
	 yRjcyWV6i+4Wd5/lXfVbwliKp0TMK4zTM2TZdt1qI0cdRkaTb9ekjsbi44w0Lswy43
	 MMz4a8pcYB/RwnWXG17WZ/4rgL6gI9WYKQ3mm5sw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1038/1848] f2fs: fix to update superblock crc in sanity_check_area_boundary()
Date: Wed, 18 Nov 2026 15:51:16 +0100
Message-ID: <20261118150000.809746877@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chao Yu <chao@kernel.org>

[ Upstream commit f8f956c7ec8c0285d7a80bed497d2f7adcbded15 ]

This patch fixes the bug reported by Sashiko:

We should update superblock crc along w/ raw_super->segment_count in
sanity_check_area_boundary() if sb_checksum feature is enabled.

Cc: stable@kernel.org
Fixes: d440c52d3151 ("f2fs: support superblock checksum")
Signed-off-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
[ sashal: Added sbi as the first argument to f2fs_crc32() to match the older API. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/super.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/fs/f2fs/super.c b/fs/f2fs/super.c
index 56ee5a097c864..f301b25b19705 100644
--- a/fs/f2fs/super.c
+++ b/fs/f2fs/super.c
@@ -2820,6 +2820,12 @@ static inline bool sanity_check_area_boundary(struct f2fs_sb_info *sbi,
 		/* fix in-memory information all the time */
 		raw_super->segment_count = cpu_to_le32((main_end_blkaddr -
 				segment0_blkaddr) >> log_blocks_per_seg);
+		if (__F2FS_HAS_FEATURE(raw_super, F2FS_FEATURE_SB_CHKSUM)) {
+			__u32 crc = f2fs_crc32(sbi, raw_super,
+					offsetof(struct f2fs_super_block, crc));
+
+			raw_super->crc = cpu_to_le32(crc);
+		}
 
 		if (f2fs_readonly(sb) || bdev_read_only(sb->s_bdev)) {
 			set_sbi_flag(sbi, SBI_NEED_SB_WRITE);
-- 
2.53.0



