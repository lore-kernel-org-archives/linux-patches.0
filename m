Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F4D2222D62;
	Thu, 12 Dec 2024 17:10:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734023405; cv=none; b=sQlWo/1GvG/+vsYjD55oWTPCfMJSoPSr4YRNOmeqemmlC0iGlsRSLITE3LJlXOn6MSSA+nlUKKUWLsV2RsDogt4U/pUC3tubPWAJNikr8rsLebfW9QBDOVqqrhih7hUuDlIiXBtWQFYS0p4rH+hzgmikJX4Qu5D5bQTzdlbO1hU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734023405; c=relaxed/simple;
	bh=zC3idkyTMko8F7/bXVhVNLo8AxOwJYvDY8PnrOyXDiU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HpvoYunbzmePz8oVUV3eHgQ5QwHqpTYgMDPIUXrt4lQ/B2Kll04qCjgsRs4Y2KxYxB2QD+om+2E8XVMH9IdITGqAwh8xpnaOVVrqwJul2W2w4Moq4gP5NegWTR8+i8TXD5NXTr+G3k2reXNvVBm5yXL2urYObNJaTCE1mZ4d27w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JheigrGS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JheigrGS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25EA8C4CECE;
	Thu, 12 Dec 2024 17:10:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734023405;
	bh=zC3idkyTMko8F7/bXVhVNLo8AxOwJYvDY8PnrOyXDiU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JheigrGSXNFP4DuJlMqNLvFZJ5mS3rRXiw4LDKBgyNso9WOtMR9G77Q/bmotogIKu
	 bxv2IUfq+5JASzCUY4V3yvaBFGPgR+IGg4ID/ntnKVEoaSGG6bhnA+fRKFkhnfeVEB
	 Egoz5lCID2cQrZ/H3u5XoUoiupx2SWpcZ5McKZsM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mengyuan Lou <mengyuanlou@net-swift.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 524/565] PCI: Add ACS quirk for Wangxun FF5xxx NICs
Date: Thu, 12 Dec 2024 16:01:59 +0100
Message-ID: <20241212144332.517763565@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144311.432886635@linuxfoundation.org>
References: <20241212144311.432886635@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mengyuan Lou <mengyuanlou@net-swift.com>

[ Upstream commit aa46a3736afcb7b0793766d22479b8b99fc1b322 ]

Wangxun FF5xxx NICs are similar to SFxxx, RP1000 and RP2000 NICs.  They may
be multi-function devices, but they do not advertise an ACS capability.

But the hardware does isolate FF5xxx functions as though it had an ACS
capability and PCI_ACS_RR and PCI_ACS_CR were set in the ACS Control
register, i.e., all peer-to-peer traffic is directed upstream instead of
being routed internally.

Add ACS quirk for FF5xxx NICs in pci_quirk_wangxun_nic_acs() so the
functions can be in independent IOMMU groups.

Link: https://lore.kernel.org/r/E16053DB2B80E9A5+20241115024604.30493-1-mengyuanlou@net-swift.com
Signed-off-by: Mengyuan Lou <mengyuanlou@net-swift.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/quirks.c | 15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
index 4ce4ca3df7432..6b76154626e25 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -4855,18 +4855,21 @@ static int pci_quirk_brcm_acs(struct pci_dev *dev, u16 acs_flags)
 }
 
 /*
- * Wangxun 10G/1G NICs have no ACS capability, and on multi-function
- * devices, peer-to-peer transactions are not be used between the functions.
- * So add an ACS quirk for below devices to isolate functions.
+ * Wangxun 40G/25G/10G/1G NICs have no ACS capability, but on
+ * multi-function devices, the hardware isolates the functions by
+ * directing all peer-to-peer traffic upstream as though PCI_ACS_RR and
+ * PCI_ACS_CR were set.
  * SFxxx 1G NICs(em).
  * RP1000/RP2000 10G NICs(sp).
+ * FF5xxx 40G/25G/10G NICs(aml).
  */
 static int  pci_quirk_wangxun_nic_acs(struct pci_dev *dev, u16 acs_flags)
 {
 	switch (dev->device) {
-	case 0x0100 ... 0x010F:
-	case 0x1001:
-	case 0x2001:
+	case 0x0100 ... 0x010F: /* EM */
+	case 0x1001: case 0x2001: /* SP */
+	case 0x5010: case 0x5025: case 0x5040: /* AML */
+	case 0x5110: case 0x5125: case 0x5140: /* AML */
 		return pci_acs_ctrl_enabled(acs_flags,
 			PCI_ACS_SV | PCI_ACS_RR | PCI_ACS_CR | PCI_ACS_UF);
 	}
-- 
2.43.0



