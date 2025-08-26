Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE6A8340DAE;
	Tue, 26 Aug 2025 11:30:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756207818; cv=none; b=m8J3xUayZ13u5szehN9ppYUV0+Gd4pYS+D9jH57vsRCSkZ6zuaBYQMstjHcrEqCoj4Xzq08/gEGImw1CzxFj4iheTuuglczdEM84nFI+FtPpqRiJ/+6D/WTmOEEfTiKdn7T0H6nRVBlpctDt6C0HS3o6qr2EipnASWUI1V0gSQw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756207818; c=relaxed/simple;
	bh=qf79HUoOgwzwCNMvRLcWl3iSfHZ3kHMw1gESj4+PmNI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VtKApwhZDjMvqkdMH098qFD4pTYdX2fIqNxwMgLlqssTxcJlE+rwwbCJFW0nV6zkUs+mLZdQe2HL2rDz9kPltboXbBjI0+zWRnx1upUzE/s96+zA+cWJ0NnzHdWicRaTfJ+PcxOCcgEP5gnASgvIvYsxnWRspHhhbuCLsNSx+vY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=L9WC6JK0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="L9WC6JK0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C136C4CEF1;
	Tue, 26 Aug 2025 11:30:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756207817;
	bh=qf79HUoOgwzwCNMvRLcWl3iSfHZ3kHMw1gESj4+PmNI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=L9WC6JK0TxCYkkF9rAmvFCGYZjMJLojtxauxhhKXIYMybljA9bO2oq1jyRy0seBpW
	 CjkdOtr8U4MWBhSG4k3ob4iCtToh1Fs3x5PdIdlQOF2FhDwguJCQUVje60beixGEs0
	 JC/mzMWusvksGTqS5nexU3Hl9SnPc6vwp4D+VpJg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Niklas Cassel <cassel@kernel.org>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Damien Le Moal <dlemoal@kernel.org>,
	Wilfred Mallawa <wilfred.mallawa@wdc.com>
Subject: [PATCH 6.16 329/457] PCI: dwc: Ensure that dw_pcie_wait_for_link() waits 100 ms after link up
Date: Tue, 26 Aug 2025 13:10:13 +0200
Message-ID: <20250826110945.474899014@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110937.289866482@linuxfoundation.org>
References: <20250826110937.289866482@linuxfoundation.org>
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

commit 80dc18a0cba8dea42614f021b20a04354b213d86 upstream.

As per PCIe r6.0, sec 6.6.1, a Downstream Port that supports Link speeds
greater than 5.0 GT/s, software must wait a minimum of 100 ms after Link
training completes before sending a Configuration Request.

Add this delay in dw_pcie_wait_for_link(), after the link is reported as
up. The delay will only be performed in the success case where the link
came up.

DWC glue drivers that have a link up IRQ (drivers that set
use_linkup_irq = true) do not call dw_pcie_wait_for_link(), instead they
perform this delay in their threaded link up IRQ handler.

Signed-off-by: Niklas Cassel <cassel@kernel.org>
Signed-off-by: Manivannan Sadhasivam <mani@kernel.org>
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: Wilfred Mallawa <wilfred.mallawa@wdc.com>
Link: https://patch.msgid.link/20250625102347.1205584-14-cassel@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pci/controller/dwc/pcie-designware.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/drivers/pci/controller/dwc/pcie-designware.c
+++ b/drivers/pci/controller/dwc/pcie-designware.c
@@ -714,6 +714,14 @@ int dw_pcie_wait_for_link(struct dw_pcie
 		return -ETIMEDOUT;
 	}
 
+	/*
+	 * As per PCIe r6.0, sec 6.6.1, a Downstream Port that supports Link
+	 * speeds greater than 5.0 GT/s, software must wait a minimum of 100 ms
+	 * after Link training completes before sending a Configuration Request.
+	 */
+	if (pci->max_link_speed > 2)
+		msleep(PCIE_RESET_CONFIG_WAIT_MS);
+
 	offset = dw_pcie_find_capability(pci, PCI_CAP_ID_EXP);
 	val = dw_pcie_readw_dbi(pci, offset + PCI_EXP_LNKSTA);
 


