Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 366EB352087;
	Tue, 26 Aug 2025 14:31:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756218665; cv=none; b=gkXWE3laDs6IuMxAAhRsVFPUdH6M3Ma2Zj8NzTyoeuepwd+Eql8WxGpU+8h0BMm3l0fvRUiTxecZxkC12weONJicPPEuZPEUGVMciMkhQGay0hKLVPFswiLQ1IffaQqIvIC8Q4acnEe0TVdMqT6CkxiVKYDEYVjTX3VcKjglbvY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756218665; c=relaxed/simple;
	bh=PmUPmxSnDt8zgYT3O1q93Ut9546oJJKLcjT1iKSMrk0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mfW358xof01yZD4+px2ZFPnjJUPPqRd69NaeOvAJO6Q1y2qRWS5pEXYUHTW6pMb9lvMTluguUUkRXya8vKds68nZm7vX0y7qUtuW3RsJuG2plr5UHm2w/4Qqv2i3EmultwkD/V7IHYFVDlm3FzVmbZoeyBeq2zSjoWaEe3jMBaY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=u2g9h1ZU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="u2g9h1ZU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90677C4CEF1;
	Tue, 26 Aug 2025 14:31:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756218665;
	bh=PmUPmxSnDt8zgYT3O1q93Ut9546oJJKLcjT1iKSMrk0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=u2g9h1ZUMBwJ346kvfiBUuRmBoESaTfK2/ZLv03iJxPG9+ThnOx/nY63TOi1mhZyf
	 ujIqQKFmteLx4hpobrKO1HIna+XIOfVCHCJCumE48jNRL82cZAn5TvU3uv9aCh6ctk
	 PnJ0vbU74cGRFm2jdfvuUL1Oie5dRIMaeIO7git8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Alan Stern <stern@rowland.harvard.edu>,
	Mathias Nyman <mathias.nyman@linux.intel.com>
Subject: [PATCH 5.4 055/403] usb: hub: Fix flushing and scheduling of delayed work that tunes runtime pm
Date: Tue, 26 Aug 2025 13:06:21 +0200
Message-ID: <20250826110907.387888110@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110905.607690791@linuxfoundation.org>
References: <20250826110905.607690791@linuxfoundation.org>
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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/core/hub.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/usb/core/hub.c
+++ b/drivers/usb/core/hub.c
@@ -1315,11 +1315,12 @@ static void hub_activate(struct usb_hub
 
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
 
@@ -1373,6 +1374,7 @@ static void hub_quiesce(struct usb_hub *
 
 	/* Stop hub_wq and related activity */
 	del_timer_sync(&hub->irq_urb_retry);
+	flush_delayed_work(&hub->init_work);
 	usb_kill_urb(hub->urb);
 	if (hub->has_indicators)
 		cancel_delayed_work_sync(&hub->leds);


