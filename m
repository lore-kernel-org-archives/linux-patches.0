Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 687AC2EBDD9;
	Tue, 22 Jul 2025 14:14:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753193694; cv=none; b=Ck3coDSJ4JICdi1MXhtOQgEUk0KnPvhqmFWr0BkO0uYBj1B/eVBu/n1nYAzDI9NVeSsnN+zGrBjw5Hse5kgx4+mQJi0ghVJoZjZWlMSEyjWtqXYnRHXAE6gGNJYojtQ7XPjA7yzoHUCg3Fc1X+YgruUtraE1xNAcCIp9vmXcPuU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753193694; c=relaxed/simple;
	bh=okB9wVqVd/mOlZjPbC8z7gbqyW+pxRIvMguYGiMnw5Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qkYPLfLITej4loh3m8joIfxyJ69DXkGsuzcGi1Nzj119Sovh+7O8UHu0DKzcrQJi7jZ7tQUyhxP0X2U9HD8xwfo01VCR2HVCS0+qeURSJnqPhnd+7b1kNJQbPmBPJmfH2Lrpx0BBkcy7O6H6FtQ3vOSYqyiT/hcoLFdy890F1Qk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0+3UJbSe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0+3UJbSe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE64BC4CEEB;
	Tue, 22 Jul 2025 14:14:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753193694;
	bh=okB9wVqVd/mOlZjPbC8z7gbqyW+pxRIvMguYGiMnw5Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0+3UJbSegXG3fZJB57s+42k/pM4h/XQoqUDQaJljzvg+Fv5x92S1lKgAxoVrrDGFB
	 dDARQeUtnarTnHAX/Z+u9Fv3Tg4058D6vgVLHjU5hCeCvDJm4XkwzrwUR2ZFJ/3qAw
	 cGPblYH1f3sVOyqqOEnWIE99/egXQ/CFGPPvewv8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Alan Stern <stern@rowland.harvard.edu>,
	Mathias Nyman <mathias.nyman@linux.intel.com>
Subject: [PATCH 6.15 168/187] usb: hub: Fix flushing and scheduling of delayed work that tunes runtime pm
Date: Tue, 22 Jul 2025 15:45:38 +0200
Message-ID: <20250722134352.026834875@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250722134345.761035548@linuxfoundation.org>
References: <20250722134345.761035548@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1359,11 +1359,12 @@ static void hub_activate(struct usb_hub
 
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
 
@@ -1417,6 +1418,7 @@ static void hub_quiesce(struct usb_hub *
 
 	/* Stop hub_wq and related activity */
 	timer_delete_sync(&hub->irq_urb_retry);
+	flush_delayed_work(&hub->init_work);
 	usb_kill_urb(hub->urb);
 	if (hub->has_indicators)
 		cancel_delayed_work_sync(&hub->leds);


