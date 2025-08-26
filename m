Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C346317332C;
	Tue, 26 Aug 2025 11:40:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756208435; cv=none; b=kLEXWsX0qMKiOMuqFKuEexunyLB+4q15bwQ9cHKna1P4hSTzzgHkBbIzJR+VFkx4lDA7Jv8Ia+BX4kVUU6U4Rggf8ckLXqYLNr1KD7l7HOGbinQhOrS+Y1FE7BBrvFuTFLGrFQAHrfChszulpuCxvNKjvhmNIOT8UBv2cl6Q0Vc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756208435; c=relaxed/simple;
	bh=ZFkcm6iAc2y2j3KtD205RX3/jzrmtpqhs9lzgjct0Q0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=axfVJr33P14NI6EIKD19miAe0Uxivqg7PD/7lG4NRJ7weYAz1eyHljzdUUYoY9GL3NKRxs+aHqsm+m0xZP8wqBxtcLgPdthtDlo3YC4L2oSw2B2YuXEzvhZn20claCBcgS8lZqW8AuunpuXBd0yuUUCpFqWFF53MhoNm6diNhMI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yOSMC0zn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yOSMC0zn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54E79C4CEF1;
	Tue, 26 Aug 2025 11:40:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756208435;
	bh=ZFkcm6iAc2y2j3KtD205RX3/jzrmtpqhs9lzgjct0Q0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yOSMC0znAwH2aTshoxuIXGd6Wjz/QGNi2dg7xE4mLIPy18d/F74D7Mg8AFOe9jM8t
	 GlvYR7Ssja2bcs6CUtL9Ts03C2MsND+a5ptFC1YPGjQYX9djf/7SN5uRi42lJjSWGX
	 MJqUz9Dyyfrm4WDY2v2vWfTm356sbIwZmHOfIsAk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Richard Zhu <hongxing.zhu@nxp.com>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Frank Li <Frank.Li@nxp.com>
Subject: [PATCH 6.12 079/322] PCI: imx6: Delay link start until configfs start written
Date: Tue, 26 Aug 2025 13:08:14 +0200
Message-ID: <20250826110917.564195363@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110915.169062587@linuxfoundation.org>
References: <20250826110915.169062587@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Richard Zhu <hongxing.zhu@nxp.com>

commit 2e6ea70690ddd1ffa422423fd0d4523e4dfe4b62 upstream.

According to Documentation/PCI/endpoint/pci-endpoint-cfs.rst, the Endpoint
controller (EPC) should only start the link when userspace writes '1' to
the '/sys/kernel/config/pci_ep/controllers/<EPC>/start' attribute, which
ultimately results in calling imx_pcie_start_link() via
pci_epc_start_store().

To align with the documented behavior, do not start the link automatically
when adding the EP controller.

Fixes: 75c2f26da03f ("PCI: imx6: Add i.MX PCIe EP mode support")
Signed-off-by: Richard Zhu <hongxing.zhu@nxp.com>
[mani: reworded commit subject and description]
Signed-off-by: Manivannan Sadhasivam <mani@kernel.org>
[bhelgaas: commit log]
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20250709033722.2924372-3-hongxing.zhu@nxp.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pci/controller/dwc/pci-imx6.c |    3 ---
 1 file changed, 3 deletions(-)

--- a/drivers/pci/controller/dwc/pci-imx6.c
+++ b/drivers/pci/controller/dwc/pci-imx6.c
@@ -1191,9 +1191,6 @@ static int imx_add_pcie_ep(struct imx_pc
 
 	pci_epc_init_notify(ep->epc);
 
-	/* Start LTSSM. */
-	imx_pcie_ltssm_enable(dev);
-
 	return 0;
 }
 


