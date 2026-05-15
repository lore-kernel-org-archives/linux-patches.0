Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 877743F8716;
	Fri, 15 May 2026 16:26:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778862414; cv=none; b=XdGFFO/Z8ReKg+FdDDN+wTxO17pvWoutIQmeaOAk8iyTjahLcdrk5GPUIZ4f2lTb/3HoeBr7XNN3dSLPi6GFZK6VWPq+rF8SGkB5SNLETOUSv4f8SDvhDEXtKtZ0YRMkBkTMZsqEH5VZWOQjYKZbpoi+sOzO19vbDMpsAOYZb3w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778862414; c=relaxed/simple;
	bh=3KMG9AA8rD3Bj28EJ4edBTuJpHw8f+W5yonWiZ69+wE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OqqmM3tBNq4j71uQdj+Yy5LYYvNQlXMcs2HE3Si2/8fioDgLTGrcHMJB/19qijInSbaJxYSRF0QsVK/Z4LvHvMli4CD+nMrFRCUjRnonGcM9UFo5sVaJsO09zy49CfHJXtnwwd6z9YIQK1uyeNd72lIzedMYlsqcfjk/OruAp0E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1aTdip8k; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1aTdip8k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9BCAC2BCB0;
	Fri, 15 May 2026 16:26:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778862414;
	bh=3KMG9AA8rD3Bj28EJ4edBTuJpHw8f+W5yonWiZ69+wE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1aTdip8kD2jl5mCZnXDGIJmvemSoAPstFoRKiTL8esfqG1fdMzIycpNWUoi/949BA
	 UuvubCfYLKisuEB2W2w+qGDPUAq53nZRhufmd7h3vOTt184IER1csrsNwkO4dfaY4+
	 ySOEhonsB264XAYMn8tDTq2qJ7SbhzRUEJgm4eQk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiaolei Wang <xiaolei.wang@windriver.com>,
	Tarang Raval <tarang.raval@siliconsignals.io>,
	Jacopo Mondi <jacopo.mondi@ideasonboard.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Subject: [PATCH 7.0 038/201] media: i2c: ov5647: Fix runtime PM refcount leak in s_ctrl
Date: Fri, 15 May 2026 17:47:36 +0200
Message-ID: <20260515154659.359942890@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154658.538039039@linuxfoundation.org>
References: <20260515154658.538039039@linuxfoundation.org>
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

From: Xiaolei Wang <xiaolei.wang@windriver.com>

commit f11ae9c04f8368a3b5a0280ef595198dace1c983 upstream.

Three control cases (AUTOGAIN, EXPOSURE_AUTO, ANALOGUE_GAIN) directly
return without calling pm_runtime_put(), causing runtime PM reference
count leaks.

Change these cases from 'return' to 'ret = ... break' pattern to ensure
pm_runtime_put() is always called before function exit.

Fixes: 4f66f36388d5 ("media: i2c: ov5647: Convert to CCI register access helpers")
Cc: stable@vger.kernel.org
Signed-off-by: Xiaolei Wang <xiaolei.wang@windriver.com>
Reviewed-by: Tarang Raval <tarang.raval@siliconsignals.io>
Reviewed-by: Jacopo Mondi <jacopo.mondi@ideasonboard.com>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/i2c/ov5647.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/media/i2c/ov5647.c b/drivers/media/i2c/ov5647.c
index 6a46ef7233ac..db9bd2892140 100644
--- a/drivers/media/i2c/ov5647.c
+++ b/drivers/media/i2c/ov5647.c
@@ -967,21 +967,21 @@ static int ov5647_s_ctrl(struct v4l2_ctrl *ctrl)
 		break;
 	case V4L2_CID_AUTOGAIN:
 		/* Non-zero turns on AGC by clearing bit 1.*/
-		return cci_update_bits(sensor->regmap, OV5647_REG_AEC_AGC, BIT(1),
-				       ctrl->val ? 0 : BIT(1), NULL);
+		ret = cci_update_bits(sensor->regmap, OV5647_REG_AEC_AGC, BIT(1),
+				      ctrl->val ? 0 : BIT(1), NULL);
 		break;
 	case V4L2_CID_EXPOSURE_AUTO:
 		/*
 		 * Everything except V4L2_EXPOSURE_MANUAL turns on AEC by
 		 * clearing bit 0.
 		 */
-		return cci_update_bits(sensor->regmap, OV5647_REG_AEC_AGC, BIT(0),
-				       ctrl->val == V4L2_EXPOSURE_MANUAL ? BIT(0) : 0, NULL);
+		ret = cci_update_bits(sensor->regmap, OV5647_REG_AEC_AGC, BIT(0),
+				      ctrl->val == V4L2_EXPOSURE_MANUAL ? BIT(0) : 0, NULL);
 		break;
 	case V4L2_CID_ANALOGUE_GAIN:
 		/* 10 bits of gain, 2 in the high register. */
-		return cci_write(sensor->regmap, OV5647_REG_GAIN,
-				 ctrl->val & 0x3ff, NULL);
+		ret = cci_write(sensor->regmap, OV5647_REG_GAIN,
+				ctrl->val & 0x3ff, NULL);
 		break;
 	case V4L2_CID_EXPOSURE:
 		/*
-- 
2.54.0



