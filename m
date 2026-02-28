Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41B16340A59
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:52:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301130; cv=none; b=k/cJn1fVlmKW5ihXU8vhaR8MHgIyVBHM7DpRe6mvQjsU9rCUrdHM+2EkR4xBrDNsslricIEcu/wjUR83peTxM9se9uBIHVcuS8ZgmlZHjjoZir7qrPimeL3laiAUnNG4B6xvzIr/pALSqEirXM7OS515I+HzripYQ29PcczdjXw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301130; c=relaxed/simple;
	bh=QCzPKq3y9x7uAsM77rTsCrbVlQytvdYrbljTC0G/Qks=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OK/6uJUMc5MYrPQuDNRWBrBJGuYDjVUrCBMgZTGQq9FdjThurd6EiqQi+q837JmqrmT+958JqiD/7ibASJT2y2//fXNI5YH9+1xI2lvfEtKJYkC2HzIPgldujrgHRRFIylRT2hSZRdqB8BxwoYc4qqg/3ODtCDuKGxm+F83sLAY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Cc5Qux8i; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Cc5Qux8i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CC30C19424;
	Sat, 28 Feb 2026 17:52:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301130;
	bh=QCzPKq3y9x7uAsM77rTsCrbVlQytvdYrbljTC0G/Qks=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Cc5Qux8iC3QHLh2e/TrS189sjWrEOsGnrAciMkxaNpV7FjFDuwNCmOPmnohYL2sFd
	 UW2SYC9C9l3soMgF/5Pe+5v3UPWyfhfujlKDNM2/aaaq9ta5/k5XdGXPemaE2O3yEq
	 wN6Kgd1xofA9N67WEvryU0CqAG78yBrLn8ZBiFUSg6JWHIHrBkqUfzOaORFYOjRt+4
	 NtWnkH2Av5tzPRR/+dljhJlmYFPOpD3N9vdaoD3jX+8kas+CN7GjOUmxXuPS/R3vZ8
	 Dlgu5KqTaw8l1UAHoK/zzmSp9X9i6j0QSzSu7iSB93Z8gXBT97yR77lEPVAex5rVPO
	 pc9evaK28e8qA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Alex Williamson <alex.williamson@nvidia.com>,
	Patrick Bianchi <patrick.w.bianchi@gmail.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 289/752] PCI: Mark ASM1164 SATA controller to avoid bus reset
Date: Sat, 28 Feb 2026 12:40:00 -0500
Message-ID: <20260228174750.1542406-289-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Alex Williamson <alex.williamson@nvidia.com>

[ Upstream commit beb2f81792a8a619e5122b6b24a374861309c54b ]

User forums report issues when assigning ASM1164 SATA controllers to VMs,
especially in configurations with multiple controllers.  Logs show the
device fails to retrain after bus reset.  Reports suggest this is an issue
across multiple platforms.  The device indicates support for PM reset,
therefore the device still has a viable function level reset mechanism.
The reporting user confirms the device is well behaved in this use case
with bus reset disabled.

Reported-by: Patrick Bianchi <patrick.w.bianchi@gmail.com>
Link: https://forum.proxmox.com/threads/problems-with-pcie-passthrough-with-two-identical-devices.149003/
Signed-off-by: Alex Williamson <alex.williamson@nvidia.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Link: https://patch.msgid.link/20260109000211.398300-1-alex.williamson@nvidia.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/quirks.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
index 9e073321b2dd2..c38434d973cd2 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -3791,6 +3791,16 @@ DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_CAVIUM, 0xa100, quirk_no_bus_reset);
  */
 DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_TI, 0xb005, quirk_no_bus_reset);
 
+/*
+ * Reports from users making use of PCI device assignment with ASM1164
+ * controllers indicate an issue with bus reset where the device fails to
+ * retrain.  The issue appears more common in configurations with multiple
+ * controllers.  The device does indicate PM reset support (NoSoftRst-),
+ * therefore this still leaves a viable reset method.
+ * https://forum.proxmox.com/threads/problems-with-pcie-passthrough-with-two-identical-devices.149003/
+ */
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_ASMEDIA, 0x1164, quirk_no_bus_reset);
+
 static void quirk_no_pm_reset(struct pci_dev *dev)
 {
 	/*
-- 
2.51.0

