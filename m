Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B878F1822CB;
	Wed,  3 Jul 2024 10:44:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720003499; cv=none; b=uI8pIKJ4H6XTX36HF1LjBj7NOMrC8NcCqySWHURmhCAfNQtzp/tMEdljWy2PrNhXCaaeZn2lzC/bmNef09UHUnbspSvPwfGoJdleK6rndazO+wJfP5oMeBMd8UptAFIdedPU8i42jUxCVDJUA6QNxk3lW+dj3BAGWqZyGjXyfkQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720003499; c=relaxed/simple;
	bh=YsTCeCpAJXv9005VvBbKM7vYZ6EmSE74krSb2ZVSfZ8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N5udUWPjXwx93Xq7ONpqDLshdDV6vUlq3Zl/ylLQs0U83E0iJaXeMUUc/5welyf43NcXJM2gexFwtMQs8pshyYMzLFEPj4W4gcCbCCTEhuAgMYY+wp+DEawHxElB5w8NOLnVLbG6CuMXFLTuQASHmPkEUJU4dz12t1HGakRueNI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=X9sH3xKo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="X9sH3xKo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3EDE2C2BD10;
	Wed,  3 Jul 2024 10:44:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720003499;
	bh=YsTCeCpAJXv9005VvBbKM7vYZ6EmSE74krSb2ZVSfZ8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=X9sH3xKor4PIAyAB7o3JU28iiV+5cOVlKolj592rPqo2ssOewHdz51s9ndEd4QlWl
	 0PaLkKPNeT9ejLElBUlc5i9gXmSFOMYMOCAT1QZ6BUKENKzWgBA2bjQLnmlAr+yc7j
	 NDGFBBh91wcbYbt+Mfi7pGvqzm/pUzWFEWzMgtcE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Songyang Li <leesongyang@outlook.com>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 069/139] MIPS: Octeon: Add PCIe link status check
Date: Wed,  3 Jul 2024 12:39:26 +0200
Message-ID: <20240703102833.047753613@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102830.432293640@linuxfoundation.org>
References: <20240703102830.432293640@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
index d919a0d813a17..38de2a9c3cf1a
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



