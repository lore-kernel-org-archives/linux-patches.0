Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F6552D594F;
	Wed,  4 Feb 2026 15:05:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770217519; cv=none; b=Qq9vbF47rc6BCNF6PsKqJQ8oSOGSfNT4kRye1+0Vf1QpNUhVVpzPL+xrlAAaTl4Xr6bEaEhxS9B8iAHUajFejwfhc7Regi3rPj2tp5fIEd65UAKIl3+GdB2NvVBwDdHXSt/qGBCYi3Lyg9nv6+RBA+PlLDheHV9tjZ0DVPCOD9c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770217519; c=relaxed/simple;
	bh=R19eOapXvUdWai2gyOvPPseFNF+triCAehx5o4/u/vg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o/JJkrZiL8o2x+wNlPOZyNuBn13Qiar/0pcgQFf0ZvVucRTw3Gog9Y/HSWd7SjEUaBnDyLfZbxPsux1Qp8KDafSHimyOrqYOZP4hrpz/n5IKQgnGaSbr5TJPOi8SbISzjOP3ESVamIwRSbXVKc9m8ioHs4jqM12eKkODzwIMdH4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BQeqEW41; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BQeqEW41"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BEDDC116C6;
	Wed,  4 Feb 2026 15:05:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770217519;
	bh=R19eOapXvUdWai2gyOvPPseFNF+triCAehx5o4/u/vg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BQeqEW41zSD1rArBQgtQndtcxcaABei4x3QU8VJ4yNTvM3A7cMFChkHZO5vyL4Tl4
	 o+XPPxR3aMxqigUALgC2NwDXgriKo9QIECxMai7mHrfWoQN+DHX4bOkdUrWgvxvnaQ
	 dz0b15dG9NpD2E37y54dC4oygjypmQfIqwbZeqwY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 6.1 039/280] can: gs_usb: gs_usb_receive_bulk_callback(): fix URB memory leak
Date: Wed,  4 Feb 2026 15:36:53 +0100
Message-ID: <20260204143911.045332726@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260204143909.614719725@linuxfoundation.org>
References: <20260204143909.614719725@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -657,6 +657,8 @@ resubmit_urb:
 			  hf, parent->hf_size_rx,
 			  gs_usb_receive_bulk_callback, parent);
 
+	usb_anchor_urb(urb, &parent->rx_submitted);
+
 	rc = usb_submit_urb(urb, GFP_ATOMIC);
 
 	/* USB failure take down all interfaces */


