Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FB401B0118;
	Thu,  6 Jun 2024 14:15:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683357; cv=none; b=HSu60bOCGLsseZdRVnDgsKGfstWKYIDqd6lzB99TqLyMcBwSNzwUkUmMPrs4UceeIbAW7JnImkOsR44yfWVO0kscezwUJnvvbYpSmfh1c48S9kw0RwcvdXr2Hbwsy5b6jOKVA/m937hVoomt3o6GFHgvJ3tqimr/oFkGJ8y9v/M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683357; c=relaxed/simple;
	bh=I4LCwm06IrFHC92QLvJKl/PLUKJzNynkAbtyt04rF80=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hfieMdnpZq8/r9E5PIx5ZK1Dy23JQUP7T4LE+A5PFOGrac3eQg4STieEUer9/VUG7PASFuv45yJfSb6Hr0vID7wOw+e8rbm3BWdUNi+KU+Zo/xBrZlNE9imcptMw9VL+F+HEH/Hw8HsH3goT8mrmGdr+tfihoOj6CTho8txet4E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=H9p/L7pU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="H9p/L7pU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2620EC32782;
	Thu,  6 Jun 2024 14:15:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683357;
	bh=I4LCwm06IrFHC92QLvJKl/PLUKJzNynkAbtyt04rF80=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=H9p/L7pUEolXY+YtfmeQCKgNUWOfTuth7gAOkBvkhAl3o2Ykz2gqlwelYb1VLrRaH
	 3JsvTJETz+kgusLEm15R8GDBFTwOmwmgHaPtzPbmDXJhocrtNvsn84movvei7DC3dx
	 qADJfhLUALKvJL3m2x8cMisZexw7PC58UDHM1nQY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Ujfalusi <peter.ujfalusi@linux.intel.com>,
	Rander Wang <rander.wang@intel.com>,
	Kai Vehmanen <kai.vehmanen@linux.intel.com>,
	Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
	Liam Girdwood <liam.r.girdwood@intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 297/744] ASoC: SOF: Intel: mtl: Implement firmware boot state check
Date: Thu,  6 Jun 2024 15:59:29 +0200
Message-ID: <20240606131741.922058080@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131732.440653204@linuxfoundation.org>
References: <20240606131732.440653204@linuxfoundation.org>
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

[ Upstream commit 6b1c1c47e76f0161bda2b1ac2e86a219fe70244f ]

With the corrected rom_status_reg values we can now add a check for target
boot status for firmware booting.
With the check now we can identify failed firmware boots (IMR boots) and
we can use the fallback to purge boot the DSP.

Fixes: 064520e8aeaa ("ASoC: SOF: Intel: Add support for MeteorLake (MTL)")
Signed-off-by: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
Reviewed-by: Rander Wang <rander.wang@intel.com>
Reviewed-by: Kai Vehmanen <kai.vehmanen@linux.intel.com>
Reviewed-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Reviewed-by: Liam Girdwood <liam.r.girdwood@intel.com>
Link: https://msgid.link/r/20240403105210.17949-6-peter.ujfalusi@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/sof/intel/mtl.c | 37 ++++++++++++++++++++++++++++++++-----
 1 file changed, 32 insertions(+), 5 deletions(-)

diff --git a/sound/soc/sof/intel/mtl.c b/sound/soc/sof/intel/mtl.c
index e3ecd48ccc4da..7d7a017c2e1f7 100644
--- a/sound/soc/sof/intel/mtl.c
+++ b/sound/soc/sof/intel/mtl.c
@@ -436,7 +436,7 @@ int mtl_dsp_cl_init(struct snd_sof_dev *sdev, int stream_tag, bool imr_boot)
 {
 	struct sof_intel_hda_dev *hda = sdev->pdata->hw_pdata;
 	const struct sof_intel_dsp_desc *chip = hda->desc;
-	unsigned int status;
+	unsigned int status, target_status;
 	u32 ipc_hdr, flags;
 	char *dump_msg;
 	int ret;
@@ -482,13 +482,40 @@ int mtl_dsp_cl_init(struct snd_sof_dev *sdev, int stream_tag, bool imr_boot)
 
 	mtl_enable_ipc_interrupts(sdev);
 
+	if (chip->rom_status_reg == MTL_DSP_ROM_STS) {
+		/*
+		 * Workaround: when the ROM status register is pointing to
+		 * the SRAM window (MTL_DSP_ROM_STS) the platform cannot catch
+		 * ROM_INIT_DONE because of a very short timing window.
+		 * Follow the recommendations and skip target state waiting.
+		 */
+		return 0;
+	}
+
 	/*
-	 * ACE workaround: don't wait for ROM INIT.
-	 * The platform cannot catch ROM_INIT_DONE because of a very short
-	 * timing window. Follow the recommendations and skip this part.
+	 * step 7:
+	 * - Cold/Full boot: wait for ROM init to proceed to download the firmware
+	 * - IMR boot: wait for ROM firmware entered (firmware booted up from IMR)
 	 */
+	if (imr_boot)
+		target_status = FSR_STATE_FW_ENTERED;
+	else
+		target_status = FSR_STATE_INIT_DONE;
 
-	return 0;
+	ret = snd_sof_dsp_read_poll_timeout(sdev, HDA_DSP_BAR,
+					chip->rom_status_reg, status,
+					(FSR_TO_STATE_CODE(status) == target_status),
+					HDA_DSP_REG_POLL_INTERVAL_US,
+					chip->rom_init_timeout *
+					USEC_PER_MSEC);
+
+	if (!ret)
+		return 0;
+
+	if (hda->boot_iteration == HDA_FW_BOOT_ATTEMPTS)
+		dev_err(sdev->dev,
+			"%s: timeout with rom_status_reg (%#x) read\n",
+			__func__, chip->rom_status_reg);
 
 err:
 	flags = SOF_DBG_DUMP_PCI | SOF_DBG_DUMP_MBOX | SOF_DBG_DUMP_OPTIONAL;
-- 
2.43.0



