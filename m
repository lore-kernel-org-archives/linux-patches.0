Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AFEB43E4BF;
	Tue, 16 Jun 2026 16:46:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781628403; cv=none; b=ArqxiGFiETlzSLvyemuxwQ3QVNZbJX4wVgcIrEjHScChcQ29HPlMhDeQo6c3MOLg7Wp4SQTHQx24l4wmcnePFWFlmpPZ3HAXpdBxeL9gTIdlEqM16EAVNcFE0mpyHEP4tY682zdzkFd5Xhn0PmDwf47XMqUufesIZgGLI6ZhpCk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781628403; c=relaxed/simple;
	bh=9ycPJHPlNYNmH452lEMd64FViwXFZz1BdyLhv6jB0bk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ufED1V0IlPz9qtIQ4QeA1XLawhQBj92H9KFH1kd/M2ub4xBXTbYCaHAZebKuD+nUui6gQ0zrBMLzDHGn4bkseThjnVCxHRXiU4LwbxcSXQq32eeoAp1gc6+MhBE5NjJdAoP8zqq90pQP9S7QeIHwEaqFgwr+slpzEHBY6VTIn6U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IxPoFN1R; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IxPoFN1R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8407E1F000E9;
	Tue, 16 Jun 2026 16:46:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781628402;
	bh=DvqkWgMm4noFiWIDsjm5mUIeE9Yi91PT1I6jMVcDj4o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IxPoFN1RLaXu4ZSeys4BFCe6bu5TLRFXqMx/X9pYiQRFVwls0Mt89JC50p8vbBzau
	 LTVBUIRlKemEzkmrAEm6WRiY+6u4EvMAWWXM4Wf6ITJhPHRPsJ6g6HGPoAtCduSzIY
	 wzIwe65Uas4p6pkcuDchNQnbBKiE5Uo3ACQJ++wg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan@kernel.org>
Subject: [PATCH 6.6 089/452] USB: serial: safe_serial: fix memory corruption with small endpoint
Date: Tue, 16 Jun 2026 20:25:16 +0530
Message-ID: <20260616145122.517455555@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145117.796205997@linuxfoundation.org>
References: <20260616145117.796205997@linuxfoundation.org>
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
 


