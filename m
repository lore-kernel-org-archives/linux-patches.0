Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47C9B1863
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 15:28:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9AC90C433EF;
	Wed, 28 Dec 2022 15:28:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672241336;
	bh=0nZct2RXErNm/Q/ixo2Jfi/Xhjlv4X0yHsElhUs+mls=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KrDN2gX79SoGNnkr1PG7Hk4jZqq0pU+JytMhyt5mYiRmNXnwW8LHPfmj4E2dO5oQb
	 ZfJ9RCwcJnfUPziK76ldCNMmdazBTUuYXg97MDCH09Ag+EnxQgeJCXy/PuWC/pLxQC
	 0VMbX2WM5Re3uxl+vOV5voVbnYwWihb3dVJ+aG9k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jernej Skrabec <jernej.skrabec@gmail.com>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0234/1146] media: cedrus: hevc: Fix offset adjustments
Date: Wed, 28 Dec 2022 15:29:33 +0100
Message-Id: <20221228144336.494727249@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jernej Skrabec <jernej.skrabec@gmail.com>

[ Upstream commit e9120e76a6f7e19a8d26c03f2964937e4ce69784 ]

As it turns out, current padding size check works fine in theory but it
doesn't in practice. Most probable reason are caching issues.

Let's rework reading data from bitstream using Cedrus engine instead of
CPU. That way we avoid all cache issues and make sure that we're reading
same data as Cedrus.

Fixes: e7060d9a78c2 ("media: uapi: Change data_bit_offset definition")
Signed-off-by: Jernej Skrabec <jernej.skrabec@gmail.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../staging/media/sunxi/cedrus/cedrus_h265.c  | 25 ++++++++++++++-----
 .../staging/media/sunxi/cedrus/cedrus_regs.h  |  2 ++
 2 files changed, 21 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/media/sunxi/cedrus/cedrus_h265.c b/drivers/staging/media/sunxi/cedrus/cedrus_h265.c
index 4952fc17f3e6..625f77a8c5bd 100644
--- a/drivers/staging/media/sunxi/cedrus/cedrus_h265.c
+++ b/drivers/staging/media/sunxi/cedrus/cedrus_h265.c
@@ -242,6 +242,18 @@ static void cedrus_h265_skip_bits(struct cedrus_dev *dev, int num)
 	}
 }
 
+static u32 cedrus_h265_show_bits(struct cedrus_dev *dev, int num)
+{
+	cedrus_write(dev, VE_DEC_H265_TRIGGER,
+		     VE_DEC_H265_TRIGGER_SHOW_BITS |
+		     VE_DEC_H265_TRIGGER_TYPE_N_BITS(num));
+
+	cedrus_wait_for(dev, VE_DEC_H265_STATUS,
+			VE_DEC_H265_STATUS_VLD_BUSY);
+
+	return cedrus_read(dev, VE_DEC_H265_BITS_READ);
+}
+
 static void cedrus_h265_write_scaling_list(struct cedrus_ctx *ctx,
 					   struct cedrus_run *run)
 {
@@ -406,7 +418,7 @@ static int cedrus_h265_setup(struct cedrus_ctx *ctx, struct cedrus_run *run)
 	u32 num_entry_point_offsets;
 	u32 output_pic_list_index;
 	u32 pic_order_cnt[2];
-	u8 *padding;
+	u8 padding;
 	int count;
 	u32 reg;
 
@@ -520,21 +532,22 @@ static int cedrus_h265_setup(struct cedrus_ctx *ctx, struct cedrus_run *run)
 	if (slice_params->data_byte_offset == 0)
 		return -EOPNOTSUPP;
 
-	padding = (u8 *)vb2_plane_vaddr(&run->src->vb2_buf, 0) +
-		slice_params->data_byte_offset - 1;
+	cedrus_h265_skip_bits(dev, (slice_params->data_byte_offset - 1) * 8);
+
+	padding = cedrus_h265_show_bits(dev, 8);
 
 	/* at least one bit must be set in that byte */
-	if (*padding == 0)
+	if (padding == 0)
 		return -EINVAL;
 
 	for (count = 0; count < 8; count++)
-		if (*padding & (1 << count))
+		if (padding & (1 << count))
 			break;
 
 	/* Include the one bit. */
 	count++;
 
-	cedrus_h265_skip_bits(dev, slice_params->data_byte_offset * 8 - count);
+	cedrus_h265_skip_bits(dev, 8 - count);
 
 	/* Bitstream parameters. */
 
diff --git a/drivers/staging/media/sunxi/cedrus/cedrus_regs.h b/drivers/staging/media/sunxi/cedrus/cedrus_regs.h
index d81f7513ade0..655c05b389cf 100644
--- a/drivers/staging/media/sunxi/cedrus/cedrus_regs.h
+++ b/drivers/staging/media/sunxi/cedrus/cedrus_regs.h
@@ -505,6 +505,8 @@
 #define VE_DEC_H265_LOW_ADDR_ENTRY_POINTS_BUF(a) \
 	SHIFT_AND_MASK_BITS(a, 7, 0)
 
+#define VE_DEC_H265_BITS_READ			(VE_ENGINE_DEC_H265 + 0xdc)
+
 #define VE_DEC_H265_SRAM_OFFSET			(VE_ENGINE_DEC_H265 + 0xe0)
 
 #define VE_DEC_H265_SRAM_OFFSET_PRED_WEIGHT_LUMA_L0	0x00
-- 
2.35.1



