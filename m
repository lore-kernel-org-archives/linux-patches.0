Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92FD44252A6;
	Thu, 16 Jul 2026 13:49:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784209780; cv=none; b=P/tjvdYho2UqdnJbI1U+EF7QE/p4tVoHPOWg/8VlEwSmUsiyy3paptVBWOKt6fZyOk9DGfRLhsTjH90LLqxn8gPgcFYNEzxts9MLjreF4CUGnL3SuvsRqMq01cb1lFswi/UDgR98Rk2xlrMso+Y31+wTYezsl2bHTMFtSnXkIoM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784209780; c=relaxed/simple;
	bh=/nSIuRLUM6DLBWodaPu5Z3VcS0YHpc36iM+Vcfq1vWg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lTjrtY26+CH5EM/mH8v2Tl6Vrey9XsXOyFLaqAiv2vzv+n8kJvNidCzz9gax07LtyDrJnyndTgYpFuBDVUeMr1BqpOChiumaNCleVpKIAJAujwt929/tTESXZMWiASWXyubHH4KXIWaJYQI7TSaPjDo7gX1pJiSu9uvGlR42DFk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ICTxdghg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ICTxdghg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 506861F00A3E;
	Thu, 16 Jul 2026 13:49:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784209775;
	bh=/BObPFhj80Ha63wVraSwm9kpaQYcPSBTDi9H1I032nM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ICTxdghgrR0Y52emsLCicMTxcQMePDbDGfn/noEUkZ6Pck2rqBECeONzEVvZq+QWT
	 Y/OLzd9gstA2dVnphaoqexOnrPQ9ILGHNMtecqUzgzid2sYBH6WbD06rr5LTejI5h+
	 OvbgOWghj1HG1s+mumwELZAgg7yri0uaQSOMKtLg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	=?UTF-8?q?HE=20WEI=20 ?= <skyexpoc@gmail.com>
Subject: [PATCH 7.1 315/518] usb: misc: usbio: bound bulk IN response length to the received transfer
Date: Thu, 16 Jul 2026 15:29:43 +0200
Message-ID: <20260716133054.715970166@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133047.772246337@linuxfoundation.org>
References: <20260716133047.772246337@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: HE WEI (ギカク) <skyexpoc@gmail.com>

commit 8c6314489550fa81d41723a0ff33f655b5b6c7b6 upstream.

usbio_bulk_msg() copies bpkt_len = le16_to_cpu(bpkt->len) bytes out of
the bulk IN buffer (usbio->rxbuf, allocated with size usbio->rxbuf_len)
into the caller's buffer.  bpkt_len is fully controlled by the device
and is only checked against ibuf_len; ibuf_len in turn is checked
against usbio->txbuf_len, not against rxbuf_len:

	if ((obuf_len > (usbio->txbuf_len - sizeof(*bpkt))) ||
	    (ibuf_len > (usbio->txbuf_len - sizeof(*bpkt))))
		return -EMSGSIZE;

txbuf_len and rxbuf_len are taken independently from the bulk OUT and
bulk IN endpoint wMaxPacketSize in usbio_probe().  A malicious or
malfunctioning device that advertises a large bulk OUT endpoint and a
small bulk IN endpoint (e.g. by claiming one of the quirk-free IDs such
as the Lattice NX33U, 0x2ac1:0x20cb) therefore makes ibuf_len, and
hence the device-supplied bpkt_len, exceed rxbuf_len.  memcpy() then
reads up to txbuf_len - rxbuf_len bytes past the end of the rxbuf slab
object.  The over-read bytes are handed back to the i2c layer and on to
user space through i2c-dev, disclosing adjacent slab memory; with KASAN
this is reported as a slab-out-of-bounds read.

The number of bytes actually received is already known: act equals the
URB actual_length and is bounded by rxbuf_len.  Reject any response
that claims more payload than was received, mirroring the existing
"act < sizeof(*bpkt)" check just above.

The control path (usbio_ctrl_msg()) is not affected: it uses a single
buffer (ctrlbuf) for both directions, so its analogous copy can never
leave the allocation.

Found by code review.  The out-of-bounds read was confirmed under
AddressSanitizer with a faithful userspace model of usbio_bulk_msg()'s
receive path (an rxbuf_len-sized buffer, the same act/ibuf_len/bpkt_len
checks and the memcpy).  A USB raw-gadget + dummy_hcd reproducer is
also available.

Fixes: 121a0f839dbb ("usb: misc: Add Intel USBIO bridge driver")
Cc: stable <stable@kernel.org>
Signed-off-by: HE WEI (ギカク) <skyexpoc@gmail.com>
Link: https://patch.msgid.link/20260624090952.86439-1-skyexpoc@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/misc/usbio.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/usb/misc/usbio.c
+++ b/drivers/usb/misc/usbio.c
@@ -344,6 +344,10 @@ read:
 	if (ibuf_len < bpkt_len)
 		return -ENOSPC;
 
+	/* The device must not claim more payload than it actually sent. */
+	if (bpkt_len > act - sizeof(*bpkt))
+		return -EPROTO;
+
 	memcpy(ibuf, bpkt->data, bpkt_len);
 
 	return bpkt_len;


