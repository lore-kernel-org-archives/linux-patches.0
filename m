Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB8FE184551;
	Mon, 12 Aug 2024 16:11:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723479076; cv=none; b=lHKDtNQY3l2bAAEWVW6Ww45R5FVl7bh1+MaI7HN8sG8e9O47q9Bn3RCbFea0An5HyBtTozvB6yVnl8sepBsNbJRhhEffHvTEntpcjtVxWcCS12HXDvpShPlGYRMpyfGx5BDdxluayX+6ZhKBmc/2vfVT9UEo4gxehRTf4m3qj4s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723479076; c=relaxed/simple;
	bh=lbWSG5EYr2U1+jQpHwwsZIskGUPFvTL3sf5lksU6fnI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Xt0h8E4WTbEy6slYsmagrh1FYtkgOLy71mzvf/yK7X82o6QHiO5Nw57WTKTWOtskAVx4oVUIZK3aoTzxCtpPE/Uc6wN89rPih8z0WBMqqOhi+tjyhzFPO3byEl65VjLudXX7VilEHWXUwl8W02yehx+0OitA9g4PIGDZRx2wHxo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PkN1gwze; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PkN1gwze"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30D9CC32782;
	Mon, 12 Aug 2024 16:11:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723479076;
	bh=lbWSG5EYr2U1+jQpHwwsZIskGUPFvTL3sf5lksU6fnI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PkN1gwzeiYbIk1C31R+7e+EwZ1JSoiVhjuBgL+EO/AP+WZ8mV2SRfsjH69Y2QrjnW
	 bKv0dqbGu9B/I0m9C2ASHJypJd/AmMfxfmF4Y6ZRbW1T/h4Yt5Sfwc3ax5cG8iAX+u
	 PMy4e+J8BLBUX0y69OXNxvCmvHAJntgzu1fMBlj4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Marek=20Marczykowski-G=C3=B3recki?= <marmarek@invisiblethingslab.com>,
	Johan Hovold <johan@kernel.org>
Subject: [PATCH 6.1 094/150] USB: serial: debug: do not echo input by default
Date: Mon, 12 Aug 2024 18:02:55 +0200
Message-ID: <20240812160128.791388365@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240812160125.139701076@linuxfoundation.org>
References: <20240812160125.139701076@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
 


