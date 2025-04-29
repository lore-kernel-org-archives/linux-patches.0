Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0774D1917E3;
	Tue, 29 Apr 2025 17:41:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745948479; cv=none; b=YGXihiBYuergoiXS7i0JoHWPJi3vhp6UXaOGjfr4W8ciLoy48RhpDiCl5C811XHAaYMCmZd5xQvFQoesEaLrZ+pRKXfs6zBu4scZXRNTJBEZLnyHUyuIwTP+gjSGGev5uwKkwnJrIOlGzkTug1hBt5FK2PlrXJfUgtqJ9VRuZHs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745948479; c=relaxed/simple;
	bh=gEegFWm8O/nXVTyKtbqSQkcVl3bRrPqsT831fIcCwpo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gNJ4z57eXO06C/qxJkO567LTF7scQlR0dhL6QCLVUIKzKDUix09/9Bf5xQnHBn77bskbqArVEmV/R50lxKwo5WmqxSkeYXbKlIwb4ZYMzptWKstANzK9FIMdhoma7ybjBacAu0Oexo73SYGG797eyi+pUOr063Lx3MlNJCoyTPo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jTgxYACE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jTgxYACE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8945AC4CEE3;
	Tue, 29 Apr 2025 17:41:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745948478;
	bh=gEegFWm8O/nXVTyKtbqSQkcVl3bRrPqsT831fIcCwpo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jTgxYACE8lfUKB2rzZ2AW0+jeTQFI3C6xR/i6aki1DgCatJHITe99hqsk4RoVf1x4
	 44xKx7BGY6titLVhf9OvYmCABK1HFGHBLGYeDPYeur+yP2cbzX8q0jlAteU8K5nYHq
	 PWfYz+q+eihmwsGNtYUlhR7rUgQ9VlGyOyiUlhmM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maxim Mikityanskiy <maxtram95@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 020/373] ALSA: hda: intel: Fix Optimus when GPU has no sound
Date: Tue, 29 Apr 2025 18:38:17 +0200
Message-ID: <20250429161123.963932347@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161123.119104857@linuxfoundation.org>
References: <20250429161123.119104857@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 16c7fbb84276a..5f0e7765b8bd6 100644
--- a/sound/pci/hda/hda_intel.c
+++ b/sound/pci/hda/hda_intel.c
@@ -1365,8 +1365,21 @@ static void azx_free(struct azx *chip)
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



