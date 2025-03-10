Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABBD42253FE;
	Mon, 10 Mar 2025 17:34:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741628042; cv=none; b=oxm/8cQBWUfqRHZpWPCy/nIP0trBsAfu6kMkVTOEgVlSPPvYJCf9VETxUXxUFkqJ3JH3lHNgejZxg2RPN9vR5mV+fBrii7mEnX+BUVasw7pEWLGRPVRUHnogU3awZyOLMFplt2r9FBi7RvBk4XCLfOFwejCwzJA5m/z4MSA968o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741628042; c=relaxed/simple;
	bh=ArRubSPPYm4NSamvtpy6vMv1xVjMC88UKQ4NqsbrDTU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tOrLsEMrSkujPQGA6N97p6WVGdbwrchPyLUns8UaFFFz1R+9xTXcQysjWbmY23caFjf4Arf6dPlDsJJLwnNYCYyTuID0zUrNh8tP3TjlEj0oUV8CEBnKxbM6mxFHdZPahUUy2z7D4FtAg3xHwtOZR5DwGbRj2SFe0UG27OLIVUY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RIY2vY9l; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RIY2vY9l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6A13C4CEE5;
	Mon, 10 Mar 2025 17:34:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741628042;
	bh=ArRubSPPYm4NSamvtpy6vMv1xVjMC88UKQ4NqsbrDTU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RIY2vY9l+ShG6LoMBE7mUDNx9zI2urzumXDEe9ykar/nf6OIXaIy70W8nGSy4KZUZ
	 yHlP9MMBp+gX9ibM0MXHk3UG+URKul3dBWo7usLfCdGaGZls8lyG1Q/q2C+u13HAn1
	 h9ZdgS7L8QqnCS3qcM6psxKjYHg+ipSwxsAnAngc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hoku Ishibe <me@hokuishi.be>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.6 036/145] ALSA: hda: intel: Add Dell ALC3271 to power_save denylist
Date: Mon, 10 Mar 2025 18:05:30 +0100
Message-ID: <20250310170436.188003384@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170434.733307314@linuxfoundation.org>
References: <20250310170434.733307314@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2222,6 +2222,8 @@ static const struct snd_pci_quirk power_
 	SND_PCI_QUIRK(0x1631, 0xe017, "Packard Bell NEC IMEDIA 5204", 0),
 	/* KONTRON SinglePC may cause a stall at runtime resume */
 	SND_PCI_QUIRK(0x1734, 0x1232, "KONTRON SinglePC", 0),
+	/* Dell ALC3271 */
+	SND_PCI_QUIRK(0x1028, 0x0962, "Dell ALC3271", 0),
 	{}
 };
 #endif /* CONFIG_PM */


