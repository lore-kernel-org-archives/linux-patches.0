Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77C8335CB6B;
	Mon,  9 Feb 2026 14:27:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770647226; cv=none; b=pvx3JbpXP8SVIlc32ti3Qqct+qKbJubsAxn2GK8st8sIyQq2QtNPu1qjSfHRE9Ve5SNhHp7cbr3BayU+KH/puiOZo117aRtycm9iCBwSqKe7EB7k5wFv8HIWkeVs9E/FcSjf9KvzsVJSEU5yO4ThvQcsnoEQt1qBAOzT95VcEIs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770647226; c=relaxed/simple;
	bh=/XrqNSMGcct946JKmA/B9rA95hX6ccrsCYmFD8bjycA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NNcUlYR/ggQGa+CfEKDxACgsyM5vg6J0Lp1n4hzeibGzct4AGDY/Laq7Liz49yjveTsaPJ1tpTy7AQpfRzHytNxWJuszBOnLbhEUvewg54+egsEJS+IvG94/Rj0aaZ43RBNEpHIrcJxDRWVhVMY4hiy0GiT/2T4JoGEsCDlgPQE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DOW2hDBW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DOW2hDBW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89849C116C6;
	Mon,  9 Feb 2026 14:27:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770647226;
	bh=/XrqNSMGcct946JKmA/B9rA95hX6ccrsCYmFD8bjycA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DOW2hDBWeDwEWjfjD9N3LAcz2gs5CMaxYUMG+RguLYcq9WnhJ2uEGVdOJDHQWKeWf
	 wFXmQZ2XkqmmoMDkqh+ecbtrIqTNJ22RZNZ8ks0ISMKjDcFBCZDGlpbPaCkH2eOFaP
	 AXf2PtLVvC+TYfSCDF7YT/QZIFyYsz6RQ9AmECzM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lukas Wunner <lukas@wunner.de>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Riana Tauro <riana.tauro@intel.com>,
	"Rafael J. Wysocki (Intel)" <rafael@kernel.org>,
	Mario Limonciello <mario.limonciello@amd.com>
Subject: [PATCH 6.18 036/175] PCI/ERR: Ensure error recoverability at all times
Date: Mon,  9 Feb 2026 15:21:49 +0100
Message-ID: <20260209142321.772571849@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260209142320.474120190@linuxfoundation.org>
References: <20260209142320.474120190@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lukas Wunner <lukas@wunner.de>

commit a2f1e22390ac2ca7ac8d77aa0f78c068b6dd2208 upstream.

When the PCI core gained power management support in 2002, it introduced
pci_save_state() and pci_restore_state() helpers to restore Config Space
after a D3hot or D3cold transition, which implies a Soft or Fundamental
Reset (PCIe r7.0 sec 5.8):

  https://git.kernel.org/tglx/history/c/a5287abe398b

In 2006, EEH and AER were introduced to recover from errors by performing
a reset.  Because errors can occur at any time, drivers began calling
pci_save_state() on probe to ensure recoverability.

In 2009, recoverability was foiled by commit c82f63e411f1 ("PCI: check
saved state before restore"):  It amended pci_restore_state() to bail out
if the "state_saved" flag has been cleared.  The flag is cleared by
pci_restore_state() itself, hence a saved state is now allowed to be
restored only once and is then invalidated.  That doesn't seem to make
sense because the saved state should be good enough to be reused.

Soon after, drivers began to work around this behavior by calling
pci_save_state() immediately after pci_restore_state(), see e.g. commit
b94f2d775a71 ("igb: call pci_save_state after pci_restore_state").
Hilariously, two drivers even set the "saved_state" flag to true before
invoking pci_restore_state(), see ipr_reset_restore_cfg_space() and
e1000_io_slot_reset().

Despite these workarounds, recoverability at all times is not guaranteed:
E.g. when a PCIe port goes through a runtime suspend and resume cycle,
the "saved_state" flag is cleared by:

  pci_pm_runtime_resume()
    pci_pm_default_resume_early()
      pci_restore_state()

... and hence on a subsequent AER event, the port's Config Space cannot be
restored.  Riana reports a recovery failure of a GPU-integrated PCIe
switch and has root-caused it to the behavior of pci_restore_state().
Another workaround would be necessary, namely calling pci_save_state() in
pcie_port_device_runtime_resume().

The motivation of commit c82f63e411f1 was to prevent restoring state if
pci_save_state() hasn't been called before.  But that can be achieved by
saving state already on device addition, after Config Space has been
initialized.  A desirable side effect is that devices become recoverable
even if no driver gets bound.  This renders the commit unnecessary, so
revert it.

Reported-by: Riana Tauro <riana.tauro@intel.com> # off-list
Signed-off-by: Lukas Wunner <lukas@wunner.de>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Tested-by: Riana Tauro <riana.tauro@intel.com>
Reviewed-by: Rafael J. Wysocki (Intel) <rafael@kernel.org>
Link: https://patch.msgid.link/9e34ce61c5404e99ffdd29205122c6fb334b38aa.1763483367.git.lukas@wunner.de
Cc: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pci/bus.c |    3 +++
 drivers/pci/pci.c |    3 ---
 2 files changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/pci/bus.c
+++ b/drivers/pci/bus.c
@@ -357,6 +357,9 @@ void pci_bus_add_device(struct pci_dev *
 	pci_proc_attach_device(dev);
 	pci_bridge_d3_update(dev);
 
+	/* Save config space for error recoverability */
+	pci_save_state(dev);
+
 	/*
 	 * If the PCI device is associated with a pwrctrl device with a
 	 * power supply, create a device link between the PCI device and
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -1855,9 +1855,6 @@ static void pci_restore_rebar_state(stru
  */
 void pci_restore_state(struct pci_dev *dev)
 {
-	if (!dev->state_saved)
-		return;
-
 	pci_restore_pcie_state(dev);
 	pci_restore_pasid_state(dev);
 	pci_restore_pri_state(dev);


