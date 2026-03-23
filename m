Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BA3E3B585E;
	Mon, 23 Mar 2026 15:23:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774279388; cv=none; b=R2/08rKyLu12wLpVG3evbBYwOhl1Hax9E4OWGqNVahMDs7pqT/DQRrtO+bVvmExT2vn/QJPZhHZfvWAcKfOQPE3dANi628DyCyqHR+VlM1EqHBmi1mqvv6gVVheX7m/IXkBzsQnuEKdFiw66VKCTy7YXfMkmT596DIceHO7LNZY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774279388; c=relaxed/simple;
	bh=SFUumI09ZcfIrTCnZ4CXhHwIiA1OfbU+2ijNW3SchW4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tGayvC06FG2COb9NQZbSId5La4RT2DkyPJMGKzp8MHXjbpHRQoMoAUvqgi6I2KfMT6PCENS6+UU1QsXSjZRbniee6pYFtYWxNK/pmJSMiU8rCXkZUvPJ6nBBzP9kI+fQoNuMKwFYjK+dAyIe+oN0WX9gVQ8Or8L2I8pTj7SBP94=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AnU+GDlu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AnU+GDlu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 862D6C2BCB1;
	Mon, 23 Mar 2026 15:23:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774279387;
	bh=SFUumI09ZcfIrTCnZ4CXhHwIiA1OfbU+2ijNW3SchW4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AnU+GDlunlnncet6fhI8Pk8I2ygKWD6GqAK2lfoeMrf4VKkOplUVwnAIUQTDIOfCe
	 R6i/dhDblF+fvdqEi2wHzdiHUjU9VDnZc/dheI3iPpLvPIe6WlmqMbwGVUNU7bmysO
	 Z5MNhcnNSM9Uwthok/OXojtBJX4PoZFUAUoxxTWk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Ji-Ze Hong (Peter Hong)" <peter_hong@fintek.com.tw>,
	Johan Hovold <johan@kernel.org>
Subject: [PATCH 6.6 553/567] USB: serial: f81232: fix incomplete serial port generation
Date: Mon, 23 Mar 2026 14:47:53 +0100
Message-ID: <20260323134547.685613783@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134533.749096647@linuxfoundation.org>
References: <20260323134533.749096647@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ji-Ze Hong (Peter Hong) <peter_hong@fintek.com.tw>

commit cd644b805da8a253198718741bf363c4c58862ff upstream.

The Fintek F81532A/534A/535/536 family relies on the
F81534A_CTRL_CMD_ENABLE_PORT (116h) register during initialization to
both determine serial port status and control port creation. If the
driver experiences fast load/unload cycles, the device state may becomes
unstable, resulting in the incomplete generation of serial ports.

Performing a dummy read operation on the register prior to the initial
write command resolves the issue. This clears the device's stale internal
state. Subsequent write operations will correctly generate all serial
ports.

This patch also removes the retry loop in f81534a_ctrl_set_register()
because the stale state has been fixed.

Tested on: HygonDM1SLT(Hygon C86 3250 8-core Processor)

Signed-off-by: Ji-Ze Hong (Peter Hong) <peter_hong@fintek.com.tw>
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/serial/f81232.c |   77 ++++++++++++++++++++++++++------------------
 1 file changed, 47 insertions(+), 30 deletions(-)

--- a/drivers/usb/serial/f81232.c
+++ b/drivers/usb/serial/f81232.c
@@ -70,7 +70,6 @@ MODULE_DEVICE_TABLE(usb, combined_id_tab
 #define F81232_REGISTER_REQUEST		0xa0
 #define F81232_GET_REGISTER		0xc0
 #define F81232_SET_REGISTER		0x40
-#define F81534A_ACCESS_REG_RETRY	2
 
 #define SERIAL_BASE_ADDRESS		0x0120
 #define RECEIVE_BUFFER_REGISTER		(0x00 + SERIAL_BASE_ADDRESS)
@@ -824,36 +823,31 @@ static void f81232_lsr_worker(struct wor
 static int f81534a_ctrl_set_register(struct usb_interface *intf, u16 reg,
 					u16 size, void *val)
 {
-	struct usb_device *dev = interface_to_usbdev(intf);
-	int retry = F81534A_ACCESS_REG_RETRY;
-	int status;
-
-	while (retry--) {
-		status = usb_control_msg_send(dev,
-					      0,
-					      F81232_REGISTER_REQUEST,
-					      F81232_SET_REGISTER,
-					      reg,
-					      0,
-					      val,
-					      size,
-					      USB_CTRL_SET_TIMEOUT,
-					      GFP_KERNEL);
-		if (status) {
-			status = usb_translate_errors(status);
-			if (status == -EIO)
-				continue;
-		}
-
-		break;
-	}
-
-	if (status) {
-		dev_err(&intf->dev, "failed to set register 0x%x: %d\n",
-				reg, status);
-	}
+	return usb_control_msg_send(interface_to_usbdev(intf),
+						0,
+						F81232_REGISTER_REQUEST,
+						F81232_SET_REGISTER,
+						reg,
+						0,
+						val,
+						size,
+						USB_CTRL_SET_TIMEOUT,
+						GFP_KERNEL);
+}
 
-	return status;
+static int f81534a_ctrl_get_register(struct usb_interface *intf, u16 reg,
+					u16 size, void *val)
+{
+	return usb_control_msg_recv(interface_to_usbdev(intf),
+						0,
+						F81232_REGISTER_REQUEST,
+						F81232_GET_REGISTER,
+						reg,
+						0,
+						val,
+						size,
+						USB_CTRL_GET_TIMEOUT,
+						GFP_KERNEL);
 }
 
 static int f81534a_ctrl_enable_all_ports(struct usb_interface *intf, bool en)
@@ -869,6 +863,29 @@ static int f81534a_ctrl_enable_all_ports
 	 * bit 0~11	: Serial port enable bit.
 	 */
 	if (en) {
+		/*
+		 * The Fintek F81532A/534A/535/536 family relies on the
+		 * F81534A_CTRL_CMD_ENABLE_PORT (116h) register during
+		 * initialization to both determine serial port status and
+		 * control port creation.
+		 *
+		 * If the driver experiences fast load/unload cycles, the
+		 * device state may becomes unstable, resulting in the
+		 * incomplete generation of serial ports.
+		 *
+		 * Performing a dummy read operation on the register prior
+		 * to the initial write command resolves the issue.
+		 *
+		 * This clears the device's stale internal state. Subsequent
+		 * write operations will correctly generate all serial ports.
+		 */
+		status = f81534a_ctrl_get_register(intf,
+						F81534A_CTRL_CMD_ENABLE_PORT,
+						sizeof(enable),
+						enable);
+		if (status)
+			return status;
+
 		enable[0] = 0xff;
 		enable[1] = 0x8f;
 	}


