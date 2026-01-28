Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D807336C0DE;
	Wed, 28 Jan 2026 15:29:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769614140; cv=none; b=JSD/nwfUkJTDfDECbF/KHoecfVCQ7O7a8hOXM84DKV24hnrwiDJ755tmeHWVJHl+8en3Y5HY7NMKvVof5qVrxG63mHbpmgn2K3ut7TP5xLz+4CKwC0tasp0RmNW1tyCvdNCiEeuYoF/wm/TdNlXLXaP7GGG/gtfgj3FYAI+1Cp4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769614140; c=relaxed/simple;
	bh=A2M/ghn2OmDbFtEL/czYWvWXcy/oUgj7XSaLUaMOFO0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ablIQa1YdQoUGe7sjr0JcCFp3Y8Ads9DNfqz2HhCOGYejQVL6iKo5Gw1KcORs9B/ndn9wcFw9+R+/znxJmtB2KpiMMSoj5PFCuGeqzUX+YDDosYtk4x8DpwhjIqe/tSQJgAGzoohFFlRxLA+m8ocWuSNInb54e4UO/qqK/lIZv8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ob6ALc41; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ob6ALc41"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51321C16AAE;
	Wed, 28 Jan 2026 15:29:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769614140;
	bh=A2M/ghn2OmDbFtEL/czYWvWXcy/oUgj7XSaLUaMOFO0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ob6ALc41iaTlwy70zndrAjylrm00ABP02lSW1VLfhMsXkL6dgwW7Fik7lPbrVJk8R
	 b8P1aQlr7R8aLT29YZBZ7saV7CW/fRT5qsFcElZG8pl9Q3Pfeh7XPZbyRT2J59bpm/
	 BUaakITsDeGs6tjiZyfhfaowVaLS9tqtzHWrQN10=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 6.6 048/254] can: gs_usb: gs_usb_receive_bulk_callback(): fix URB memory leak
Date: Wed, 28 Jan 2026 16:20:24 +0100
Message-ID: <20260128145346.430581264@linuxfoundation.org>
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

commit 7352e1d5932a0e777e39fa4b619801191f57e603 upstream.

In gs_can_open(), the URBs for USB-in transfers are allocated, added to the
parent->rx_submitted anchor and submitted. In the complete callback
gs_usb_receive_bulk_callback(), the URB is processed and resubmitted. In
gs_can_close() the URBs are freed by calling
usb_kill_anchored_urbs(parent->rx_submitted).

However, this does not take into account that the USB framework unanchors
the URB before the complete function is called. This means that once an
in-URB has been completed, it is no longer anchored and is ultimately not
released in gs_can_close().

Fix the memory leak by anchoring the URB in the
gs_usb_receive_bulk_callback() to the parent->rx_submitted anchor.

Fixes: d08e973a77d1 ("can: gs_usb: Added support for the GS_USB CAN devices")
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20260105-gs_usb-fix-memory-leak-v2-1-cc6ed6438034@pengutronix.de
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/can/usb/gs_usb.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/net/can/usb/gs_usb.c
+++ b/drivers/net/can/usb/gs_usb.c
@@ -748,6 +748,8 @@ resubmit_urb:
 			  hf, parent->hf_size_rx,
 			  gs_usb_receive_bulk_callback, parent);
 
+	usb_anchor_urb(urb, &parent->rx_submitted);
+
 	rc = usb_submit_urb(urb, GFP_ATOMIC);
 
 	/* USB failure take down all interfaces */


