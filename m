Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 770EF2F83C1;
	Tue, 26 Aug 2025 11:20:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756207239; cv=none; b=tfg3tUU0xBjz0Z1DiraUDxcDxGlC0Oo0aqT2bpTKTn3XPHzwckXwrZ/ccXWExF91NULeZpXnlaNnBob8mYf11iB+xoFnIKMMMDXQMJf8RGt5XhgTRaVW4dUm0bCuMhMojYtmtUsPszXUNjqxDpl50eA9qG4aNCKLZTU5ntHyqQA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756207239; c=relaxed/simple;
	bh=Qu37dA89Z1rTLHkH11U4P5sJro6VkYjjUWnBV6Q2qz4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SvCpyg4XdqJS5FvWLAckanK+hjtfHm35t5ciGHE4T2HPgDJ9JSCGHwe4dDIMxsBbdcu78B2opGmqhiTzPvaQVkFMcVNi9LzLATyXKEjP129jT7IrCDuzw6osTnP7DEil/8V10fBXz0hiJ8pVnHmV7kmyMbsskxL9i+5KgH4zb7E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kKh9cm10; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kKh9cm10"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08831C4CEF1;
	Tue, 26 Aug 2025 11:20:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756207239;
	bh=Qu37dA89Z1rTLHkH11U4P5sJro6VkYjjUWnBV6Q2qz4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kKh9cm10lhglU2xFwHzHD277uyC6Wqb9/MWMVDdm66AiIu0FgtH4ta3564p1Jh+Tc
	 tl/GQxdLzXK2A13WGflgK+5evQHRGVyb1oY09h41cLHlCNXjO27Ln3pEl53b5kyfXF
	 LnXlnOTmpkWc074SU7pklrEaJ3I5rCnrg4R+Xt3g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Richard Zhu <hongxing.zhu@nxp.com>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Frank Li <Frank.Li@nxp.com>
Subject: [PATCH 6.16 104/457] PCI: imx6: Delay link start until configfs start written
Date: Tue, 26 Aug 2025 13:06:28 +0200
Message-ID: <20250826110939.946909758@linuxfoundation.org>
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
@@ -1468,9 +1468,6 @@ static int imx_add_pcie_ep(struct imx_pc
 
 	pci_epc_init_notify(ep->epc);
 
-	/* Start LTSSM. */
-	imx_pcie_ltssm_enable(dev);
-
 	return 0;
 }
 


