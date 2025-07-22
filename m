Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8191AA32;
	Tue, 22 Jul 2025 14:05:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753193152; cv=none; b=RRXaLyiTmAbPsj2Prpw2budD+rkR6+v5sQUVCbQEK1qBrJeZgRQQhKVvJL0eB9KmQmJ3sYLedSb5b/flfUkrhv75NHHc3mmtKsEpgXlwrfKtfSZbLdVguIrWlwrOuEnzQK60CnPeuDW4ip7WTCNbMMm+V8624K4GiQHx7QN0vRA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753193152; c=relaxed/simple;
	bh=z5JX+T0tIC0sgC8Vn80Cyti5/AbdTLjDGzsHRZgH+xU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SazJJ/Dt6EckvrlsUagZ0G1xgjz4YwC/l6wPUCwfGAlDfwOCCeerq014Pge44APv/R2YcNZ4kdlug6isxWQ9bkGxjOFTe5RDTFjH0kM9tQU6ANgaItmR5X1r/Y8c00qaLWliXpPBCO79u9FYnnTG0xKPS+GcY+OSjKxvWzi6g4U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Cr5sc2Bj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Cr5sc2Bj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00DFFC4CEEB;
	Tue, 22 Jul 2025 14:05:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753193152;
	bh=z5JX+T0tIC0sgC8Vn80Cyti5/AbdTLjDGzsHRZgH+xU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Cr5sc2BjKvUmFcGv7vrGoKAIIhJ/UEY7kZ7o3cVC7zD+QNEIega5ze3Vzhp4lkanC
	 fMwNgJdeDU5J2nlVEPV+cTh0So2n4ze20Xq51NgXmLgDNrwi9aCvXd574ocdSB9oxz
	 q7Cwwv040CkHl0lNTUKydVdy46L7zcsRDykKlxIQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Alan Stern <stern@rowland.harvard.edu>,
	Mathias Nyman <mathias.nyman@linux.intel.com>
Subject: [PATCH 6.12 144/158] usb: hub: Fix flushing and scheduling of delayed work that tunes runtime pm
Date: Tue, 22 Jul 2025 15:45:28 +0200
Message-ID: <20250722134346.093256034@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250722134340.596340262@linuxfoundation.org>
References: <20250722134340.596340262@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mathias Nyman <mathias.nyman@linux.intel.com>

commit a49e1e2e785fb3621f2d748581881b23a364998a upstream.

Delayed work to prevent USB3 hubs from runtime-suspending immediately
after resume was added in commit 8f5b7e2bec1c ("usb: hub: fix detection
of high tier USB3 devices behind suspended hubs").

This delayed work needs be flushed if system suspends, or hub needs to
be quiesced for other reasons right after resume. Not flushing it
triggered issues on QC SC8280XP CRD board during suspend/resume testing.

Fix it by flushing the delayed resume work in hub_quiesce()

The delayed work item that allow hub runtime suspend is also scheduled
just before calling autopm get. Alan pointed out there is a small risk
that work is run before autopm get, which would call autopm put before
get, and mess up the runtime pm usage order.
Swap the order of work sheduling and calling autopm get to solve this.

Cc: stable <stable@kernel.org>
Fixes: 8f5b7e2bec1c ("usb: hub: fix detection of high tier USB3 devices behind suspended hubs")
Reported-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Closes: https://lore.kernel.org/linux-usb/acaaa928-832c-48ca-b0ea-d202d5cd3d6c@oss.qualcomm.com
Reported-by: Alan Stern <stern@rowland.harvard.edu>
Closes: https://lore.kernel.org/linux-usb/c73fbead-66d7-497a-8fa1-75ea4761090a@rowland.harvard.edu
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Link: https://lore.kernel.org/r/20250626130102.3639861-2-mathias.nyman@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/core/hub.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/usb/core/hub.c
+++ b/drivers/usb/core/hub.c
@@ -1358,11 +1358,12 @@ static void hub_activate(struct usb_hub
 
 	if (type == HUB_RESUME && hub_is_superspeed(hub->hdev)) {
 		/* give usb3 downstream links training time after hub resume */
+		usb_autopm_get_interface_no_resume(
+			to_usb_interface(hub->intfdev));
+
 		INIT_DELAYED_WORK(&hub->init_work, hub_post_resume);
 		queue_delayed_work(system_power_efficient_wq, &hub->init_work,
 				   msecs_to_jiffies(USB_SS_PORT_U0_WAKE_TIME));
-		usb_autopm_get_interface_no_resume(
-			to_usb_interface(hub->intfdev));
 		return;
 	}
 
@@ -1416,6 +1417,7 @@ static void hub_quiesce(struct usb_hub *
 
 	/* Stop hub_wq and related activity */
 	del_timer_sync(&hub->irq_urb_retry);
+	flush_delayed_work(&hub->init_work);
 	usb_kill_urb(hub->urb);
 	if (hub->has_indicators)
 		cancel_delayed_work_sync(&hub->leds);


