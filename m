Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8F8F27B353;
	Sat, 14 Feb 2026 21:25:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771104327; cv=none; b=nYMSVU4aT5g9o/vBaWhVrg3TyVeNZOxl1N2lB3K78H8NaLENR+DvM8BfqAb2Vs39UBy85cblNK6zeuNxt9wGeyQ4HL492VR4Fy6JcPQTwTMLLdRHsYhBC0auq+PCvirWjGi8HpBedixO4p4xhuj/PnWk0MytpdB5LeNPYAYthVw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771104327; c=relaxed/simple;
	bh=7awT1Li4DxKat07UYtWiH20wtPbjOrZkWejQapyOazc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=jSNc7XVd5n9BnxP74cUmA4muotT+OKCplRfJ2I/fmjO7FCAhHWDfVzLjvjFMsI98eJRqpHRa5s3uL6J0xV4Hqs4i08KxikTg4mm0yQTNZJYMSSfVW4dpn4PLa2nL9G8wDWbZp2YXVXu8VP81SPkhclaSk9yky1001dAeFO+e6vw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=c9JtTOtr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="c9JtTOtr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EAA6CC16AAE;
	Sat, 14 Feb 2026 21:25:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771104327;
	bh=7awT1Li4DxKat07UYtWiH20wtPbjOrZkWejQapyOazc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=c9JtTOtrxOKjZZuxt4OfvFbMvgYPAnYc6owLu24UMHWZYilvQTQlYVcJHgTJss0Uj
	 eWkuAEZYpkRy4lhkYUuLUUiCuD2dseSfRfiDfWTZaJ4YlQnlVzvryJlmix1o83uKF2
	 JILkPXpzHuOc1VPrgRIaz6qERzhU1wSMZ9m1GcPNW5B76plOCZx85K0s3llMiHVDbT
	 en16GgXbHz9XKp8/O/JnRqaTT5nTWUE+S1HCKafasC+SydjMdxQ8vwvJtLHtUOUzHA
	 6pM+c0gYf9Y+YlQN+XjU50Q8E3BijhPJM0sbHBiJMYetWCI5JIJlH0lORCHZaU2lgH
	 pgEhDW1Ed1PbA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: =?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Adam Stylinski <kungfujesus06@gmail.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Sasha Levin <sashal@kernel.org>,
	linux-pci@vger.kernel.org
Subject: [PATCH AUTOSEL 6.19-6.18] PCI/bwctrl: Disable BW controller on Intel P45 using a quirk
Date: Sat, 14 Feb 2026 16:22:44 -0500
Message-ID: <20260214212452.782265-19-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260214212452.782265-1-sashal@kernel.org>
References: <20260214212452.782265-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.19
Content-Transfer-Encoding: 8bit

From: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>

[ Upstream commit 46a9f70e93ef73860d1dbbec75ef840031f8f30a ]

The commit 665745f27487 ("PCI/bwctrl: Re-add BW notification portdrv as
PCIe BW controller") was found to lead to a boot hang on a Intel P45
system. Testing without setting Link Bandwidth Management Interrupt Enable
(LBMIE) and Link Autonomous Bandwidth Interrupt Enable (LABIE) (PCIe r7.0,
sec 7.5.3.7) in bwctrl allowed system to come up.

P45 is a very old chipset and supports only up to gen2 PCIe, so not having
bwctrl does not seem a huge deficiency.

Add no_bw_notif in struct pci_dev and quirk Intel P45 Root Port with it.

Reported-by: Adam Stylinski <kungfujesus06@gmail.com>
Link: https://lore.kernel.org/linux-pci/aUCt1tHhm_-XIVvi@eggsbenedict/
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Tested-by: Adam Stylinski <kungfujesus06@gmail.com>
Link: https://patch.msgid.link/20260116131513.2359-1-ilpo.jarvinen@linux.intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

The offending commit `665745f274870` first appeared in **v6.13-rc1**,
meaning it's present in **6.13.y** stable trees and newer. This means
the boot hang regression affects stable kernel users on 6.13.y and
later.

### 6. User Impact

- **Severity**: CRITICAL — complete boot hang (system is unusable)
- **Affected hardware**: Intel P45 chipset systems (older but still in
  use)
- **Affected versions**: v6.13 and later (wherever bwctrl was
  introduced)
- **Users impacted**: Anyone running an Intel P45 system who upgrades to
  6.13+

### 7. Risk vs. Benefit

**Benefit**: Fixes a boot hang on Intel P45 systems — without this
quirk, these systems cannot boot kernels 6.13+.

**Risk**: Essentially zero. The quirk only fires for one specific PCI
device ID (0x2e21). The probe check returns -ENODEV before any resources
are allocated. This follows a well-established PCI quirk pattern used
hundreds of times in the kernel. The only "loss" is BW notification on a
Gen2 PCIe chipset, which is of negligible value.

### 8. Backport Considerations

The fix should apply cleanly to any tree that has the bwctrl code
(6.13+). The `no_bw_notif` bit field addition to `struct pci_dev` is
straightforward. The quirk file change is a simple addition. The
bwctrl.c check is at the top of the probe function.

One minor consideration: the `pci_dev` struct layout might differ
slightly between stable versions, but adding a bitfield member to the
existing bitfield group should be safe.

### Summary

This is a textbook stable backport candidate:
- **Fixes a real, user-reported boot hang** (critical regression)
- **Hardware quirk** (explicitly allowed in stable)
- **Small, surgical fix** (~15 lines)
- **Near-zero regression risk** (only affects one device ID)
- **Tested by the reporter** (confirmed working)
- **Written and reviewed by subsystem experts** (Intel engineer + PCI
  maintainer)
- **Fixes a regression introduced in 6.13** (affects stable users)

**YES**

 drivers/pci/pcie/bwctrl.c |  3 +++
 drivers/pci/quirks.c      | 10 ++++++++++
 include/linux/pci.h       |  1 +
 3 files changed, 14 insertions(+)

diff --git a/drivers/pci/pcie/bwctrl.c b/drivers/pci/pcie/bwctrl.c
index 36f939f23d34e..4ae92c9f912a8 100644
--- a/drivers/pci/pcie/bwctrl.c
+++ b/drivers/pci/pcie/bwctrl.c
@@ -250,6 +250,9 @@ static int pcie_bwnotif_probe(struct pcie_device *srv)
 	struct pci_dev *port = srv->port;
 	int ret;
 
+	if (port->no_bw_notif)
+		return -ENODEV;
+
 	/* Can happen if we run out of bus numbers during enumeration. */
 	if (!port->subordinate)
 		return -ENODEV;
diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
index 5782dfb863cad..5cf84ec1cdb2d 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -1359,6 +1359,16 @@ static void quirk_transparent_bridge(struct pci_dev *dev)
 DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL,	PCI_DEVICE_ID_INTEL_82380FB,	quirk_transparent_bridge);
 DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_TOSHIBA,	0x605,	quirk_transparent_bridge);
 
+/*
+ * Enabling Link Bandwidth Management Interrupts (BW notifications) can cause
+ * boot hangs on P45.
+ */
+static void quirk_p45_bw_notifications(struct pci_dev *dev)
+{
+	dev->no_bw_notif = 1;
+}
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, 0x2e21, quirk_p45_bw_notifications);
+
 /*
  * Common misconfiguration of the MediaGX/Geode PCI master that will reduce
  * PCI bandwidth from 70MB/s to 25MB/s.  See the GXM/GXLV/GX1 datasheets
diff --git a/include/linux/pci.h b/include/linux/pci.h
index b5cc0c2b99065..e958ff7443356 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -406,6 +406,7 @@ struct pci_dev {
 						      user sysfs */
 	unsigned int	clear_retrain_link:1;	/* Need to clear Retrain Link
 						   bit manually */
+	unsigned int	no_bw_notif:1;	/* BW notifications may cause issues */
 	unsigned int	d3hot_delay;	/* D3hot->D0 transition time in ms */
 	unsigned int	d3cold_delay;	/* D3cold->D0 transition time in ms */
 
-- 
2.51.0

