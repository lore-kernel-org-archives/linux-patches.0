Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C2F5343D75;
	Tue, 16 Dec 2025 11:36:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765884988; cv=none; b=goTmxoel4HXt0xWn/EwcMaZsjZIIMJV+U20KOHDnl3+dbsqj/+TWc6XX9BPBlgONPEcQ/CbFiqd3ixfoMZTbkgrHoSEeNow2WRLzU3tbCOgAkzssdFfZAX9mWvnI349FVgBpYfMcSuSVXcF4WiktcPVV7sz9j83chHwFlMvWhLQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765884988; c=relaxed/simple;
	bh=ssDH+ed1a79u8Rw9i8jDLniV9xy5jQGv1Khfka3I/Do=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hiLLe1DwBMpAlDDElemNoib5BJkromD6f3sHcvRy7at1kuCK9SowUj631jwF8/BhBMG/ng8kyEKeB2ZCF+8nzi2zo4yOGq1HlX0ZZ8fPhuKEbVAIeQ9YqvrA2TQNqpa5iY4dT+Xi1CZqMqXdP/WbjRDbvzh+1tLvrIEt0Med7nA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KzR1NwtK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KzR1NwtK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A237FC4CEF5;
	Tue, 16 Dec 2025 11:36:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765884988;
	bh=ssDH+ed1a79u8Rw9i8jDLniV9xy5jQGv1Khfka3I/Do=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KzR1NwtKziSdAtj05aYh3zz5IEHYzjb3ltodXth+Hxfl6iARCgjVxpwBWLQRSgoMw
	 9aCNAKFvzpf2ypUynpTizJE3YJNzimfQCCqnVsBhRuPgTzmhFX78D6GteFlhUXY7Vs
	 HHHC8w+tv9yIYCk7u66pPm/uuoyInWxSxAMN1ciE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Thinh Nguyen <Thinh.Nguyen@synopsys.com>,
	Neal Gompa <neal@gompa.dev>,
	Sven Peter <sven@kernel.org>
Subject: [PATCH 6.12 352/354] usb: dwc3: dwc3_power_off_all_roothub_ports: Use ioremap_np when required
Date: Tue, 16 Dec 2025 12:15:19 +0100
Message-ID: <20251216111333.661199855@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111320.896758933@linuxfoundation.org>
References: <20251216111320.896758933@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
 
 	/* xhci regs is not mapped yet, do it temperary here */
 	if (dwc->xhci_resources[0].start) {
-		xhci_regs = ioremap(dwc->xhci_resources[0].start, DWC3_XHCI_REGS_END);
+		if (dwc->xhci_resources[0].flags & IORESOURCE_MEM_NONPOSTED)
+			xhci_regs = ioremap_np(dwc->xhci_resources[0].start, DWC3_XHCI_REGS_END);
+		else
+			xhci_regs = ioremap(dwc->xhci_resources[0].start, DWC3_XHCI_REGS_END);
 		if (!xhci_regs) {
 			dev_err(dwc->dev, "Failed to ioremap xhci_regs\n");
 			return;


