Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CE0727FD7A;
	Wed, 23 Apr 2025 14:57:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745420240; cv=none; b=IZ0ew2s6/Ev08HTD6z0as+SBmi7dmvlgUtxhOGoZJ1PNYdEo5ArNoDrkFJICDdAkyvwX4oOKq71e0Xeq+Ecm7YWpfo7mLM7JKrrqxzmCrDHCcum0je3Q6X+87f4bXqbUqAiEI0PNlYFm8K14yxlULYnfdhdSDQ/a6jYEBzvWvZI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745420240; c=relaxed/simple;
	bh=JnotzXJiWIPpzFcw8ibDtxXOP07PmuUzqgYmjNpFRa4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iY5KVyqJr8bl7UAZrGKIKAFZyfusHdr88LjcCKv3ddZGQruVbDZ4cB6o5GtMVD+OsB/UJE6pvCtRKG+refLTHxNfSOXmIjYhT14ZOX81BddLd2kBqLQySz58CP143Ezy/mSBXXuLxOvJ9Aso4KgELUF1NGHpFVbkqLQ+853ofUo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rUj4aJ2a; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rUj4aJ2a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54119C4CEEB;
	Wed, 23 Apr 2025 14:57:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745420236;
	bh=JnotzXJiWIPpzFcw8ibDtxXOP07PmuUzqgYmjNpFRa4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rUj4aJ2aV2Mvt2zBeaSS/Q+u3By5PlLTBioTQF4/pe+upHW63fDmfylVRVIu7vWhv
	 wQrYD9aC/YHvhR186AiWvRP5YybvwSpYeXeowq6AQZkqB99rcdsZ/KO8xaBHZdOmq6
	 etv+yNuSB1bPePT/ofSMCFdc16PGgAPM8wy2oeWE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maxim Mikityanskiy <maxtram95@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 029/291] ALSA: hda: intel: Fix Optimus when GPU has no sound
Date: Wed, 23 Apr 2025 16:40:18 +0200
Message-ID: <20250423142625.590196141@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142624.409452181@linuxfoundation.org>
References: <20250423142624.409452181@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 56ee7708f6c49..7d0b12aab886f 100644
--- a/sound/pci/hda/hda_intel.c
+++ b/sound/pci/hda/hda_intel.c
@@ -1366,8 +1366,21 @@ static void azx_free(struct azx *chip)
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



