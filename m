Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3DD623816A;
	Mon,  2 Jun 2025 14:58:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748876308; cv=none; b=dMAws9zQJ/3vjwe6W0J10Dk5lvX9VlhtFeIT9N/RK40GhLRUl53p1m11iETb5WncPTuGow0wnsfK5ARLEUfwDcnrcHNDjeyDCvvAGRQCkALrdKkANX5xubPqSYEpahI6HK/EIrWLsGwgW+huMR/fCxBjoKB7oQnRTkNYizJ1XRg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748876308; c=relaxed/simple;
	bh=XBqp66rOTH4JqKqPoG1nmTVCjiz8AfeBPcJ5tz7wRTk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iOHw1z9y+TS4gQPcS7puOPXArTJSujqbDwuiEE2RLQzVI1tXy79cy1T5hPQe/5As3AVSXwKfcoclTsW/BnTIpjzguNSDoMi741RiSH7+c9rUw3ctF20B/oriarEF4gLHhH0P+XLJtDKp0AvqYbJsWTpEyjahUXMRQE8U82Oxr6c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yzgJd2IJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yzgJd2IJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B4D8C4CEEB;
	Mon,  2 Jun 2025 14:58:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748876308;
	bh=XBqp66rOTH4JqKqPoG1nmTVCjiz8AfeBPcJ5tz7wRTk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yzgJd2IJCpF5Se6WZbSXCq1lVh9BicwXpSZIc0InMxHin0KRcPbtJ2DqZsyNvtaaa
	 VBKy8khZ3jIMCeKor5tQojY0gqE9I7FB+b5slF5dOo3nVUClDooBXyEurKmlR1G8RS
	 88mqH0nf6/+L9JLna/i5C864lsyUnjTsL+JJK318=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Depeng Shao <quic_depengs@quicinc.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 136/207] media: qcom: camss: csid: Only add TPG v4l2 ctrl if TPG hardware is available
Date: Mon,  2 Jun 2025 15:48:28 +0200
Message-ID: <20250602134304.053951297@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134258.769974467@linuxfoundation.org>
References: <20250602134258.769974467@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 2a294587ec9d9..5583cbea12f3f 100644
--- a/drivers/media/platform/qcom/camss/camss-csid.c
+++ b/drivers/media/platform/qcom/camss/camss-csid.c
@@ -219,11 +219,13 @@ static int csid_set_stream(struct v4l2_subdev *sd, int enable)
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
@@ -298,7 +300,8 @@ static void csid_try_format(struct csid_device *csid,
 		break;
 
 	case MSM_CSID_PAD_SRC:
-		if (csid->testgen_mode->cur.val == 0) {
+		if (csid->testgen.nmodes == CSID_PAYLOAD_MODE_DISABLED ||
+		    csid->testgen_mode->cur.val == 0) {
 			/* Test generator is disabled, */
 			/* keep pad formats in sync */
 			u32 code = fmt->code;
@@ -348,7 +351,8 @@ static int csid_enum_mbus_code(struct v4l2_subdev *sd,
 
 		code->code = csid->formats[code->index].code;
 	} else {
-		if (csid->testgen_mode->cur.val == 0) {
+		if (csid->testgen.nmodes == CSID_PAYLOAD_MODE_DISABLED ||
+		    csid->testgen_mode->cur.val == 0) {
 			struct v4l2_mbus_framefmt *sink_fmt;
 
 			sink_fmt = __csid_get_format(csid, sd_state,
@@ -707,7 +711,8 @@ static int csid_link_setup(struct media_entity *entity,
 
 		/* If test generator is enabled */
 		/* do not allow a link from CSIPHY to CSID */
-		if (csid->testgen_mode->cur.val != 0)
+		if (csid->testgen.nmodes != CSID_PAYLOAD_MODE_DISABLED &&
+		    csid->testgen_mode->cur.val != 0)
 			return -EBUSY;
 
 		sd = media_entity_to_v4l2_subdev(remote->entity);
@@ -800,24 +805,27 @@ int msm_csid_register_entity(struct csid_device *csid,
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
@@ -848,7 +856,8 @@ int msm_csid_register_entity(struct csid_device *csid,
 media_cleanup:
 	media_entity_cleanup(&sd->entity);
 free_ctrl:
-	v4l2_ctrl_handler_free(&csid->ctrls);
+	if (csid->testgen.nmodes != CSID_PAYLOAD_MODE_DISABLED)
+		v4l2_ctrl_handler_free(&csid->ctrls);
 
 	return ret;
 }
@@ -861,5 +870,6 @@ void msm_csid_unregister_entity(struct csid_device *csid)
 {
 	v4l2_device_unregister_subdev(&csid->subdev);
 	media_entity_cleanup(&csid->subdev.entity);
-	v4l2_ctrl_handler_free(&csid->ctrls);
+	if (csid->testgen.nmodes != CSID_PAYLOAD_MODE_DISABLED)
+		v4l2_ctrl_handler_free(&csid->ctrls);
 }
-- 
2.39.5



