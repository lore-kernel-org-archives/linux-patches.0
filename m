Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 639D21494B8;
	Mon, 12 Aug 2024 16:35:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723480513; cv=none; b=r8YQDDYbfuSqnKQgh/yaPXWOf0yWDKwrcv3ghtJBc5BuUs1Y0urzj41ckwJNZ7sKYSPIN6s6zLfjc/YUiak4+jeSh/cBEVFMwRWp1b7S48E5XVv1o2Yf/2x4XfT8DaGFUKnlGfK7d3kTBU/91BAcLp8F65JvskT/33qFsE5l1nw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723480513; c=relaxed/simple;
	bh=mIwNm6SzEps4/7zLmm3EaI8zpLYM3+LON8lw5QtNraQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ITOoUwbTvfqrccwS4RO0iKF0RGYhqTJSMV2OTVWbeiCqGGmVgi50BJVpcu/b+85NLJgavvqmOLL0jA99+c7O5nAm9NWRyJUDa+fXp9mObZdSMdRPEgHl6zA5hq7Ppq6tOJBKlhLUqEuYvLq893t8iOW7tUokSKbAW0f17JbQeU8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Qo6S9KsI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Qo6S9KsI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9EC6C32782;
	Mon, 12 Aug 2024 16:35:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723480513;
	bh=mIwNm6SzEps4/7zLmm3EaI8zpLYM3+LON8lw5QtNraQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Qo6S9KsI7sl3IJI2FHdQ76xwsp0KDOMgV/O9jcMfJzZ7Q3rjmpVwMTiZPr9thQCYM
	 DY8Q0hsu1zP3F1ZnQBVj2ah/ND1YePZYhaFND3Ph3aiiOLRm4l3LRhbKQsM7JEr8/x
	 CO/NDe0poe9HOKjoO/py52UYmriVeQ0wNMQe8h0s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Marek=20Marczykowski-G=C3=B3recki?= <marmarek@invisiblethingslab.com>,
	Johan Hovold <johan@kernel.org>
Subject: [PATCH 6.10 187/263] USB: serial: debug: do not echo input by default
Date: Mon, 12 Aug 2024 18:03:08 +0200
Message-ID: <20240812160153.704540456@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240812160146.517184156@linuxfoundation.org>
References: <20240812160146.517184156@linuxfoundation.org>
User-Agent: quilt/0.67
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marek Marczykowski-Górecki <marmarek@invisiblethingslab.com>

commit 00af4f3dda1461ec90d892edc10bec6d3c50c554 upstream.

This driver is intended as a "client" end of the console connection.
When connected to a host it's supposed to receive debug logs, and
possibly allow to interact with whatever debug console is available
there. Feeding messages back, depending on a configuration may cause log
messages be executed as shell commands (which can be really bad if one
is unlucky, imagine a log message like "prevented running `rm -rf
/home`"). In case of Xen, it exposes sysrq-like debug interface, and
feeding it its own logs will pretty quickly hit 'R' for "instant
reboot".

Contrary to a classic serial console, the USB one cannot be configured
ahead of time, as the device shows up only when target OS is up. And at
the time device is opened to execute relevant ioctl, it's already too
late, especially when logs start flowing shortly after device is
initialized.
Avoid the issue by changing default to no echo for this type of devices.

Signed-off-by: Marek Marczykowski-Górecki <marmarek@invisiblethingslab.com>
[ johan: amend summary; disable also ECHONL ]
Cc: stable@vger.kernel.org
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/serial/usb_debug.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/drivers/usb/serial/usb_debug.c
+++ b/drivers/usb/serial/usb_debug.c
@@ -76,6 +76,11 @@ static void usb_debug_process_read_urb(s
 	usb_serial_generic_process_read_urb(urb);
 }
 
+static void usb_debug_init_termios(struct tty_struct *tty)
+{
+	tty->termios.c_lflag &= ~(ECHO | ECHONL);
+}
+
 static struct usb_serial_driver debug_device = {
 	.driver = {
 		.owner =	THIS_MODULE,
@@ -85,6 +90,7 @@ static struct usb_serial_driver debug_de
 	.num_ports =		1,
 	.bulk_out_size =	USB_DEBUG_MAX_PACKET_SIZE,
 	.break_ctl =		usb_debug_break_ctl,
+	.init_termios =		usb_debug_init_termios,
 	.process_read_urb =	usb_debug_process_read_urb,
 };
 
@@ -96,6 +102,7 @@ static struct usb_serial_driver dbc_devi
 	.id_table =		dbc_id_table,
 	.num_ports =		1,
 	.break_ctl =		usb_debug_break_ctl,
+	.init_termios =		usb_debug_init_termios,
 	.process_read_urb =	usb_debug_process_read_urb,
 };
 


