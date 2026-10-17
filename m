Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6478938F658;
	Sat, 17 Oct 2026 17:10:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792257052; cv=none; b=eevOYxkBzCoXQcTeduz/SubhY4oAUuXtJdJ54ZTgjTEo3LieWT2OeUDpblTf/ncGlj/zL8emo5uTpngsl6GHTxPvLIvgrFEr9hiqVTKEucg00IVUTrM7Yl5LY+gGZAoQLyP6x0OFAN57FRAXEW6HAuk679/JiqW1zvw4pVTmAYo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792257052; c=relaxed/simple;
	bh=93W2YDmYkdy8MFTdOw9brjlrueaxXS2ooY0BfgGOpMs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HZlgLLbwh7nXglAvYtbQq81AMyZCaN/dFoLld7d0ohVzdDhPmo344Zgoa4fIfPEcTH71Qjdc4T0qIlA0RFapj+Gn1Lhwg160+bYTvYIyY8Yvxxx2cMILucI2DtwSN4DnojnuwFz5/XW6FgNYjMpfQEXT0QJ/5wpLeDOk+K9v91Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RwQUlFJd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RwQUlFJd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A791F1F000C4;
	Sat, 17 Oct 2026 17:10:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792257051;
	bh=FMhR3MWH2CvDol1z0/wtlS0/QFpJB7/29RWbXqMl1W4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RwQUlFJdp5tgUgKNTnq1ZjofnOHZUyjUIT+DR0hbpYa++bsekcdF9qeRPUMeOg2Ag
	 XfulbFYCNhZGbXfhAC/Dk/1HUZ5nedK61Iro/tIDidNFAJ2Du8C+HCVffipjnrPNvW
	 7wPkewgYOTsMtgcFkdU/8/vmsaudb2qYWwPqfnbc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Runyu Xiao <runyu.xiao@seu.edu.cn>,
	Thinh Nguyen <Thinh.Nguyen@synopsys.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0393/1674] USB: dwc2: shut down wakeup timer before freeing HCD state
Date: Sat, 17 Oct 2026 17:44:25 +0200
Message-ID: <20261017160441.195911944@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Runyu Xiao <runyu.xiao@seu.edu.cn>

[ Upstream commit fd772af9512cdecb83de34a461801533828e77fd ]

dwc2_wakeup_detected() accesses the DWC2 host state and can rearm the
wakeup timer.  dwc2_hcd_free() currently deletes the timer only after
freeing host-owned state, and timer_delete() does not synchronize a
callback or prevent it from being queued again.

Stop and shut down the timer in dwc2_hcd_release(), before the HCD
resources are freed.  This covers both the HCD initialization error path
and normal HCD removal.

Fixes: 7359d482eb4d ("staging: HCD files for the DWC2 driver")
Cc: stable <stable@kernel.org>
Assisted-by: Codex:GPT-5
Signed-off-by: Runyu Xiao <runyu.xiao@seu.edu.cn>
Reviewed-by: Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Link: https://patch.msgid.link/20260904065323.4047026-1-runyu.xiao@seu.edu.cn
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
[ sashal: Adapted the timer_delete() removal to the existing del_timer() call. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/dwc2/hcd.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/usb/dwc2/hcd.c b/drivers/usb/dwc2/hcd.c
index e0f84726f4b1d..5e71094a22b2f 100644
--- a/drivers/usb/dwc2/hcd.c
+++ b/drivers/usb/dwc2/hcd.c
@@ -5082,14 +5082,13 @@ static void dwc2_hcd_free(struct dwc2_hsotg *hsotg)
 	}
 
 	cancel_work_sync(&hsotg->phy_reset_work);
-
-	del_timer(&hsotg->wkp_timer);
 }
 
 static void dwc2_hcd_release(struct dwc2_hsotg *hsotg)
 {
 	/* Turn off all host-specific interrupts */
 	dwc2_disable_host_interrupts(hsotg);
+	timer_shutdown_sync(&hsotg->wkp_timer);
 
 	dwc2_hcd_free(hsotg);
 }
-- 
2.53.0



