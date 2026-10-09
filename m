Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5911D3BD64D;
	Fri,  9 Oct 2026 14:28:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791556139; cv=none; b=BgJ56K4zaJWPMMu3dqOWLx+yyPM6T4OTBQ9ueUqKCSHMRjRPc9gnOVId8BW/LAEpRo0NvxXZLtoRHh/FIhGLUM5puWxWoZuI1hOC4KfYrUvsVqj3fqv5bp0D6zvNPXEGi/U+hUn963YUQq0ota3xKGRacgfU1vS45TVYxLk/4Xk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791556139; c=relaxed/simple;
	bh=ZeKs6W9CRNOEqaEDYZPIalxG9d+tjYuLVzz2BCK/R8I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uHgw4FAGF4Js8wiMrKHrKbgJBwzq5Y0POMd15F4W6xDqnMsQBaEJA0WR0Fzii2H7SE9XaNv7dvKUt16tz/TQORZPLt3P3CbVYmO4Mn0r9Z/Olywmt8eH1WfPe4hlJdFBDC2XUiSDDPlL55dbnRxyQSmRnGoaHHNARRmP73SIjGQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wgETlWSp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wgETlWSp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71ED71F000FF;
	Fri,  9 Oct 2026 14:28:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791556138;
	bh=AWIGzNPlmKwJ76rh9j2aTjNtflRmQN42UPSyi9dl+jM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wgETlWSpLMFsooP7Q5rxHdlWNtRvRzNE3Uuzj6um8bEyRfe1VOMHI4HHwdcO0ilVC
	 zClVkKdNEVxmMDtzvPSGdXuSk384//0i0NuCaLltUpimUOUfSS1zM09IhzI837KrJb
	 ocVcwf7HOo3J5OUgRT0idvygj0e+3veDbRXq0FVY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Runyu Xiao <runyu.xiao@seu.edu.cn>,
	Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Subject: [PATCH 6.18 180/403] USB: dwc2: shut down wakeup timer before freeing HCD state
Date: Fri,  9 Oct 2026 16:09:01 +0200
Message-ID: <20261009140956.328752632@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140952.119038291@linuxfoundation.org>
References: <20261009140952.119038291@linuxfoundation.org>
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

From: Runyu Xiao <runyu.xiao@seu.edu.cn>

commit fd772af9512cdecb83de34a461801533828e77fd upstream.

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
---
 drivers/usb/dwc2/hcd.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/usb/dwc2/hcd.c
+++ b/drivers/usb/dwc2/hcd.c
@@ -5082,14 +5082,13 @@ static void dwc2_hcd_free(struct dwc2_hs
 	}
 
 	cancel_work_sync(&hsotg->phy_reset_work);
-
-	timer_delete(&hsotg->wkp_timer);
 }
 
 static void dwc2_hcd_release(struct dwc2_hsotg *hsotg)
 {
 	/* Turn off all host-specific interrupts */
 	dwc2_disable_host_interrupts(hsotg);
+	timer_shutdown_sync(&hsotg->wkp_timer);
 
 	dwc2_hcd_free(hsotg);
 }


