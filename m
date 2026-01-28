Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FE112F83BB;
	Wed, 28 Jan 2026 15:40:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769614810; cv=none; b=efhZqMCiokNiqcLFN45JUAayeeL7pSW6kPDRitfagev3Mz1ZbeN3R8e8MkzuQ21VQs3r0XeEnoWUW2voFt4M03Xu44gbStJL1YCt2pA6Y909G8LKkltAwzb37A0wTJ4XDo9fQxx5LDk1loIAHyRgc9kWZwZknM3F7XIEGGpAOJw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769614810; c=relaxed/simple;
	bh=9k9mfRLH+Nsfnd6CVFV2DPsDHHUvBwzD/bmJ5YF7X70=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZtbqDipBuAJOStXD1u1er7aapQOHunFqXw01MgMmGfvXMHfwNT93xomtpCnjfoBwcBGPZwYhBTyJReQtH0XA1smYQY8SNeH8UM0qe5mKE6WvDVWDaiKf7wu3wN0UyreeKqboviLOBZd0SBcQy6mto5f2Es06TCrcebqeK69IBmk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lj/6/PBt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lj/6/PBt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AEEBDC4CEF7;
	Wed, 28 Jan 2026 15:40:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769614810;
	bh=9k9mfRLH+Nsfnd6CVFV2DPsDHHUvBwzD/bmJ5YF7X70=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lj/6/PBtQJDvWnOuMLHoa3fE+JDWQExDJJfnJ+qfi1Yf25GA1momTdeLZ6zNEcObZ
	 EiP9+2fgoVhgIC3q+0wyt2WFo+Li07SHuegerIQy95WmTgV+AAK4V0FjTRM4Luh2qa
	 jxJ6AthEW8JTFpSv9fNdDNkFNlHXjKE1KC2Th6co=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 6.6 216/254] can: ems_usb: ems_usb_read_bulk_callback(): fix URB memory leak
Date: Wed, 28 Jan 2026 16:23:12 +0100
Message-ID: <20260128145352.562499543@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260128145344.698118637@linuxfoundation.org>
References: <20260128145344.698118637@linuxfoundation.org>
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

From: Marc Kleine-Budde <mkl@pengutronix.de>

commit 0ce73a0eb5a27070957b67fd74059b6da89cc516 upstream.

Fix similar memory leak as in commit 7352e1d5932a ("can: gs_usb:
gs_usb_receive_bulk_callback(): fix URB memory leak").

In ems_usb_open(), the URBs for USB-in transfers are allocated, added to
the dev->rx_submitted anchor and submitted. In the complete callback
ems_usb_read_bulk_callback(), the URBs are processed and resubmitted. In
ems_usb_close() the URBs are freed by calling
usb_kill_anchored_urbs(&dev->rx_submitted).

However, this does not take into account that the USB framework unanchors
the URB before the complete function is called. This means that once an
in-URB has been completed, it is no longer anchored and is ultimately not
released in ems_usb_close().

Fix the memory leak by anchoring the URB in the
ems_usb_read_bulk_callback() to the dev->rx_submitted anchor.

Fixes: 702171adeed3 ("ems_usb: Added support for EMS CPC-USB/ARM7 CAN/USB interface")
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20260116-can_usb-fix-memory-leak-v2-1-4b8cb2915571@pengutronix.de
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/can/usb/ems_usb.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/drivers/net/can/usb/ems_usb.c
+++ b/drivers/net/can/usb/ems_usb.c
@@ -486,11 +486,17 @@ resubmit_urb:
 			  urb->transfer_buffer, RX_BUFFER_SIZE,
 			  ems_usb_read_bulk_callback, dev);
 
+	usb_anchor_urb(urb, &dev->rx_submitted);
+
 	retval = usb_submit_urb(urb, GFP_ATOMIC);
+	if (!retval)
+		return;
+
+	usb_unanchor_urb(urb);
 
 	if (retval == -ENODEV)
 		netif_device_detach(netdev);
-	else if (retval)
+	else
 		netdev_err(netdev,
 			   "failed resubmitting read bulk urb: %d\n", retval);
 }


