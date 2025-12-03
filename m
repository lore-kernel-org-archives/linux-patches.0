Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 329E515ADB4;
	Wed,  3 Dec 2025 15:47:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764776825; cv=none; b=tL864vu1BtGEMtRFd/rAOwakTH7c+phUqkkhWeYF7JkkBok9q2hWJTM+cQlBl0IX4WQ1SKT0ZkZYuwqqhq7In/MnZAGh2ncl6Ko7ERiZH4KSzo7Xx1GsiE34RE5LboaU5xyJ1wHSSMMnH/ZnPiPRTeUnDmnGh7OV157ItSQ2NAw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764776825; c=relaxed/simple;
	bh=6udfINIVTAUx9sbLisajiNBNad4mkDxN0onYR7XVFGQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UHQ8YGpOArfB7IJ1TTFY5A2qd+7B8VpRWdlKmKZj8GCNfwXanrXC7AoclwdkMJ13BeNMKd4nedTTWhZKYwpD4XwNZ44qwPoefrxJnioWJZK89ndqQGrPmpsWPrbDD3wXfhQ1/xCbCE1ZRRDbo/mh1hXTnlZRiFheccTQY0mkAYM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=v9tWH4hV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="v9tWH4hV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACA03C4CEF5;
	Wed,  3 Dec 2025 15:47:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764776825;
	bh=6udfINIVTAUx9sbLisajiNBNad4mkDxN0onYR7XVFGQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=v9tWH4hVmWTMwdzClnOSxRiywMdmnBBfP1o4VDloTCEmta03mYSRds+K2pS6gEIZu
	 aWBgWuATWL0SapUrIHxQtkd7/T2FkM0tJVyxZkGSGaTQq8e971jXOJ3HPOgbNMODOk
	 3JzKyKN0L0d3jDkYbGlm0NlyfXi4jAYADPokxQ24=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Yu Chen <chenyu45@xiaomi.com>,
	Owen Gu <guhuinan@xiaomi.com>,
	Oliver Neukum <oneukum@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 298/300] usb: uas: fix urb unmapping issue when the uas device is remove during ongoing data transfer
Date: Wed,  3 Dec 2025 16:28:22 +0100
Message-ID: <20251203152411.662476099@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152400.447697997@linuxfoundation.org>
References: <20251203152400.447697997@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Owen Gu <guhuinan@xiaomi.com>

[ Upstream commit 26d56a9fcb2014b99e654127960aa0a48a391e3c ]

When a UAS device is unplugged during data transfer, there is
a probability of a system panic occurring. The root cause is
an access to an invalid memory address during URB callback handling.
Specifically, this happens when the dma_direct_unmap_sg() function
is called within the usb_hcd_unmap_urb_for_dma() interface, but the
sg->dma_address field is 0 and the sg data structure has already been
freed.

The SCSI driver sends transfer commands by invoking uas_queuecommand_lck()
in uas.c, using the uas_submit_urbs() function to submit requests to USB.
Within the uas_submit_urbs() implementation, three URBs (sense_urb,
data_urb, and cmd_urb) are sequentially submitted. Device removal may
occur at any point during uas_submit_urbs execution, which may result
in URB submission failure. However, some URBs might have been successfully
submitted before the failure, and uas_submit_urbs will return the -ENODEV
error code in this case. The current error handling directly calls
scsi_done(). In the SCSI driver, this eventually triggers scsi_complete()
to invoke scsi_end_request() for releasing the sgtable. The successfully
submitted URBs, when being unlinked to giveback, call
usb_hcd_unmap_urb_for_dma() in hcd.c, leading to exceptions during sg
unmapping operations since the sg data structure has already been freed.

This patch modifies the error condition check in the uas_submit_urbs()
function. When a UAS device is removed but one or more URBs have already
been successfully submitted to USB, it avoids immediately invoking
scsi_done() and save the cmnd to devinfo->cmnd array. If the successfully
submitted URBs is completed before devinfo->resetting being set, then
the scsi_done() function will be called within uas_try_complete() after
all pending URB operations are finalized. Otherwise, the scsi_done()
function will be called within uas_zap_pending(), which is executed after
usb_kill_anchored_urbs().

The error handling only takes effect when uas_queuecommand_lck() calls
uas_submit_urbs() and returns the error value -ENODEV . In this case,
the device is disconnected, and the flow proceeds to uas_disconnect(),
where uas_zap_pending() is invoked to call uas_try_complete().

Fixes: eb2a86ae8c54 ("USB: UAS: fix disconnect by unplugging a hub")
Cc: stable <stable@kernel.org>
Signed-off-by: Yu Chen <chenyu45@xiaomi.com>
Signed-off-by: Owen Gu <guhuinan@xiaomi.com>
Acked-by: Oliver Neukum <oneukum@suse.com>
Link: https://patch.msgid.link/20251120123336.3328-1-guhuinan@xiaomi.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
[ adapted scsi_done(cmnd) helper to older cmnd->scsi_done(cmnd) callback API ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/storage/uas.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/drivers/usb/storage/uas.c
+++ b/drivers/usb/storage/uas.c
@@ -705,7 +705,11 @@ static int uas_queuecommand_lck(struct s
 	 * of queueing, no matter how fatal the error
 	 */
 	if (err == -ENODEV) {
-		set_host_byte(cmnd, DID_ERROR);
+		if (cmdinfo->state & (COMMAND_INFLIGHT | DATA_IN_URB_INFLIGHT |
+				DATA_OUT_URB_INFLIGHT))
+			goto out;
+
+		set_host_byte(cmnd, DID_NO_CONNECT);
 		cmnd->scsi_done(cmnd);
 		goto zombie;
 	}
@@ -718,6 +722,7 @@ static int uas_queuecommand_lck(struct s
 		uas_add_work(cmdinfo);
 	}
 
+out:
 	devinfo->cmnd[idx] = cmnd;
 zombie:
 	spin_unlock_irqrestore(&devinfo->lock, flags);


