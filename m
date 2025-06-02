Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7A2B1A2547;
	Mon,  2 Jun 2025 15:12:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748877172; cv=none; b=EH0tBFOOgosEFsiCUdLSmly/6TMT12iH4XxlbXvU94xrIj+dda9/CBpCib+HT/YH88+k1yZ8GT0jz/3Wln3DssM95IHDi82fCLFtw11Y8S7mk/CcPoQixM0s2rmZP9QRx9Zy79HsTzvYxXBSFqr2pq9+JQA1wa759spNawGYcgQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748877172; c=relaxed/simple;
	bh=GYb2GXnKPF69yi813sCYzPPcHgK1TECtAquvjIlxDpA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rzIDi0d3f0ZCkWie7yjM9L/Ao/ptEZ4CPFhcaaR+rM3Y77SBOK5fyEVXyWnjOVdTLiugA3EvYqC/zbdwiCYqxZDVMPjiCOLP+97+Hd9YX2vFYr1bfKCBvMN6WQDgjEzo1p+I5BNLaiE2FJcpIkNgsT/cvfUZAtnox/EvtwsYi8E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sd7hLEEw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sd7hLEEw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27ECAC4CEEB;
	Mon,  2 Jun 2025 15:12:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748877172;
	bh=GYb2GXnKPF69yi813sCYzPPcHgK1TECtAquvjIlxDpA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sd7hLEEwJPKAAQ0nVWfDhBqWqPcjmOoQLGTjzDNJ0gX6BkT4h/I2mhViIFM2eI5tR
	 cR0vllwhitjgqsvq5xaDtXG8/Vq1LRYBHQyBvuCQJWLNP3uttYVMaRrYT4nKmGul4D
	 onkSptt5EgXlfwBxCtNDS3ZRtQLUC4uHDG+ox/+Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Depeng Shao <quic_depengs@quicinc.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 194/325] media: qcom: camss: csid: Only add TPG v4l2 ctrl if TPG hardware is available
Date: Mon,  2 Jun 2025 15:47:50 +0200
Message-ID: <20250602134327.687875818@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134319.723650984@linuxfoundation.org>
References: <20250602134319.723650984@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Depeng Shao <quic_depengs@quicinc.com>

[ Upstream commit 2f1361f862a68063f37362f1beb400e78e289581 ]

There is no CSID TPG on some SoCs, so the v4l2 ctrl in CSID driver
shouldn't be registered. Checking the supported TPG modes to indicate
if the TPG hardware exists or not and only registering v4l2 ctrl for
CSID only when the TPG hardware is present.

Signed-off-by: Depeng Shao <quic_depengs@quicinc.com>
Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../media/platform/qcom/camss/camss-csid.c    | 60 +++++++++++--------
 1 file changed, 35 insertions(+), 25 deletions(-)

diff --git a/drivers/media/platform/qcom/camss/camss-csid.c b/drivers/media/platform/qcom/camss/camss-csid.c
index 6360314f04a63..b90e2e690f3aa 100644
--- a/drivers/media/platform/qcom/camss/camss-csid.c
+++ b/drivers/media/platform/qcom/camss/camss-csid.c
@@ -239,11 +239,13 @@ static int csid_set_stream(struct v4l2_subdev *sd, int enable)
 	int ret;
 
 	if (enable) {
-		ret = v4l2_ctrl_handler_setup(&csid->ctrls);
-		if (ret < 0) {
-			dev_err(csid->camss->dev,
-				"could not sync v4l2 controls: %d\n", ret);
-			return ret;
+		if (csid->testgen.nmodes != CSID_PAYLOAD_MODE_DISABLED) {
+			ret = v4l2_ctrl_handler_setup(&csid->ctrls);
+			if (ret < 0) {
+				dev_err(csid->camss->dev,
+					"could not sync v4l2 controls: %d\n", ret);
+				return ret;
+			}
 		}
 
 		if (!csid->testgen.enabled &&
@@ -318,7 +320,8 @@ static void csid_try_format(struct csid_device *csid,
 		break;
 
 	case MSM_CSID_PAD_SRC:
-		if (csid->testgen_mode->cur.val == 0) {
+		if (csid->testgen.nmodes == CSID_PAYLOAD_MODE_DISABLED ||
+		    csid->testgen_mode->cur.val == 0) {
 			/* Test generator is disabled, */
 			/* keep pad formats in sync */
 			u32 code = fmt->code;
@@ -368,7 +371,8 @@ static int csid_enum_mbus_code(struct v4l2_subdev *sd,
 
 		code->code = csid->formats[code->index].code;
 	} else {
-		if (csid->testgen_mode->cur.val == 0) {
+		if (csid->testgen.nmodes == CSID_PAYLOAD_MODE_DISABLED ||
+		    csid->testgen_mode->cur.val == 0) {
 			struct v4l2_mbus_framefmt *sink_fmt;
 
 			sink_fmt = __csid_get_format(csid, sd_state,
@@ -750,7 +754,8 @@ static int csid_link_setup(struct media_entity *entity,
 
 		/* If test generator is enabled */
 		/* do not allow a link from CSIPHY to CSID */
-		if (csid->testgen_mode->cur.val != 0)
+		if (csid->testgen.nmodes != CSID_PAYLOAD_MODE_DISABLED &&
+		    csid->testgen_mode->cur.val != 0)
 			return -EBUSY;
 
 		sd = media_entity_to_v4l2_subdev(remote->entity);
@@ -843,24 +848,27 @@ int msm_csid_register_entity(struct csid_device *csid,
 		 MSM_CSID_NAME, csid->id);
 	v4l2_set_subdevdata(sd, csid);
 
-	ret = v4l2_ctrl_handler_init(&csid->ctrls, 1);
-	if (ret < 0) {
-		dev_err(dev, "Failed to init ctrl handler: %d\n", ret);
-		return ret;
-	}
+	if (csid->testgen.nmodes != CSID_PAYLOAD_MODE_DISABLED) {
+		ret = v4l2_ctrl_handler_init(&csid->ctrls, 1);
+		if (ret < 0) {
+			dev_err(dev, "Failed to init ctrl handler: %d\n", ret);
+			return ret;
+		}
 
-	csid->testgen_mode = v4l2_ctrl_new_std_menu_items(&csid->ctrls,
-				&csid_ctrl_ops, V4L2_CID_TEST_PATTERN,
-				csid->testgen.nmodes, 0, 0,
-				csid->testgen.modes);
+		csid->testgen_mode =
+			v4l2_ctrl_new_std_menu_items(&csid->ctrls,
+						     &csid_ctrl_ops, V4L2_CID_TEST_PATTERN,
+						     csid->testgen.nmodes, 0, 0,
+						     csid->testgen.modes);
 
-	if (csid->ctrls.error) {
-		dev_err(dev, "Failed to init ctrl: %d\n", csid->ctrls.error);
-		ret = csid->ctrls.error;
-		goto free_ctrl;
-	}
+		if (csid->ctrls.error) {
+			dev_err(dev, "Failed to init ctrl: %d\n", csid->ctrls.error);
+			ret = csid->ctrls.error;
+			goto free_ctrl;
+		}
 
-	csid->subdev.ctrl_handler = &csid->ctrls;
+		csid->subdev.ctrl_handler = &csid->ctrls;
+	}
 
 	ret = csid_init_formats(sd, NULL);
 	if (ret < 0) {
@@ -891,7 +899,8 @@ int msm_csid_register_entity(struct csid_device *csid,
 media_cleanup:
 	media_entity_cleanup(&sd->entity);
 free_ctrl:
-	v4l2_ctrl_handler_free(&csid->ctrls);
+	if (csid->testgen.nmodes != CSID_PAYLOAD_MODE_DISABLED)
+		v4l2_ctrl_handler_free(&csid->ctrls);
 
 	return ret;
 }
@@ -904,5 +913,6 @@ void msm_csid_unregister_entity(struct csid_device *csid)
 {
 	v4l2_device_unregister_subdev(&csid->subdev);
 	media_entity_cleanup(&csid->subdev.entity);
-	v4l2_ctrl_handler_free(&csid->ctrls);
+	if (csid->testgen.nmodes != CSID_PAYLOAD_MODE_DISABLED)
+		v4l2_ctrl_handler_free(&csid->ctrls);
 }
-- 
2.39.5



