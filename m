Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E6DA125B2;
	Mon,  9 Feb 2026 14:36:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770647765; cv=none; b=R+I68OGMQQ9QSV5x9aqMBGSzGZppMKQYxO9KA7uV95Pn+03rhvnSs94+fc/ImZl7DZMSXsSPgKri8Wo8oKbHcuRCPBKgGPeREOVAt9u/1YOkDnmUpsewNuauzhQkElS+LNanteWp0jZxiO3lI42taMlnsIOB0IOtMr5XD+Quihk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770647765; c=relaxed/simple;
	bh=gg68BC5YUt+6hUYfH/K8+2//7lBEU2RT7RzoT4MVHTM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P7w24WC9OLDLcnENVpJhQGuhecwtd80Yfl4IMtcHtL8rLmJfQfQSNazBAWKTFJtCZSjv2A6Pxod1Outy8exE3xME2LmOK8rZTkmzk4ojRtvECUc5hiNMz2aTFrob6YwsgC7jHl/GQ9oZ9s95HgfL+7DwNgBFqz1QMDuHGnY2Ck8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=T5VDuK3d; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="T5VDuK3d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F042C16AAE;
	Mon,  9 Feb 2026 14:36:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770647764;
	bh=gg68BC5YUt+6hUYfH/K8+2//7lBEU2RT7RzoT4MVHTM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=T5VDuK3dR1VQInlug2qizIUFhxiacrZ+ccaKT3bq2XmJU1k6o0cqBDwMDqnWQwb5N
	 kEpddlOlgaVKDAr3Z2daXluiSf6ueO7x6J3JhDK5rx/ItKpVNkHL1KNEXB0cwrOQBa
	 ZyeVx+yVt1tyz7WCouHnkIliOdktZSgJeshTjt4s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lukas Wunner <lukas@wunner.de>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Riana Tauro <riana.tauro@intel.com>,
	"Rafael J. Wysocki (Intel)" <rafael@kernel.org>,
	Mario Limonciello <mario.limonciello@amd.com>
Subject: [PATCH 6.12 021/113] PCI/ERR: Ensure error recoverability at all times
Date: Mon,  9 Feb 2026 15:22:50 +0100
Message-ID: <20260209142310.971573344@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260209142310.204833231@linuxfoundation.org>
References: <20260209142310.204833231@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -331,6 +331,9 @@ void pci_bus_add_device(struct pci_dev *
 	struct device_node *dn = dev->dev.of_node;
 	int retval;
 
+	/* Save config space for error recoverability */
+	pci_save_state(dev);
+
 	/*
 	 * Can not put in pci_device_add yet because resources
 	 * are not assigned yet for some devices.
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -1939,9 +1939,6 @@ static void pci_restore_rebar_state(stru
  */
 void pci_restore_state(struct pci_dev *dev)
 {
-	if (!dev->state_saved)
-		return;
-
 	pci_restore_pcie_state(dev);
 	pci_restore_pasid_state(dev);
 	pci_restore_pri_state(dev);


