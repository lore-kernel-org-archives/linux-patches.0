Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793210962;
	b=chIVhDXzbpQEvlKek+h+dZ3R7wGsmfFLzdDDV8E3yO5OGAsJACx/JzW7O71kfK8feTLK
	 RWn3MnZhLGxuugkzDFvCIsuGfznLDX+lVN89d9S5LkEOkrTF1ae9fJHLe+fIchn8S2zky
	 r9UUoY+aMCVyOyjwOd0HU4vN7h7JERMBvrck2iCs0VF3MunBaXTKMW9q0zx2LArm7Pjzi
	 7OM6lba2NrF3pVzmM+LvA3Jd/d1g8KoiiqGgPPKL5oRMjAJm6fWHcpt3yMFSbMXPmZJkU
	 hQbS1Eh8bbupfSIztBea1j8THuopR2iqW71UJ6IKBcRy1psVeHT5vfN74eTHuGURVsw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793210962;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=awtIS3ynaYJ8DLzcg1rGaR+sd6CPwQFQ5Mav3/7N9FI=;
	b=IYeNtHjOWH8MFPoCom9m+2FF8ADs5PKNMfcytdvG6yg4Di0FxvIgnKpP7lvrh4HjNvyF
	 sy9S41WYgKXqQhLpr0cdH8mwOwGR0BqpE/peO798jeLBi4e7ig2T58DZpghzkVSWX001I
	 m8BzUk82/0gGbg0G35qOoLLGBX8JVwxb2Bm4V+tZTcQBTBExboFlka2W0lrsBnav86ras
	 WlTJMFiOyndLc2DExzXx2RzUW0gr0V/KxM1cGg6GjN3N0c0Fs1WOHKNMzoGoWHe3TPSk+
	 NTBmjAnOznaWsGj0ejaqLjg6+IQ7GiS86296VhyB1QqvgnwpcxSerhZyjLl/FnWB6WA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bwj00ECI;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1F76606A324;
	Wed, 28 Oct 2026 18:09:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bwj00ECI
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DC231F031E2;
	Wed, 28 Oct 2026 18:09:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793210961;
	bh=awtIS3ynaYJ8DLzcg1rGaR+sd6CPwQFQ5Mav3/7N9FI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bwj00ECICeKKdh5DxdBXoPBZIltRYo640MqOxq/Nc+DjAoIVRygYjmbwYSpzN/Von
	 OMn4Yyc3JIg1Hk+UYdFsajjHV9JkYNXsbqTaD1XU4S/OgZ/TsOotWIrpoKAyUfl43q
	 whmCuBUBEq2eWQxi18xHYW8+/I0H7EsmxUQf6lKc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Hui Peng <benquike@gmail.com>,
	Alan Stern <stern@rowland.harvard.edu>
Subject: [PATCH 5.15 209/571] usb: core: clear both ep_in and ep_out for non-ep0 control endpoints
Date: Wed, 28 Oct 2026 17:55:56 +0100
Message-ID: <20261028170012.962028980@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170008.009143722@linuxfoundation.org>
References: <20261028170008.009143722@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1331,7 +1331,8 @@ static void remove_intf_ep_devs(struct u
  *
  * Disables the endpoint for URB submission and nukes all pending URBs.
  * If @reset_hardware is set then also deallocates hcd/hardware state
- * for the endpoint.
+ * for the endpoint (clearing both ep_in and ep_out pointers for
+ * bidirectional non-ep0 control endpoints).
  */
 void usb_disable_endpoint(struct usb_device *dev, unsigned int epaddr,
 		bool reset_hardware)
@@ -1352,6 +1353,11 @@ void usb_disable_endpoint(struct usb_dev
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


