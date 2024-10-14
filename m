Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1DA43A1B6;
	Mon, 14 Oct 2024 15:00:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728918015; cv=none; b=O0Fmrs1VBwrYf82qGo26anbe2h1uQ000M+98DgDHfVajKGNIeXeoTxPQjh+V/Tm5A41ryEw2wdqhw5//2fmGnaixtauMV5OVge6iUs5oxvhH8FDJ3uxbwJegQ9pXJ5zQyUdP5MKlmLoPXBHBuHE16m/8N+qZPOkYdaRWghHFFiE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728918015; c=relaxed/simple;
	bh=8xGShRhLpqgAlNB7bWVpqeP1Lr7Q0qJ9tjIUnFWZgMI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ihTL9zmAnP3xLcvF+yvLuCVfBiBJLI0fbbGcCjQwe/Pc6OckT/L8ybfintrOI+NvErRPlr0TBtZI+eX2xye2t9GVAaYeuO0OED3QiBMguSPOvHphSYHsXPm3owdxyG0JVNt4wHC//LDbGHYMhM7VqLKN9sXKDGP/wyQ/LPZN+ao=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zKbk9PeA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zKbk9PeA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15744C4CEC7;
	Mon, 14 Oct 2024 15:00:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728918015;
	bh=8xGShRhLpqgAlNB7bWVpqeP1Lr7Q0qJ9tjIUnFWZgMI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zKbk9PeAw72iytc9sugNCYbuD5O0hb/I2OGUtTeljRu7GpFLasO7kCg96X2KaCoU1
	 d/w71Wn90mlD53GLkD+0xkYopUL864Cuej2kMIVTCXyIQ7vTQkJM+5xwaXAbvqw2c2
	 g4i1hPh4HDATfzzYIna/nde28BwrbNkCFJcSPRYY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Chiu <chris.chiu@canonical.com>,
	Mika Westerberg <mika.westerberg@linux.intel.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Lukas Wunner <lukas@wunner.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 198/798] PCI/PM: Increase wait time after resume
Date: Mon, 14 Oct 2024 16:12:32 +0200
Message-ID: <20241014141225.705820901@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Mika Westerberg <mika.westerberg@linux.intel.com>

[ Upstream commit e8b908146d44310473e43b3382eca126e12d279c ]

PCIe r6.0 sec 6.6.1 prescribes that a device must be able to respond to
config requests within 1.0 s (PCI_RESET_WAIT) after exiting conventional
reset and this same delay is prescribed when coming out of D3cold (as that
involves reset too).

A device that requires more than 1 second to initialize after reset may
respond to config requests with Request Retry Status completions (sec
2.3.1), and we accommodate that in Linux with a 60 second cap
(PCIE_RESET_READY_POLL_MS).

Previously we waited up to PCIE_RESET_READY_POLL_MS only in the reset code
path, not in the resume path.  However, a device has surfaced, namely Intel
Titan Ridge xHCI, which requires a longer delay also in the resume code
path.

Make the resume code path to use this same extended delay as the reset
path.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=216728
Link: https://lore.kernel.org/r/20230404052714.51315-2-mika.westerberg@linux.intel.com
Reported-by: Chris Chiu <chris.chiu@canonical.com>
Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Cc: Lukas Wunner <lukas@wunner.de>
Stable-dep-of: 3e40aa29d47e ("PCI: Wait for Link before restoring Downstream Buses")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/pci-driver.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/pci/pci-driver.c b/drivers/pci/pci-driver.c
index 8dda3b205dfd0..bafe7c9e6d190 100644
--- a/drivers/pci/pci-driver.c
+++ b/drivers/pci/pci-driver.c
@@ -579,7 +579,8 @@ static void pci_pm_default_resume_early(struct pci_dev *pci_dev)
 
 static void pci_pm_bridge_power_up_actions(struct pci_dev *pci_dev)
 {
-	pci_bridge_wait_for_secondary_bus(pci_dev, "resume", PCI_RESET_WAIT);
+	pci_bridge_wait_for_secondary_bus(pci_dev, "resume",
+					  PCIE_RESET_READY_POLL_MS);
 	/*
 	 * When powering on a bridge from D3cold, the whole hierarchy may be
 	 * powered on into D0uninitialized state, resume them to give them a
-- 
2.43.0



