Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFE4725D8F6;
	Tue, 25 Mar 2025 12:38:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742906323; cv=none; b=KkBxutkXbbVc587lZvMgVLgbGPjiJRJLij3/WhqCyBSNhpk+BFZl1dSba44xR1AVzn6nbeQR8sdLBCXcMt8qP/d/2Y9URDRvBLgYVrUdewQyB8+8caqHsLn/IqGhpFe4wlWrTuvqOEdrC9UvUx0NWo0+VEmhTNj0p3dxeCFtzp4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742906323; c=relaxed/simple;
	bh=TLl0zf+hkOIQmCVmNyC1DiJ0WR+//OpPzQF+W8ph4Lk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qz39LksGS338/Jk1gP2zdf0dxgE/yzAjnyrrO7X8NYNQgQe1j0q28GD9yVfCat1qednH/85GMgII18fXtuVux+pH6Gcujk50Hxm3cg8YVNxGx7cjBv0uV9LOdj3wnfgCUCWuq+yy+ymEknB8dnDtpa5/MFF3B3anFUDuG6XODvg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lc+VZoDc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lc+VZoDc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60DC3C4CEE4;
	Tue, 25 Mar 2025 12:38:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742906323;
	bh=TLl0zf+hkOIQmCVmNyC1DiJ0WR+//OpPzQF+W8ph4Lk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lc+VZoDcnLu2Eb4J71dbvpeuMxAsXojK1Ow/fnX0TSKjGnZx+eNDfuZu1uYgi0QJP
	 S79bTqIe6318nNs0L2/dMLVAk45YGl5HHocS3troM2tSLpiTDUwszp42I8+mvXOr9V
	 fH/1S2QA6zk1xtEpfeg8EvPE4857sneuUIvWNvBw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+d7d8c418e8317899e88c@syzkaller.appspotmail.com,
	Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
	Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 6.12 056/116] can: ucan: fix out of bound read in strscpy() source
Date: Tue, 25 Mar 2025 08:22:23 -0400
Message-ID: <20250325122150.642033080@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250325122149.207086105@linuxfoundation.org>
References: <20250325122149.207086105@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Vincent Mailhol <mailhol.vincent@wanadoo.fr>

commit 1d22a122ffb116c3cf78053e812b8b21f8852ee9 upstream.

Commit 7fdaf8966aae ("can: ucan: use strscpy() to instead of strncpy()")
unintentionally introduced a one byte out of bound read on strscpy()'s
source argument (which is kind of ironic knowing that strscpy() is meant
to be a more secure alternative :)).

Let's consider below buffers:

  dest[len + 1]; /* will be NUL terminated */
  src[len]; /* may not be NUL terminated */

When doing:

  strncpy(dest, src, len);
  dest[len] = '\0';

strncpy() will read up to len bytes from src.

On the other hand:

  strscpy(dest, src, len + 1);

will read up to len + 1 bytes from src, that is to say, an out of bound
read of one byte will occur on src if it is not NUL terminated. Note
that the src[len] byte is never copied, but strscpy() still needs to
read it to check whether a truncation occurred or not.

This exact pattern happened in ucan.

The root cause is that the source is not NUL terminated. Instead of
doing a copy in a local buffer, directly NUL terminate it as soon as
usb_control_msg() returns. With this, the local firmware_str[] variable
can be removed.

On top of this do a couple refactors:

  - ucan_ctl_payload->raw is only used for the firmware string, so
    rename it to ucan_ctl_payload->fw_str and change its type from u8 to
    char.

  - ucan_device_request_in() is only used to retrieve the firmware
    string, so rename it to ucan_get_fw_str() and refactor it to make it
    directly handle all the string termination logic.

Reported-by: syzbot+d7d8c418e8317899e88c@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/linux-can/67b323a4.050a0220.173698.002b.GAE@google.com/
Fixes: 7fdaf8966aae ("can: ucan: use strscpy() to instead of strncpy()")
Signed-off-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Link: https://patch.msgid.link/20250218143515.627682-2-mailhol.vincent@wanadoo.fr
Cc: stable@vger.kernel.org
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/can/usb/ucan.c |   43 ++++++++++++++++++-------------------------
 1 file changed, 18 insertions(+), 25 deletions(-)

--- a/drivers/net/can/usb/ucan.c
+++ b/drivers/net/can/usb/ucan.c
@@ -186,7 +186,7 @@ union ucan_ctl_payload {
 	 */
 	struct ucan_ctl_cmd_get_protocol_version cmd_get_protocol_version;
 
-	u8 raw[128];
+	u8 fw_str[128];
 } __packed;
 
 enum {
@@ -424,18 +424,20 @@ static int ucan_ctrl_command_out(struct
 			       UCAN_USB_CTL_PIPE_TIMEOUT);
 }
 
-static int ucan_device_request_in(struct ucan_priv *up,
-				  u8 cmd, u16 subcmd, u16 datalen)
+static void ucan_get_fw_str(struct ucan_priv *up, char *fw_str, size_t size)
 {
-	return usb_control_msg(up->udev,
-			       usb_rcvctrlpipe(up->udev, 0),
-			       cmd,
-			       USB_DIR_IN | USB_TYPE_VENDOR | USB_RECIP_DEVICE,
-			       subcmd,
-			       0,
-			       up->ctl_msg_buffer,
-			       datalen,
-			       UCAN_USB_CTL_PIPE_TIMEOUT);
+	int ret;
+
+	ret = usb_control_msg(up->udev, usb_rcvctrlpipe(up->udev, 0),
+			      UCAN_DEVICE_GET_FW_STRING,
+			      USB_DIR_IN | USB_TYPE_VENDOR |
+			      USB_RECIP_DEVICE,
+			      0, 0, fw_str, size - 1,
+			      UCAN_USB_CTL_PIPE_TIMEOUT);
+	if (ret > 0)
+		fw_str[ret] = '\0';
+	else
+		strscpy(fw_str, "unknown", size);
 }
 
 /* Parse the device information structure reported by the device and
@@ -1314,7 +1316,6 @@ static int ucan_probe(struct usb_interfa
 	u8 in_ep_addr;
 	u8 out_ep_addr;
 	union ucan_ctl_payload *ctl_msg_buffer;
-	char firmware_str[sizeof(union ucan_ctl_payload) + 1];
 
 	udev = interface_to_usbdev(intf);
 
@@ -1527,17 +1528,6 @@ static int ucan_probe(struct usb_interfa
 	 */
 	ucan_parse_device_info(up, &ctl_msg_buffer->cmd_get_device_info);
 
-	/* just print some device information - if available */
-	ret = ucan_device_request_in(up, UCAN_DEVICE_GET_FW_STRING, 0,
-				     sizeof(union ucan_ctl_payload));
-	if (ret > 0) {
-		/* copy string while ensuring zero termination */
-		strscpy(firmware_str, up->ctl_msg_buffer->raw,
-			sizeof(union ucan_ctl_payload) + 1);
-	} else {
-		strcpy(firmware_str, "unknown");
-	}
-
 	/* device is compatible, reset it */
 	ret = ucan_ctrl_command_out(up, UCAN_COMMAND_RESET, 0, 0);
 	if (ret < 0)
@@ -1555,7 +1545,10 @@ static int ucan_probe(struct usb_interfa
 
 	/* initialisation complete, log device info */
 	netdev_info(up->netdev, "registered device\n");
-	netdev_info(up->netdev, "firmware string: %s\n", firmware_str);
+	ucan_get_fw_str(up, up->ctl_msg_buffer->fw_str,
+			sizeof(up->ctl_msg_buffer->fw_str));
+	netdev_info(up->netdev, "firmware string: %s\n",
+		    up->ctl_msg_buffer->fw_str);
 
 	/* success */
 	return 0;


