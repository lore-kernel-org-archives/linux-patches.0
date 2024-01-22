Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AA3915704E;
	Tue, 23 Jan 2024 00:28:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705969731; cv=none; b=elaUuAsBnpt8hctIVhp7haci3+5qhFPmk6Tv2CO4CCw1blfgxRAx3mIDthnOoDGCXttaK8AXmxOgRSIWSXHWCahBAuyXpz1Va2pnIhsknCoyZkgLo+VotbpbrsgoGN1C7o7bD2V3tE5KCfdvCXEvMWccB6P3qww236LtsvtvOqE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705969731; c=relaxed/simple;
	bh=4o1StubQ2A0cjBh7MbZjv7RQhe9sYOJ4910JPjvkdHw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ERA48wzyR8nkdWzRLVCQau57xRhGlfIvafO/MGENalN5oFu0SVVDLkAtizmLXNr4oaGZ2JTfJCpbab2LraNsv0gxErxSfDyANZp8JWlo5DYi/ZF3mBMWk60MBYHsoUztz74p/zPEYSncO+icfhJVtJExfC0Yi/tRBGEzSDvzQSA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BWraXx7q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BWraXx7q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D96ECC433C7;
	Tue, 23 Jan 2024 00:28:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705969731;
	bh=4o1StubQ2A0cjBh7MbZjv7RQhe9sYOJ4910JPjvkdHw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BWraXx7qniZX9VG2tNQPK78PyZGRGAOFGjs2iThMvNMHEaIqavHgVomhh8ZKgvjRD
	 EOkMuRuwOffQlDIcPGrW9c/xkkDnMIy5cHW7UVBXrFi1kFOd1g7qpn1YaDRuXXurDX
	 1G0g/KHmLoScUvmdS2sTCl0+DWq385BMMfW3ZJ04=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wesley Cheng <quic_wcheng@quicinc.com>
Subject: [PATCH 6.7 398/641] usb: dwc3: gadget: Queue PM runtime idle on disconnect event
Date: Mon, 22 Jan 2024 15:55:02 -0800
Message-ID: <20240122235830.421167083@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235818.091081209@linuxfoundation.org>
References: <20240122235818.091081209@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wesley Cheng <quic_wcheng@quicinc.com>

commit 3c7af52c7616c3aa6dacd2336ec748d4a65df8f4 upstream.

There is a scenario where DWC3 runtime suspend is blocked due to the
dwc->connected flag still being true while PM usage_count is zero after
DWC3 giveback is completed and the USB gadget session is being terminated.
This leads to a case where nothing schedules a PM runtime idle for the
device.

The exact condition is seen with the following sequence:
  1.  USB bus reset is issued by the host
  2.  Shortly after, or concurrently, a USB PD DR SWAP request is received
      (sink->source)
  3.  USB bus reset event handler runs and issues
      dwc3_stop_active_transfers(), and pending transfer are stopped
  4.  DWC3 usage_count decremented to 0, and runtime idle occurs while
      dwc->connected == true, returns -EBUSY
  5.  DWC3 disconnect event seen, dwc->connected set to false due to DR
      swap handling
  6.  No runtime idle after this point

Address this by issuing an asynchronous PM runtime idle call after the
disconnect event is completed, as it modifies the dwc->connected flag,
which is what blocks the initial runtime idle.

Fixes: fc8bb91bc83e ("usb: dwc3: implement runtime PM")
Cc:  <stable@vger.kernel.org>
Signed-off-by: Wesley Cheng <quic_wcheng@quicinc.com>
Link: https://lore.kernel.org/r/20240103214946.2596-1-quic_wcheng@quicinc.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/dwc3/gadget.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/drivers/usb/dwc3/gadget.c
+++ b/drivers/usb/dwc3/gadget.c
@@ -3983,6 +3983,13 @@ static void dwc3_gadget_disconnect_inter
 	usb_gadget_set_state(dwc->gadget, USB_STATE_NOTATTACHED);
 
 	dwc3_ep0_reset_state(dwc);
+
+	/*
+	 * Request PM idle to address condition where usage count is
+	 * already decremented to zero, but waiting for the disconnect
+	 * interrupt to set dwc->connected to FALSE.
+	 */
+	pm_request_idle(dwc->dev);
 }
 
 static void dwc3_gadget_reset_interrupt(struct dwc3 *dwc)


