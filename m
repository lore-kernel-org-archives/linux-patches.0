Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE27847277F;
	Tue, 16 Jun 2026 16:28:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781627289; cv=none; b=tUKo4fx4E/qxhiuY3/o/jDqGtPoWcleXdaLo7+fFeWZlxen/lYNxlPNv4Ckqa06LuiieBghvMy/Er/AQgp1Hl2qlMd4fA2ss2WZbJIvznSdy+iBbYLx2Wc5teGALcRrdS9SIgwXKRHsfnczB3gdfTYIM4nQl3hGDOHF0Et0E0ac=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781627289; c=relaxed/simple;
	bh=Va1I41W4CtZDK8pd6bw8uefeHj6AIrj43wk1jOk9y7g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YddSeNSO2rKhxbh7Y+eIZ9HBXi7ukvmWv2KdGMOJh0Cbjv7D4W0rsg7Z2SrAL0EGb9m8hMgBiKBUj1eb0yXuXllRHk0IF7DhYy7wdhphZy9BNATBpE4UZJuoD6bcbu0TZzzO7gBX8/XdVgo/qrlFFZd4Syow+6S2zdYv2QeMaC8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OsQ2TR+m; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OsQ2TR+m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EEB011F000E9;
	Tue, 16 Jun 2026 16:28:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781627287;
	bh=jsJXFlXIGHHQaabXqmfSxJex3TLAJ+Afx0ppmGyILLk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OsQ2TR+mqAdPd/bncM0qvc4l3JPIOuq70DheDu8Lvw5QvTo6tixy7NfSPatg0kzzy
	 cGl2b+dXFJqfPcAjOakMcS4gq3Z4fwOSJl75JPmDS6v7ttfswsE+TIKRVTvb6/ILhT
	 RAfJ2+Gis4lBNLTnBgOEKaRI7QU/n8HvU4St7Rt4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	HyeongJun An <sammiee5311@gmail.com>,
	Johan Hovold <johan@kernel.org>
Subject: [PATCH 6.12 142/261] USB: serial: kl5kusb105: fix bulk-out buffer overflow
Date: Tue, 16 Jun 2026 20:29:40 +0530
Message-ID: <20260616145051.662977615@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145044.869532709@linuxfoundation.org>
References: <20260616145044.869532709@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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


