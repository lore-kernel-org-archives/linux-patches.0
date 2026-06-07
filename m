Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F900202C46;
	Sun,  7 Jun 2026 10:25:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780827910; cv=none; b=dVEsVJA/jY2DyIlrAjKiB0axAe3ykHvzyyVEmj+sDUJ50s7A8uobrJd9HqjOGvF19KzNj0O6rlZ0cwIP3nWlTVBptWuYyeO2qduxgk9PQ2w1/kXo2apl50Qw30LLkSVFKm9/UCmc6J9IZcaCghI7i9vHdoozUoIXBcXTVOPghn8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780827910; c=relaxed/simple;
	bh=LeHhIHcwZnqje1NpehLAN8w5D5rrQ+E37LFDgjUJtaQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n3Wym5HUYMRKVh3fC0hVUTJ+AMxOPEFTNwvd0HZ9bXLNCf6ca+bZBJ1LcCveiv2DykpySNAdGx1ZvX9ht0/W2ZPM71bokJD1KVrfPldT7yCO5wizbECoUeeNhj26wG5M3HZUQee9j41rRV8DOVPwZfQaG5rBFI9Khg/9X6JGeNE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1NKUH3pa; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1NKUH3pa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D97591F00893;
	Sun,  7 Jun 2026 10:25:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780827909;
	bh=ljSiUK1/fKXUnSSXpj1e85oOc9nHwjlrbZiexA0hr1A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1NKUH3paGCBoraoUy6Cwd7ADm366Uuk15x5/us5+PG675AAPPO8U9eNnR1Q0L7TDo
	 j8DkRKwAC+Pd7GOGHTMXimo9Rm9JtyKGjngKX2jE/FcHaYo0clSacJwlId6R6jPrcm
	 OvxT8EwBoTBswcmr0UMz0YmYR6WvDZksccaVC0o8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan@kernel.org>
Subject: [PATCH 7.0 129/332] USB: serial: safe_serial: fix memory corruption with small endpoint
Date: Sun,  7 Jun 2026 11:58:18 +0200
Message-ID: <20260607095732.843110755@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095728.031258202@linuxfoundation.org>
References: <20260607095728.031258202@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

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
 


