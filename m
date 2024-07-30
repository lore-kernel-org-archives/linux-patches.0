Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DD081A76B2;
	Tue, 30 Jul 2024 17:28:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722360483; cv=none; b=TJLcRRR7mud2enf7JFFqiSTfVK1JAAPfI3JsdsBkNT2C5oOuwdzgB6SPGmIL7ogYNWSBF/LBQ9xD3RtpfA5S1vC6vdAT0STMCeiER1K5GvoG5VCZUtU7GBojkCzz+o9AcgmVIiLk5ePWy3VrH1ZRq3d5pDTaKbGYohkHqhXEGCo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722360483; c=relaxed/simple;
	bh=FiBdSTIFeuATbaes2F4vzqlYZA/U6/CrXJSadvFkur4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MiGFR7S6mc+WjmSmJlMX8KqdnlfXHmdb4dfKKLfMNk6pxTFPjt7HsQPDmytD/YfVYUosbUvplXSAIlBObLUHvZTUcsaiMnlYFGLzKN4OBK98NFspoPrO/9OgnJAtJsY0f/g/nPEL9dDR482pRG77KT9ZqB3M+rJO6fU+mYSpuuI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Lm7MrqGA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Lm7MrqGA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D30DBC4AF0C;
	Tue, 30 Jul 2024 17:28:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722360483;
	bh=FiBdSTIFeuATbaes2F4vzqlYZA/U6/CrXJSadvFkur4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Lm7MrqGA1yKnzlFwSPFeEnPsOaNeS4Y+dydxlQt+SI/xXcriZgiRf0+/A75xaH/gy
	 JIQqUzeNZSfLwnjW5FsDp87LyKkJybgWMZL4wIRiCoESHs3x9LK9QzFTV+KwSShrZz
	 OnSTlbu4tLe2hS3wyqU61AnbTDDTRpnyMNP/EqBI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kai Vehmanen <kai.vehmanen@linux.intel.com>,
	Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
	Bard Liao <yung-chuan.liao@linux.intel.com>,
	Peter Ujfalusi <peter.ujfalusi@linux.intel.com>,
	Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.10 712/809] ASoC: SOF: ipc4-topology: Use correct queue_id for requesting input pin format
Date: Tue, 30 Jul 2024 17:49:48 +0200
Message-ID: <20240730151753.054372425@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>

commit fe836c78ef1ff16da32912c22348091a0d67bda1 upstream.

It is incorrect to request the input pin format of the destination widget
using the output pin index of the source module as the indexes are not
necessarily matching.
moduleA.out_pin1 can be connected to moduleB.in_pin0 for example.

Use the dst_queue_id to request the input format of the destination module.

This bug remained unnoticed likely because in nocodec topologies we don't
have process modules after a module copier, thus the pin/queue index is
ignored.
For the process module case, the code was likely have been tested in a
controlled way where all the pin/queue/format properties were present to
work.

Update the debug prints to have better information.

Reviewed-by: Kai Vehmanen <kai.vehmanen@linux.intel.com>
Reviewed-by: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
Reviewed-by: Bard Liao <yung-chuan.liao@linux.intel.com>
Signed-off-by: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
Signed-off-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Cc: stable@vger.kernel.org # v6.8+
Link: https://patch.msgid.link/20240624121519.91703-3-pierre-louis.bossart@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/sof/ipc4-topology.c |   28 +++++++++++++++-------------
 1 file changed, 15 insertions(+), 13 deletions(-)

--- a/sound/soc/sof/ipc4-topology.c
+++ b/sound/soc/sof/ipc4-topology.c
@@ -2875,7 +2875,7 @@ static void sof_ipc4_put_queue_id(struct
 static int sof_ipc4_set_copier_sink_format(struct snd_sof_dev *sdev,
 					   struct snd_sof_widget *src_widget,
 					   struct snd_sof_widget *sink_widget,
-					   int sink_id)
+					   struct snd_sof_route *sroute)
 {
 	struct sof_ipc4_copier_config_set_sink_format format;
 	const struct sof_ipc_ops *iops = sdev->ipc->ops;
@@ -2884,9 +2884,6 @@ static int sof_ipc4_set_copier_sink_form
 	struct sof_ipc4_fw_module *fw_module;
 	struct sof_ipc4_msg msg = {{ 0 }};
 
-	dev_dbg(sdev->dev, "%s set copier sink %d format\n",
-		src_widget->widget->name, sink_id);
-
 	if (WIDGET_IS_DAI(src_widget->id)) {
 		struct snd_sof_dai *dai = src_widget->private;
 
@@ -2897,13 +2894,15 @@ static int sof_ipc4_set_copier_sink_form
 
 	fw_module = src_widget->module_info;
 
-	format.sink_id = sink_id;
+	format.sink_id = sroute->src_queue_id;
 	memcpy(&format.source_fmt, &src_config->audio_fmt, sizeof(format.source_fmt));
 
-	pin_fmt = sof_ipc4_get_input_pin_audio_fmt(sink_widget, sink_id);
+	pin_fmt = sof_ipc4_get_input_pin_audio_fmt(sink_widget, sroute->dst_queue_id);
 	if (!pin_fmt) {
-		dev_err(sdev->dev, "Unable to get pin %d format for %s",
-			sink_id, sink_widget->widget->name);
+		dev_err(sdev->dev,
+			"Failed to get input audio format of %s:%d for output of %s:%d\n",
+			sink_widget->widget->name, sroute->dst_queue_id,
+			src_widget->widget->name, sroute->src_queue_id);
 		return -EINVAL;
 	}
 
@@ -2961,7 +2960,8 @@ static int sof_ipc4_route_setup(struct s
 	sroute->src_queue_id = sof_ipc4_get_queue_id(src_widget, sink_widget,
 						     SOF_PIN_TYPE_OUTPUT);
 	if (sroute->src_queue_id < 0) {
-		dev_err(sdev->dev, "failed to get queue ID for source widget: %s\n",
+		dev_err(sdev->dev,
+			"failed to get src_queue_id ID from source widget %s\n",
 			src_widget->widget->name);
 		return sroute->src_queue_id;
 	}
@@ -2969,7 +2969,8 @@ static int sof_ipc4_route_setup(struct s
 	sroute->dst_queue_id = sof_ipc4_get_queue_id(src_widget, sink_widget,
 						     SOF_PIN_TYPE_INPUT);
 	if (sroute->dst_queue_id < 0) {
-		dev_err(sdev->dev, "failed to get queue ID for sink widget: %s\n",
+		dev_err(sdev->dev,
+			"failed to get dst_queue_id ID from sink widget %s\n",
 			sink_widget->widget->name);
 		sof_ipc4_put_queue_id(src_widget, sroute->src_queue_id,
 				      SOF_PIN_TYPE_OUTPUT);
@@ -2978,10 +2979,11 @@ static int sof_ipc4_route_setup(struct s
 
 	/* Pin 0 format is already set during copier module init */
 	if (sroute->src_queue_id > 0 && WIDGET_IS_COPIER(src_widget->id)) {
-		ret = sof_ipc4_set_copier_sink_format(sdev, src_widget, sink_widget,
-						      sroute->src_queue_id);
+		ret = sof_ipc4_set_copier_sink_format(sdev, src_widget,
+						      sink_widget, sroute);
 		if (ret < 0) {
-			dev_err(sdev->dev, "failed to set sink format for %s source queue ID %d\n",
+			dev_err(sdev->dev,
+				"failed to set sink format for source %s:%d\n",
 				src_widget->widget->name, sroute->src_queue_id);
 			goto out;
 		}


