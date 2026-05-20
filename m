Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 572153A453B;
	Wed, 20 May 2026 16:26:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779294380; cv=none; b=po5Shg5EFT3+/kQaIlsEsz+gHmRw3dcfE72w/H0xHg/gGYWxFBS6y+G+F2l1sd65PvnGdH8bB9W9qLyOpYhLQB4LlpJn45nb6AFDCd4rjFCSvg/ditZgzZzp3M9KFpBDy7LTMjRAXZ73957EgsHmSv8V8TObVC1GrxsuvjRK1Fc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779294380; c=relaxed/simple;
	bh=DwP1T3eWa0lKCmyCCsKwqQii+s5rMfidXOnDV8aHWDM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ScHfk0mQln8D/U1Qt0yF6ZgOqQnG5ODxNoAsiGOWE/Uvb4sTeUmu2OG2vYYBmGjMRSzc8cUeFxp329wnfarnojMX3SB1naL1yHVATen3MTjarFfKMV3CNYuoVy7Zb+jbYIGVqPtISu486MA4vtVSi2NKkg6dCrm2bOlMYxg3Hcw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VuNmxAAK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VuNmxAAK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9235F1F000E9;
	Wed, 20 May 2026 16:26:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779294379;
	bh=eVkd3sGjci9nFMfN1MBJ9IKWOgkiIDoD2JsMx8z0spI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VuNmxAAKnf/hxuRfdeccHQtsIThEhkPrqZgx5I43Jei/XJ8L7EyrsjbAJZeSWYyYr
	 M5YUgZfkJ1WtCwj32EpWqjzvmc23rLCre5ighl9MWE8F0YmBX2cQSGFy7o+EaFmvPd
	 cCqQQiaRVPdp9jwst5A6GekGzCUtcZExuP37LVuw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gao Xiang <hsiangkao@linux.alibaba.com>,
	Zhan Xusheng <zhanxusheng@xiaomi.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0018/1146] erofs: handle 48-bit blocks/uniaddr for extra devices
Date: Wed, 20 May 2026 18:04:28 +0200
Message-ID: <20260520162148.800970609@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhan Xusheng <zhanxusheng1024@gmail.com>

[ Upstream commit 63c2f06198ca7513433f1c92f2c654869d72417e ]

erofs_init_device() only reads blocks_lo and uniaddr_lo from the
on-disk device slot, ignoring blocks_hi and uniaddr_hi that were
introduced alongside the 48-bit block addressing feature.

For the primary device (dif0), erofs_read_superblock() already handles
this correctly by combining blocks_lo with blocks_hi when 48-bit
layout is enabled.  But the same logic was not applied to extra
devices.

With a 48-bit EROFS image using extra devices whose uniaddr or blocks
exceed 32-bit range, the truncated values cause erofs_map_dev() to
compute wrong physical addresses, leading to silent data corruption.

Fix this by reading blocks_hi and uniaddr_hi in erofs_init_device()
when 48-bit layout is enabled, consistent with the primary device
handling.  Also fix the erofs_deviceslot on-disk definition where
blocks_hi was incorrectly declared as __le32 instead of __le16.

Fixes: 61ba89b57905 ("erofs: add 48-bit block addressing on-disk support")
Suggested-by: Gao Xiang <hsiangkao@linux.alibaba.com>
Signed-off-by: Zhan Xusheng <zhanxusheng@xiaomi.com>
Reviewed-by: Gao Xiang <hsiangkao@linux.alibaba.com>
Signed-off-by: Gao Xiang <hsiangkao@linux.alibaba.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/erofs/erofs_fs.h | 4 ++--
 fs/erofs/super.c    | 8 ++++++--
 2 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/fs/erofs/erofs_fs.h b/fs/erofs/erofs_fs.h
index b80c6bb33a58c..7871b16c1d333 100644
--- a/fs/erofs/erofs_fs.h
+++ b/fs/erofs/erofs_fs.h
@@ -44,9 +44,9 @@ struct erofs_deviceslot {
 	u8 tag[64];		/* digest(sha256), etc. */
 	__le32 blocks_lo;	/* total blocks count of this device */
 	__le32 uniaddr_lo;	/* unified starting block of this device */
-	__le32 blocks_hi;	/* total blocks count MSB */
+	__le16 blocks_hi;	/* total blocks count MSB */
 	__le16 uniaddr_hi;	/* unified starting block MSB */
-	u8 reserved[50];
+	u8 reserved[52];
 };
 #define EROFS_DEVT_SLOT_SIZE	sizeof(struct erofs_deviceslot)
 
diff --git a/fs/erofs/super.c b/fs/erofs/super.c
index 972a0c82198d7..802add6652fda 100644
--- a/fs/erofs/super.c
+++ b/fs/erofs/super.c
@@ -129,6 +129,7 @@ static int erofs_init_device(struct erofs_buf *buf, struct super_block *sb,
 	struct erofs_fscache *fscache;
 	struct erofs_deviceslot *dis;
 	struct file *file;
+	bool _48bit;
 
 	dis = erofs_read_metabuf(buf, sb, *pos, false);
 	if (IS_ERR(dis))
@@ -175,8 +176,11 @@ static int erofs_init_device(struct erofs_buf *buf, struct super_block *sb,
 		dif->file = file;
 	}
 
-	dif->blocks = le32_to_cpu(dis->blocks_lo);
-	dif->uniaddr = le32_to_cpu(dis->uniaddr_lo);
+	_48bit = erofs_sb_has_48bit(sbi);
+	dif->blocks = le32_to_cpu(dis->blocks_lo) |
+		(_48bit ? (u64)le16_to_cpu(dis->blocks_hi) << 32 : 0);
+	dif->uniaddr = le32_to_cpu(dis->uniaddr_lo) |
+		(_48bit ? (u64)le16_to_cpu(dis->uniaddr_hi) << 32 : 0);
 	sbi->total_blocks += dif->blocks;
 	*pos += EROFS_DEVT_SLOT_SIZE;
 	return 0;
-- 
2.53.0



