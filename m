Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2F16267B05;
	Sat, 30 May 2026 17:42:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780162959; cv=none; b=lXSEinS2PUc2A34x+0399TpPtiWmfOfm4oppj3txdM3TLl9C4L1UyB4tQcsNAfx+gnRGCejFY9mHqaiiUICa5dZvaO+Uh3VcqZhcfiV5yHO7Lpt3Y0XgLcsqZcJWzUZ9SlIDtUqLMwlF4ZH5uj7rjHLLn2V+mTTcm5IqbvxVgF8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780162959; c=relaxed/simple;
	bh=UYVWwWbQ6KLaOuZNB8lUOg3YP6g+1DrFyWFTEIpm5ZY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oYR13RNdLt56gNriKXWNAKYNV9QsPmUvI7NRAFyNaRiB8ZL67/ooiUXQmMdk8UCvisPVn7JXEhOMhNRkrUooVW10Lgkg0LwYDEREAuR83Ut76DOWZWDRt/4B4e9lKPpmC1f7W70re0GHBv9X7V1qVuJxUxXiAyQbA89bx2XnVbI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZHcWTfWe; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZHcWTfWe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43E901F00893;
	Sat, 30 May 2026 17:42:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780162957;
	bh=J7wANRIPs5TOpb1YCzkCHdn/MPnpXV16yqij2tcDl0o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZHcWTfWeYlH5nHROJkKPKCl9fKhfZS56DdQbsB6fyo1g8bti8a3UgK2GvdCvPH0tZ
	 nEK89i6sjEuM28dUpVKbComlpIU4zdySdOsjIfMVyQPGIdMoRhjQdL1ANjFMdBsjUt
	 APA5xYE5dlKnfyFuUQnzCg14ZP2A43Tiqy5xCYKo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Nathan Rebello <nathan.c.rebello@gmail.com>
Subject: [PATCH 5.15 065/776] usbip: validate number_of_packets in usbip_pack_ret_submit()
Date: Sat, 30 May 2026 17:56:19 +0200
Message-ID: <20260530160241.996400390@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160240.228940103@linuxfoundation.org>
References: <20260530160240.228940103@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nathan Rebello <nathan.c.rebello@gmail.com>

commit 2ab833a16a825373aad2ba7d54b572b277e95b71 upstream.

When a USB/IP client receives a RET_SUBMIT response,
usbip_pack_ret_submit() unconditionally overwrites
urb->number_of_packets from the network PDU. This value is
subsequently used as the loop bound in usbip_recv_iso() and
usbip_pad_iso() to iterate over urb->iso_frame_desc[], a flexible
array whose size was fixed at URB allocation time based on the
*original* number_of_packets from the CMD_SUBMIT.

A malicious USB/IP server can set number_of_packets in the response
to a value larger than what was originally submitted, causing a heap
out-of-bounds write when usbip_recv_iso() writes to
urb->iso_frame_desc[i] beyond the allocated region.

KASAN confirmed this with kernel 7.0.0-rc5:

  BUG: KASAN: slab-out-of-bounds in usbip_recv_iso+0x46a/0x640
  Write of size 4 at addr ffff888106351d40 by task vhci_rx/69

  The buggy address is located 0 bytes to the right of
   allocated 320-byte region [ffff888106351c00, ffff888106351d40)

The server side (stub_rx.c) and gadget side (vudc_rx.c) already
validate number_of_packets in the CMD_SUBMIT path since commits
c6688ef9f297 ("usbip: fix stub_rx: harden CMD_SUBMIT path to handle
malicious input") and b78d830f0049 ("usbip: fix vudc_rx: harden
CMD_SUBMIT path to handle malicious input"). The server side validates
against USBIP_MAX_ISO_PACKETS because no URB exists yet at that point.
On the client side we have the original URB, so we can use the tighter
bound: the response must not exceed the original number_of_packets.

This mirrors the existing validation of actual_length against
transfer_buffer_length in usbip_recv_xbuff(), which checks the
response value against the original allocation size.

Kelvin Mbogo's series ("usb: usbip: fix integer overflow in
usbip_recv_iso()", v2) hardens the receive-side functions themselves;
this patch complements that work by catching the bad value at its
source -- in usbip_pack_ret_submit() before the overwrite -- and
using the tighter per-URB allocation bound rather than the global
USBIP_MAX_ISO_PACKETS limit.

Fix this by checking rpdu->number_of_packets against
urb->number_of_packets in usbip_pack_ret_submit() before the
overwrite. On violation, clamp to zero so that usbip_recv_iso() and
usbip_pad_iso() safely return early.

Fixes: 1325f85fa49f ("staging: usbip: bugfix add number of packets for isochronous frames")
Cc: stable <stable@kernel.org>
Acked-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Nathan Rebello <nathan.c.rebello@gmail.com>
Link: https://patch.msgid.link/20260402085259.234-1-nathan.c.rebello@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/usbip/usbip_common.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)

--- a/drivers/usb/usbip/usbip_common.c
+++ b/drivers/usb/usbip/usbip_common.c
@@ -384,6 +384,18 @@ static void usbip_pack_ret_submit(struct
 		urb->status		= rpdu->status;
 		urb->actual_length	= rpdu->actual_length;
 		urb->start_frame	= rpdu->start_frame;
+		/*
+		 * The number_of_packets field determines the length of
+		 * iso_frame_desc[], which is a flexible array allocated
+		 * at URB creation time. A response must never claim more
+		 * packets than originally submitted; doing so would cause
+		 * an out-of-bounds write in usbip_recv_iso() and
+		 * usbip_pad_iso(). Clamp to zero on violation so both
+		 * functions safely return early.
+		 */
+		if (rpdu->number_of_packets < 0 ||
+		    rpdu->number_of_packets > urb->number_of_packets)
+			rpdu->number_of_packets = 0;
 		urb->number_of_packets = rpdu->number_of_packets;
 		urb->error_count	= rpdu->error_count;
 	}


