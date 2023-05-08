Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FEA4125DF
	for <patches@lists.linux.dev>; Mon,  8 May 2023 11:08:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56E5FC433EF;
	Mon,  8 May 2023 11:07:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683544080;
	bh=oJGSdN700irTBfOAhWe/HAnxt0W7uX5X0mBBazGBAQI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UVskMrF37JxQCQ7iiBpCOSx2FdlOulT8yp4uZHVvnT+32jLkg4oizvswikb3S3ulp
	 UuDk+ype0QH9THso+YqJZMmr06XPDU/mv0qfZEWlTE4kfBUR+PqhSh6kildoWj6D4B
	 ip/Le0jQwIBzK+dxpH9ZTF7oWIoh+WstkYp5MLnk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Moudy Ho <moudy.ho@mediatek.com>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 296/694] media: platform: mtk-mdp3: fix potential frame size overflow in mdp_try_fmt_mplane()
Date: Mon,  8 May 2023 11:42:11 +0200
Message-Id: <20230508094441.888563819@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094432.603705160@linuxfoundation.org>
References: <20230508094432.603705160@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Moudy Ho <moudy.ho@mediatek.com>

[ Upstream commit 4168720753ce6c14c5d3a35302fc2e1841383443 ]

Fix overflow risk when setting certain formats whose frame size exceeds
a RGB24 with 7723x7723 resolution.

For example, a 7723x7724 RGB24 frame:
    1. bpl (byte per line) = 7723 * 3.
    2. Overflow occurs when bpl * 7724 * depth.

Fixes: 61890ccaefaf ("media: platform: mtk-mdp3: add MediaTek MDP3 driver")
Signed-off-by: Moudy Ho <moudy.ho@mediatek.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/mediatek/mdp3/mtk-mdp3-regs.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/media/platform/mediatek/mdp3/mtk-mdp3-regs.c b/drivers/media/platform/mediatek/mdp3/mtk-mdp3-regs.c
index 4e84a37ecdfc1..36336d169bd91 100644
--- a/drivers/media/platform/mediatek/mdp3/mtk-mdp3-regs.c
+++ b/drivers/media/platform/mediatek/mdp3/mtk-mdp3-regs.c
@@ -4,6 +4,7 @@
  * Author: Ping-Hsun Wu <ping-hsun.wu@mediatek.com>
  */
 
+#include <linux/math64.h>
 #include <media/v4l2-common.h>
 #include <media/videobuf2-v4l2.h>
 #include <media/videobuf2-dma-contig.h>
@@ -428,14 +429,15 @@ const struct mdp_format *mdp_try_fmt_mplane(struct v4l2_format *f,
 		u32 bpl = pix_mp->plane_fmt[i].bytesperline;
 		u32 min_si, max_si;
 		u32 si = pix_mp->plane_fmt[i].sizeimage;
+		u64 di;
 
 		bpl = clamp(bpl, min_bpl, max_bpl);
 		pix_mp->plane_fmt[i].bytesperline = bpl;
 
-		min_si = (bpl * pix_mp->height * fmt->depth[i]) /
-			 fmt->row_depth[i];
-		max_si = (bpl * s.max_height * fmt->depth[i]) /
-			 fmt->row_depth[i];
+		di = (u64)bpl * pix_mp->height * fmt->depth[i];
+		min_si = (u32)div_u64(di, fmt->row_depth[i]);
+		di = (u64)bpl * s.max_height * fmt->depth[i];
+		max_si = (u32)div_u64(di, fmt->row_depth[i]);
 
 		si = clamp(si, min_si, max_si);
 		pix_mp->plane_fmt[i].sizeimage = si;
-- 
2.39.2



