Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2F3E44103A;
	Tue, 16 Jun 2026 16:01:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781625666; cv=none; b=hBhvT8JtzmQP1ELjtidxd3ue/Q5J0XnrmTWqiHloBneeSg4UOyu4kpcSYAdsvyqc30dbYZf9AH5pY3ut0dXhGAdFNwX6KIAPyW5b4ttyj3ykJlAO8CCjKi26OAG78DgC7y/y/uAtKHwmg/Eo/9ECYnj+QDQq48s/PQXTljdWWMY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781625666; c=relaxed/simple;
	bh=9hzeqs/knRgAtWiip/lNqKc2tHSoIR2X+hlKJXIwJoQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cS/XqaL73Mmx8xsspyH+54aZ7C9hPGrT8ixEbAbM03zjQrSgyxideap9AbLPaDGzd2DijI4q7VOXGivypzrDKZ2hjhse5mpXOkcrw5j9dK2W06GsLEgElui8LA+tMVmLVug0iqx9u60O1HrjPyn5QtVOWDwnT+/idunoDjryQss=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zECB2pt3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zECB2pt3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC2571F000E9;
	Tue, 16 Jun 2026 16:01:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781625665;
	bh=XOduJSJWNlberM2AYUEqUhTKr0z+J1pFCt7d/YSyxkI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zECB2pt3AZlb5TI6fPJ57OZhlWh4bs9rfF9AJaXKqdL2ODfjc0JGKf+iFsGGYJTnT
	 AsnzkHyRKnRFp1ULMq1erUBtxELos5QVIIq68DhinV2ZRNjw3UfEJ5lqQSDWXqPeUg
	 AS2iDs/KlEY9Dv907mFfWxGKKD56bWROfvji3FTw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	HyeongJun An <sammiee5311@gmail.com>,
	Johan Hovold <johan@kernel.org>
Subject: [PATCH 6.18 177/325] USB: serial: kl5kusb105: fix bulk-out buffer overflow
Date: Tue, 16 Jun 2026 20:29:33 +0530
Message-ID: <20260616145106.690633153@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145057.827196531@linuxfoundation.org>
References: <20260616145057.827196531@linuxfoundation.org>
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

From: HyeongJun An <sammiee5311@gmail.com>

commit 96d47e40bf9db4a9efd5c8fb53287a508d165f14 upstream.

klsi_105_prepare_write_buffer() is called by the generic write path
with the bulk-out buffer and its size (bulk_out_size, 64 bytes). It
stores a two-byte length header at the start of the buffer and copies
the payload from the write fifo starting at buf + KLSI_HDR_LEN, but
passes the full buffer size as the number of bytes to copy:

  count = kfifo_out_locked(&port->write_fifo, buf + KLSI_HDR_LEN,
                           size, &port->lock);

When the fifo holds at least size bytes, size bytes are copied starting
two bytes into the size-byte buffer, writing KLSI_HDR_LEN bytes past its
end. Copy at most size - KLSI_HDR_LEN bytes instead, leaving room for
the header as safe_serial already does.

Writing bulk_out_size or more bytes to the tty triggers a slab
out-of-bounds write, observed with KASAN by emulating the device with
dummy_hcd and raw-gadget:

  BUG: KASAN: slab-out-of-bounds in kfifo_copy_out+0x83/0xc0
  Write of size 64 at addr ffff888112c62202 by task python3
   kfifo_copy_out
   klsi_105_prepare_write_buffer [kl5kusb105]
   usb_serial_generic_write_start [usbserial]
  Allocated by task 139:
   usb_serial_probe [usbserial]
  The buggy address is located 2 bytes inside of allocated 64-byte region

The out-of-bounds write no longer occurs with this change applied.

Fixes: 60b3013cdaf3 ("USB: kl5usb105: reimplement using generic framework")
Cc: stable@vger.kernel.org
Assisted-by: Claude:claude-opus-4-8
Signed-off-by: HyeongJun An <sammiee5311@gmail.com>
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/serial/kl5kusb105.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/usb/serial/kl5kusb105.c
+++ b/drivers/usb/serial/kl5kusb105.c
@@ -330,8 +330,8 @@ static int klsi_105_prepare_write_buffer
 	unsigned char *buf = dest;
 	int count;
 
-	count = kfifo_out_locked(&port->write_fifo, buf + KLSI_HDR_LEN, size,
-								&port->lock);
+	count = kfifo_out_locked(&port->write_fifo, buf + KLSI_HDR_LEN,
+				 size - KLSI_HDR_LEN, &port->lock);
 	put_unaligned_le16(count, buf);
 
 	return count + KLSI_HDR_LEN;


