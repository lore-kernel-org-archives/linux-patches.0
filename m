Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 224413CE4BA;
	Tue, 16 Jun 2026 18:14:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781633648; cv=none; b=RMTY3gaF6wJGgURl5x8H8yZafDTdaVlsKAO62cXlMbpI80Qkg4XDtq4d1GP1OTAoh5RTpKAxoz4MQYrYhKXbwWlIVf+W+Ot4esPAIhjoKP6KKMwzxrV/OqmJHkUnwh2c93MjTcDg4SYnQSlUfjINR69RQZ6iNX+34e1AQ1Z1KaE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781633648; c=relaxed/simple;
	bh=7A2DxV3LgL8yZdkiAjnCMfR62z2nXxA6nX2tgqJ03bo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NDPR3DUSSPCUti0/kGXKK927DbL2yCAFFbTRUG1LlvfJ/b/MNnHp/0JludrlOaQ9z+RCpaa0ZrLG9R1hycYXaI31p2AFjfq6U60/KawoJ3fiDxAZ50klrnwtkKa/+o13Ejnlfto0+y84XHwWPbyFMkZlGQvzuAGquju9dkeMyao=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UdxijG1A; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UdxijG1A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F1201F000E9;
	Tue, 16 Jun 2026 18:14:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781633647;
	bh=u6bprMsjU1zolLXLR2/K8Yc1FQruL8jzR9SF2VUiOT4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UdxijG1A9q3/dyZJPnAXDupfeDmunDt/GTXMq1cn4zqTjLMdyyt5XbudX1g/N4kbU
	 Sa5Fz7C4w4X1km/LJny8Mn84JKfu3O8jQW4alHMuSW2BWbTQofRMM03n0ZieQaMQyo
	 ZqKLUqRy6uwINh0Pu6GeZKL19RM+FfxTRyUrhYGY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhang Cen <rollkingzzc@gmail.com>,
	Johan Hovold <johan@kernel.org>
Subject: [PATCH 5.15 117/411] USB: serial: cypress_m8: validate interrupt packet headers
Date: Tue, 16 Jun 2026 20:25:55 +0530
Message-ID: <20260616145106.527604752@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145100.376842714@linuxfoundation.org>
References: <20260616145100.376842714@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhang Cen <rollkingzzc@gmail.com>

commit 9f9bfc80c67f35a275820da7e83a35dface08281 upstream.

cypress_read_int_callback() parses the interrupt-in buffer according to
the selected Cypress packet format. Format 1 has a two-byte status/count
header and format 2 has a one-byte combined status/count header. The
usb-serial core sizes the interrupt-in buffer from the endpoint
descriptor's wMaxPacketSize, and successful interrupt transfers can
complete short when URB_SHORT_NOT_OK is not set.

Check that the completed packet contains the selected header before
reading it. Malformed short reports are ignored and the interrupt URB is
resubmitted through the existing retry path, preventing out-of-bounds
header-byte reads.

KASAN report as below:
KASAN slab-out-of-bounds in cypress_read_int_callback+0x240/0x7f0
Read of size 1
Call trace:
  cypress_read_int_callback() (drivers/usb/serial/cypress_m8.c:1009)
  __usb_hcd_giveback_urb()
  dummy_timer()

Fixes: 3416eaa1f8f8 ("USB: cypress_m8: Packet format is separate from characteristic size")
Assisted-by: Codex:gpt-5.5
Signed-off-by: Zhang Cen <rollkingzzc@gmail.com>
Fixes: 3416eaa1f8f8 ("USB: cypress_m8: Packet format is separate from characteristic size")
Cc: stable@vger.kernel.org	# 2.6.26
[ johan: use constants in header length sanity checks ]
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/serial/cypress_m8.c |   12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

--- a/drivers/usb/serial/cypress_m8.c
+++ b/drivers/usb/serial/cypress_m8.c
@@ -1018,8 +1018,8 @@ static void cypress_read_int_callback(st
 	char tty_flag = TTY_NORMAL;
 	int bytes = 0;
 	int result;
-	int i = 0;
 	int status = urb->status;
+	int i;
 
 	switch (status) {
 	case 0: /* success */
@@ -1057,22 +1057,32 @@ static void cypress_read_int_callback(st
 
 	spin_lock_irqsave(&priv->lock, flags);
 	result = urb->actual_length;
+	i = 0;
 	switch (priv->pkt_fmt) {
 	default:
 	case packet_format_1:
 		/* This is for the CY7C64013... */
+		if (result < 2)
+			break;
 		priv->current_status = data[0] & 0xF8;
 		bytes = data[1] + 2;
 		i = 2;
 		break;
 	case packet_format_2:
 		/* This is for the CY7C63743... */
+		if (result < 1)
+			break;
 		priv->current_status = data[0] & 0xF8;
 		bytes = (data[0] & 0x07) + 1;
 		i = 1;
 		break;
 	}
 	spin_unlock_irqrestore(&priv->lock, flags);
+	if (i == 0) {
+		dev_dbg(dev, "%s - short packet received: %d bytes\n",
+			__func__, result);
+		goto continue_read;
+	}
 	if (result < bytes) {
 		dev_dbg(dev,
 			"%s - wrong packet size - received %d bytes but packet said %d bytes\n",


