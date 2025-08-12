Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C0392FD1B2;
	Tue, 12 Aug 2025 18:45:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755024308; cv=none; b=rzPjDSMlGYTMjn72aCNTuLzGqrWiGhnc6ijcZtAb0pfg00wKMzaQaCma95j6Zc4b2VC5PKuBEqYu6Mqug5tDN8HsqUphXO4ZYJNHTAmPlVUnlvzwu4ZiRHy9hcx/ecnvfCjpU/Y7tYPzfTTd9Lrt9/X97qAnssMjG/moK86Z+3I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755024308; c=relaxed/simple;
	bh=VOU+ab00pTmM63Ve23ts/h5e2GEB4AingRagMFl6jTY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g8U0aT7+HkdN4uO73Vs0sZPmuzrx4ndz1GP5c1d8RymGPw7hUqNNX6Ro6qxEp7NSWmQobZvjtk2mWAnRFNJeslP4BhItzqBKH0EBLOw/dF+GtCH9XDBP7sRxeBtgVNAuJ7m/mgBHSZnKIM6jgerfqh6xqryEj7BB5XfxhQKcHAA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gge1Ivnl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gge1Ivnl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91FC7C4CEF1;
	Tue, 12 Aug 2025 18:45:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755024308;
	bh=VOU+ab00pTmM63Ve23ts/h5e2GEB4AingRagMFl6jTY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gge1IvnlHvCumuOJdRU6fFTBiU3mLQStuo1c7ecfGTg3sNT1WI+/qKTqP4j3glYhn
	 LCVjSioLWrh7WocJGkQ+qK4Gm1l2E1kDh2LAKk+Gc3/9msCIqQqsjs5iB+YCwhJovc
	 g7c1riElUKEt4fD0tlXk03D3U98Xzs+bwMlufeQU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Niklas Cassel <cassel@kernel.org>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Damien Le Moal <dlemoal@kernel.org>,
	Wilfred Mallawa <wilfred.mallawa@wdc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 334/627] PCI: qcom: Wait PCIE_RESET_CONFIG_WAIT_MS after link-up IRQ
Date: Tue, 12 Aug 2025 19:30:29 +0200
Message-ID: <20250812173431.994707543@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173419.303046420@linuxfoundation.org>
References: <20250812173419.303046420@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Niklas Cassel <cassel@kernel.org>

[ Upstream commit 15b6b243cc2b1017cf89e2477aa0b4e1a306a82a ]

Per PCIe r6.0, sec 6.6.1, software must generally wait a minimum of
100ms (PCIE_RESET_CONFIG_WAIT_MS) after Link training completes before
sending a Configuration Request.

Prior to 36971d6c5a9a ("PCI: qcom: Don't wait for link if we can detect
Link Up"), qcom used dw_pcie_wait_for_link(), which waited between 0
and 90ms after the link came up before we enumerate the bus, and this
was apparently enough for most devices.

After 36971d6c5a9a, qcom_pcie_global_irq_thread() started enumeration
immediately when handling the link-up IRQ, and devices (e.g., Laszlo
Fiat's PLEXTOR PX-256M8PeGN NVMe SSD) may not be ready to handle config
requests yet.

Delay PCIE_RESET_CONFIG_WAIT_MS after the link-up IRQ before starting
enumeration.

Fixes: 82a823833f4e ("PCI: qcom: Add Qualcomm PCIe controller driver")
Signed-off-by: Niklas Cassel <cassel@kernel.org>
Signed-off-by: Manivannan Sadhasivam <mani@kernel.org>
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: Wilfred Mallawa <wilfred.mallawa@wdc.com>
Link: https://patch.msgid.link/20250625102347.1205584-13-cassel@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/dwc/pcie-qcom.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/pci/controller/dwc/pcie-qcom.c b/drivers/pci/controller/dwc/pcie-qcom.c
index c789e3f85655..9b12f2f02042 100644
--- a/drivers/pci/controller/dwc/pcie-qcom.c
+++ b/drivers/pci/controller/dwc/pcie-qcom.c
@@ -1564,6 +1564,7 @@ static irqreturn_t qcom_pcie_global_irq_thread(int irq, void *data)
 	writel_relaxed(status, pcie->parf + PARF_INT_ALL_CLEAR);
 
 	if (FIELD_GET(PARF_INT_ALL_LINK_UP, status)) {
+		msleep(PCIE_RESET_CONFIG_WAIT_MS);
 		dev_dbg(dev, "Received Link up event. Starting enumeration!\n");
 		/* Rescan the bus to enumerate endpoint devices */
 		pci_lock_rescan_remove();
-- 
2.39.5



