Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BBD5226D0B;
	Mon, 10 Mar 2025 17:22:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741627321; cv=none; b=Fr6FTqW6MxPnF5iAyZQlK0TUEwXqaOM86WEtbWhLut7J14rrhKikBHX4M770ItvkAT5WkUQLLMh1OOw96fe/avAkUikuJzk5QUdYqxWNVR528trRWMIRu4ruMnSjbBq9s9Pu1bChxOtYyT33cD6ZpgvhmIJC/4Ck2Irw3tx9jqY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741627321; c=relaxed/simple;
	bh=rTks+dO1Jd4ZuaS4uV68Y4SM7Lq5jSFwYzfAkr+4o6A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QnOMQEz1R8fXnnRgF8jumxPKhX2XvvaqCex26kVWsaEIcfY39Lpnt5Lhh+sxccpZuj5jRBRGYMJVwLgpiM9222VtKIUV3WhDTIPfVt5XNmWtzD6lNMYY0m/Rly8BdnnzcZzU+kFI/LRmpNAST/KHKOEzp/IUsn3+DfkCbKIids0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Kx61N/Xr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Kx61N/Xr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9621C4CEEC;
	Mon, 10 Mar 2025 17:22:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741627321;
	bh=rTks+dO1Jd4ZuaS4uV68Y4SM7Lq5jSFwYzfAkr+4o6A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Kx61N/XrAHE1MwbpjBFXVtny5EZIeJRSoUSk/zqRX7NHHe7Vlq70buDh2BLCoBBTq
	 hYLNZ888MzveCyXl6Mr6mkJzzhZOHKZvjqmxA6K0RP/wT8ZIXWNZvbDmNZf5zeLDOS
	 SsnHEzDK9U7ibTu6OG2WO5C4AkwHTY1wwZN6JlIg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hoku Ishibe <me@hokuishi.be>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.12 090/269] ALSA: hda: intel: Add Dell ALC3271 to power_save denylist
Date: Mon, 10 Mar 2025 18:04:03 +0100
Message-ID: <20250310170501.301359607@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170457.700086763@linuxfoundation.org>
References: <20250310170457.700086763@linuxfoundation.org>
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
@@ -2242,6 +2242,8 @@ static const struct snd_pci_quirk power_
 	SND_PCI_QUIRK(0x1631, 0xe017, "Packard Bell NEC IMEDIA 5204", 0),
 	/* KONTRON SinglePC may cause a stall at runtime resume */
 	SND_PCI_QUIRK(0x1734, 0x1232, "KONTRON SinglePC", 0),
+	/* Dell ALC3271 */
+	SND_PCI_QUIRK(0x1028, 0x0962, "Dell ALC3271", 0),
 	{}
 };
 


