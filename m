Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E99A01C08
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 16:31:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A3C8C433EF;
	Wed, 28 Dec 2022 16:31:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672245119;
	bh=N1GJ3on9aKbYsh/vdzM70STSM2nIaOETM2ctPL68z2M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=q0jOgGPNPcr2NKNNGKwGGgRy0qiEt4lPPzD89GT7r7xtDCdEOR5yxG47pKXAeEhdM
	 FaxfH0VgUb+OZy+KiLdZuyfkc2ym477Zn06R+Ug/UZ7s3wjD4H8Tz8THs8W318DYkF
	 FfLYMipjErbZoNgsnWqu5fce30tx1az7N7aKP738=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <error27@gmail.com>,
	Yong Wu <yong.wu@mediatek.com>,
	Joerg Roedel <jroedel@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0836/1073] iommu/mediatek: Fix forever loop in error handling
Date: Wed, 28 Dec 2022 15:40:24 +0100
Message-Id: <20221228144350.725324424@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Dan Carpenter <error27@gmail.com>

[ Upstream commit 462e768b55a2331324ff72e74706261134369826 ]

There is a typo so this loop does i++ where i-- was intended.  It will
result in looping until the kernel crashes.

Fixes: 26593928564c ("iommu/mediatek: Add error path for loop of mm_dts_parse")
Signed-off-by: Dan Carpenter <error27@gmail.com>
Reviewed-by: Yong Wu <yong.wu@mediatek.com>
Link: https://lore.kernel.org/r/Y5C3mTam2nkbaz6o@kili
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/mtk_iommu.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/iommu/mtk_iommu.c b/drivers/iommu/mtk_iommu.c
index 213fc8f5b6c1..ec73720e239b 100644
--- a/drivers/iommu/mtk_iommu.c
+++ b/drivers/iommu/mtk_iommu.c
@@ -1127,8 +1127,7 @@ static int mtk_iommu_mm_dts_parse(struct device *dev, struct component_match **m
 	return 0;
 
 err_larbdev_put:
-	/* id may be not linear mapping, loop whole the array */
-	for (i = MTK_LARB_NR_MAX - 1; i >= 0; i++) {
+	for (i = MTK_LARB_NR_MAX - 1; i >= 0; i--) {
 		if (!data->larb_imu[i].dev)
 			continue;
 		put_device(data->larb_imu[i].dev);
-- 
2.35.1



