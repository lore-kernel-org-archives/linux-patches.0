Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0DBE1C1F02;
	Wed, 19 Mar 2025 14:37:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742395077; cv=none; b=uD0WU98byvepAI1YB67+Oux8C5iQxI4+d0bj5hQExHTzf7lZnH78z9HXpebLYsR0V3vXYz6Sf+GK9fiQCu+z2SaXLmeqmWGGb7Pvs4b049qIbG9B8DmgbHmyJ7OSu6k5Uu2J9cKLUU1D6KN8TdSJR83A0V6YY/O6a8xbQUFuQFY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742395077; c=relaxed/simple;
	bh=oAnR+L+pXnfx2F76jqxfVHhInOxeal57pnDAD0p/vrE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JjZGFSJLs0n2NE6P1MwCBX6yihCre9zm5iin4xZ4LcbPDm/6nfoL8J7PrP+o7eFMy5QwSlXSh4hRbb7cG4yIYgtGaDqvB5Jh6HBy8rEYY8cEfWceFs+h05C1odZJ8jdlsDC8e8qShgSFekH8D6OF3pg4s1Jj3ahPnTqPcJGL7js=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Px6Tu4nW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Px6Tu4nW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79F9CC4CEE4;
	Wed, 19 Mar 2025 14:37:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742395077;
	bh=oAnR+L+pXnfx2F76jqxfVHhInOxeal57pnDAD0p/vrE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Px6Tu4nWpA79efqM0lUAkU49xzjeEZFi0M+oTK6jRww8CAfDRvfaqW2pv1r6SSQgt
	 cnsa2ILdkk+dUuyduQPE7aUA6I13TnOjPcAZyxOg0NVdqxILzoQLv6USJzgGgz6/8G
	 SlRa4NjLod6j0ukJLXH0YKBmI8xkmfvJQ91+vzEQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cristian Ciocaltea <cristian.ciocaltea@collabora.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 117/231] ASoC: SOF: amd: Add post_fw_run_delay ACP quirk
Date: Wed, 19 Mar 2025 07:30:10 -0700
Message-ID: <20250319143029.736406670@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250319143026.865956961@linuxfoundation.org>
References: <20250319143026.865956961@linuxfoundation.org>
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

From: Cristian Ciocaltea <cristian.ciocaltea@collabora.com>

[ Upstream commit 91b98d5a6e8067c5226207487681a48f0d651e46 ]

Stress testing resume from suspend on Valve Steam Deck OLED (Galileo)
revealed that the DSP firmware could enter an unrecoverable faulty
state, where the kernel ring buffer is flooded with IPC related error
messages:

[  +0.017002] snd_sof_amd_vangogh 0000:04:00.5: acp_sof_ipc_send_msg: Failed to acquire HW lock
[  +0.000054] snd_sof_amd_vangogh 0000:04:00.5: ipc3_tx_msg_unlocked: ipc message send for 0x30100000 failed: -22
[  +0.000005] snd_sof_amd_vangogh 0000:04:00.5: Failed to setup widget PIPELINE.6.ACPHS1.IN
[  +0.000004] snd_sof_amd_vangogh 0000:04:00.5: Failed to restore pipeline after resume -22
[  +0.000003] snd_sof_amd_vangogh 0000:04:00.5: PM: dpm_run_callback(): pci_pm_resume returns -22
[  +0.000009] snd_sof_amd_vangogh 0000:04:00.5: PM: failed to resume async: error -22
[...]
[  +0.002582] PM: suspend exit
[  +0.065085] snd_sof_amd_vangogh 0000:04:00.5: ipc tx error for 0x30130000 (msg/reply size: 12/0): -22
[  +0.000499] snd_sof_amd_vangogh 0000:04:00.5: error: failed widget list set up for pcm 1 dir 0
[  +0.000011] snd_sof_amd_vangogh 0000:04:00.5: error: set pcm hw_params after resume
[  +0.000006] snd_sof_amd_vangogh 0000:04:00.5: ASoC: error at snd_soc_pcm_component_prepare on 0000:04:00.5: -22
[...]

A system reboot would be necessary to restore the speakers
functionality.

However, by delaying a bit any host to DSP transmission right after
the firmware boot completed, the issue could not be reproduced anymore
and sound continued to work flawlessly even after performing thousands
of suspend/resume cycles.

Introduce the post_fw_run_delay ACP quirk to allow providing the
aforementioned delay via the snd_sof_dsp_ops->post_fw_run() callback for
the affected devices.

Signed-off-by: Cristian Ciocaltea <cristian.ciocaltea@collabora.com>
Link: https://patch.msgid.link/20250207-sof-vangogh-fixes-v1-1-67824c1e4c9a@collabora.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/sof/amd/acp.c     |  1 +
 sound/soc/sof/amd/acp.h     |  1 +
 sound/soc/sof/amd/vangogh.c | 18 ++++++++++++++++++
 3 files changed, 20 insertions(+)

diff --git a/sound/soc/sof/amd/acp.c b/sound/soc/sof/amd/acp.c
index 95d4762c9d939..35eb23d2a056d 100644
--- a/sound/soc/sof/amd/acp.c
+++ b/sound/soc/sof/amd/acp.c
@@ -27,6 +27,7 @@ MODULE_PARM_DESC(enable_fw_debug, "Enable Firmware debug");
 static struct acp_quirk_entry quirk_valve_galileo = {
 	.signed_fw_image = true,
 	.skip_iram_dram_size_mod = true,
+	.post_fw_run_delay = true,
 };
 
 const struct dmi_system_id acp_sof_quirk_table[] = {
diff --git a/sound/soc/sof/amd/acp.h b/sound/soc/sof/amd/acp.h
index 800594440f739..2a19d82d62002 100644
--- a/sound/soc/sof/amd/acp.h
+++ b/sound/soc/sof/amd/acp.h
@@ -220,6 +220,7 @@ struct sof_amd_acp_desc {
 struct acp_quirk_entry {
 	bool signed_fw_image;
 	bool skip_iram_dram_size_mod;
+	bool post_fw_run_delay;
 };
 
 /* Common device data struct for ACP devices */
diff --git a/sound/soc/sof/amd/vangogh.c b/sound/soc/sof/amd/vangogh.c
index 61372958c09dc..436f58be3a9f9 100644
--- a/sound/soc/sof/amd/vangogh.c
+++ b/sound/soc/sof/amd/vangogh.c
@@ -11,6 +11,7 @@
  * Hardware interface for Audio DSP on Vangogh platform
  */
 
+#include <linux/delay.h>
 #include <linux/platform_device.h>
 #include <linux/module.h>
 
@@ -136,6 +137,20 @@ static struct snd_soc_dai_driver vangogh_sof_dai[] = {
 	},
 };
 
+static int sof_vangogh_post_fw_run_delay(struct snd_sof_dev *sdev)
+{
+	/*
+	 * Resuming from suspend in some cases my cause the DSP firmware
+	 * to enter an unrecoverable faulty state.  Delaying a bit any host
+	 * to DSP transmission right after firmware boot completion seems
+	 * to resolve the issue.
+	 */
+	if (!sdev->first_boot)
+		usleep_range(100, 150);
+
+	return 0;
+}
+
 /* Vangogh ops */
 struct snd_sof_dsp_ops sof_vangogh_ops;
 EXPORT_SYMBOL_NS(sof_vangogh_ops, SND_SOC_SOF_AMD_COMMON);
@@ -157,6 +172,9 @@ int sof_vangogh_ops_init(struct snd_sof_dev *sdev)
 
 		if (quirks->signed_fw_image)
 			sof_vangogh_ops.load_firmware = acp_sof_load_signed_firmware;
+
+		if (quirks->post_fw_run_delay)
+			sof_vangogh_ops.post_fw_run = sof_vangogh_post_fw_run_delay;
 	}
 
 	return 0;
-- 
2.39.5



