Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0ECD9305688;
	Tue, 16 Jun 2026 17:25:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781630746; cv=none; b=CKg71MnctBQZIIjAf50wKNMYVlS0FYVsWCKLoVUSeK3XA8Yeb52QsvnLw8RsBWMW2ki/Ort8Q1KtROcK1ZpWeXyozphfcjUx99G3ug5lhJxKPZrfvRyZj6TWOoKBHjR6wXFo8PYRcSvwS5+qQg1nLaBjfcvczuC3JBWnyGTIcXU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781630746; c=relaxed/simple;
	bh=0osi0+eYrS4RIeK9ESdI5vUtaO0w0+ZvnVF/5Lv53eA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UxQHL2K/BBN0cx97WxkQv+6CDM4Ex12TlXMbD7iGpfcFFAFzPtLboJkfVr7N6yRR4k6iJhQazxSGnuXkgXJOnGWJkafTFCM+5TGvBDmIses5+jHW3WswMGKXOKrTZ2PmwVzxGz5glrQTQvmRH2Ip18YNa5A2aFUMxpBNRGSnNx0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hdXd3rhR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hdXd3rhR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1247D1F000E9;
	Tue, 16 Jun 2026 17:25:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781630745;
	bh=B33GC15nfcJ5Zyyu1kY92TbllsS8U3x/BBHm2gzpGxE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hdXd3rhRidrbl4e/09y1utuO7zbCFWzBpMB/HJPeaddey5/PIdSsY9wm2ajq0+gUl
	 PG0GzRJhSTqE6k/ERnwBgg5sAylg560Cm82MrQE4m+kDtZJBftUa/tNSjrweufr7T+
	 /MDNd573mL8Yac9JiGMTxRkNonuRQo8m8punwGtY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan@kernel.org>
Subject: [PATCH 6.1 088/522] USB: serial: safe_serial: fix memory corruption with small endpoint
Date: Tue, 16 Jun 2026 20:23:55 +0530
Message-ID: <20260616145129.990551157@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145125.307082728@linuxfoundation.org>
References: <20260616145125.307082728@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
 


