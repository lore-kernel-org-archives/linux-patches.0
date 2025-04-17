Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6D59257426;
	Thu, 17 Apr 2025 18:41:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744915264; cv=none; b=RZr/Kp6J4IpV5iotS8naUzgWa6IqW4B0vw8IGtjGUoWsyG9Vi+fS0E+U+r8Q48PygAeHmBtKKwRMxrNSRK4r84OljUJgsNsdfP58UO507/n8U1k7IA1a8cLTq0bRrNekFWVqU/7H9Y0jWrqfiztUGQdejSr4b5HXYjHJWXwXDF0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744915264; c=relaxed/simple;
	bh=0Mxn+8Y8QWcJXiV4mzsjR1Na0uDDSwugEx2F9UIRf08=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e26u1pWdEjg9onI9rqXiFHrV/IyMUyNb7jvCKzbcTME1UsDxhyseAyf7dfERKISFjn1OyjW8/JSwSJhz7hvvcpe51C8TSEP711xYKNfmRVQFjCJsoSzRIgOBONEN6P8B0M1Re6MwjI5qVDsNUSs0PdRHquFYY2UBvWB11bFyaYA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tBSNDs12; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tBSNDs12"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BAEECC4CEE4;
	Thu, 17 Apr 2025 18:41:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744915264;
	bh=0Mxn+8Y8QWcJXiV4mzsjR1Na0uDDSwugEx2F9UIRf08=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tBSNDs12ZyTBY+jonb18p59/jFOl+F7FGMLDJkOvf7Jp5m3mTgJxWfLVpNFUvL378
	 4bz+PykGdl3kVq3ZaPE9IpDrqfUdOCQpPebnYallu3GjzFqOM9aA/V/s1nUUguL3tf
	 MchunlgpRgqjvojMY8lCz79U5JnNbjWEZjV84MoU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maxim Mikityanskiy <maxtram95@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 072/393] ALSA: hda: intel: Fix Optimus when GPU has no sound
Date: Thu, 17 Apr 2025 19:48:01 +0200
Message-ID: <20250417175110.490397719@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175107.546547190@linuxfoundation.org>
References: <20250417175107.546547190@linuxfoundation.org>
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

From: Maxim Mikityanskiy <maxtram95@gmail.com>

[ Upstream commit 2b360ba9a4936486380bc30d1eabceb40a714d98 ]

quirk_nvidia_hda() forcefully enables HDA controller on all NVIDIA GPUs,
because some buggy BIOSes leave it disabled. However, some dual-GPU
laptops do not have a functional HDA controller in DGPU, and BIOS
disables it on purpose. After quirk_nvidia_hda() reenables this dummy
HDA controller, attempting to probe it fails at azx_first_init(), which
is too late to cancel the probe, as it happens in azx_probe_continue().

The sna_hda_intel driver calls azx_free() and stops the chip, however,
it stays probed, and from the runtime PM point of view, the device
remains active (it was set as active by the PCI subsystem on probe). It
prevents vga_switcheroo from turning off the DGPU, because
pci_create_device_link() syncs power management for video and audio
devices.

Affected devices should be added to driver_denylist to prevent them from
probing early. This patch helps identify such devices by printing a
warning, and also forces the device to the suspended state to allow
vga_switcheroo turn off DGPU.

Signed-off-by: Maxim Mikityanskiy <maxtram95@gmail.com>
Link: https://patch.msgid.link/20250208214602.39607-2-maxtram95@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/hda_intel.c | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/sound/pci/hda/hda_intel.c b/sound/pci/hda/hda_intel.c
index cb9925948175f..b511563bbb6ba 100644
--- a/sound/pci/hda/hda_intel.c
+++ b/sound/pci/hda/hda_intel.c
@@ -1360,8 +1360,21 @@ static void azx_free(struct azx *chip)
 	if (use_vga_switcheroo(hda)) {
 		if (chip->disabled && hda->probe_continued)
 			snd_hda_unlock_devices(&chip->bus);
-		if (hda->vga_switcheroo_registered)
+		if (hda->vga_switcheroo_registered) {
 			vga_switcheroo_unregister_client(chip->pci);
+
+			/* Some GPUs don't have sound, and azx_first_init fails,
+			 * leaving the device probed but non-functional. As long
+			 * as it's probed, the PCI subsystem keeps its runtime
+			 * PM status as active. Force it to suspended (as we
+			 * actually stop the chip) to allow GPU to suspend via
+			 * vga_switcheroo, and print a warning.
+			 */
+			dev_warn(&pci->dev, "GPU sound probed, but not operational: please add a quirk to driver_denylist\n");
+			pm_runtime_disable(&pci->dev);
+			pm_runtime_set_suspended(&pci->dev);
+			pm_runtime_enable(&pci->dev);
+		}
 	}
 
 	if (bus->chip_init) {
-- 
2.39.5



