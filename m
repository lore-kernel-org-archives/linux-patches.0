Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CCBB3D9DCE;
	Fri,  9 Oct 2026 14:39:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791556747; cv=none; b=MwFGjhAZ/h9e9pGcbqk7gdSU5nz4xHyNR9JwIM5UIuONNnHjpM3D5S1Z3XuSzY+VYMfPilNq+oSGPJjqKXNkVfehoUs+zhnYApGM3unaa7/ETejxc+m003UNsYC7jUPZBIt6NHJb0wtfiKzEluUONdFzS82RS4o1IilEKUKJPSs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791556747; c=relaxed/simple;
	bh=7SuAL61r6WA0JZdlZPqhmQTmakZ05n+19IctygnVGKI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RLv8UOf1GQteyrjJr1Mg5Em7BfDlFmoqq+0g7j5Ek7Bu89QIbQUzMPt25H7owzdg6Ws3sQwEzH7M/2fKbFMNYPrXkP78kSSQtZUaVZzuWzrnBX1ZqbLp8hBymNSOVyaBT/mgGMXti5QERlMLrzsccGGOdELhlrHC6Tv+OjjAkSY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Y5W3zFM7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Y5W3zFM7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBD721F000FF;
	Fri,  9 Oct 2026 14:39:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791556746;
	bh=QPTVch4WXT/spCbks1kqiC0GRDTWtGfwZ5IQcsJeQLY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Y5W3zFM7X3rQP0CIhkLU7ZO+lGhUdGP/yDqphAYHyNwHEsbWhGeHVOklPWcDpvNRD
	 +IHdDQ4aXP4T6WCIlMRmAUTqOrNDmcsShmtOuHN1lf0lQbiCamIxVQiQ1EdhiqTQTu
	 CB31L7pkxu57RHxE/sQB8CGJ7a6iIFZDZGxtaA2E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Runyu Xiao <runyu.xiao@seu.edu.cn>,
	Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Subject: [PATCH 7.2 226/428] USB: dwc2: shut down wakeup timer before freeing HCD state
Date: Fri,  9 Oct 2026 16:09:23 +0200
Message-ID: <20261009140951.081017451@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140946.008206689@linuxfoundation.org>
References: <20261009140946.008206689@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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


