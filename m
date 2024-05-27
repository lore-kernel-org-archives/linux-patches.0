Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 559D9168C4;
	Mon, 27 May 2024 19:22:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716837750; cv=none; b=TXfxAW6b1/ERoW8cA8TOf7XaLZofhCPtylBcBnWe7rW4MzSPNQJi8PWVJV79EHskZtqFVXNR+f0EDKToi4ufpvk477isqLy0GAiqIJHtniNLXYi1HQIIPPSJSZ+5E+97qhvxM8KVYlwR6f/OBDvYWd2NbMR6DUt28mYBD1wDG3g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716837750; c=relaxed/simple;
	bh=yihpeV8JqqaMlGZGDJzKTIYJd/ZWOBjccj+ZrLqzDB4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Dgb9MgMiCMu7cQ8kLKF0md+c+Vnrfiy7xuCX3sfnLmY3B3/8mqYfMmQ71LHi3Om96mpi0sKHm6KuM29HPBprNmB+74nbN3M14c8lapj2wgWWCz2NuiJeCGSvMyNTKUA7jWQKeE8zHQ8YA+rwV+xh8w4b64VuLGkB0h0ldVuB4w4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GDQTEea6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GDQTEea6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1463C2BBFC;
	Mon, 27 May 2024 19:22:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716837750;
	bh=yihpeV8JqqaMlGZGDJzKTIYJd/ZWOBjccj+ZrLqzDB4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GDQTEea6dM58ckGf2wz64n/llwtvEm1h8/+0ryNs/uz2qcfCaceiWQ6avL+5o7c5x
	 7fVRwbhtkiITw1R31k+rkg9HEQzGrnfVvf5QsC+HtLsR12vDl/VU5md9HTfHPZ4YFO
	 AbWSwjnFkuc/Krk363D8VlOq3il9AV0GTNyAvIiI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mauro Carvalho Chehab <mchehab@kernel.org>,
	Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
	Bard Liao <yung-chuan.liao@linux.intel.com>,
	=?UTF-8?q?P=C3=A9ter=20Ujfalusi?= <peter.ujfalusi@linux.intel.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 090/493] ALSA: hda: intel-dsp-config: harden I2C/I2S codec detection
Date: Mon, 27 May 2024 20:51:32 +0200
Message-ID: <20240527185633.315506331@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185626.546110716@linuxfoundation.org>
References: <20240527185626.546110716@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>

[ Upstream commit 79ac4c1443eaec0d09355307043a9149287f23c1 ]

The SOF driver is selected whenever specific I2C/I2S HIDs are reported
as 'present' in the ACPI DSDT. In some cases, an HID is reported but
the hardware does not actually rely on I2C/I2S.  This false positive
leads to an invalid selection of the SOF driver and as a result an
invalid topology is loaded.

This patch hardens the detection with a check that the NHLT table is
consistent with the report of an I2S-based codec in DSDT. This table
should expose at least one SSP endpoint configured for an I2S-codec
connection.

Tested on Huawei Matebook D14 (NBLB-WAX9N) using an HDaudio codec with
an invalid ES8336 ACPI HID reported:

[    7.858249] snd_hda_intel 0000:00:1f.3: DSP detected with PCI class/subclass/prog-if info 0x040380
[    7.858312] snd_hda_intel 0000:00:1f.3: snd_intel_dsp_find_config: no valid SSP found for HID ESSX8336, skipped

Reported-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Tested-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Closes: https://github.com/thesofproject/linux/issues/4934
Signed-off-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Reviewed-by: Bard Liao <yung-chuan.liao@linux.intel.com>
Reviewed-by: Péter Ujfalusi <peter.ujfalusi@linux.intel.com>
Message-ID: <20240426152818.38443-1-pierre-louis.bossart@linux.intel.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/hda/intel-dsp-config.c | 27 +++++++++++++++++++++++++--
 1 file changed, 25 insertions(+), 2 deletions(-)

diff --git a/sound/hda/intel-dsp-config.c b/sound/hda/intel-dsp-config.c
index 6a384b922e4fa..d1f6cdcf1866e 100644
--- a/sound/hda/intel-dsp-config.c
+++ b/sound/hda/intel-dsp-config.c
@@ -557,9 +557,32 @@ static const struct config_entry *snd_intel_dsp_find_config
 		if (table->codec_hid) {
 			int i;
 
-			for (i = 0; i < table->codec_hid->num_codecs; i++)
-				if (acpi_dev_present(table->codec_hid->codecs[i], NULL, -1))
+			for (i = 0; i < table->codec_hid->num_codecs; i++) {
+				struct nhlt_acpi_table *nhlt;
+				bool ssp_found = false;
+
+				if (!acpi_dev_present(table->codec_hid->codecs[i], NULL, -1))
+					continue;
+
+				nhlt = intel_nhlt_init(&pci->dev);
+				if (!nhlt) {
+					dev_warn(&pci->dev, "%s: NHLT table not found, skipped HID %s\n",
+						 __func__, table->codec_hid->codecs[i]);
+					continue;
+				}
+
+				if (intel_nhlt_has_endpoint_type(nhlt, NHLT_LINK_SSP) &&
+				    intel_nhlt_ssp_endpoint_mask(nhlt, NHLT_DEVICE_I2S))
+					ssp_found = true;
+
+				intel_nhlt_free(nhlt);
+
+				if (ssp_found)
 					break;
+
+				dev_warn(&pci->dev, "%s: no valid SSP found for HID %s, skipped\n",
+					 __func__, table->codec_hid->codecs[i]);
+			}
 			if (i == table->codec_hid->num_codecs)
 				continue;
 		}
-- 
2.43.0



