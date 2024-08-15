Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E75B419FA7E;
	Thu, 15 Aug 2024 14:01:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723730481; cv=none; b=sFejbY21sFZW7Ny0lDDn1ahjxqSpzrm9VGOv+DTlpW/gnCLi+LG7+SHSGAq0hWDpx2SS8ZF7ILO4xxFpZNnQX2hpZH94BxujMS70lAIPQdfcpRc7BIUdNIp3TqcLpkmsdhlQYC+McoSftva/xjThAzvdH8ylBUAroE/zDpAmaT4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723730481; c=relaxed/simple;
	bh=2N/+70lMBDgmqh8LWYtxVYxduj+3aOch/BEEu1JBu/I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Ss6oQdT/q0Ct1eN4tUb6+fsdSkmsS5pj0NzfO2KVWm9ryC+z3pJ0FY+gW3A4cstEHJc+y4SrMwql8tDJPDFYVyGSrSw/Mkyu5g942zjXEeY5cE91VeZRceLPDQwdsyERoMmuSUbRQVLMA0D857sc/Xi3lFCJzmY9T0o+DMfQfuk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hzXBju/s; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hzXBju/s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C60CC32786;
	Thu, 15 Aug 2024 14:01:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723730480;
	bh=2N/+70lMBDgmqh8LWYtxVYxduj+3aOch/BEEu1JBu/I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hzXBju/sEw1Y3sreU/+byr0rHeJvHsKhkNNaNO02AG26cwPaj0b0qGJYsxwTzsF2X
	 wqiQ4r2chQJNcS5AHt89ZbZ8EX+ezjH2McjYvSIizZSjtU5Tbh6gkXrmB/R+nsjC//
	 g/UHNvfuVdOaG/3uxC932N+deh1457d9C3KujbUg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Marek=20Marczykowski-G=C3=B3recki?= <marmarek@invisiblethingslab.com>,
	Johan Hovold <johan@kernel.org>
Subject: [PATCH 5.15 421/484] USB: serial: debug: do not echo input by default
Date: Thu, 15 Aug 2024 15:24:39 +0200
Message-ID: <20240815131957.717089465@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131941.255804951@linuxfoundation.org>
References: <20240815131941.255804951@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -69,6 +69,11 @@ static void usb_debug_process_read_urb(s
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
@@ -78,6 +83,7 @@ static struct usb_serial_driver debug_de
 	.num_ports =		1,
 	.bulk_out_size =	USB_DEBUG_MAX_PACKET_SIZE,
 	.break_ctl =		usb_debug_break_ctl,
+	.init_termios =		usb_debug_init_termios,
 	.process_read_urb =	usb_debug_process_read_urb,
 };
 
@@ -89,6 +95,7 @@ static struct usb_serial_driver dbc_devi
 	.id_table =		dbc_id_table,
 	.num_ports =		1,
 	.break_ctl =		usb_debug_break_ctl,
+	.init_termios =		usb_debug_init_termios,
 	.process_read_urb =	usb_debug_process_read_urb,
 };
 


