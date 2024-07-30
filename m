Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2D3B1A6160;
	Tue, 30 Jul 2024 16:22:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722356527; cv=none; b=GQUppAHoio6pMtd58M23UiL+BDOD9nfBvZY91I+HbupNVWvBs4BcPGDzvWXuK84Ke+lxFEkkvk2yWFhHChiQPsIb8AEG5CctnEt7iSzJqzNvDwt/wQg2/ZdJlA11x4r1tMOxN9V7QswmiQCZHDT2HdWHBdc/6WDqFVY517+nIeI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722356527; c=relaxed/simple;
	bh=oczPFCM4TcQT15x9gA6WfGua9ilYkgjYWzyJPyDd6/U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=tuIpMo2bIajrrWgzZWk3SmYuVtwx8SXrmxiSkiEIgUG/W4p20Fzs7f4Edq7kJomkdu6YUU+E8rDVHV5Ce4RZR0nA2/OudNbL5cso54iWuJ+X0tTGtHT4Qf8rCUwRrqyajq4LgOTu+pP3bnswxFpp4um1EMyQXj3nKPunIz3cSpw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=axtfv0n3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="axtfv0n3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34987C32782;
	Tue, 30 Jul 2024 16:22:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722356527;
	bh=oczPFCM4TcQT15x9gA6WfGua9ilYkgjYWzyJPyDd6/U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=axtfv0n3K04j0D7T9i2+y4FmrOrTUGK5esOYsvnMwlyhwCflRrlV6dmdSNFRIo2Fi
	 E3cJx1d9i9PCvTNr9vJbVE1JkvtZX5nVatZHJu2D+WqFNEWlcoBkmtkUqi/ULTL7mv
	 MoMsaOPCZxqi1hcEiUKAwPe3jbrnyLtj3tLi5npQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marek Vasut <marek.vasut+renesas@mailbox.org>,
	=?UTF-8?q?Krzysztof=20Wilczy=C5=84ski?= <kwilczynski@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 181/440] PCI: rcar: Demote WARN() to dev_warn_ratelimited() in rcar_pcie_wakeup()
Date: Tue, 30 Jul 2024 17:46:54 +0200
Message-ID: <20240730151622.944970070@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151615.753688326@linuxfoundation.org>
References: <20240730151615.753688326@linuxfoundation.org>
User-Agent: quilt/0.67
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marek Vasut <marek.vasut+renesas@mailbox.org>

[ Upstream commit c93637e6a4c4e1d0e85ef7efac78d066bbb24d96 ]

Avoid large backtrace, it is sufficient to warn the user that there has
been a link problem. Either the link has failed and the system is in need
of maintenance, or the link continues to work and user has been informed.
The message from the warning can be looked up in the sources.

This makes an actual link issue less verbose.

First of all, this controller has a limitation in that the controller
driver has to assist the hardware with transition to L1 link state by
writing L1IATN to PMCTRL register, the L1 and L0 link state switching
is not fully automatic on this controller.

In case of an ASMedia ASM1062 PCIe SATA controller which does not support
ASPM, on entry to suspend or during platform pm_test, the SATA controller
enters D3hot state and the link enters L1 state. If the SATA controller
wakes up before rcar_pcie_wakeup() was called and returns to D0, the link
returns to L0 before the controller driver even started its transition to
L1 link state. At this point, the SATA controller did send an PM_ENTER_L1
DLLP to the PCIe controller and the PCIe controller received it, and the
PCIe controller did set PMSR PMEL1RX bit.

Once rcar_pcie_wakeup() is called, if the link is already back in L0 state
and PMEL1RX bit is set, the controller driver has no way to determine if
it should perform the link transition to L1 state, or treat the link as if
it is in L0 state. Currently the driver attempts to perform the transition
to L1 link state unconditionally, which in this specific case fails with a
PMSR L1FAEG poll timeout, however the link still works as it is already
back in L0 state.

Reduce this warning verbosity. In case the link is really broken, the
rcar_pcie_config_access() would fail, otherwise it will succeed and any
system with this controller and ASM1062 can suspend without generating
a backtrace.

Fixes: 84b576146294 ("PCI: rcar: Finish transition to L1 state in rcar_pcie_config_access()")
Link: https://lore.kernel.org/linux-pci/20240511235513.77301-1-marek.vasut+renesas@mailbox.org
Signed-off-by: Marek Vasut <marek.vasut+renesas@mailbox.org>
Signed-off-by: Krzysztof Wilczyński <kwilczynski@kernel.org>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/pcie-rcar-host.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/pci/controller/pcie-rcar-host.c b/drivers/pci/controller/pcie-rcar-host.c
index e4faf90feaf5c..d0fe5076d9777 100644
--- a/drivers/pci/controller/pcie-rcar-host.c
+++ b/drivers/pci/controller/pcie-rcar-host.c
@@ -92,7 +92,11 @@ static int rcar_pcie_wakeup(struct device *pcie_dev, void __iomem *pcie_base)
 		writel(L1IATN, pcie_base + PMCTLR);
 		ret = readl_poll_timeout_atomic(pcie_base + PMSR, val,
 						val & L1FAEG, 10, 1000);
-		WARN(ret, "Timeout waiting for L1 link state, ret=%d\n", ret);
+		if (ret) {
+			dev_warn_ratelimited(pcie_dev,
+					     "Timeout waiting for L1 link state, ret=%d\n",
+					     ret);
+		}
 		writel(L1FAEG | PMEL1RX, pcie_base + PMSR);
 	}
 
-- 
2.43.0



