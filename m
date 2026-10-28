Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793208659;
	b=KJiDQPO5m/mWFTMD2ibnwF7ZXNkzAy5Cg5G1BGoRx+z4MhgYzzo5TOYwyl789tuUJM1r
	 s3zU4cs/1e1xbFSd3Za/Ok8s0cNvbjlE7lIPRPixKMJmiO1q8WWsU1hbtuFQyCoctw2xQ
	 cJKfQFKOkSGkeyPd8L48mmtX0YERMfhCHbiBf5tOFh/Ja1opvtkfMgWpr+WsuE9WvjTR+
	 RpiX8S2Ck9/ImpqROX1lSGyRV15Fe1Rr8AGZI4giN86ir/AUpPyT+98NGfzKWUYbc++R9
	 voMqDs5k8acqVzYSGH9KyMRSd7ZH8PVnLFvrKphIgW7k8uFi1HRSljS4vPWeJ7Egncw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793208659;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=kWtSQs22tpQImr0CXEE1ur6Vh4F3pC8mIzJq823b7cU=;
	b=yDjkMZGHltSCfUCn10lD+aRXPDFVb6GGEVLgv4G7zdEfPkcTaEYfkI8wYH1tj/StNplv
	 ZQTGlBFZ8/lhp7Hqs8indX1SNnrxY9apaTl8VdJLtXRENpBUYs5kV7B5paD/a0KKEUFo/
	 a9dLcsKyaK0fVxhEnuIXXd6RX8VaN+PZVS4WCQabjlkGYTCDdHtc2Mm7LbYd9CNaEpI64
	 v0HrTFkYbaQFIhg1kQQsmHJ1EO9F79D+jCGA7eZrORU06A21Ln+ngCXdCGWvjuDkVQu+P
	 /E8MzyrIG4lS3pMhDZbTuRUFkhndiTj9GHF651a6p62QK/xCAQfW2JLgYdYA1bEDPJA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XcMameW7;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3796D606A31A;
	Wed, 28 Oct 2026 17:30:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XcMameW7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 877241F01825;
	Wed, 28 Oct 2026 17:30:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793208659;
	bh=kWtSQs22tpQImr0CXEE1ur6Vh4F3pC8mIzJq823b7cU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XcMameW7oBUHGzTw40w+iDK5e3DN5ylBVW5KlZAfpukT0ZuUg1OCibayLBFs6bfWD
	 YQWjSEkbqlBY3TOdDZXiz/bDFugGyMe7m+G4lITxVvEuG20xkz5c6IW/epD/IuVDEE
	 +WPAFzrGQWk5tXMEe6sBvb9Yhv4dWMHvzJt2ZqWc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Hui Peng <benquike@gmail.com>,
	Alan Stern <stern@rowland.harvard.edu>
Subject: [PATCH 5.10 198/516] usb: core: clear both ep_in and ep_out for non-ep0 control endpoints
Date: Wed, 28 Oct 2026 17:55:50 +0100
Message-ID: <20261028170008.192184109@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170003.522232767@linuxfoundation.org>
References: <20261028170003.522232767@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hui Peng <benquike@gmail.com>

commit 0e8baa78d872f2db440d8b9ded946ab8dceb89eb upstream.

In usb_enable_endpoint(), non-zero control endpoints (where
usb_endpoint_xfer_control(&ep->desc) is true) populate both
dev->ep_in[epnum] and dev->ep_out[epnum] with the same struct
usb_host_endpoint pointer.

However, usb_disable_endpoint() only clears either dev->ep_out[epnum] or
dev->ep_in[epnum] depending on the direction bit of epaddr when
reset_hardware is set, leaving the opposite direction's array slot
pointing to the disabled/freed endpoint.

Clear both dev->ep_out[epnum] and dev->ep_in[epnum] when disabling a
non-ep0 control endpoint with reset_hardware set, and update the
function kerneldoc accordingly.

Tested in QEMU against Linux 7.3.0-rc3 using dummy_hcd and raw-gadget to
enumerate a USB device with a non-zero control endpoint
(bEndpointAddress 0x01, bmAttributes USB_ENDPOINT_XFER_CONTROL),
verifying that both dev->ep_in[1] and dev->ep_out[1] are cleared when
the interface is disabled.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: stable <stable@kernel.org>
Assisted-by: LLM
Signed-off-by: Hui Peng <benquike@gmail.com>
Acked-by: Alan Stern <stern@rowland.harvard.edu>
Link: https://patch.msgid.link/20260920231702.110963-1-benquike@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/core/message.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/drivers/usb/core/message.c
+++ b/drivers/usb/core/message.c
@@ -1329,7 +1329,8 @@ static void remove_intf_ep_devs(struct u
  *
  * Disables the endpoint for URB submission and nukes all pending URBs.
  * If @reset_hardware is set then also deallocates hcd/hardware state
- * for the endpoint.
+ * for the endpoint (clearing both ep_in and ep_out pointers for
+ * bidirectional non-ep0 control endpoints).
  */
 void usb_disable_endpoint(struct usb_device *dev, unsigned int epaddr,
 		bool reset_hardware)
@@ -1350,6 +1351,11 @@ void usb_disable_endpoint(struct usb_dev
 			dev->ep_in[epnum] = NULL;
 	}
 	if (ep) {
+		if (reset_hardware && epnum != 0 &&
+		    usb_endpoint_xfer_control(&ep->desc)) {
+			dev->ep_out[epnum] = NULL;
+			dev->ep_in[epnum] = NULL;
+		}
 		ep->enabled = 0;
 		usb_hcd_flush_endpoint(dev, ep);
 		if (reset_hardware)


