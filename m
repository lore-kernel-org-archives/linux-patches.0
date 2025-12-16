Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3C373596EC;
	Tue, 16 Dec 2025 12:04:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765886657; cv=none; b=JaozvouBoMtmK565gBtb9klUzCAxeNykqEq24iPWrw6w13DbOCu0SEplyJobZxZlxB7378xMrhz2MUDs66TLFhn4iSizNGyWH8M1xlBbGFinoeWcqWq3I6jM/uWfOGd09Qvqoib+9CzeNMDXyzGgGNwyX+Fg4G7iIq8fylnWLNE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765886657; c=relaxed/simple;
	bh=m/Q+bg8x9Z9mnDF4n9b6qg41dKL/+mt48r/LOiganVk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Tpq/ivzbNloexpyvcoDAKXp+zZQRCwV0W8DMVuMykB+KQzTDAy4hlva5HW2SNF5K+a5aQuujiUt1VY5rHUb2+mxZEiCcESogobiiOdwRoZ+kdce0zB1Szx7VEnXRetzPIamQtxCdM8uSdcy0fwelMMeScmT+vgO/V1APfMfh1Tk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=URAi4g0a; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="URAi4g0a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79320C4CEF1;
	Tue, 16 Dec 2025 12:04:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765886656;
	bh=m/Q+bg8x9Z9mnDF4n9b6qg41dKL/+mt48r/LOiganVk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=URAi4g0aX4+5MLLEbGOomeJBYQ7BEkhP6V0dssvcM750btgM9zagT22u5L3I9Uh4N
	 1c8D5sE29A+WBf79UcuT3MzkQNsdntaj40V9OH4WEGlEyWXSPMpxcDG8/DZPCpfwB3
	 1LfL+oyOjFaYPrj8Wqq90gN07pRiTVOa59S4evtc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Thinh Nguyen <Thinh.Nguyen@synopsys.com>,
	Neal Gompa <neal@gompa.dev>,
	Sven Peter <sven@kernel.org>
Subject: [PATCH 6.17 502/507] usb: dwc3: dwc3_power_off_all_roothub_ports: Use ioremap_np when required
Date: Tue, 16 Dec 2025 12:15:43 +0100
Message-ID: <20251216111403.624369763@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111345.522190956@linuxfoundation.org>
References: <20251216111345.522190956@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

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


