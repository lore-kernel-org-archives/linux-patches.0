Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86B224071DD;
	Sun,  7 Jun 2026 10:50:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780829458; cv=none; b=LWfa+b8ZYPb++vDsOyBQe5zOLemhLF+T1HXhk/pz2DvrBz/jWiXM/4Sa9+l/vAQ9+z/6h+tBuTiiax9smN+zopTdDBH8OeI1yPvUCL7YxkDCWl2pQmH7+bBfoIA79SpKVeVZp9vthR4ac2mLSQGwwfnFQLUNHDVd0Omlam0EyJ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780829458; c=relaxed/simple;
	bh=mU6fmH+9fxQNMrJhYvBttvQn61CjxViBuVPE9i3J+hQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nZbu17ZwcfFpGJXvgLUhnQiLlCL3pLWPMr/WZJSKiDU3pPAmbCELaD30VVhGPsOwMmNDCzWMs54ND4VpbK+uXO3QKS04C6rmPOo9d/SdaxNKSQ30b/7iGrIGbrVVnMc8mGbzMeoYmgxGFDLcpVjd8TXH08kvqkJn8XFffFmDEOc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dTr0P1bo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dTr0P1bo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 823701F00893;
	Sun,  7 Jun 2026 10:50:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780829457;
	bh=dIbuXqGCQx7sQ0rUPHXnB1otXTgZOzlFgOHozmrEOlM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dTr0P1bo2V64iplhBCG7+syOcM1DC3c1XSMldgFfHgOeZtN2kbBLmCHlX1YzBfDJX
	 mSRhuNk6X3sdtmKfQ8et6xO7IiSQbWND7Sl+I048Ch3kBo3vaBAJRYm/EtNZ8G8nq8
	 xLk1CEznYpZHQvRtVhcoDixpY/OirqlVQUMxxVIs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhang Cen <rollkingzzc@gmail.com>,
	Johan Hovold <johan@kernel.org>
Subject: [PATCH 6.12 226/307] USB: serial: cypress_m8: validate interrupt packet headers
Date: Sun,  7 Jun 2026 12:00:23 +0200
Message-ID: <20260607095736.003257994@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095727.647295505@linuxfoundation.org>
References: <20260607095727.647295505@linuxfoundation.org>
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
@@ -1017,8 +1017,8 @@ static void cypress_read_int_callback(st
 	char tty_flag = TTY_NORMAL;
 	int bytes = 0;
 	int result;
-	int i = 0;
 	int status = urb->status;
+	int i;
 
 	switch (status) {
 	case 0: /* success */
@@ -1056,22 +1056,32 @@ static void cypress_read_int_callback(st
 
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


