Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BE8D2E63B
	for <patches@lists.linux.dev>; Wed, 20 Sep 2023 12:15:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A0B8C433C7;
	Wed, 20 Sep 2023 12:15:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1695212106;
	bh=bQNlHx0SGgWoX0EUDtzTOe3nyKT+4cgtIqiFmdtLVfM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dobAB14CQYwuTBesaSCrI0lmCZKl9X4LIDaj6pHFeIGYZyE16OuzEf97WKlTZ+M2O
	 5IyM9k0+DbFeOzfnjEM1XJTEGSqunX3x2wSle93nHzpiNTGC4Ky8HxYz9sLSHNXP1L
	 aJEJ3WvE0yehG1YjB0uys2spdezpUKk/CHENzSDQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Scally <dan.scally@ideasonboard.com>,
	Rui Miguel Silva <rmfrfs@gmail.com>,
	Hans de Goede <hdegoede@redhat.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Mauro Carvalho Chehab <mchehab@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 152/273] media: ov2680: Fix vflip / hflip set functions
Date: Wed, 20 Sep 2023 13:29:52 +0200
Message-ID: <20230920112851.234153008@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230920112846.440597133@linuxfoundation.org>
References: <20230920112846.440597133@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hans de Goede <hdegoede@redhat.com>

[ Upstream commit d5d08ad330c9ccebc5e066fda815423a290f48b0 ]

ov2680_vflip_disable() / ov2680_hflip_disable() pass BIT(0) instead of
0 as value to ov2680_mod_reg().

While fixing this also:

1. Stop having separate enable/disable functions for hflip / vflip
2. Move the is_streaming check, which is unique to hflip / vflip
   into the ov2680_set_?flip() functions.

for a nice code cleanup.

Fixes: 3ee47cad3e69 ("media: ov2680: Add Omnivision OV2680 sensor driver")
Reviewed-by: Daniel Scally <dan.scally@ideasonboard.com>
Acked-by: Rui Miguel Silva <rmfrfs@gmail.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/i2c/ov2680.c | 50 +++++++++-----------------------------
 1 file changed, 12 insertions(+), 38 deletions(-)

diff --git a/drivers/media/i2c/ov2680.c b/drivers/media/i2c/ov2680.c
index 96513c86c8f66..142c6c1721649 100644
--- a/drivers/media/i2c/ov2680.c
+++ b/drivers/media/i2c/ov2680.c
@@ -328,23 +328,15 @@ static void ov2680_set_bayer_order(struct ov2680_dev *sensor)
 	sensor->fmt.code = ov2680_hv_flip_bayer_order[hv_flip];
 }
 
-static int ov2680_vflip_enable(struct ov2680_dev *sensor)
+static int ov2680_set_vflip(struct ov2680_dev *sensor, s32 val)
 {
 	int ret;
 
-	ret = ov2680_mod_reg(sensor, OV2680_REG_FORMAT1, BIT(2), BIT(2));
-	if (ret < 0)
-		return ret;
-
-	ov2680_set_bayer_order(sensor);
-	return 0;
-}
-
-static int ov2680_vflip_disable(struct ov2680_dev *sensor)
-{
-	int ret;
+	if (sensor->is_streaming)
+		return -EBUSY;
 
-	ret = ov2680_mod_reg(sensor, OV2680_REG_FORMAT1, BIT(2), BIT(0));
+	ret = ov2680_mod_reg(sensor, OV2680_REG_FORMAT1,
+			     BIT(2), val ? BIT(2) : 0);
 	if (ret < 0)
 		return ret;
 
@@ -352,23 +344,15 @@ static int ov2680_vflip_disable(struct ov2680_dev *sensor)
 	return 0;
 }
 
-static int ov2680_hflip_enable(struct ov2680_dev *sensor)
+static int ov2680_set_hflip(struct ov2680_dev *sensor, s32 val)
 {
 	int ret;
 
-	ret = ov2680_mod_reg(sensor, OV2680_REG_FORMAT2, BIT(2), BIT(2));
-	if (ret < 0)
-		return ret;
-
-	ov2680_set_bayer_order(sensor);
-	return 0;
-}
-
-static int ov2680_hflip_disable(struct ov2680_dev *sensor)
-{
-	int ret;
+	if (sensor->is_streaming)
+		return -EBUSY;
 
-	ret = ov2680_mod_reg(sensor, OV2680_REG_FORMAT2, BIT(2), BIT(0));
+	ret = ov2680_mod_reg(sensor, OV2680_REG_FORMAT2,
+			     BIT(2), val ? BIT(2) : 0);
 	if (ret < 0)
 		return ret;
 
@@ -724,19 +708,9 @@ static int ov2680_s_ctrl(struct v4l2_ctrl *ctrl)
 	case V4L2_CID_EXPOSURE:
 		return ov2680_exposure_set(sensor, ctrl->val);
 	case V4L2_CID_VFLIP:
-		if (sensor->is_streaming)
-			return -EBUSY;
-		if (ctrl->val)
-			return ov2680_vflip_enable(sensor);
-		else
-			return ov2680_vflip_disable(sensor);
+		return ov2680_set_vflip(sensor, ctrl->val);
 	case V4L2_CID_HFLIP:
-		if (sensor->is_streaming)
-			return -EBUSY;
-		if (ctrl->val)
-			return ov2680_hflip_enable(sensor);
-		else
-			return ov2680_hflip_disable(sensor);
+		return ov2680_set_hflip(sensor, ctrl->val);
 	case V4L2_CID_TEST_PATTERN:
 		return ov2680_test_pattern_set(sensor, ctrl->val);
 	default:
-- 
2.40.1



