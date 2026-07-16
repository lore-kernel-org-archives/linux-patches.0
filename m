Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C1BC2E8897;
	Thu, 16 Jul 2026 13:49:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784209797; cv=none; b=mJbuTasAv7agLQ929PYnKh+9AlUmSnjZVGHDlW0GeJmNr7MUDWeRyLI5OrqJ2Ewsg/BZ3fXMIL9VulfOIr4nHIpL5voovrqgryRbfsJSrV9ebFdjGQQQmtil8xG52Wv8FiS2pXhc8A5jAwnIFnboiVsKk+XNufbVqybxKYK2jNc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784209797; c=relaxed/simple;
	bh=vX3tkXqg02NHFCLfn3zwTfXWMToGlnIfO1VUVnRn0Bo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k9CixBixJV/dzb4WLyRDkshwvlC1OZgkTfWQbpHCCYmvru+U8R/bfEaMHvqmT8JAflrbmHYFXYDRnmm+gIuFw0MfwQj4Kv/Wsce0dJx03zOS/mSgdUcR+RxxoQnvtzpj/AULorm0supDabWSCJhvEwZPiX9b6922LQc8smzLPbs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jYVzvtfb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jYVzvtfb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 234E91F000E9;
	Thu, 16 Jul 2026 13:49:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784209791;
	bh=Rob68KTNwy0UzD/Kbxs7Q633amFoIGAN8KIuwoakRVs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jYVzvtfbRDGMNqVej33XRe0ZTHWVjfGYMKRZ8phPte0C7fX8v7lbR1pwKl/TpQlsw
	 HZEkY3Ga+4+HAHKwb9/lBP0IDuU+aZwd7A1VZe/ugmEbYC2Li5Oyc7B3mpIg/BiODe
	 +abijuKou5P4qubydRSLu4GDRMji0uyRpucwKAyw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan@kernel.org>
Subject: [PATCH 7.1 321/518] USB: serial: digi_acceleport: fix hard lockup on disconnect
Date: Thu, 16 Jul 2026 15:29:49 +0200
Message-ID: <20260716133054.842204414@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133047.772246337@linuxfoundation.org>
References: <20260716133047.772246337@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -394,12 +394,14 @@ static int digi_write_oob_command(struct
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


