Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8BDF299931;
	Sat, 14 Feb 2026 21:26:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771104379; cv=none; b=o96Q4VL4f13adSGklo+qmz7Pf4sQUmpNBuY6/t7Q4qBNOK8nMkqFCLYSoPKuEWvbj5CD/1gT/frBQt+p0AF0mNgOQgKNwCaj515DVF/Lu3B08zPnBC2bIsRP3kAquwG1aHSdo+ShB854jlni6Cwkg2FvYSJM6ZzQ6NLc6o30cCM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771104379; c=relaxed/simple;
	bh=yvaIk8C/stOejqPYYeijZfAu+PYjAATRUsgqrhgm224=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=iaRhz7L9skS3WzYK2WCZGLrzMI43IJ1NeLDGJ/54Lf5utHypMNevqW9Kgyx+tiS0yzZqBLQQqPqRG3OpdBAtXdo9yE/pCmqpC+ofnlHw155GbIQcFDFE1RVfISheolV6dy/OTl0LEwVeEn4kdqlRAK6pvDkee+1KXe+BMg+nRwA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LLHJ/SDm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LLHJ/SDm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7CA3C16AAE;
	Sat, 14 Feb 2026 21:26:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771104379;
	bh=yvaIk8C/stOejqPYYeijZfAu+PYjAATRUsgqrhgm224=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LLHJ/SDmux4vUwUwbuTsotvpu2LL28YHR6MuWkZHlgL+sT84yQp91FxpsD5wytZPO
	 wrrFL+0EqsynbdM8Agt60o3Pt1ztJgtzaFGnDVEowucvv7iztXzz7jO4SJUuHyvFdj
	 jwkzIvwD1SDJcvs5jjrRNx03ZV3zerpN8fYSdIOwauUlejw1QKqgd5k67VwV9pUT/f
	 5R5SsIA9H/m/mpLFdGDVrcJyqhu4Qw4m8JLcab2iN5ZcfbM1/8QmC7fmkNkYNjRvd/
	 Wmo7aJztAwr29jj6HeC85M/SEgCINAtomYk/ZnW4Bxg+f8aMZ1FjmohiL7vOA3sqis
	 Cb5zqhMNFJerQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Lukas Wunner <lukas@wunner.de>,
	Lucas Van <lucas.van@intel.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>,
	mahesh@linux.ibm.com,
	linuxppc-dev@lists.ozlabs.org
Subject: [PATCH AUTOSEL 6.19-5.15] PCI/AER: Clear stale errors on reporting agents upon probe
Date: Sat, 14 Feb 2026 16:23:18 -0500
Message-ID: <20260214212452.782265-53-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260214212452.782265-1-sashal@kernel.org>
References: <20260214212452.782265-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.19
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Lukas Wunner <lukas@wunner.de>

[ Upstream commit e242d09b58e869f86071b7889acace4cff215935 ]

Correctable and Uncorrectable Error Status Registers on reporting agents
are cleared upon PCI device enumeration in pci_aer_init() to flush past
events.  They're cleared again when an error is handled by the AER driver.

If an agent reports a new error after pci_aer_init() and before the AER
driver has probed on the corresponding Root Port or Root Complex Event
Collector, that error is not handled by the AER driver:  It clears the
Root Error Status Register on probe, but neglects to re-clear the
Correctable and Uncorrectable Error Status Registers on reporting agents.

The error will eventually be reported when another error occurs.  Which
is irritating because to an end user it appears as if the earlier error
has just happened.

Amend the AER driver to clear stale errors on reporting agents upon probe.

Skip reporting agents which have not invoked pci_aer_init() yet to avoid
using an uninitialized pdev->aer_cap.  They're recognizable by the error
bits in the Device Control register still being clear.

Reporting agents may execute pci_aer_init() after the AER driver has
probed, particularly when devices are hotplugged or removed/rescanned via
sysfs.  For this reason, it continues to be necessary that pci_aer_init()
clears Correctable and Uncorrectable Error Status Registers.

Reported-by: Lucas Van <lucas.van@intel.com> # off-list
Signed-off-by: Lukas Wunner <lukas@wunner.de>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Tested-by: Lucas Van <lucas.van@intel.com>
Reviewed-by: Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>
Link: https://patch.msgid.link/3011c2ed30c11f858e35e29939add754adea7478.1769332702.git.lukas@wunner.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

### 3. Classification

This is a **bug fix** — it addresses stale error reporting in the PCI
AER subsystem. The issue is that errors that occur in a specific timing
window (between `pci_aer_init()` and AER driver probe) are not properly
cleared, causing misleading error reports to users later.

**Nature of the bug**: Not a crash or security issue, but a functional
correctness issue. Stale PCIe AER errors are reported at the wrong time,
confusing users and potentially causing unnecessary troubleshooting or
even unnecessary hardware replacements.

### 4. Scope and Risk Assessment

**Changes**:
- **New function**: `clear_status_iter()` (~12 lines) — a simple
  callback that checks `PCI_EXP_AER_FLAGS` in Device Control (to skip
  devices that haven't been initialized), then calls existing
  `pci_aer_clear_status()` and `pcie_clear_device_status()`.
- **Modified function**: `aer_enable_rootport()` — adds ~8 lines after
  clearing Root Error Status to walk subordinate devices and clear their
  error status too. The walk is conditional on `AER_ERR_STATUS_MASK`
  being set in the root status register.

**Risk assessment**:
- The new code uses **well-established APIs**: `pci_walk_bus()`,
  `pcie_walk_rcec()`, `pci_aer_clear_status()`,
  `pcie_clear_device_status()` — all already used elsewhere in the same
  file.
- The guard condition `!(devctl & PCI_EXP_AER_FLAGS)` mirrors the
  existing check at line 1047 in `is_error_source()`, so this is a
  proven pattern.
- The `AER_ERR_STATUS_MASK` check ensures the walk only happens when
  there are actual errors to clear, minimizing unnecessary bus walks.
- Only touches one file (`drivers/pci/pcie/aer.c`).

### 5. User Impact

- **Who is affected**: Any system with PCIe devices that can generate
  AER errors. This is common on servers, workstations, and laptops.
- **How severe**: Not a crash or data corruption, but stale error
  reporting can:
  - Cause unnecessary alarm and investigation
  - Mask the true timing of errors, complicating root cause analysis
  - Confuse monitoring/alerting systems
- **Real-world impact**: Reported by Intel engineer (Lucas Van),
  suggesting this was encountered in real deployment scenarios.

### 6. Stability Indicators

- **Tested-by**: Lucas Van (the reporter) — confirms the fix works
- **Reviewed-by**: Kuppuswamy Sathyanarayanan (Intel kernel developer) —
  expert review
- **Signed-off-by**: Bjorn Helgaas — PCI subsystem maintainer, extremely
  conservative gatekeeper

### 7. Dependency Check

The functions used (`pci_walk_bus`, `pcie_walk_rcec`,
`pci_aer_clear_status`, `pcie_clear_device_status`, `PCI_EXP_AER_FLAGS`)
all exist in current stable trees. The `AER_ERR_STATUS_MASK` macro is
defined in the same file. No dependencies on recent mainline changes
detected.

### Summary

**Pros**:
- Fixes a real bug reported and tested by an Intel engineer
- Small, contained change (~20 lines added) in a single file
- Uses existing, well-established APIs with proven patterns
- Reviewed by PCI subsystem maintainer
- No risk of regression — only adds clearing of stale error registers at
  probe time
- All dependencies exist in stable trees

**Cons**:
- Not a crash/security/corruption fix — it's a "misleading error
  reporting" fix
- Adds a new function (though trivial and self-contained)
- The bug is somewhat niche (requires specific timing of error vs. AER
  probe)

While this isn't a critical crash or security fix, it does fix a real
functional bug that affects error reporting accuracy. The fix is small,
well-tested, well-reviewed, uses established patterns, and carries
minimal regression risk. The PCI AER subsystem is important for system
reliability monitoring, and misleading error reports can lead to
unnecessary hardware replacements or missed real issues. The quality
indicators (maintainer sign-off, tested-by, reviewed-by, Intel reporter)
are all strong.

**YES**

 drivers/pci/pcie/aer.c | 26 +++++++++++++++++++++++++-
 1 file changed, 25 insertions(+), 1 deletion(-)

diff --git a/drivers/pci/pcie/aer.c b/drivers/pci/pcie/aer.c
index e0bcaa896803c..4299c553d9bb4 100644
--- a/drivers/pci/pcie/aer.c
+++ b/drivers/pci/pcie/aer.c
@@ -1608,6 +1608,20 @@ static void aer_disable_irq(struct pci_dev *pdev)
 	pci_write_config_dword(pdev, aer + PCI_ERR_ROOT_COMMAND, reg32);
 }
 
+static int clear_status_iter(struct pci_dev *dev, void *data)
+{
+	u16 devctl;
+
+	/* Skip if pci_enable_pcie_error_reporting() hasn't been called yet */
+	pcie_capability_read_word(dev, PCI_EXP_DEVCTL, &devctl);
+	if (!(devctl & PCI_EXP_AER_FLAGS))
+		return 0;
+
+	pci_aer_clear_status(dev);
+	pcie_clear_device_status(dev);
+	return 0;
+}
+
 /**
  * aer_enable_rootport - enable Root Port's interrupts when receiving messages
  * @rpc: pointer to a Root Port data structure
@@ -1629,9 +1643,19 @@ static void aer_enable_rootport(struct aer_rpc *rpc)
 	pcie_capability_clear_word(pdev, PCI_EXP_RTCTL,
 				   SYSTEM_ERROR_INTR_ON_MESG_MASK);
 
-	/* Clear error status */
+	/* Clear error status of this Root Port or RCEC */
 	pci_read_config_dword(pdev, aer + PCI_ERR_ROOT_STATUS, &reg32);
 	pci_write_config_dword(pdev, aer + PCI_ERR_ROOT_STATUS, reg32);
+
+	/* Clear error status of agents reporting to this Root Port or RCEC */
+	if (reg32 & AER_ERR_STATUS_MASK) {
+		if (pci_pcie_type(pdev) == PCI_EXP_TYPE_RC_EC)
+			pcie_walk_rcec(pdev, clear_status_iter, NULL);
+		else if (pdev->subordinate)
+			pci_walk_bus(pdev->subordinate, clear_status_iter,
+				     NULL);
+	}
+
 	pci_read_config_dword(pdev, aer + PCI_ERR_COR_STATUS, &reg32);
 	pci_write_config_dword(pdev, aer + PCI_ERR_COR_STATUS, reg32);
 	pci_read_config_dword(pdev, aer + PCI_ERR_UNCOR_STATUS, &reg32);
-- 
2.51.0

