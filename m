Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37B031EF38C;
	Tue, 12 Aug 2025 18:24:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755023100; cv=none; b=Z4qwH2emK15moWc+5s5E0AB4H6bY5uVrlBVL2Q7YsL1MYfhoQe2tWdUXZfnfIRQGpJNR8mArpnEa85jUVzKzd16j+AWTOFCTSgfDRMCO2SUSBxEB9n49WVK8/6oBjRDvUasvGrBm79QSYG7zN2XFXzZLi9WzG8we5aAJY8CcYik=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755023100; c=relaxed/simple;
	bh=F5wrTzgbny7VIDf9kbY7m6BcHqEcqvk7PzEIv7RA/VM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=bEXtN+IENZuW0ViSUZRJo00tMzHZCJ01Z23NuHrHpHM8c2EPxym0s/72CygMVWA45pq/Hop0/jLd2Z0QMF7MsP/v2mlBjw//odb8Nc7NEBfhPn3NLk/yewMwfZgaXlDj25BNteCY8eHN8BpjIe473XXVWfCpJMnz32ZeK/YTM+0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qAHcl82O; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qAHcl82O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C81FC4CEF0;
	Tue, 12 Aug 2025 18:24:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755023099;
	bh=F5wrTzgbny7VIDf9kbY7m6BcHqEcqvk7PzEIv7RA/VM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qAHcl82O0jtiD6TssWUVEBa1fIc2ekha5nv8fFBVd8hls9rf539/BXD2oaYOyN2B0
	 eiW7vHa54txgYeA2jdynkJRrglF+KbT2laSSdCT3ycFbr3AQaCLA8dnrCzZ8wd8z53
	 Vtxm1oWIK96xiSlPm5phZx+bSSaCMFvPNgcu2B7k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Nikl=C4=81vs=20Ko=C4=BCes=C5=86ikovs?= <pinkflames.linux@gmail.com>,
	Paul Menzel <pmenzel@molgen.mpg.de>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Brian Norris <briannorris@chromium.org>
Subject: [PATCH 6.12 348/369] PCI/ASPM: Fix L1SS saving
Date: Tue, 12 Aug 2025 19:30:45 +0200
Message-ID: <20250812173029.786603557@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173014.736537091@linuxfoundation.org>
References: <20250812173014.736537091@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>

commit 7507eb3e7bfac7c3baef8dd377fdf5871eefd42b upstream.

Commit 1db806ec06b7 ("PCI/ASPM: Save parent L1SS config in
pci_save_aspm_l1ss_state()") aimed to perform L1SS config save for both the
Upstream Port and its upstream bridge when handling an Upstream Port, which
matches what the L1SS restore side does. However, parent->state_saved can
be set true at an earlier time when the upstream bridge saved other parts
of its state. Then later when attempting to save the L1SS config while
handling the Upstream Port, parent->state_saved is true in
pci_save_aspm_l1ss_state() resulting in early return and skipping saving
bridge's L1SS config because it is assumed to be already saved. Later on
restore, junk is written into L1SS config which causes issues with some
devices.

Remove parent->state_saved check and unconditionally save L1SS config also
for the upstream bridge from an Upstream Port which ought to be harmless
from correctness point of view. With the Upstream Port check now present,
saving the L1SS config more than once for the bridge is no longer a problem
(unlike when the parent->state_saved check got introduced into the fix
during its development).

Link: https://lore.kernel.org/r/20250131152913.2507-1-ilpo.jarvinen@linux.intel.com
Fixes: 1db806ec06b7 ("PCI/ASPM: Save parent L1SS config in pci_save_aspm_l1ss_state()")
Closes: https://bugzilla.kernel.org/show_bug.cgi?id=219731
Reported-by: Niklāvs Koļesņikovs <pinkflames.linux@gmail.com>
Reported by: Rafael J. Wysocki <rafael@kernel.org>
Closes: https://lore.kernel.org/r/CAJZ5v0iKmynOQ5vKSQbg1J_FmavwZE-nRONovOZ0mpMVauheWg@mail.gmail.com
Reported-by: Paul Menzel <pmenzel@molgen.mpg.de>
Closes: https://lore.kernel.org/r/d7246feb-4f3f-4d0c-bb64-89566b170671@molgen.mpg.de
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Tested-by: Niklāvs Koļesņikovs <pinkflames.linux@gmail.com>
Tested-by: Paul Menzel <pmenzel@molgen.mpg.de> # Dell XPS 13 9360
Cc: Brian Norris <briannorris@chromium.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pci/pcie/aspm.c |    3 ---
 1 file changed, 3 deletions(-)

--- a/drivers/pci/pcie/aspm.c
+++ b/drivers/pci/pcie/aspm.c
@@ -108,9 +108,6 @@ void pci_save_aspm_l1ss_state(struct pci
 	pci_read_config_dword(pdev, pdev->l1ss + PCI_L1SS_CTL2, cap++);
 	pci_read_config_dword(pdev, pdev->l1ss + PCI_L1SS_CTL1, cap++);
 
-	if (parent->state_saved)
-		return;
-
 	/*
 	 * Save parent's L1 substate configuration so we have it for
 	 * pci_restore_aspm_l1ss_state(pdev) to restore.


