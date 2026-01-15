Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C71443BF30A;
	Thu, 15 Jan 2026 17:31:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768498300; cv=none; b=Nt2Er3/wN9WxqPpEJUVMdNzJLc44GLKiqAiKPlLpLpu3T2JH1hxK+KSnD3dhuo6EAkH+K2LJ018wzbMf9YeIVwb287b/fRHmk02V64MIyw7JounLjsO6lYtShowANd2cq/2kClEB7uzKpAhlln4qAjsmhSDRBgOibRYqAGdTweg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768498300; c=relaxed/simple;
	bh=2P6ANUOXeMux0uSJgUdxPLJg4pkqbqNpX9WyLx3rHHk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I1D/NSF9VkxIHHj6618k7U4ScZFwd5URGK6fY7tp0yjkrK843bsUTe7z3NZ6aYsoc6U19WTzC6BKwcIefOLC/OS6RKisq++c+dr0RxDjCAjNs/iBYKqZzwmCx0I6f7PunyGgghsGEjmY+gx+pFMeUBGW+n7qcLhrTcIdlsuG0xo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zcA4f99x; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zcA4f99x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 531E6C116D0;
	Thu, 15 Jan 2026 17:31:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768498300;
	bh=2P6ANUOXeMux0uSJgUdxPLJg4pkqbqNpX9WyLx3rHHk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zcA4f99xMo7i0ENvyknvz33uFH7xknWefKySiIqA5DeFy5PrHOTS398Q59P/D236+
	 mEvqu5KXcfQ7EvKfJd0zRDWMGDUvd1QJzsLHXDNu2GZKCKcetQCylT7pROALj9WZer
	 kpbvXI8aKsglUsOxyDzDdvt/e6E0hSpiRyFGXUck=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lukas Wunner <lukas@wunner.de>,
	Bjorn Helgaas <bhelgaas@google.com>,
	"Rafael J. Wysocki (Intel)" <rafael@kernel.org>
Subject: [PATCH 5.15 382/554] PCI/PM: Reinstate clearing state_saved in legacy and !PM codepaths
Date: Thu, 15 Jan 2026 17:47:28 +0100
Message-ID: <20260115164300.064232144@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164246.225995385@linuxfoundation.org>
References: <20260115164246.225995385@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lukas Wunner <lukas@wunner.de>

commit 894f475f88e06c0f352c829849560790dbdedbe5 upstream.

When a PCI device is suspended, it is normally the PCI core's job to save
Config Space and put the device into a low power state.  However drivers
are allowed to assume these responsibilities.  When they do, the PCI core
can tell by looking at the state_saved flag in struct pci_dev:  The flag
is cleared before commencing the suspend sequence and it is set when
pci_save_state() is called.  If the PCI core finds the flag set late in
the suspend sequence, it refrains from calling pci_save_state() itself.

But there are two corner cases where the PCI core neglects to clear the
flag before commencing the suspend sequence:

* If a driver has legacy PCI PM callbacks, pci_legacy_suspend() neglects
  to clear the flag.  The (stale) flag is subsequently queried by
  pci_legacy_suspend() itself and pci_legacy_suspend_late().

* If a device has no driver or its driver has no PCI PM callbacks,
  pci_pm_freeze() neglects to clear the flag.  The (stale) flag is
  subsequently queried by pci_pm_freeze_noirq().

The flag may be set prior to suspend if the device went through error
recovery:  Drivers commonly invoke pci_restore_state() + pci_save_state()
to restore Config Space after reset.

The flag may also be set if drivers call pci_save_state() on probe to
allow for recovery from subsequent errors.

The result is that pci_legacy_suspend_late() and pci_pm_freeze_noirq()
don't call pci_save_state() and so the state that will be restored on
resume is the one recorded on last error recovery or on probe, not the one
that the device had on suspend.  If the two states happen to be identical,
there's no problem.

Reinstate clearing the flag in pci_legacy_suspend() and pci_pm_freeze().
The two functions used to do that until commit 4b77b0a2ba27 ("PCI: Clear
saved_state after the state has been restored") deemed it unnecessary
because it assumed that it's sufficient to clear the flag on resume in
pci_restore_state().  The commit seemingly did not take into account that
pci_save_state() and pci_restore_state() are not only used by power
management code, but also for error recovery.

Devices without driver or whose driver has no PCI PM callbacks may be in
runtime suspend when pci_pm_freeze() is called.  Their state has already
been saved, so don't clear the flag to skip a pointless pci_save_state()
in pci_pm_freeze_noirq().

None of the drivers with legacy PCI PM callbacks seem to use runtime PM,
so clear the flag unconditionally in their case.

Fixes: 4b77b0a2ba27 ("PCI: Clear saved_state after the state has been restored")
Signed-off-by: Lukas Wunner <lukas@wunner.de>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Rafael J. Wysocki (Intel) <rafael@kernel.org>
Cc: stable@vger.kernel.org # v2.6.32+
Link: https://patch.msgid.link/094f2aad64418710daf0940112abe5a0afdc6bce.1763483367.git.lukas@wunner.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pci/pci-driver.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/pci/pci-driver.c
+++ b/drivers/pci/pci-driver.c
@@ -598,6 +598,8 @@ static int pci_legacy_suspend(struct dev
 	struct pci_dev *pci_dev = to_pci_dev(dev);
 	struct pci_driver *drv = pci_dev->driver;
 
+	pci_dev->state_saved = false;
+
 	if (drv && drv->suspend) {
 		pci_power_t prev = pci_dev->current_state;
 		int error;
@@ -999,6 +1001,8 @@ static int pci_pm_freeze(struct device *
 
 	if (!pm) {
 		pci_pm_default_suspend(pci_dev);
+		if (!pm_runtime_suspended(dev))
+			pci_dev->state_saved = false;
 		return 0;
 	}
 


