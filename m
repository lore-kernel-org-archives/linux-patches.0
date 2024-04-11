Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B72314430D;
	Thu, 11 Apr 2024 10:02:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712829779; cv=none; b=BuB8iDOQD3N2M1h36skWd74052fxTVTUEZARxATFVcZR/O7pkBdR2EH3xmqy+6QxzefYYAYvAbYkJs8MhQ6RCyibN8H8WgYsOh+ho1G5vg/wpnMcVaFbbgP47vFOK7TzlI+I6r0RkxiHZPpFMEyLVcPQw+2EPylAxCzmoTmqlK0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712829779; c=relaxed/simple;
	bh=Stb6TA6y6LKHy0EDi3ZPzVA9euzab6Ksow0uBkAtTxI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ERmji7svW5ebN1SQYWy94kO73rsWTZTBqrvqgmisoaiV3XYVXE6SuB+0nGBdjAiG+oHT9BbW7wqD+ric2+G+2h0sPu9AOHbiHQS6LscMaHmdf6uCvvZSeL4O0ygCnf7oiaYx3NS7cTnNgItfmYrWk6ZJjM+E4wcU+fz3ZM249Eg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PHBq61gC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PHBq61gC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3F48C433F1;
	Thu, 11 Apr 2024 10:02:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712829779;
	bh=Stb6TA6y6LKHy0EDi3ZPzVA9euzab6Ksow0uBkAtTxI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PHBq61gCEfObJ6QeHTIiFNkd12ORiTYZuvJNlkTEXBIUovCPmvMlZc9NdaUKanJj5
	 qRLRGuarcQsXXCwvlthtz7+oUy6XFrHLdt8/Ku1jb2PpE3dXqzfTT7BssQ57Lf/nXk
	 j80A96oAfwB9aht1RcaSHgaXov7K8P3Lbp4D69ts=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Minas Harutyunyan <Minas.Harutyunyan@synopsys.com>
Subject: [PATCH 4.19 102/175] usb: dwc2: host: Fix hibernation flow
Date: Thu, 11 Apr 2024 11:55:25 +0200
Message-ID: <20240411095422.640896437@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095419.532012976@linuxfoundation.org>
References: <20240411095419.532012976@linuxfoundation.org>
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

From: Minas Harutyunyan <Minas.Harutyunyan@synopsys.com>

commit 3c7b9856a82227db01a20171d2e24c7ce305d59b upstream.

Added to backup/restore registers HFLBADDR, HCCHARi, HCSPLTi,
HCTSIZi, HCDMAi and HCDMABi.

Fixes: 58e52ff6a6c3 ("usb: dwc2: Move register save and restore functions")
Fixes: d17ee77b3044 ("usb: dwc2: add controller hibernation support")
CC: stable@vger.kernel.org
Signed-off-by: Minas Harutyunyan <Minas.Harutyunyan@synopsys.com>
Link: https://lore.kernel.org/r/c2d10ee6098b9b009a8e94191e046004747d3bdd.1708945444.git.Minas.Harutyunyan@synopsys.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/dwc2/core.h |   12 ++++++++++++
 drivers/usb/dwc2/hcd.c  |   18 ++++++++++++++++--
 2 files changed, 28 insertions(+), 2 deletions(-)

--- a/drivers/usb/dwc2/core.h
+++ b/drivers/usb/dwc2/core.h
@@ -716,8 +716,14 @@ struct dwc2_dregs_backup {
  * struct dwc2_hregs_backup - Holds host registers state before
  * entering partial power down
  * @hcfg:		Backup of HCFG register
+ * @hflbaddr:		Backup of HFLBADDR register
  * @haintmsk:		Backup of HAINTMSK register
+ * @hcchar:		Backup of HCCHAR register
+ * @hcsplt:		Backup of HCSPLT register
  * @hcintmsk:		Backup of HCINTMSK register
+ * @hctsiz:		Backup of HCTSIZ register
+ * @hdma:		Backup of HCDMA register
+ * @hcdmab:		Backup of HCDMAB register
  * @hprt0:		Backup of HPTR0 register
  * @hfir:		Backup of HFIR register
  * @hptxfsiz:		Backup of HPTXFSIZ register
@@ -725,8 +731,14 @@ struct dwc2_dregs_backup {
  */
 struct dwc2_hregs_backup {
 	u32 hcfg;
+	u32 hflbaddr;
 	u32 haintmsk;
+	u32 hcchar[MAX_EPS_CHANNELS];
+	u32 hcsplt[MAX_EPS_CHANNELS];
 	u32 hcintmsk[MAX_EPS_CHANNELS];
+	u32 hctsiz[MAX_EPS_CHANNELS];
+	u32 hcidma[MAX_EPS_CHANNELS];
+	u32 hcidmab[MAX_EPS_CHANNELS];
 	u32 hprt0;
 	u32 hfir;
 	u32 hptxfsiz;
--- a/drivers/usb/dwc2/hcd.c
+++ b/drivers/usb/dwc2/hcd.c
@@ -5480,9 +5480,16 @@ int dwc2_backup_host_registers(struct dw
 	/* Backup Host regs */
 	hr = &hsotg->hr_backup;
 	hr->hcfg = dwc2_readl(hsotg, HCFG);
+	hr->hflbaddr = dwc2_readl(hsotg, HFLBADDR);
 	hr->haintmsk = dwc2_readl(hsotg, HAINTMSK);
-	for (i = 0; i < hsotg->params.host_channels; ++i)
+	for (i = 0; i < hsotg->params.host_channels; ++i) {
+		hr->hcchar[i] = dwc2_readl(hsotg, HCCHAR(i));
+		hr->hcsplt[i] = dwc2_readl(hsotg, HCSPLT(i));
 		hr->hcintmsk[i] = dwc2_readl(hsotg, HCINTMSK(i));
+		hr->hctsiz[i] = dwc2_readl(hsotg, HCTSIZ(i));
+		hr->hcidma[i] = dwc2_readl(hsotg, HCDMA(i));
+		hr->hcidmab[i] = dwc2_readl(hsotg, HCDMAB(i));
+	}
 
 	hr->hprt0 = dwc2_read_hprt0(hsotg);
 	hr->hfir = dwc2_readl(hsotg, HFIR);
@@ -5516,10 +5523,17 @@ int dwc2_restore_host_registers(struct d
 	hr->valid = false;
 
 	dwc2_writel(hsotg, hr->hcfg, HCFG);
+	dwc2_writel(hsotg, hr->hflbaddr, HFLBADDR);
 	dwc2_writel(hsotg, hr->haintmsk, HAINTMSK);
 
-	for (i = 0; i < hsotg->params.host_channels; ++i)
+	for (i = 0; i < hsotg->params.host_channels; ++i) {
+		dwc2_writel(hsotg, hr->hcchar[i], HCCHAR(i));
+		dwc2_writel(hsotg, hr->hcsplt[i], HCSPLT(i));
 		dwc2_writel(hsotg, hr->hcintmsk[i], HCINTMSK(i));
+		dwc2_writel(hsotg, hr->hctsiz[i], HCTSIZ(i));
+		dwc2_writel(hsotg, hr->hcidma[i], HCDMA(i));
+		dwc2_writel(hsotg, hr->hcidmab[i], HCDMAB(i));
+	}
 
 	dwc2_writel(hsotg, hr->hprt0, HPRT0);
 	dwc2_writel(hsotg, hr->hfir, HFIR);


