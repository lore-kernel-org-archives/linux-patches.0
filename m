Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1570D17E90E;
	Mon, 27 May 2024 19:11:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716837086; cv=none; b=CVNAq1tENJ0ZlBKG046gDNpZFbJJ+EudKXF6F/80zs+7APHBiBVl+qeebh7ENFOTjN87E1sHkdEMrNq5PhBAhnzyxTvoX+UlvaK2zL6qRVVBDTLZO05v/K4fm0O+33zIaDFdLWLbvCTp3iWYa4auHb3fiaXHfN6OcXsbdhoVdpU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716837086; c=relaxed/simple;
	bh=8skkggTJr5T9Ud8PKR5EJJ2pkfBRL1oTvR8AXdV2a8U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RAF6qBIT6OlWtKUhf6vFoaQDlwBU2JO/sUZzZ2c7hr3u6T/mUQduXff8tJesztDW6VzZajdHuiV1+sVDSqgnpSzzGfKpHPgI9To98XbjCGQdlsEk0K0wHE6np6bVlT8oWth8q2F/rnc3Fz5W1AETkSwsnhh1ajcBgMULpeqWo2A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YLx2Rmcw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YLx2Rmcw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9EF0AC2BBFC;
	Mon, 27 May 2024 19:11:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716837086;
	bh=8skkggTJr5T9Ud8PKR5EJJ2pkfBRL1oTvR8AXdV2a8U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YLx2RmcwOuSgYW5+ydJ3XeY3n+L5rMSw9utE5K832hCr+boZNggzNGr5mU9Gce/op
	 J4kl06seM9a4xbS8cPvAD4KzXI9M6A638ayr1r6OAmZrSXBMthXNMe2PUK81jlgDw5
	 1s4jkAYlL+HzTCoW2mOqe4bcKhxyGQa/3A70XP6g=
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
Subject: [PATCH 6.9 304/427] ASoC: SOF: Intel: mtl: Implement firmware boot state check
Date: Mon, 27 May 2024 20:55:51 +0200
Message-ID: <20240527185630.469091920@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185601.713589927@linuxfoundation.org>
References: <20240527185601.713589927@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

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
index fbd7cf77e8174..05023763080d9 100644
--- a/sound/soc/sof/intel/mtl.c
+++ b/sound/soc/sof/intel/mtl.c
@@ -439,7 +439,7 @@ int mtl_dsp_cl_init(struct snd_sof_dev *sdev, int stream_tag, bool imr_boot)
 {
 	struct sof_intel_hda_dev *hda = sdev->pdata->hw_pdata;
 	const struct sof_intel_dsp_desc *chip = hda->desc;
-	unsigned int status;
+	unsigned int status, target_status;
 	u32 ipc_hdr, flags;
 	char *dump_msg;
 	int ret;
@@ -485,13 +485,40 @@ int mtl_dsp_cl_init(struct snd_sof_dev *sdev, int stream_tag, bool imr_boot)
 
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



