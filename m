Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 643E747AF68;
	Tue, 16 Jun 2026 17:42:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781631776; cv=none; b=hth79PYp3AA5yZZl1WGBlXzb+aSPqtGWePkjth57CTi2mM8n5cFERbWlMQ88oU2awF1S0G12ktgz2umml4s8J28F5NiM5ye759745hLUb9hKzHGx2mQn80U48jpfnx/ZmAeOA+C7D9/7Zu2Kon+YKO4sxk03Cy51RYCJQ/2hoKU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781631776; c=relaxed/simple;
	bh=sO+TOePnY4ZsxPj3SFaQl7hX0CUO2uR4iifOFC3+US4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Fagq+UG9g9efMAsz5y9MHiFSI1Js8l6d8u2BYDy0lm27GKgG8mbDfL5CKzIftMnntweZMnl774xtlCaBYEO3ULnnYRW8wzfRlC/vqZEEstZno7CE7wGrFbxTSm4U8dv402LUNbFDv/wq+35eaDOeFQOZveN+BAL2cN3BXM/a7fI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MzyxFsTX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MzyxFsTX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 063811F000E9;
	Tue, 16 Jun 2026 17:42:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781631773;
	bh=z3EZyQKETQ2SeBgfsHRHflmVhthsh3g7wIfH2Sn/mMI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MzyxFsTXxTpDjcWkoO4rBUy7+WZfygekD8NvT7zPEnS4xlSopPBmUskU5ZDEvu2UT
	 jEoyMdzX7Jj4jWU9XdaTUfSpGnfkp3azrZ+fGm2n56Lg+wWumh8E+idkioFdRh2mqV
	 ItOaFpEo7Pt9L9ZSAMJO2DD9mAGVZ6gyksL6aA4Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	HyeongJun An <sammiee5311@gmail.com>,
	Johan Hovold <johan@kernel.org>
Subject: [PATCH 6.1 277/522] USB: serial: kl5kusb105: fix bulk-out buffer overflow
Date: Tue, 16 Jun 2026 20:27:04 +0530
Message-ID: <20260616145138.911493552@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145125.307082728@linuxfoundation.org>
References: <20260616145125.307082728@linuxfoundation.org>
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
@@ -331,8 +331,8 @@ static int klsi_105_prepare_write_buffer
 	unsigned char *buf = dest;
 	int count;
 
-	count = kfifo_out_locked(&port->write_fifo, buf + KLSI_HDR_LEN, size,
-								&port->lock);
+	count = kfifo_out_locked(&port->write_fifo, buf + KLSI_HDR_LEN,
+				 size - KLSI_HDR_LEN, &port->lock);
 	put_unaligned_le16(count, buf);
 
 	return count + KLSI_HDR_LEN;


