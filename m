Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795047408;
	b=Czy3TVUtiuZlX1JWY0rdNOb4Ylt7+BYZ2tbp4SivamGlpCFOj4QZ9Jl/juDSA04MmqoE
	 cSW3uTa+sdBJs3PlADCHWd6kCPtT7nEREH0Rm7jCs1iz8skpzDSI5FRvl2pQlwHqUpipb
	 YOzdSNL0CrSyKyawjtwSmWxc3DSF1JOc9H4EVg2BtTwzRseT1797V4TFghmguVn5AtTXw
	 Q9ChX021+vP2F0uu3KsD4LQ/Z6I6OsBL5pc3F0TiHJKPGTMy6FshAM19mKCrNhWaoFvTN
	 vLlNDk7q4Mqf0BQPYzgugO4zgnHw3XNrCksR6MpRC00luSMGThV+El1lukURuw3A3UA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795047408;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=mEUgsGvClr5lCuRZAfBBK+VZeFn3rx/mq8WaNVbODIA=;
	b=SHP514/vNlxOMhCFfmyotYTmDcqfoXqGkEGPNbrLf4jBb8piUmoq5y6v6OZYqFfuoXIu
	 fC3ga3eSv2/pTXqZ40mnR9oWarfPJhkvCvY7QekZUU93XanEy0aFiEuPgohZKSTtWyUoU
	 zQBq/t4v+1h16rFGdEzkoKanxOEI1VhBF5/W9cm+7YzKB8wkyk9ksMKgufeIIzacWeHp/
	 zBkuseVLs96fPiOa54tVTpOK4C4KPja5rscGC7M/mTmN2cGm7tEqqqg3oPlJel9cjZzIQ
	 Os/IPAkmQDlKcSg2G8WX8kvk2Q3TInPW+yPpM0L9pXROJ2RYBAfdjxwm1k3A9TLBQbg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zv19qqdL;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1BC0606A325;
	Thu, 19 Nov 2026 00:16:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zv19qqdL
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A27111F000C4;
	Thu, 19 Nov 2026 00:16:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795047408;
	bh=mEUgsGvClr5lCuRZAfBBK+VZeFn3rx/mq8WaNVbODIA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zv19qqdLVwNZdl+x61Sv4aTjb+B7DlsA0UUPaNzOaFeKb2ydRJJaZmQymm+ZYrlsL
	 LCSZf7ZvFkD9ldcCKUz8O0QAESbmqwfZ+10m6bU3Gi3/m9kOFpqE7Tz401n+ZCpwLh
	 f/d2+plSrnFsPyr9dTP9xa4MFPge34tP7IfOIRBo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1627/2857] f2fs: fix to update superblock crc in sanity_check_area_boundary()
Date: Wed, 18 Nov 2026 15:44:21 +0100
Message-ID: <20261118150259.926629972@linuxfoundation.org>
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

From: Chao Yu <chao@kernel.org>

[ Upstream commit f8f956c7ec8c0285d7a80bed497d2f7adcbded15 ]

This patch fixes the bug reported by Sashiko:

We should update superblock crc along w/ raw_super->segment_count in
sanity_check_area_boundary() if sb_checksum feature is enabled.

Cc: stable@kernel.org
Fixes: d440c52d3151 ("f2fs: support superblock checksum")
Signed-off-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
[ sashal: Added the required sbi argument to f2fs_crc32(). ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/super.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/fs/f2fs/super.c b/fs/f2fs/super.c
index 89d1de05cb31c..9d6b1a91780a4 100644
--- a/fs/f2fs/super.c
+++ b/fs/f2fs/super.c
@@ -3350,6 +3350,12 @@ static inline bool sanity_check_area_boundary(struct f2fs_sb_info *sbi,
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



