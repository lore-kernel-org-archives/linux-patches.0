Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAC84246326;
	Tue, 29 Apr 2025 16:52:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745945568; cv=none; b=kG0GqnFs9OQ4QEm+n6mxXSsF02pTSA3nRGQ/xUTLJJUwisKAxzALE+xEqlvRwaEW80nO3y6p3DlYg1ZAe+IjZsuGUULhq2tUJ/zvdbkx6x4ofaAvOJtO2n25ALg2POG7ZMWQPdTRPLhp7BQd6P+kYz1QJ8wAiA1UwF2Tle1LQ4U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745945568; c=relaxed/simple;
	bh=ZKrnIPDzItLsnvncTpGTHTyLqwc7b40hkhwvN6SPIDI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=J4tSzCvJTkeFe+AObctmvUbv3zDaSHGd5QbdTAG6szZEG+SiViCYm3cFpGE/qHtroKTepOIfUywxlLD4TEvanw1sYf1LobVqqXn3bwBkrk7eo9bAI3Z213l1bF91mlgUiRBEQLozWLIAquCRDyFMu5+K5bvNAx/BinDor2e0SuM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yReTDcy/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yReTDcy/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 643D1C4CEE3;
	Tue, 29 Apr 2025 16:52:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745945568;
	bh=ZKrnIPDzItLsnvncTpGTHTyLqwc7b40hkhwvN6SPIDI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yReTDcy/7mV+sfSV9GeEDPTlSeJW5VYJ/cbGgQSVjEdXn5OhOAN2s0ARUMuqihvX3
	 B5OcnuiWYeZZfAmsNG6ExV+u9zzLPtQiO8D8LW/HNNTWeeFoIxitjVmN5Pn4gAdJiH
	 WoD5RBS5QQkaZ056A+eVi1R3oAOQ6pfIaVZw+7hA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Martin Kepplinger <martin.kepplinger@puri.sm>,
	Felipe Balbi <balbi@kernel.org>
Subject: [PATCH 5.4 117/179] usb: dwc3: support continuous runtime PM with dual role
Date: Tue, 29 Apr 2025 18:40:58 +0200
Message-ID: <20250429161054.137820769@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161049.383278312@linuxfoundation.org>
References: <20250429161049.383278312@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Martin Kepplinger <martin.kepplinger@puri.sm>

commit c2cd3452d5f8b66d49a73138fba5baadd5b489bd upstream.

The DRD module calls dwc3_set_mode() on role switches, i.e. when a device is
being plugged in. In order to support continuous runtime power management when
plugging in / unplugging a cable, we need to call pm_runtime_get_sync() in
this path.

Signed-off-by: Martin Kepplinger <martin.kepplinger@puri.sm>
Signed-off-by: Felipe Balbi <balbi@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/dwc3/core.c |   11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

--- a/drivers/usb/dwc3/core.c
+++ b/drivers/usb/dwc3/core.c
@@ -122,17 +122,19 @@ static void __dwc3_set_mode(struct work_
 	if (dwc->dr_mode != USB_DR_MODE_OTG)
 		return;
 
+	pm_runtime_get_sync(dwc->dev);
+
 	if (dwc->current_dr_role == DWC3_GCTL_PRTCAP_OTG)
 		dwc3_otg_update(dwc, 0);
 
 	if (!dwc->desired_dr_role)
-		return;
+		goto out;
 
 	if (dwc->desired_dr_role == dwc->current_dr_role)
-		return;
+		goto out;
 
 	if (dwc->desired_dr_role == DWC3_GCTL_PRTCAP_OTG && dwc->edev)
-		return;
+		goto out;
 
 	switch (dwc->current_dr_role) {
 	case DWC3_GCTL_PRTCAP_HOST:
@@ -196,6 +198,9 @@ static void __dwc3_set_mode(struct work_
 		break;
 	}
 
+out:
+	pm_runtime_mark_last_busy(dwc->dev);
+	pm_runtime_put_autosuspend(dwc->dev);
 }
 
 void dwc3_set_mode(struct dwc3 *dwc, u32 mode)


