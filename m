Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99AE12110E;
	Tue, 27 May 2025 17:32:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748367166; cv=none; b=D+Qa/T9z1qlvpOjefOp+gkOoYjOaS12x7YeWz1KGBF/faXCLmRRZVDQIa2BlYId3APxsRQlOcU7QC3WxeYe/fUFUxYJQKIe0YwNT4IIbCxg1FCzPu9TS1DpRuNqjTK6JWCR0gaav0nVT/XbZeVzhegyleP79ED7ykfTE3t1juWk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748367166; c=relaxed/simple;
	bh=k67tgOcqkvFi3CPbEenbz/WTijHWAuY3s8vW8Ql0qCU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZwXU5f0ZmcFCtbOFTaNRM6CAw5eoVgR7nuw/9dKbtXSC7TgDQRPhEaqkn1u04aLrUoOCyGSZ1nz6vRogI3KBYKQ95hQ6qrPSg2bkMjrpFxNG/G/LYTFWjEpppMRo9Lv+bG9wrLhAyf4qYYOCeIo87Jd/i9XjK/IEWKxIw+0F0jU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=l3oOVsfw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="l3oOVsfw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F351C4CEE9;
	Tue, 27 May 2025 17:32:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748367166;
	bh=k67tgOcqkvFi3CPbEenbz/WTijHWAuY3s8vW8Ql0qCU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=l3oOVsfw4XR2atudYuHKY84UHwPxpVJTb1qHVhGkbWK24Kk6FaUouH8XEwsKLS0TQ
	 dJaKIeqt9I501Y5JU21J7K6Ao7RNx81FJLddRSTXJljj40pvCWKIk404BpUzTyR0gT
	 DtYhc1pFPLr9wf4M2Yvy+4ID4PUZ3O7L7cujf77k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paul Elder <paul.elder@ideasonboard.com>,
	Kieran Bingham <kieran.bingham@ideasonboard.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 299/783] media: imx335: Set vblank immediately
Date: Tue, 27 May 2025 18:21:36 +0200
Message-ID: <20250527162525.251932276@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162513.035720581@linuxfoundation.org>
References: <20250527162513.035720581@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paul Elder <paul.elder@ideasonboard.com>

[ Upstream commit c0aa40f45fef80b4182704d1bc089cbf8ae8bed0 ]

When the vblank v4l2 control is set, it does not get written to the
hardware unless exposure is also changed. Change the behavior such that
the vblank is written immediately when the control is set, as setting
the vblank without changing the exposure is a valid use case (such as
for changing the frame rate).

Signed-off-by: Paul Elder <paul.elder@ideasonboard.com>
Reviewed-by: Kieran Bingham <kieran.bingham@ideasonboard.com>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/i2c/imx335.c | 21 +++++++++++++++------
 1 file changed, 15 insertions(+), 6 deletions(-)

diff --git a/drivers/media/i2c/imx335.c b/drivers/media/i2c/imx335.c
index fcfd1d851bd4a..0beb80b8c4581 100644
--- a/drivers/media/i2c/imx335.c
+++ b/drivers/media/i2c/imx335.c
@@ -559,12 +559,14 @@ static int imx335_set_ctrl(struct v4l2_ctrl *ctrl)
 			imx335->vblank,
 			imx335->vblank + imx335->cur_mode->height);
 
-		return __v4l2_ctrl_modify_range(imx335->exp_ctrl,
-						IMX335_EXPOSURE_MIN,
-						imx335->vblank +
-						imx335->cur_mode->height -
-						IMX335_EXPOSURE_OFFSET,
-						1, IMX335_EXPOSURE_DEFAULT);
+		ret = __v4l2_ctrl_modify_range(imx335->exp_ctrl,
+					       IMX335_EXPOSURE_MIN,
+					       imx335->vblank +
+					       imx335->cur_mode->height -
+					       IMX335_EXPOSURE_OFFSET,
+					       1, IMX335_EXPOSURE_DEFAULT);
+		if (ret)
+			return ret;
 	}
 
 	/*
@@ -575,6 +577,13 @@ static int imx335_set_ctrl(struct v4l2_ctrl *ctrl)
 		return 0;
 
 	switch (ctrl->id) {
+	case V4L2_CID_VBLANK:
+		exposure = imx335->exp_ctrl->val;
+		analog_gain = imx335->again_ctrl->val;
+
+		ret = imx335_update_exp_gain(imx335, exposure, analog_gain);
+
+		break;
 	case V4L2_CID_EXPOSURE:
 		exposure = ctrl->val;
 		analog_gain = imx335->again_ctrl->val;
-- 
2.39.5



