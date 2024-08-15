Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 911A01A00F5;
	Thu, 15 Aug 2024 14:05:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723730706; cv=none; b=WeuCWrmkrjFPqYyCJepk3XdvzxhKGtrHpWmZ2+tMSnKKfRYV0H4v42h6VUWyrNH74U2qaRLFRXzfP57n1JJw1FmS09YdDsMx8+iCjJ1Bkji+g0qeJkF4SiGcaC+S4vtCMcIbotuCkqcVx0Yw9EMIcKEmRNB/MBwNYB9yMzURFxI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723730706; c=relaxed/simple;
	bh=zxh6cJhs7xCBjgNYZo/02HETLXRP/BGMQ5q2Z6oXCBo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bQoxFJQTJX8SHMcEenKSsmUqgdSL/vOMjDeeDcV110hg3vd0m3Nr1/nPd0cRrBc9vyNDHMmeismg0YumtSLiSg9AO7uVekzzS2S12Ndf53SL3paWrbOCbSz+Yu22SPjsavnX4XJSzVfzpvsOtGoiOhgZZ9kPcRF/UBUSuFIrvFk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sawvZoGm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sawvZoGm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 019E9C32786;
	Thu, 15 Aug 2024 14:05:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723730706;
	bh=zxh6cJhs7xCBjgNYZo/02HETLXRP/BGMQ5q2Z6oXCBo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sawvZoGmvqF/n2z0JZFU4q7Xw75zhaQUYyjYEN+N6Dx9a5Lv2YhB19qJpl1c7TfnW
	 /bG/hBAbuiN4/mt52KA6dK1KsncB0WQGrYzw9YApiTtXsSunxpn4r4/+mg4XtY/AQm
	 4bGEwKi1iJl7PtNvMM84RIHP0cQNNiZpfpqrr0nE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Richard Zhu <hongxing.zhu@nxp.com>,
	Jisheng Zhang <jszhang@kernel.org>,
	Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
	Bjorn Helgaas <bhelgaas@google.com>
Subject: [PATCH 5.15 472/484] PCI: dwc: Restore MSI Receiver mask during resume
Date: Thu, 15 Aug 2024 15:25:30 +0200
Message-ID: <20240815131959.707523521@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131941.255804951@linuxfoundation.org>
References: <20240815131941.255804951@linuxfoundation.org>
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

From: Jisheng Zhang <jszhang@kernel.org>

commit 815953dc2011ad7a34de355dfa703dcef1085219 upstream

If a host that uses the IP's integrated MSI Receiver lost power
during suspend, we call dw_pcie_setup_rc() to reinit the RC. But
dw_pcie_setup_rc() always sets pp->irq_mask[ctrl] to ~0, so the mask
register is always set as 0xffffffff incorrectly, thus the MSI can't
work after resume.

Fix this issue by moving pp->irq_mask[ctrl] initialization to
dw_pcie_host_init() so we can correctly set the mask reg during both
boot and resume.

Tested-by: Richard Zhu <hongxing.zhu@nxp.com>
Link: https://lore.kernel.org/r/20211226074019.2556-1-jszhang@kernel.org
Signed-off-by: Jisheng Zhang <jszhang@kernel.org>
Signed-off-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pci/controller/dwc/pcie-designware-host.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/drivers/pci/controller/dwc/pcie-designware-host.c
+++ b/drivers/pci/controller/dwc/pcie-designware-host.c
@@ -352,6 +352,12 @@ int dw_pcie_host_init(struct pcie_port *
 			if (ret < 0)
 				return ret;
 		} else if (pp->has_msi_ctrl) {
+			u32 ctrl, num_ctrls;
+
+			num_ctrls = pp->num_vectors / MAX_MSI_IRQS_PER_CTRL;
+			for (ctrl = 0; ctrl < num_ctrls; ctrl++)
+				pp->irq_mask[ctrl] = ~0;
+
 			if (!pp->msi_irq) {
 				pp->msi_irq = platform_get_irq_byname_optional(pdev, "msi");
 				if (pp->msi_irq < 0) {
@@ -550,7 +556,6 @@ void dw_pcie_setup_rc(struct pcie_port *
 
 		/* Initialize IRQ Status array */
 		for (ctrl = 0; ctrl < num_ctrls; ctrl++) {
-			pp->irq_mask[ctrl] = ~0;
 			dw_pcie_writel_dbi(pci, PCIE_MSI_INTR0_MASK +
 					    (ctrl * MSI_REG_CTRL_BLOCK_SIZE),
 					    pp->irq_mask[ctrl]);


