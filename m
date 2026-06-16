Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 776803CFF55;
	Tue, 16 Jun 2026 18:47:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781635669; cv=none; b=a3bHJ+8cs+58/nDTzNbiVD8u+0GAMS37r5oJ2RYyEtf1KgswtrQzEdtJ31+O51R2Mch+wEQSrX3s0dmjVyDHXsrwtcH1TA/UOvb7T7WEABQ8DLGWR+y72/laQFZbCtorKEfmh0/4e0PU+p1pvZyq50+Dz8/10R3aX82uLqNZnMw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781635669; c=relaxed/simple;
	bh=2iHp9pp9P2efIlr+nNURPvNWQMUjpAxZGOV5mLCPNAc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hnHiU3DmkWpNqrjeIHpQgaRWA/5JAjsI61UCs/dCRcB+uw/xxfEELiB9HXNhPAnSHQOOxX/59PM6ym3031VkMxgLQ+n6oVnn2C9f6No3IFTmWkDoxuowTK9A+IEiU74fBWEG0BTvsMlgnRKaulnvA0wDRESVbLuaMklHwDZ0W+g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2c8/UxTQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2c8/UxTQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D22D1F000E9;
	Tue, 16 Jun 2026 18:47:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781635668;
	bh=BnNJYS47TqI/3bwX2vqv/opG/rzC7RVBsxF/E5ssCy8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2c8/UxTQt0tUbCCIxWZDkpGhIXxH0SICyHGrhcIoG9MzAbDJauwfHfY3qof3vkEf4
	 p8Zqchj5evfYmPuZ/3RfM0uTiNQkPJlC2S19ebC7WhjilFAdORXhwTD8gmvLS+und1
	 wcWBX00Sj0CZrDJ8AnoXoNPYIWWENihbzEqz2iNs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan@kernel.org>
Subject: [PATCH 5.10 049/342] USB: serial: safe_serial: fix memory corruption with small endpoint
Date: Tue, 16 Jun 2026 20:25:45 +0530
Message-ID: <20260616145050.542019924@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145048.348037099@linuxfoundation.org>
References: <20260616145048.348037099@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan@kernel.org>

commit 438061ed1ad85e6743e2dce826671772d81089ec upstream.

Make sure that the bulk-out buffer size is at least eight bytes to avoid
user-controlled slab corruption in "safe" mode should a malicious device
report a smaller size.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: stable@vger.kernel.org
Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/serial/safe_serial.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

--- a/drivers/usb/serial/safe_serial.c
+++ b/drivers/usb/serial/safe_serial.c
@@ -259,6 +259,7 @@ static int safe_prepare_write_buffer(str
 static int safe_startup(struct usb_serial *serial)
 {
 	struct usb_interface_descriptor	*desc;
+	int bulk_out_size;
 
 	if (serial->dev->descriptor.bDeviceClass != CDC_DEVICE_CLASS)
 		return -ENODEV;
@@ -279,6 +280,16 @@ static int safe_startup(struct usb_seria
 	default:
 		return -EINVAL;
 	}
+
+	/*
+	 * The bulk-out buffer needs to be large enough for the two-byte
+	 * trailer in safe mode, but assume anything smaller than eight bytes
+	 * is broken.
+	 */
+	bulk_out_size = serial->port[0]->bulk_out_size;
+	if (bulk_out_size > 0 && bulk_out_size < 8)
+		return -EINVAL;
+
 	return 0;
 }
 


