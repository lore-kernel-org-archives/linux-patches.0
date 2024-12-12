Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C37381487CD;
	Thu, 12 Dec 2024 15:27:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734017259; cv=none; b=tLfGjA8Guwxt2fWP79WVrY0LyxsrNFC00BbylZSOT3O7hhv7khUypNYRfwYLiDR8FRCDlyeKzdxqonP4Jgwo3TCyNCwtHPq9qrXrbYu0OLtwGfOfYXWBFHILhKdn7jnRSjJrMzjFZz7XRYEm3BCVM09nsQ0tE1eChBcbuMj0Td8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734017259; c=relaxed/simple;
	bh=njxTDeii+tiUcQWaqUS8HjwJ3Mh3ndPHyZ7mJUFtQTs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MK0wIqemqr0S4uXeYSYzifVlJlbHSOPoQ/jtr9OCmTZAhbYGYhiU7+rZs2uPs2uwjVNkN02EbaKX/jdEia+Q2sn+C1njuANc2fUqLp5mEcw4vua5Y9Je5+0Z+YOR4L8v63ovMvfqZzEvp22EUyTxpNNeBeHTS9sjbZ08Lewc1X8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VDhk1Nox; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VDhk1Nox"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1D4CC4CECE;
	Thu, 12 Dec 2024 15:27:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734017259;
	bh=njxTDeii+tiUcQWaqUS8HjwJ3Mh3ndPHyZ7mJUFtQTs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VDhk1NoxA+qrmnHzy0kGz6Cr3MfcmGXJcrTkckuWtV7HBIHe2F60YF1b+u8+0odA1
	 zoVOu3zbyf7pZYARrPdeLAAAVDT6xx4WxVHlBCNh97Ywa/SeGVAPCw5X9GSTDjG+eO
	 Oa+qsGXl243ibn2cTexQthBYJDIFaQFNc2gRbw2s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mengyuan Lou <mengyuanlou@net-swift.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 397/466] PCI: Add ACS quirk for Wangxun FF5xxx NICs
Date: Thu, 12 Dec 2024 15:59:26 +0100
Message-ID: <20241212144322.448936777@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144306.641051666@linuxfoundation.org>
References: <20241212144306.641051666@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index dccb60c1d9cc3..8103bc24a54ea 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -4996,18 +4996,21 @@ static int pci_quirk_brcm_acs(struct pci_dev *dev, u16 acs_flags)
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



