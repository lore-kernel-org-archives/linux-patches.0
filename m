Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 874C62727E2;
	Mon, 18 Aug 2025 13:14:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755522866; cv=none; b=q0LLxkFcD8hHyiRiTP60eWnN7/UCMjWTfoFSmensyEKAgx/upbJc/f0+wEpDqI2a7ft5l92PpfPBC4J1grQjb34K2pUPVC6AycKoQ5hNPQD+keNxOTwLny32+1zM6y/JT0vE9bAbQ0FgowxlMbhlAZh4dGXM6lbQfEJdCEWLg/g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755522866; c=relaxed/simple;
	bh=GSqJirkA2UbnWwwgbSvFgCBbHJV6tV/2zkb19Ot3vbE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Xlxrs1Lm6/+9OBQkq22t60AsvjIX5NRohsA0h9aBqYOl0V9qbZ/feyuNmaXBEN7zk+skuhMLWKqWlMVqFU4ejl+BkzOtI0ffje32i2hFhZsm9wmrd7ob3E4Rym1OMeeMy617tSAA100gHPot/rOHp1wNc5QJv9Vsq6wMsKVhIos=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Rpr1MxNV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Rpr1MxNV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D4F8C4CEEB;
	Mon, 18 Aug 2025 13:14:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755522866;
	bh=GSqJirkA2UbnWwwgbSvFgCBbHJV6tV/2zkb19Ot3vbE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Rpr1MxNVNdJ5WIPjjvLsYO8D+rslHY3rKSFraA0nFSPb/tzp63rScarsMI4OFLEEV
	 MpS0Rz8VDECBjUEp71msqRmIP4P5kBCg4TNKw+rDMLjT6nTKfP1BQWuX3RFCcWYkSY
	 i8wmQfAjDl0fKWFV38UfCa4a6UutF7UqKnIErJpQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	Brian Norris <briannorris@chromium.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 431/444] PCI: Allow PCI bridges to go to D3Hot on all non-x86
Date: Mon, 18 Aug 2025 14:47:37 +0200
Message-ID: <20250818124505.115434121@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124448.879659024@linuxfoundation.org>
References: <20250818124448.879659024@linuxfoundation.org>
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

From: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>

[ Upstream commit a5fb3ff632876d63ee1fc5ed3af2464240145a00 ]

Currently, pci_bridge_d3_possible() encodes a variety of decision factors
when deciding whether a given bridge can be put into D3. A particular one
of note is for "recent enough PCIe ports." Per Rafael [0]:

  "There were hardware issues related to PM on x86 platforms predating
   the introduction of Connected Standby in Windows.  For instance,
   programming a port into D3hot by writing to its PMCSR might cause the
   PCIe link behind it to go down and the only way to revive it was to
   power cycle the Root Complex.  And similar."

Thus, this function contains a DMI-based check for post-2015 BIOS.

The above factors (Windows, x86) don't really apply to non-x86 systems, and
also, many such systems don't have BIOS or DMI. However, we'd like to be
able to suspend bridges on non-x86 systems too.

Restrict the "recent enough" check to x86. If we find further
incompatibilities, it probably makes sense to expand on the deny-list
approach (i.e., bridge_d3_blacklist or similar).

Link: https://lore.kernel.org/r/20250320110604.v6.1.Id0a0e78ab0421b6bce51c4b0b87e6aebdfc69ec7@changeid
Link: https://lore.kernel.org/linux-pci/CAJZ5v0j_6jeMAQ7eFkZBe5Yi+USGzysxAgfemYh=-zq4h5W+Qg@mail.gmail.com/ [0]
Link: https://lore.kernel.org/linux-pci/20240227225442.GA249898@bhelgaas/ [1]
Link: https://lore.kernel.org/linux-pci/20240828210705.GA37859@bhelgaas/ [2]
[Brian: rewrite to !X86 based on Rafael's suggestions]
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Signed-off-by: Brian Norris <briannorris@chromium.org>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Stable-dep-of: 6cff20ce3b92 ("PCI/ACPI: Fix runtime PM ref imbalance on Hot-Plug Capable ports")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pci/pci.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -3024,7 +3024,7 @@ static const struct dmi_system_id bridge
  * @bridge: Bridge to check
  *
  * This function checks if it is possible to move the bridge to D3.
- * Currently we only allow D3 for recent enough PCIe ports and Thunderbolt.
+ * Currently we only allow D3 for some PCIe ports and for Thunderbolt.
  */
 bool pci_bridge_d3_possible(struct pci_dev *bridge)
 {
@@ -3068,10 +3068,10 @@ bool pci_bridge_d3_possible(struct pci_d
 			return false;
 
 		/*
-		 * It should be safe to put PCIe ports from 2015 or newer
-		 * to D3.
+		 * Out of caution, we only allow PCIe ports from 2015 or newer
+		 * into D3 on x86.
 		 */
-		if (dmi_get_bios_year() >= 2015)
+		if (!IS_ENABLED(CONFIG_X86) || dmi_get_bios_year() >= 2015)
 			return true;
 		break;
 	}


