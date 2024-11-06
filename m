Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2DA91FBF6A;
	Wed,  6 Nov 2024 12:55:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730897723; cv=none; b=dsML9gn5p3W/gKdO/qRT3p2UgXk8tpiFccsgvmi6t56DYbW/rmyJTmrwoMOmJ8TkWCT3MYVqiac4nyVZHVjLBGb5dpVIdILZC6nm/zb8K/Lm9VQFJNmBwpZHHXuc2xLqsdmGXWC9+8YmoGtZEz8scmMD64g3FciSCfl5xJHclBE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730897723; c=relaxed/simple;
	bh=eNPZUO9ZqfSu2Pdr/YBQPtfYNnh6ht+RQ1YSXbmXaKY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FrEqcG6I/qql7a5iorWG7Yv7t6p0a89aPm9F98spCx4rfaKnWOOKP5xqYlWN39UdlG6UBStUhWq4FJ3SLEIi/qljpGu+UtfGR9YIpaBLpoHSH8GdLJBUI1BzOPljZzpvzVdRq/bdAHEeQcyh7vcReieSQngHwBo4JQ5C1GyL8tw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rsOuEbg1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rsOuEbg1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D648FC4CECD;
	Wed,  6 Nov 2024 12:55:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730897723;
	bh=eNPZUO9ZqfSu2Pdr/YBQPtfYNnh6ht+RQ1YSXbmXaKY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rsOuEbg1SygU2z0u1BdNhytunwvNH0xlHjV1LQOX74Pd/9s60WHBJGNN1WZPB4I/Q
	 HmjBAi1//A8bZBsAxMMRkjiHf/d1jgJvUyfeamr8kYvLRRFia0IVYoFT9MdGIkqlae
	 2m7baCmUcRgITELUzDp4wKUY17/hqGXsnmyFa8LE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Ujfalusi <peter.ujfalusi@linux.intel.com>,
	Bard Liao <yung-chuan.liao@linux.intel.com>,
	Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.6 148/151] ASoC: SOF: ipc4-control: Add support for ALSA switch control
Date: Wed,  6 Nov 2024 13:05:36 +0100
Message-ID: <20241106120312.919518958@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120308.841299741@linuxfoundation.org>
References: <20241106120308.841299741@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>

commit 4a2fd607b7ca6128ee3532161505da7624197f55 upstream.

Volume controls with a max value of 1 are switches.
Switch controls use generic param_id and a generic struct where the data
is passed to the firmware.

Signed-off-by: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
Reviewed-by: Bard Liao <yung-chuan.liao@linux.intel.com>
Reviewed-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Link: https://lore.kernel.org/r/20230919103115.30783-3-peter.ujfalusi@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/sof/ipc4-control.c  |  111 +++++++++++++++++++++++++++++++++++++++++-
 sound/soc/sof/ipc4-topology.c |   16 ++++--
 2 files changed, 122 insertions(+), 5 deletions(-)

--- a/sound/soc/sof/ipc4-control.c
+++ b/sound/soc/sof/ipc4-control.c
@@ -201,6 +201,102 @@ static int sof_ipc4_volume_get(struct sn
 	return 0;
 }
 
+static int
+sof_ipc4_set_generic_control_data(struct snd_sof_dev *sdev,
+				  struct snd_sof_widget *swidget,
+				  struct snd_sof_control *scontrol, bool lock)
+{
+	struct sof_ipc4_control_data *cdata = scontrol->ipc_control_data;
+	struct sof_ipc4_control_msg_payload *data;
+	struct sof_ipc4_msg *msg = &cdata->msg;
+	size_t data_size;
+	unsigned int i;
+	int ret;
+
+	data_size = struct_size(data, chanv, scontrol->num_channels);
+	data = kzalloc(data_size, GFP_KERNEL);
+	if (!data)
+		return -ENOMEM;
+
+	data->id = cdata->index;
+	data->num_elems = scontrol->num_channels;
+	for (i = 0; i < scontrol->num_channels; i++) {
+		data->chanv[i].channel = cdata->chanv[i].channel;
+		data->chanv[i].value = cdata->chanv[i].value;
+	}
+
+	msg->data_ptr = data;
+	msg->data_size = data_size;
+
+	ret = sof_ipc4_set_get_kcontrol_data(scontrol, true, lock);
+	msg->data_ptr = NULL;
+	msg->data_size = 0;
+	if (ret < 0)
+		dev_err(sdev->dev, "Failed to set control update for %s\n",
+			scontrol->name);
+
+	kfree(data);
+
+	return ret;
+}
+
+static bool sof_ipc4_switch_put(struct snd_sof_control *scontrol,
+				struct snd_ctl_elem_value *ucontrol)
+{
+	struct sof_ipc4_control_data *cdata = scontrol->ipc_control_data;
+	struct snd_soc_component *scomp = scontrol->scomp;
+	struct snd_sof_dev *sdev = snd_soc_component_get_drvdata(scomp);
+	struct snd_sof_widget *swidget;
+	bool widget_found = false;
+	bool change = false;
+	unsigned int i;
+	u32 value;
+	int ret;
+
+	/* update each channel */
+	for (i = 0; i < scontrol->num_channels; i++) {
+		value = ucontrol->value.integer.value[i];
+		change = change || (value != cdata->chanv[i].value);
+		cdata->chanv[i].channel = i;
+		cdata->chanv[i].value = value;
+	}
+
+	if (!pm_runtime_active(scomp->dev))
+		return change;
+
+	/* find widget associated with the control */
+	list_for_each_entry(swidget, &sdev->widget_list, list) {
+		if (swidget->comp_id == scontrol->comp_id) {
+			widget_found = true;
+			break;
+		}
+	}
+
+	if (!widget_found) {
+		dev_err(scomp->dev, "Failed to find widget for kcontrol %s\n", scontrol->name);
+		return false;
+	}
+
+	ret = sof_ipc4_set_generic_control_data(sdev, swidget, scontrol, true);
+	if (ret < 0)
+		return false;
+
+	return change;
+}
+
+static int sof_ipc4_switch_get(struct snd_sof_control *scontrol,
+			       struct snd_ctl_elem_value *ucontrol)
+{
+	struct sof_ipc4_control_data *cdata = scontrol->ipc_control_data;
+	unsigned int i;
+
+	/* read back each channel */
+	for (i = 0; i < scontrol->num_channels; i++)
+		ucontrol->value.integer.value[i] = cdata->chanv[i].value;
+
+	return 0;
+}
+
 static int sof_ipc4_set_get_bytes_data(struct snd_sof_dev *sdev,
 				       struct snd_sof_control *scontrol,
 				       bool set, bool lock)
@@ -438,6 +534,16 @@ static int sof_ipc4_bytes_ext_volatile_g
 	return _sof_ipc4_bytes_ext_get(scontrol, binary_data, size, true);
 }
 
+static int
+sof_ipc4_volsw_setup(struct snd_sof_dev *sdev, struct snd_sof_widget *swidget,
+		     struct snd_sof_control *scontrol)
+{
+	if (scontrol->max == 1)
+		return sof_ipc4_set_generic_control_data(sdev, swidget, scontrol, false);
+
+	return sof_ipc4_set_volume_data(sdev, swidget, scontrol, false);
+}
+
 /* set up all controls for the widget */
 static int sof_ipc4_widget_kcontrol_setup(struct snd_sof_dev *sdev, struct snd_sof_widget *swidget)
 {
@@ -450,8 +556,7 @@ static int sof_ipc4_widget_kcontrol_setu
 			case SND_SOC_TPLG_CTL_VOLSW:
 			case SND_SOC_TPLG_CTL_VOLSW_SX:
 			case SND_SOC_TPLG_CTL_VOLSW_XR_SX:
-				ret = sof_ipc4_set_volume_data(sdev, swidget,
-							       scontrol, false);
+				ret = sof_ipc4_volsw_setup(sdev, swidget, scontrol);
 				break;
 			case SND_SOC_TPLG_CTL_BYTES:
 				ret = sof_ipc4_set_get_bytes_data(sdev, scontrol,
@@ -498,6 +603,8 @@ sof_ipc4_set_up_volume_table(struct snd_
 const struct sof_ipc_tplg_control_ops tplg_ipc4_control_ops = {
 	.volume_put = sof_ipc4_volume_put,
 	.volume_get = sof_ipc4_volume_get,
+	.switch_put = sof_ipc4_switch_put,
+	.switch_get = sof_ipc4_switch_get,
 	.bytes_put = sof_ipc4_bytes_put,
 	.bytes_get = sof_ipc4_bytes_get,
 	.bytes_ext_put = sof_ipc4_bytes_ext_put,
--- a/sound/soc/sof/ipc4-topology.c
+++ b/sound/soc/sof/ipc4-topology.c
@@ -2127,12 +2127,22 @@ static int sof_ipc4_control_load_volume(
 	msg->primary |= SOF_IPC4_MSG_DIR(SOF_IPC4_MSG_REQUEST);
 	msg->primary |= SOF_IPC4_MSG_TARGET(SOF_IPC4_MODULE_MSG);
 
-	msg->extension = SOF_IPC4_MOD_EXT_MSG_PARAM_ID(SOF_IPC4_GAIN_PARAM_ID);
+	/* volume controls with range 0-1 (off/on) are switch controls */
+	if (scontrol->max == 1)
+		msg->extension = SOF_IPC4_MOD_EXT_MSG_PARAM_ID(SOF_IPC4_SWITCH_CONTROL_PARAM_ID);
+	else
+		msg->extension = SOF_IPC4_MOD_EXT_MSG_PARAM_ID(SOF_IPC4_GAIN_PARAM_ID);
 
-	/* set default volume values to 0dB in control */
 	for (i = 0; i < scontrol->num_channels; i++) {
 		control_data->chanv[i].channel = i;
-		control_data->chanv[i].value = SOF_IPC4_VOL_ZERO_DB;
+		/*
+		 * Default, initial values:
+		 * - 0dB for volume controls
+		 * - off (0) for switch controls - value already zero after
+		 *				   memory allocation
+		 */
+		if (scontrol->max > 1)
+			control_data->chanv[i].value = SOF_IPC4_VOL_ZERO_DB;
 	}
 
 	return 0;


