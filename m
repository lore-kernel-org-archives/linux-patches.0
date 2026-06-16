Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07DB83D45D0;
	Tue, 16 Jun 2026 18:08:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781633337; cv=none; b=coBcjCCL2dnWzCYSHoyUA0hHUwhjvDqRAZ38+5CxOzpjJyfUv9dekQC6ipT8g6qca7ZfRvks74GN1zdjW3DCeWS0DwesCmWUAc6qgSo7hjBmtxH+k1zCklp/E84UMsdD+EXrtvA+fFUkSzYnvJ3vaFbLFyFCpqe29pE++toLhMk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781633337; c=relaxed/simple;
	bh=uDtIqsBe0iQ+FsIvi2cfzH3cApb373mL+71JG2xINQU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ridxEaYdY9w4i6BCYFDBqw+yJhLs1dj9Yv1i5rVO2IdIGoGjMluIC0scIHpxfurw1CA5qYDfKZxsY+mYmSGcqLNiqi1zIMc1Lg9vJNVoDiTki9X1Gu+12qFbaEba77M7v8eWwANtpm7+B+ClgM1TaftwmmJ/pTcV34NshxwBKyo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WTXi8jSC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WTXi8jSC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1676E1F000E9;
	Tue, 16 Jun 2026 18:08:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781633335;
	bh=u7Y8htDUflrRDsup/U9uhXH+vM+9H1wqEJDzCzU4kJM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WTXi8jSCtMqaHpshgPKZR+rbF6+jLgaUcnWcgsZRMh3k/dt1JH4eowMWjqSZw4VUX
	 IGiswAqqeIMQ+a2PqEjD+qN20Lg5LPXFXO9OtBJNRGE43PBaImrRhgCH9tjF4tprpV
	 aDHAp3nU28ivbZ3vgi8VHukySviFaGidcfPS6ibQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan@kernel.org>
Subject: [PATCH 5.15 060/411] USB: serial: safe_serial: fix memory corruption with small endpoint
Date: Tue, 16 Jun 2026 20:24:58 +0530
Message-ID: <20260616145103.471894948@linuxfoundation.org>
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
 


