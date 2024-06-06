Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE3CB19750E;
	Thu,  6 Jun 2024 14:12:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683132; cv=none; b=oaxvBnGChJpqfDXEOnzlz4GAK1yhhOuCRnmLeJw82B/9FcMj+9KVImdn4nnqg+4guGovknNAKmqfJmc5mrB0NY15RGRGc1mjn0whPBnGfGvaKoTZEZAmL+5rkO8ytBrI1MeJm1XJ8SFH6+bRH0Xs6ix28qu0KdYFXcsMdGZ7Vfc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683132; c=relaxed/simple;
	bh=DKjxvwpAbOi34PLoBs+/KKHkdpZ0OWfQwWSXucnhxC0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ohjzRfk9kpxCeE2BgNbRJkxUuzZ0uMJBkxDYWgTgw23/o4vj9x6MthX1Kyi3tDCh/uUBGd/qiOl3RiYEXqw1A/SY6tQ8Yvgo0B/NUVSQjoKltLXcbMoHpBQ6iILUkz31OoZiQd4jSUL5DRdPNsLYpQo4Gg/+6BSOQiYviJLUmfA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fDxU1QIN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fDxU1QIN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBB6BC2BD10;
	Thu,  6 Jun 2024 14:12:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683131;
	bh=DKjxvwpAbOi34PLoBs+/KKHkdpZ0OWfQwWSXucnhxC0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fDxU1QINgn/PKcpo4iukRmy/y/ClEESrcu4O3M8MsDLdMrlNNC3FosgBKCKDuW8AH
	 SAwGKysOrtDofnMxwIHlS0lZiePQ/kYISDoisrppLPBQQYjyPkzvNIMUEQeUE8Soc/
	 bTNC0V4PoPACKopSwtH8ScjFJ2bSaGB/MJ6S36Lo=
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
Subject: [PATCH 6.6 075/744] ALSA: hda: intel-dsp-config: harden I2C/I2S codec detection
Date: Thu,  6 Jun 2024 15:55:47 +0200
Message-ID: <20240606131734.804175499@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

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



