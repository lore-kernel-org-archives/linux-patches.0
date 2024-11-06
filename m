Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E1791FBF70;
	Wed,  6 Nov 2024 12:55:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730897726; cv=none; b=X2/krjjboOk5/OHK4p0tXOkkaxiQtJ6AFS6ttZ+zbIoFDBFkqE4YpA0pKuUQ5Md9Fo5iBI3F+KlZ1D0L0HHAYoGR/anGGR1dPCJeNKCcvmU8zguBkxm1y/QqPjb9D97xx7MNCF2IWnnYsEKRRKHh8BE1I0gzFresioDctoj5G+o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730897726; c=relaxed/simple;
	bh=be/cLx72kFT7ZJ5iL33A/cguX5r8Lvy1kgvutYrWs4M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jxG3UIJ/T/TpsiW9JlRQG4h6OMEtibA7FLEAXWNHuePEY8b3V55UJbxXPEg3GDJn2KHfNGWa6a9z+eItZCtmHivqYhOo1H06nipW2RzSerQNSrZg2gl41F6i14bCYyaFK5YqwB+zeMzONItsJBaxBVV0XPfDjroJUR9md686f7U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GHK2P+t4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GHK2P+t4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D54FAC4CECD;
	Wed,  6 Nov 2024 12:55:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730897726;
	bh=be/cLx72kFT7ZJ5iL33A/cguX5r8Lvy1kgvutYrWs4M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GHK2P+t4I/curzi8840ndHV118PqJpVsvm0HN6itis6jIc3wafQ65LcsHRECX54ZA
	 xyWga5jNx7i54wMAUVs5Ykj1mcFR+9JZs8EVaQq+AsWsnuo8EXI1Mx9aDDz6pqALKf
	 WJXOfbuirhfYlGMEpuxA2AaiVCPmvUBSEvdI5mXI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Ujfalusi <peter.ujfalusi@linux.intel.com>,
	Bard Liao <yung-chuan.liao@linux.intel.com>,
	Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.6 149/151] ASoC: SOF: ipc4-control: Add support for ALSA enum control
Date: Wed,  6 Nov 2024 13:05:37 +0100
Message-ID: <20241106120312.945852126@linuxfoundation.org>
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

commit 07a866a41982c896dc46476f57d209a200602946 upstream.

Enum controls use generic param_id and a generic struct where the data
is passed to the firmware.

Signed-off-by: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
Reviewed-by: Bard Liao <yung-chuan.liao@linux.intel.com>
Reviewed-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Link: https://lore.kernel.org/r/20230919103115.30783-4-peter.ujfalusi@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/sof/ipc4-control.c  |   64 ++++++++++++++++++++++++++++++++++++++++++
 sound/soc/sof/ipc4-topology.c |   33 +++++++++++++++++++++
 2 files changed, 97 insertions(+)

--- a/sound/soc/sof/ipc4-control.c
+++ b/sound/soc/sof/ipc4-control.c
@@ -297,6 +297,63 @@ static int sof_ipc4_switch_get(struct sn
 	return 0;
 }
 
+static bool sof_ipc4_enum_put(struct snd_sof_control *scontrol,
+			      struct snd_ctl_elem_value *ucontrol)
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
+		value = ucontrol->value.enumerated.item[i];
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
+static int sof_ipc4_enum_get(struct snd_sof_control *scontrol,
+			     struct snd_ctl_elem_value *ucontrol)
+{
+	struct sof_ipc4_control_data *cdata = scontrol->ipc_control_data;
+	unsigned int i;
+
+	/* read back each channel */
+	for (i = 0; i < scontrol->num_channels; i++)
+		ucontrol->value.enumerated.item[i] = cdata->chanv[i].value;
+
+	return 0;
+}
+
 static int sof_ipc4_set_get_bytes_data(struct snd_sof_dev *sdev,
 				       struct snd_sof_control *scontrol,
 				       bool set, bool lock)
@@ -562,6 +619,11 @@ static int sof_ipc4_widget_kcontrol_setu
 				ret = sof_ipc4_set_get_bytes_data(sdev, scontrol,
 								  true, false);
 				break;
+			case SND_SOC_TPLG_CTL_ENUM:
+			case SND_SOC_TPLG_CTL_ENUM_VALUE:
+				ret = sof_ipc4_set_generic_control_data(sdev, swidget,
+									scontrol, false);
+				break;
 			default:
 				break;
 			}
@@ -605,6 +667,8 @@ const struct sof_ipc_tplg_control_ops tp
 	.volume_get = sof_ipc4_volume_get,
 	.switch_put = sof_ipc4_switch_put,
 	.switch_get = sof_ipc4_switch_get,
+	.enum_put = sof_ipc4_enum_put,
+	.enum_get = sof_ipc4_enum_get,
 	.bytes_put = sof_ipc4_bytes_put,
 	.bytes_get = sof_ipc4_bytes_get,
 	.bytes_ext_put = sof_ipc4_bytes_ext_put,
--- a/sound/soc/sof/ipc4-topology.c
+++ b/sound/soc/sof/ipc4-topology.c
@@ -2148,6 +2148,36 @@ static int sof_ipc4_control_load_volume(
 	return 0;
 }
 
+static int sof_ipc4_control_load_enum(struct snd_sof_dev *sdev, struct snd_sof_control *scontrol)
+{
+	struct sof_ipc4_control_data *control_data;
+	struct sof_ipc4_msg *msg;
+	int i;
+
+	scontrol->size = struct_size(control_data, chanv, scontrol->num_channels);
+
+	/* scontrol->ipc_control_data will be freed in sof_control_unload */
+	scontrol->ipc_control_data = kzalloc(scontrol->size, GFP_KERNEL);
+	if (!scontrol->ipc_control_data)
+		return -ENOMEM;
+
+	control_data = scontrol->ipc_control_data;
+	control_data->index = scontrol->index;
+
+	msg = &control_data->msg;
+	msg->primary = SOF_IPC4_MSG_TYPE_SET(SOF_IPC4_MOD_LARGE_CONFIG_SET);
+	msg->primary |= SOF_IPC4_MSG_DIR(SOF_IPC4_MSG_REQUEST);
+	msg->primary |= SOF_IPC4_MSG_TARGET(SOF_IPC4_MODULE_MSG);
+
+	msg->extension = SOF_IPC4_MOD_EXT_MSG_PARAM_ID(SOF_IPC4_ENUM_CONTROL_PARAM_ID);
+
+	/* Default, initial value for enums: first enum entry is selected (0) */
+	for (i = 0; i < scontrol->num_channels; i++)
+		control_data->chanv[i].channel = i;
+
+	return 0;
+}
+
 static int sof_ipc4_control_load_bytes(struct snd_sof_dev *sdev, struct snd_sof_control *scontrol)
 {
 	struct sof_ipc4_control_data *control_data;
@@ -2222,6 +2252,9 @@ static int sof_ipc4_control_setup(struct
 		return sof_ipc4_control_load_volume(sdev, scontrol);
 	case SND_SOC_TPLG_CTL_BYTES:
 		return sof_ipc4_control_load_bytes(sdev, scontrol);
+	case SND_SOC_TPLG_CTL_ENUM:
+	case SND_SOC_TPLG_CTL_ENUM_VALUE:
+		return sof_ipc4_control_load_enum(sdev, scontrol);
 	default:
 		break;
 	}


