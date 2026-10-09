Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 846363431F5;
	Fri,  9 Oct 2026 14:28:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791556133; cv=none; b=IaMkwXLUgT2jbgZEP3woZ+La2C9NLwpgCr5036w7AH+gx/XfkDMtgmOY7tWvSUXmnzMciZa0n2/k6cERFIAghNtWYVXEnTSOZYBAZIVoEeIhGt3wMfgsf/LhSFuzHm8E+ktdghaZJzs5Zc1dl/qUFcYuHyAEgb6pb4kAd4kw+Uo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791556133; c=relaxed/simple;
	bh=CPgLLrzJbvUwXLl8oS5XsUSELa6RuBRzWfvytmnS/hQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WUPYypNbrTv6/pHFXcg9ZyfgkiNaHhuCMlWxd8mRRN+lPykOqCjeh+Lw5+au5gsyJVrqlkCXXKDkleznj44jy+SumjD2hrRuQ2uiY19R9hdx3fbjtE4r4GXcIE9BufnKAjGJnRpf4RIMPTNT15XHFkMx/nPYOn5UPGSurHe+zcE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VfnRi5qP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VfnRi5qP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E38D21F000FF;
	Fri,  9 Oct 2026 14:28:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791556132;
	bh=feGs81PTC9mGn7AkkbJqtOcn6H2MeFEUqVxUxvmboao=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VfnRi5qPrRlmIjsV5qDj/g4YQmaw7gWiOXQsYtu3tJhuYmaYIVaQUOmRXD1PIA+zh
	 3/dK3BEzr6C2bc7RgNYHwNiG0NRBEDpjS37b3s09NJFVOBnjBJj8wfTuaIaY+TzYTt
	 GlqBHLFu7ANeB+2DK8nP5mVQUBkZirEdFKKOFg6c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Hui Peng <benquike@gmail.com>,
	Alan Stern <stern@rowland.harvard.edu>
Subject: [PATCH 6.18 179/403] usb: core: clear both ep_in and ep_out for non-ep0 control endpoints
Date: Fri,  9 Oct 2026 16:09:00 +0200
Message-ID: <20261009140956.303785829@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140952.119038291@linuxfoundation.org>
References: <20261009140952.119038291@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1335,7 +1335,8 @@ static void remove_intf_ep_devs(struct u
  *
  * Disables the endpoint for URB submission and nukes all pending URBs.
  * If @reset_hardware is set then also deallocates hcd/hardware state
- * for the endpoint.
+ * for the endpoint (clearing both ep_in and ep_out pointers for
+ * bidirectional non-ep0 control endpoints).
  */
 void usb_disable_endpoint(struct usb_device *dev, unsigned int epaddr,
 		bool reset_hardware)
@@ -1356,6 +1357,11 @@ void usb_disable_endpoint(struct usb_dev
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


