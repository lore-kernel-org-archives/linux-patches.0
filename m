Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26BBD39BEA3;
	Tue, 16 Dec 2025 12:38:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765888685; cv=none; b=MzjQEnvGO9okvzMcBEZbKT93O+j7p49uP0oZrIbwXShyHCZcIq84VftHxt8prko/XtRGvdzPQ+cZQoC6Ojaj81z1ZysABQPA60UpKg9LbKz51RVsdA9pMuTb/Af/cpnnFxfQaHSpJY+aVmFvGZSCQwUv62gOuwzL7XXJogN0bw8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765888685; c=relaxed/simple;
	bh=FOab5xcxcPsl2ARJKGuecMbR1po6FPVgyDRjJvfpTk8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RmVWq8ZNd/9SSXN5qmDlqqUaHn65/SGLDUBOElLSbglJ+hBUzfLKK1tRzqYMDyNrptvuHuFOyHIm7AodSOztCwocyzGQMMfFdGFmX3rbQekRHfn+h9hc+JHpDxTMWWPGjAttQ0j8zVLCap8T7w1qn/dD0JS/uq/xUcr6VFeBwqU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vUJ+gJyG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vUJ+gJyG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A358C4CEF1;
	Tue, 16 Dec 2025 12:38:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765888685;
	bh=FOab5xcxcPsl2ARJKGuecMbR1po6FPVgyDRjJvfpTk8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vUJ+gJyGeyiLNL+8II4k/I1MvFNphwpYNTFNVywunK6UtmuVQ0G5iEWydFNhl5yEY
	 7K4HLhcQyfRX6jFzUX1R9FdY6XfyZeClkrn9gJNAePuz5osksTjWTmfuvw8nBIBqSn
	 3TBmkBHZIgBzVOCqXdMzuUzQg3KKbU8oMVu/LkFA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Thinh Nguyen <Thinh.Nguyen@synopsys.com>,
	Neal Gompa <neal@gompa.dev>,
	Sven Peter <sven@kernel.org>
Subject: [PATCH 6.18 608/614] usb: dwc3: dwc3_power_off_all_roothub_ports: Use ioremap_np when required
Date: Tue, 16 Dec 2025 12:16:15 +0100
Message-ID: <20251216111423.424104310@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111401.280873349@linuxfoundation.org>
References: <20251216111401.280873349@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sven Peter <sven@kernel.org>

commit 5ed9cc71432a8adf3c42223c935f714aac29901b upstream.

On Apple Silicon machines we can't use ioremap() / Device-nGnRE to map most
regions but must use ioremap_np() / Device-nGnRnE whenever
IORESOURCE_MEM_NONPOSTED is set. Make sure this is also done inside
dwc3_power_off_all_roothub_ports to prevent SErrors.

Fixes: 2d2a3349521d ("usb: dwc3: Add workaround for host mode VBUS glitch when boot")
Cc: stable@kernel.org
Acked-by: Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Reviewed-by: Neal Gompa <neal@gompa.dev>
Signed-off-by: Sven Peter <sven@kernel.org>
Link: https://patch.msgid.link/20251015-b4-aplpe-dwc3-v2-2-cbd65a2d511a@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/dwc3/host.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/usb/dwc3/host.c
+++ b/drivers/usb/dwc3/host.c
@@ -37,7 +37,10 @@ static void dwc3_power_off_all_roothub_p
 
 	/* xhci regs are not mapped yet, do it temporarily here */
 	if (dwc->xhci_resources[0].start) {
-		xhci_regs = ioremap(dwc->xhci_resources[0].start, DWC3_XHCI_REGS_END);
+		if (dwc->xhci_resources[0].flags & IORESOURCE_MEM_NONPOSTED)
+			xhci_regs = ioremap_np(dwc->xhci_resources[0].start, DWC3_XHCI_REGS_END);
+		else
+			xhci_regs = ioremap(dwc->xhci_resources[0].start, DWC3_XHCI_REGS_END);
 		if (!xhci_regs) {
 			dev_err(dwc->dev, "Failed to ioremap xhci_regs\n");
 			return;


