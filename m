Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 078492D8378;
	Sun,  7 Jun 2026 10:25:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780827948; cv=none; b=NADeQEtojLwoSUO4OZVmgQaJ+O7kdY1XUlxPTC7wNrgEIaaJndZsnydia3T/T/iZYX1NLIhK5oPXjQMB731F1sIyiVudscGq1T6QQ8snt+5BbiOFsqr1QXn9w7WiWaIwHpfLjSRnwqJ318j02U7CE8iO/XZoTbgPa7ODKltkm9k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780827948; c=relaxed/simple;
	bh=gyqNyBtqWf/171q/XKdiO7CWuvDCvx9lWeOUVCJwROM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SRNcpSd4HtL2QLxw1F5moNno2o0B6luC6x1X7yJTTCy2Fody57aLq3A7FWcYiBcy+D6I91mDsgTyYXjTanxhETgUnIJPJ+etSePC8UcIg69zCSlhcaALR+qFyiF6lKPz7y8MfxsmIDb0tZexOVyzOmraKdnSsAhhBbhQ6Cv71RA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hMjWPwjF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hMjWPwjF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D17A1F00893;
	Sun,  7 Jun 2026 10:25:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780827946;
	bh=kmH/ILhPhgM5Zz/0T6x9/ReQSPjyDRp74j3KHGSV6Mc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hMjWPwjFURiZByc9BJ90Z/byJhnjqYe5aQJrA1MmjhP8Vg4sPF4MDxmhU4BWTENuh
	 642BWf5HZZr9Li5qvprUwRq0dldMQ8GzCSGQvNU00tmf2HIzjK8QEWTa4PhaQ/g5Ir
	 oGjX05dsDFTwdTeWcIMe7q/XneO0ZlXpYw8ceEI8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan@kernel.org>
Subject: [PATCH 6.18 115/315] USB: serial: safe_serial: fix memory corruption with small endpoint
Date: Sun,  7 Jun 2026 11:58:22 +0200
Message-ID: <20260607095731.860845342@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095727.528828913@linuxfoundation.org>
References: <20260607095727.528828913@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
 


