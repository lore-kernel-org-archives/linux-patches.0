Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 007883BED2C;
	Mon, 23 Mar 2026 16:26:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774283219; cv=none; b=jd8UuWg+uJ1KOT7BmIUfJEvu5PR1E+eXFkYY7gVnkHt+6FzDDYOEebAACqhX4s4enjV+SARZuxK4CpiJNsUkDvyesR7UEZmZ9NsxKF8I7zUHDk6u6P/AfnnKGODZCBcRHsSpUIdoKfxKfG1H2HBuDbDa3oHCNZnfHnXgydxFsTg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774283219; c=relaxed/simple;
	bh=dw2jx2clebVI7Thz6aHcY/dSUzKafN1mQhURgx0Gt1Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Alc/Kx49fU3mSWxVfp6VFkUoh4n3ZD3GFFxRdTWmK7sZVxAjN2kJojnD7G6tWdKEoFOA8gy6WUS3n8wdBJyOlqO8omkKZw2YD1VcOXndiG32cpWfoJdALZ8VRBBaYwi8kBPQ0KExJKQok8cixzM9/MSysFjR4Oho5aP3BkrhMTQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zOJ+gXQ4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zOJ+gXQ4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42157C2BC9E;
	Mon, 23 Mar 2026 16:26:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774283218;
	bh=dw2jx2clebVI7Thz6aHcY/dSUzKafN1mQhURgx0Gt1Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zOJ+gXQ4uXNfM9jIpSO/PGB240AhR8C5aSX/8LKJBZ2OdfEQGG/jEv+XXrtimNGoC
	 qgGD7aHoN1SQmMHnVYXlEwiccV+R9XY6A9uOWcnX2SyGU4h97hJ7vQBYBK2dQnG6tn
	 r8xjPaFqOm0FRMtaJ2YTaLVBgphLMzAxgJdN/Lrc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Ji-Ze Hong (Peter Hong)" <peter_hong@fintek.com.tw>,
	Johan Hovold <johan@kernel.org>
Subject: [PATCH 6.1 446/481] USB: serial: f81232: fix incomplete serial port generation
Date: Mon, 23 Mar 2026 14:47:08 +0100
Message-ID: <20260323134536.084086033@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134525.256603107@linuxfoundation.org>
References: <20260323134525.256603107@linuxfoundation.org>
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
@@ -822,36 +821,31 @@ static void f81232_lsr_worker(struct wor
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
@@ -867,6 +861,29 @@ static int f81534a_ctrl_enable_all_ports
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


