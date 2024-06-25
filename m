Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 568631465A8;
	Tue, 25 Jun 2024 10:00:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719309600; cv=none; b=Yc821UvHA6TKu2Z/ew5jzPkBNYNbcerwI+FGneagIdRcBBqYKMzXlhOfhos5kfLfx3K+K8NaVc62l9h84MX39ATpgwjATq/4nvGsTSqMbgk9S1f4vN2dhvnEHVBk97HvShQGc6+OjW3JNOMLRD8hlyJjocRr+oVDrdgTANQ/jM4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719309600; c=relaxed/simple;
	bh=hj5enNyEXW4yITV+EAJJ6VhtuluvEEGcQI5IihlG8hQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ceC0LRExIChESVuWjWrH2lRBsHQShDhsQFijcROO+Ec6ntgxgKoaSePUKnTuDLdBlAllJxR6MzMMaVatuimCFxpLJoQl8tsZGW26wcWDkgmiIHrRkj4SnYIPsXUGUDHxRkaSBTm82LFysjOhKwke6ODhfbXcawoIJAiEXoXzewM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=D5m688ON; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="D5m688ON"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5462C32781;
	Tue, 25 Jun 2024 09:59:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719309600;
	bh=hj5enNyEXW4yITV+EAJJ6VhtuluvEEGcQI5IihlG8hQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=D5m688ON8vQpYn1mnA9t64vcxe6ul2t12wsZZ2Wx/SEcFEzmrHejPmrtvQjYn6D7y
	 NzNxKr1oz47i/7c+0+rDr+ke4XMiix/LRNGAuBSErRnGvRVGBHJBmYrGoxarj3HDgz
	 WZ0NgN9q+5j+l2pr/RzMnfDvMGAOqVkBcY5umoQQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Songyang Li <leesongyang@outlook.com>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 040/131] MIPS: Octeon: Add PCIe link status check
Date: Tue, 25 Jun 2024 11:33:15 +0200
Message-ID: <20240625085527.476777334@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240625085525.931079317@linuxfoundation.org>
References: <20240625085525.931079317@linuxfoundation.org>
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

From: Songyang Li <leesongyang@outlook.com>

[ Upstream commit 29b83a64df3b42c88c0338696feb6fdcd7f1f3b7 ]

The standard PCIe configuration read-write interface is used to
access the configuration space of the peripheral PCIe devices
of the mips processor after the PCIe link surprise down, it can
generate kernel panic caused by "Data bus error". So it is
necessary to add PCIe link status check for system protection.
When the PCIe link is down or in training, assigning a value
of 0 to the configuration address can prevent read-write behavior
to the configuration space of peripheral PCIe devices, thereby
preventing kernel panic.

Signed-off-by: Songyang Li <leesongyang@outlook.com>
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/mips/pci/pcie-octeon.c | 6 ++++++
 1 file changed, 6 insertions(+)
 mode change 100644 => 100755 arch/mips/pci/pcie-octeon.c

diff --git a/arch/mips/pci/pcie-octeon.c b/arch/mips/pci/pcie-octeon.c
old mode 100644
new mode 100755
index c9edd3fb380df..9eaacd3d33880
--- a/arch/mips/pci/pcie-octeon.c
+++ b/arch/mips/pci/pcie-octeon.c
@@ -230,12 +230,18 @@ static inline uint64_t __cvmx_pcie_build_config_addr(int pcie_port, int bus,
 {
 	union cvmx_pcie_address pcie_addr;
 	union cvmx_pciercx_cfg006 pciercx_cfg006;
+	union cvmx_pciercx_cfg032 pciercx_cfg032;
 
 	pciercx_cfg006.u32 =
 	    cvmx_pcie_cfgx_read(pcie_port, CVMX_PCIERCX_CFG006(pcie_port));
 	if ((bus <= pciercx_cfg006.s.pbnum) && (dev != 0))
 		return 0;
 
+	pciercx_cfg032.u32 =
+		cvmx_pcie_cfgx_read(pcie_port, CVMX_PCIERCX_CFG032(pcie_port));
+	if ((pciercx_cfg032.s.dlla == 0) || (pciercx_cfg032.s.lt == 1))
+		return 0;
+
 	pcie_addr.u64 = 0;
 	pcie_addr.config.upper = 2;
 	pcie_addr.config.io = 1;
-- 
2.43.0



