Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F6371863
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 15:50:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B982DC433D2;
	Wed, 28 Dec 2022 15:50:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672242625;
	bh=RzFKg73NmVg4QrdkjnmU8dVPSIa3qh7CBkbkM4yKjO0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iUO3nwQ8vkYjgIkftJVsbWqyy/hZzj+DRCQqIJmXtq4e5RQ6s+Z1IDSCAUMJKNMsT
	 IJw8e73PXU6RdcZBhoWkmsiJ+BgR8varveD/2aK1o0xp1uz8Mr2fWu/NSpDPTDAxO/
	 rki/lgSaZ2ztkKQ7IPNLzJYOu57o0u8hDwLTnuds=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Paul Elder <paul.elder@ideasonboard.com>,
	Rui Miguel Silva <rmfrfs@gmail.com>,
	Mauro Carvalho Chehab <mchehab@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0395/1146] media: imx: imx7-media-csi: Clear BIT_MIPI_DOUBLE_CMPNT for <16b formats
Date: Wed, 28 Dec 2022 15:32:14 +0100
Message-Id: <20221228144340.894146501@linuxfoundation.org>
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

From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

[ Upstream commit cccc08a95ca57624563daafd47df5691e8c38995 ]

Commit 9babbbaaeb87 ("media: imx: imx7-media-csi: Use dual sampling for
YUV 1X16") set BIT_MIPI_DOUBLE_CMPNT in the CR18 register for 16-bit YUV
formats in imx7_csi_configure(). The CR18 register is always updated
with read-modify-write cycles, so if a 16-bit YUV format is selected,
the bit will stay set forever, even if the format is changed. Fix it by
clearing the bit at the beginning of the imx7_csi_configure() function.

While at it, swap two of the bits being cleared to match the MSB to LSB
order. This doesn't cause any functional change.

Fixes: 9babbbaaeb87 ("media: imx: imx7-media-csi: Use dual sampling for YUV 1X16")
Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Reviewed-by: Paul Elder <paul.elder@ideasonboard.com>
Acked-by: Rui Miguel Silva <rmfrfs@gmail.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/media/imx/imx7-media-csi.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/media/imx/imx7-media-csi.c b/drivers/staging/media/imx/imx7-media-csi.c
index e5b550ccfa22..c77401f184d7 100644
--- a/drivers/staging/media/imx/imx7-media-csi.c
+++ b/drivers/staging/media/imx/imx7-media-csi.c
@@ -521,9 +521,9 @@ static void imx7_csi_configure(struct imx7_csi *csi)
 	cr18 = imx7_csi_reg_read(csi, CSI_CSICR18);
 
 	cr18 &= ~(BIT_CSI_HW_ENABLE | BIT_MIPI_DATA_FORMAT_MASK |
-		  BIT_DATA_FROM_MIPI | BIT_BASEADDR_CHG_ERR_EN |
-		  BIT_BASEADDR_SWITCH_EN | BIT_BASEADDR_SWITCH_SEL |
-		  BIT_DEINTERLACE_EN);
+		  BIT_DATA_FROM_MIPI | BIT_MIPI_DOUBLE_CMPNT |
+		  BIT_BASEADDR_CHG_ERR_EN | BIT_BASEADDR_SWITCH_SEL |
+		  BIT_BASEADDR_SWITCH_EN | BIT_DEINTERLACE_EN);
 
 	if (out_pix->field == V4L2_FIELD_INTERLACED) {
 		cr18 |= BIT_DEINTERLACE_EN;
-- 
2.35.1



