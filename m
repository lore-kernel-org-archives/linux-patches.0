Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9F70370AFB;
	Tue, 21 Jul 2026 21:59:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784671173; cv=none; b=bi004zkdoKKYWv0SOrS5hP7mlsNriQ58YyuS9PDoGOGktc/CfkStWNc89+rGpz3/xl85mwa87WQT3KVEy3oC+tv638DsinrZakjIDJo+j5t8mlV/klGH3Jeh6Z0DKOR0VWTA7rU7n7gDdE85qaOjsSWXhQKIgsk0KnI2fZGocMw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784671173; c=relaxed/simple;
	bh=dLOB2Z6R8dtexvXyhcOdb7BWxgUoWLOBPJnOgAYetrw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o7a+FU/uB6szKCWA8/ywOwM5r0LFuxnxEL8N29ssRsccQCJ1C4pxZaEO282LSgN30iPIah+H22JT2RQp71zTdY5Lk0Ca0+TAwox1OJzI2LT8Na4V8vt/Zhqel+qsSEjCfk7eQg1KcO721XFT0r5Zmbrv/ogaeKiFhkP/Bply4Xc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vc+pWMKG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vc+pWMKG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F11FE1F00A3A;
	Tue, 21 Jul 2026 21:59:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784671172;
	bh=cEoIojTnbsWoB7OdcZymTr3QZOAsSzthXtLNgNPCyNo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vc+pWMKGCK96w3jKT+d7InL3SIz5WpnTrfN06U6wz6WbZPdVmLsAX9NsTNOPJLL+c
	 vPkYMHCpWMnpAeCQvrVBSY3GqkC/uasbxbOjg0ISmnAiHhC8ytEzi+h21e/mm3/Gi5
	 JMJ89c0tWX6KbX04pAb5BOwPeIH3tlykQ/xuDV9M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan@kernel.org>
Subject: [PATCH 5.15 146/843] USB: serial: digi_acceleport: fix hard lockup on disconnect
Date: Tue, 21 Jul 2026 17:16:21 +0200
Message-ID: <20260721152409.296133864@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152405.946368001@linuxfoundation.org>
References: <20260721152405.946368001@linuxfoundation.org>
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

From: Johan Hovold <johan@kernel.org>

commit 5c1ea24b53bf3bfb859f0a05573997487975da23 upstream.

If submitting the OOB write urb fails persistently (e.g if the device is
being disconnected) the driver would loop indefinitely with interrupts
disabled.

Check for urb submission errors when sending OOB commands to avoid
hanging if, for example, open(), set_termios() or close() races with a
physical disconnect.

This is issue was flagged by Sashiko when reviewing an unrelated change
to the driver.

Link: https://sashiko.dev/#/patchset/20260610132232.356139-1-johan%40kernel.org?part=1
Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: stable@vger.kernel.org
Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/serial/digi_acceleport.c |   12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

--- a/drivers/usb/serial/digi_acceleport.c
+++ b/drivers/usb/serial/digi_acceleport.c
@@ -395,12 +395,14 @@ static int digi_write_oob_command(struct
 			len &= ~3;
 		memcpy(oob_port->write_urb->transfer_buffer, buf, len);
 		oob_port->write_urb->transfer_buffer_length = len;
+
 		ret = usb_submit_urb(oob_port->write_urb, GFP_ATOMIC);
-		if (ret == 0) {
-			oob_priv->dp_write_urb_in_use = 1;
-			count -= len;
-			buf += len;
-		}
+		if (ret)
+			break;
+
+		oob_priv->dp_write_urb_in_use = 1;
+		count -= len;
+		buf += len;
 	}
 	spin_unlock_irqrestore(&oob_priv->dp_port_lock, flags);
 	if (ret)


