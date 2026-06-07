Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 905BC2D8378;
	Sun,  7 Jun 2026 10:49:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780829347; cv=none; b=dBskbq/ja8vsvnI0XAMXWCbsCVYj9CoMUENYwJk+dl37gZ7ssW6YiGy+s1gRB1Ht5FmHJhRRTKxUwfz2s+Cy+kHefC0ceJhxqPiAv8W7CYsms7YO4n+9oN2Rm6Jg37FcdhOUDTXZkYvyP/z22/iZ1E4VC0cnNzt2mZfqL000aag=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780829347; c=relaxed/simple;
	bh=ArzO638Gce4cYmJI6kH/F3nO4XSKYy3TygyFsCaKBoM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ek6Z5xPOEghYIN1Iq72+17/aJMPovAWF4i26YoTjpfJ6SPAhKY3usf65tddnZb/2PRcBbLBUGazRO1w1VLpwVBtMEWa/fHUvdxRMsHFI+QbJARlp1GOcEFiMjUl5vJNCSgNAYRC45F+d4F0oUEg7xxALtnw/9ZqP0TuBtKSjWxY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bq67ZJvW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bq67ZJvW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE8531F00893;
	Sun,  7 Jun 2026 10:49:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780829346;
	bh=wYqfNezPcjyOQFS5+rT6kLpke4u2mv4bZrVeQOBJ+Go=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bq67ZJvWnpoo5nW1LJKOfZp9J/jmF+pHCkh+wEcAUsTYdhJVjxPDJPTGy+nk8CdGo
	 NfyTdk30+Oel5x9ksHK44ZYYi6+l2Q8lwQ5hIosQs//AiwOGhhLfOUSM5TQNdHKKuU
	 /mRrxIUWUdaOPJLXdtOq2TsBSyLhHahJnt8iGeGQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhang Cen <rollkingzzc@gmail.com>,
	Johan Hovold <johan@kernel.org>
Subject: [PATCH 7.0 266/332] USB: serial: belkin_sa: validate interrupt status length
Date: Sun,  7 Jun 2026 12:00:35 +0200
Message-ID: <20260607095737.806737277@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095728.031258202@linuxfoundation.org>
References: <20260607095728.031258202@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhang Cen <rollkingzzc@gmail.com>

commit 4ce058df2ee02cc2a0f0fd5cd64ce6f1482a0b65 upstream.

The Belkin interrupt callback treats interrupt data as a four-byte
status report and reads LSR/MSR fields at offsets 2 and 3. The
interrupt-in buffer length is derived from endpoint wMaxPacketSize, and
short interrupt transfers may complete successfully with a smaller
actual_length.

Check the completed interrupt packet length before parsing status
fields so short interrupt endpoints and short successful packets are
ignored instead of causing out-of-bounds or stale status-byte reads.

KASAN report as below:

BUG: KASAN: slab-out-of-bounds in belkin_sa_read_int_callback()
Read of size 1
Call trace:
  belkin_sa_read_int_callback() (drivers/usb/serial/belkin_sa.c:202)
  __usb_hcd_giveback_urb() (drivers/usb/core/hcd.c:1630)
  dummy_timer() (?:?)

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Assisted-by: Codex:gpt-5.5
Signed-off-by: Zhang Cen <rollkingzzc@gmail.com>
Cc: stable@vger.kernel.org
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/serial/belkin_sa.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/usb/serial/belkin_sa.c
+++ b/drivers/usb/serial/belkin_sa.c
@@ -194,6 +194,9 @@ static void belkin_sa_read_int_callback(
 
 	usb_serial_debug_data(&port->dev, __func__, urb->actual_length, data);
 
+	if (urb->actual_length < BELKIN_SA_MSR_INDEX + 1)
+		goto exit;
+
 	/* Handle known interrupt data */
 	/* ignore data[0] and data[1] */
 


