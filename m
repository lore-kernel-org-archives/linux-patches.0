Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8710B18EB1;
	Sat,  3 Feb 2024 04:14:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933675; cv=none; b=uZ2khqQgiH+8fCKlIamHOPgfC6ogUt5qIK5VDhh9xL6cGEbwcPMVwcAo4yooMzqFvV3zaVR2ZgEd7II/FLqhwQ1azCyZKp4IWOIQG6peWNPLcLyBDdHKb7/rqbEIjQV3nEMJVrw1XaYwh5LRo1J2IjCo8bGi2xePPqdOmosGZNA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933675; c=relaxed/simple;
	bh=ocEDrnDlomAadB7ap2ZEMCby0kOwHARLFKDJfyrmokM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D4rTbbVe57/PgfRPNlTI6pp1/za/nbJqOoDDPjPm3HCHFpPorripnPH0EVlQb0dp4y2TdZNDrCy6WfFUhCza9EyAD1tXq5vDZShBp0je+rRPhV+ZQyHMcsoA/+ngFV8jL4DrZ9lHaYk4adovVNFes8mdZImbhc/tYroSCKGcYlA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nkGRe/RL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nkGRe/RL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F30AC433C7;
	Sat,  3 Feb 2024 04:14:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933675;
	bh=ocEDrnDlomAadB7ap2ZEMCby0kOwHARLFKDJfyrmokM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nkGRe/RLOl3QwR3ZLgZSR5mgoZPs6SsP+hDNPb8rA+5dYdhNK5aT10LYagWrO9C1W
	 TIToxZFnlssRH09DnBFY41sFTudtdTMULq3Qk9Nis8/P0YtVLO/fDMWA6lViGtQ2uH
	 e1eKJ5jd4+jerFX7UHozPrPpXPfbL9emu0/qFCNo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yinbo Zhu <zhuyinbo@loongson.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 243/322] usb: xhci-plat: fix usb disconnect issue after s4
Date: Fri,  2 Feb 2024 20:05:40 -0800
Message-ID: <20240203035407.030083720@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035359.041730947@linuxfoundation.org>
References: <20240203035359.041730947@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yinbo Zhu <zhuyinbo@loongson.cn>

[ Upstream commit 6d6887c42e946f43bed2e64571a40c8476a1e4a9 ]

The xhci retaining bogus hardware states cause usb disconnect devices
connected before hibernation(s4) and refer to the commit 'f3d478858be
("usb: ohci-platform: fix usb disconnect issue after s4")' which set
flag "hibernated" as true when resume-from-hibernation and that the
drivers will reset the hardware to get rid of any existing state and
make sure resume from hibernation re-enumerates everything for xhci.

Signed-off-by: Yinbo Zhu <zhuyinbo@loongson.cn>
Link: https://lore.kernel.org/r/20231228071113.1719-1-zhuyinbo@loongson.cn
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/host/xhci-plat.c | 23 +++++++++++++++++++----
 1 file changed, 19 insertions(+), 4 deletions(-)

diff --git a/drivers/usb/host/xhci-plat.c b/drivers/usb/host/xhci-plat.c
index 732cdeb73920..f0853c4478f5 100644
--- a/drivers/usb/host/xhci-plat.c
+++ b/drivers/usb/host/xhci-plat.c
@@ -433,7 +433,7 @@ void xhci_plat_remove(struct platform_device *dev)
 }
 EXPORT_SYMBOL_GPL(xhci_plat_remove);
 
-static int __maybe_unused xhci_plat_suspend(struct device *dev)
+static int xhci_plat_suspend(struct device *dev)
 {
 	struct usb_hcd	*hcd = dev_get_drvdata(dev);
 	struct xhci_hcd	*xhci = hcd_to_xhci(hcd);
@@ -461,7 +461,7 @@ static int __maybe_unused xhci_plat_suspend(struct device *dev)
 	return 0;
 }
 
-static int __maybe_unused xhci_plat_resume(struct device *dev)
+static int xhci_plat_resume_common(struct device *dev, struct pm_message pmsg)
 {
 	struct usb_hcd	*hcd = dev_get_drvdata(dev);
 	struct xhci_hcd	*xhci = hcd_to_xhci(hcd);
@@ -483,7 +483,7 @@ static int __maybe_unused xhci_plat_resume(struct device *dev)
 	if (ret)
 		goto disable_clks;
 
-	ret = xhci_resume(xhci, PMSG_RESUME);
+	ret = xhci_resume(xhci, pmsg);
 	if (ret)
 		goto disable_clks;
 
@@ -502,6 +502,16 @@ static int __maybe_unused xhci_plat_resume(struct device *dev)
 	return ret;
 }
 
+static int xhci_plat_resume(struct device *dev)
+{
+	return xhci_plat_resume_common(dev, PMSG_RESUME);
+}
+
+static int xhci_plat_restore(struct device *dev)
+{
+	return xhci_plat_resume_common(dev, PMSG_RESTORE);
+}
+
 static int __maybe_unused xhci_plat_runtime_suspend(struct device *dev)
 {
 	struct usb_hcd  *hcd = dev_get_drvdata(dev);
@@ -524,7 +534,12 @@ static int __maybe_unused xhci_plat_runtime_resume(struct device *dev)
 }
 
 const struct dev_pm_ops xhci_plat_pm_ops = {
-	SET_SYSTEM_SLEEP_PM_OPS(xhci_plat_suspend, xhci_plat_resume)
+	.suspend = pm_sleep_ptr(xhci_plat_suspend),
+	.resume = pm_sleep_ptr(xhci_plat_resume),
+	.freeze = pm_sleep_ptr(xhci_plat_suspend),
+	.thaw = pm_sleep_ptr(xhci_plat_resume),
+	.poweroff = pm_sleep_ptr(xhci_plat_suspend),
+	.restore = pm_sleep_ptr(xhci_plat_restore),
 
 	SET_RUNTIME_PM_OPS(xhci_plat_runtime_suspend,
 			   xhci_plat_runtime_resume,
-- 
2.43.0



