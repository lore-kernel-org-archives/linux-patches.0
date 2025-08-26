Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16BF518DB01;
	Tue, 26 Aug 2025 13:39:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756215593; cv=none; b=HzyKf3djRQjp64p/W89Ko9pCMlsYqF4/TRxaBcCYRppLDc9CBz4wKcYWMnxA+BKeq+OyptEou+QJUK0nnyWRyiQhmjLayGkoK0YUtB2X6l4pqciQ6a7zyaO0apjLeLx5DO/s8Mgy+6a6DeNdW1oao8m07ajpjPY9ob/ViftpnDs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756215593; c=relaxed/simple;
	bh=/gSFB6x0y6QW8FvlvnAcb05zNe0cPthQwtRcMG/MR2Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HxtY1zVphjpmkjyNJN7AWbBpcw5T0JvDQGMnAnERrFzUpG5xLONM0zo522sMnJkAVzifMfqOr39qhTP05RIcQG8/ps5gAZ+QqCHQnDkPLzJdEM45IgiZB5xuysXDb3idTgAYEzyPu/p9T4uJFCMz5WiJIQZXangmBzSk0T3jrrg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=J3sZvmEv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="J3sZvmEv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94414C4CEF1;
	Tue, 26 Aug 2025 13:39:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756215592;
	bh=/gSFB6x0y6QW8FvlvnAcb05zNe0cPthQwtRcMG/MR2Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=J3sZvmEv8RDNL580pG9TxjoknafQ9SoOQzeiSXBKrPxaWhfIP+sURABE25vcHHvZv
	 46uOPny0HWiVFXcAHFwiSyIO6cjafZc3cCTy7oCIG2zAaWd+5Cl7vE7e1HtAkyKaCS
	 e0WF+Y13lNgfrCJUrvRZNYp/0lw5wxr+nX28IPhM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Alan Stern <stern@rowland.harvard.edu>,
	Mathias Nyman <mathias.nyman@linux.intel.com>
Subject: [PATCH 5.15 062/644] usb: hub: Fix flushing and scheduling of delayed work that tunes runtime pm
Date: Tue, 26 Aug 2025 13:02:33 +0200
Message-ID: <20250826110948.037674477@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110946.507083938@linuxfoundation.org>
References: <20250826110946.507083938@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1316,11 +1316,12 @@ static void hub_activate(struct usb_hub
 
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
 
@@ -1374,6 +1375,7 @@ static void hub_quiesce(struct usb_hub *
 
 	/* Stop hub_wq and related activity */
 	del_timer_sync(&hub->irq_urb_retry);
+	flush_delayed_work(&hub->init_work);
 	usb_kill_urb(hub->urb);
 	if (hub->has_indicators)
 		cancel_delayed_work_sync(&hub->leds);


