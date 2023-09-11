Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 293471170D
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 14:13:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5AD28C433C7;
	Mon, 11 Sep 2023 14:13:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694441615;
	bh=r/ALvqjdSIK0bQb9MuIDqkBEjanuyBWXm6Gj63eNGTs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RohRiIvUtKj+lOZn48m7cWYfIl1Tp2/K/oW+kvECT038yZse1ykr09ZubEJLUQXf9
	 QhcNgRIJMa1/McdFZiK33P0d7e2ZiHUBPnBBbjUN8VFNPWaMnsaLFZB3mbRGaivetk
	 o76APuhhqQ0+ZNRKMeWrVajR69GXOG2KFUwlexH0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiaoyong Lu <xiaoyong.lu@mediatek.com>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 476/739] media: mediatek: vcodec: fix AV1 decode fail for 36bit iova
Date: Mon, 11 Sep 2023 15:44:35 +0200
Message-ID: <20230911134704.438510173@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230911134650.921299741@linuxfoundation.org>
References: <20230911134650.921299741@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xiaoyong Lu <xiaoyong.lu@mediatek.com>

[ Upstream commit 89a4f369b20810a8365f87badf7862c67d344bbe ]

Fix av1 decode fail when iova is 36bit.

Decoder hardware will access incorrect iova address when tile buffer is
36bit, it will lead to iommu fault when hardware access dram data.

Fixes: 2f5d0aef37c6 ("media: mediatek: vcodec: support stateless AV1 decoder")
Signed-off-by: Xiaoyong Lu<xiaoyong.lu@mediatek.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../mediatek/vcodec/vdec/vdec_av1_req_lat_if.c       | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/media/platform/mediatek/vcodec/vdec/vdec_av1_req_lat_if.c b/drivers/media/platform/mediatek/vcodec/vdec/vdec_av1_req_lat_if.c
index 404a1a23fd402..b00b423274b3b 100644
--- a/drivers/media/platform/mediatek/vcodec/vdec/vdec_av1_req_lat_if.c
+++ b/drivers/media/platform/mediatek/vcodec/vdec/vdec_av1_req_lat_if.c
@@ -1658,9 +1658,9 @@ static void vdec_av1_slice_setup_tile_buffer(struct vdec_av1_slice_instance *ins
 	u32 allow_update_cdf = 0;
 	u32 sb_boundary_x_m1 = 0, sb_boundary_y_m1 = 0;
 	int tile_info_base;
-	u32 tile_buf_pa;
+	u64 tile_buf_pa;
 	u32 *tile_info_buf = instance->tile.va;
-	u32 pa = (u32)bs->dma_addr;
+	u64 pa = (u64)bs->dma_addr;
 
 	if (uh->disable_cdf_update == 0)
 		allow_update_cdf = 1;
@@ -1673,8 +1673,12 @@ static void vdec_av1_slice_setup_tile_buffer(struct vdec_av1_slice_instance *ins
 		tile_info_buf[tile_info_base + 0] = (tile_group->tile_size[tile_num] << 3);
 		tile_buf_pa = pa + tile_group->tile_start_offset[tile_num];
 
-		tile_info_buf[tile_info_base + 1] = (tile_buf_pa >> 4) << 4;
-		tile_info_buf[tile_info_base + 2] = (tile_buf_pa % 16) << 3;
+		/* save av1 tile high 4bits(bit 32-35) address in lower 4 bits position
+		 * and clear original for hw requirement.
+		 */
+		tile_info_buf[tile_info_base + 1] = (tile_buf_pa & 0xFFFFFFF0ull) |
+			((tile_buf_pa & 0xF00000000ull) >> 32);
+		tile_info_buf[tile_info_base + 2] = (tile_buf_pa & 0xFull) << 3;
 
 		sb_boundary_x_m1 =
 			(tile->mi_col_starts[tile_col + 1] - tile->mi_col_starts[tile_col] - 1) &
-- 
2.40.1



