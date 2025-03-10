Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1343B230BE6;
	Mon, 10 Mar 2025 17:09:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741626541; cv=none; b=lw29o6QHEEK83Wj7/LxXqzzmxpynF00NndrAMSx2wpjlgtkpW6sFSB/MnHZkj/G1F4CVqxBCSHDy3xu12HKRhm8xWPyj8qNj81x5BtRmxtLDDuiib9C88h+Pas80GrvW6wzqsRGAEMyt/0xADSBXsP/8CAjBa8T4PIV+6ds+5qs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741626541; c=relaxed/simple;
	bh=Kyjs2yAshyximXYR0e7167sKqgWakFwjG0ez9syso0c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qOaJjrsli1Wh9LjoyCIOaTWY73O+BNYjoaV1Z3PBAHTfWUPktpXByji2rmSYwhUI76P46DRgc/Mo0Ym5cI6fA+cvjyrRQ1qvRMrTOqUqictzr36GZ2/VYxpzMq2hISdIoOUvBaNlNZethpUw3OVfllRUBVgOf8jj6LjyI98D52g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tYkVQneP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tYkVQneP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DF4DC4CEE5;
	Mon, 10 Mar 2025 17:09:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741626540;
	bh=Kyjs2yAshyximXYR0e7167sKqgWakFwjG0ez9syso0c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tYkVQnePQMTk/CX2y8KB+u3hupxPFbRpQfi+V58H2rd1+vRwouVae3DYw2MqDLmHd
	 TkkFsJBiQy5vT3WzloabG7K5Lik7Nt558x8eDpPY6l5R5PyuMk8WvyhHNJ82QVUGbe
	 Y7flmw65cn3qCVrLH1wKZOFFNPrUWTImwhfu2Ag4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hoku Ishibe <me@hokuishi.be>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.13 027/207] ALSA: hda: intel: Add Dell ALC3271 to power_save denylist
Date: Mon, 10 Mar 2025 18:03:40 +0100
Message-ID: <20250310170448.852098308@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170447.729440535@linuxfoundation.org>
References: <20250310170447.729440535@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hoku Ishibe <me@hokuishi.be>

commit 1ee5aa765c22a0577ec552d460bf2035300b4b51 upstream.

Dell XPS 13 7390 with the Realtek ALC3271 codec experiences
persistent humming noise when the power_save mode is enabled.
This issue occurs when the codec enters power saving mode,
leading to unwanted noise from the speakers.

This patch adds the affected model (PCI ID 0x1028:0x0962) to the
power_save denylist to ensure power_save is disabled by default,
preventing power-off related noise issues.

Steps to Reproduce
1. Boot the system with `snd_hda_intel` loaded.
2. Verify that `power_save` mode is enabled:
```sh
cat /sys/module/snd_hda_intel/parameters/power_save
````
output: 10 (default power save timeout)
3. Wait for the power save timeout
4. Observe a persistent humming noise from the speakers
5. Disable `power_save` manually:
```sh
echo 0 | sudo tee /sys/module/snd_hda_intel/parameters/power_save
````
6. Confirm that the noise disappears immediately.

This issue has been observed on my system, and this patch
successfully eliminates the unwanted noise. If other users
experience similar issues, additional reports would be helpful.

Signed-off-by: Hoku Ishibe <me@hokuishi.be>
Cc: <stable@vger.kernel.org>
Link: https://patch.msgid.link/20250224020517.51035-1-me@hokuishi.be
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/hda_intel.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/sound/pci/hda/hda_intel.c
+++ b/sound/pci/hda/hda_intel.c
@@ -2232,6 +2232,8 @@ static const struct snd_pci_quirk power_
 	SND_PCI_QUIRK(0x1631, 0xe017, "Packard Bell NEC IMEDIA 5204", 0),
 	/* KONTRON SinglePC may cause a stall at runtime resume */
 	SND_PCI_QUIRK(0x1734, 0x1232, "KONTRON SinglePC", 0),
+	/* Dell ALC3271 */
+	SND_PCI_QUIRK(0x1028, 0x0962, "Dell ALC3271", 0),
 	{}
 };
 


