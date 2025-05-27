Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 487A9194A67;
	Tue, 27 May 2025 16:58:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748365134; cv=none; b=b+SFEUGHRIAnW3Uj1ktcyZQEwOADSBfMgOAXC+mRfiKGkygrsXDFuFhiq39kHz39MnSttMcTByZj2sq1XNdWpt3NahCMvlwTk1UHKuXUniVlFels/91DZNUt+Zc3HN1sU7HE2rEO4/tWbxSF1h7cyi2XlqDhuvld9t7VHbhCylE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748365134; c=relaxed/simple;
	bh=PjVVUXDBjgd9fYU5Tmy66BoTuXiumGReMiAPBmtaRYo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qrDxqpqdwwEMU/igw00UrH3IDElpT5tqU9llvGNNXiu55Q9Ty0+JLdzgmTAzCmy3AwlrGTaSXmhpIX0YB88wbUk84K6bF2qCKoEy+X9Xjvp8W1jVQ75Qe20WQj1Pq6Df7/MmnwmRRvVcUUW6NPll9k5MckbOMLG1w2p++6kprHs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=c5Wg0H7L; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="c5Wg0H7L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB48FC4CEE9;
	Tue, 27 May 2025 16:58:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748365134;
	bh=PjVVUXDBjgd9fYU5Tmy66BoTuXiumGReMiAPBmtaRYo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=c5Wg0H7L/He37m3TLYoXD9Onx/QMagoKSV73NcTFsFF3VVzS96JLyFiDGczwj6HqK
	 vyMO3jR3rRbAO/g7S4hWKRfbdYOWHhj8KqXoZbz/mWyoflvFoDlXh95H1xmd6lhv4U
	 0BA7BnFO4UkhqNMIjpB2m6ty41oAMKKuLKFF/+es=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paul Elder <paul.elder@ideasonboard.com>,
	Kieran Bingham <kieran.bingham@ideasonboard.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 247/626] media: imx335: Set vblank immediately
Date: Tue, 27 May 2025 18:22:20 +0200
Message-ID: <20250527162455.051554705@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162445.028718347@linuxfoundation.org>
References: <20250527162445.028718347@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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



