Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0618C1A3029;
	Tue, 21 Oct 2025 20:07:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761077266; cv=none; b=A5G67Fo4qS87TiWdGXO7wQnCu0RDaw817/4OPpG6nNMwVeBRs9mHB7t6/Kydf/U754RZA1CeRiiHFAR0uoRbYeBG7hBheTwPdK6utf9CACWEOo9WhuSEx1QHG1g7J1JNBVS+5nIgcu8oUPFGpDyS0dUlrlqP3SNin4fym0HjSXc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761077266; c=relaxed/simple;
	bh=sWwfiqsn7ELezQN6wZ607n5WtYuSK3l5UzIEKMOmoYY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VjgDuhKwWdiRKkDTm8sJhYqliyC6H5XlrTDo/8KU9fs9R7L8ZroxPBCPbqcEAyoZtoV9eONSHRmezQmFLzmLpd4VEcXdz4FiVt+mUwG6JAMPPJU9hKeJYj+Ml5TerFLoLP9OQX737rfQcqdsZyGNaJ4Vqs0F+WnQLpHr2j7TRUs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=z7sySN4p; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="z7sySN4p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 644B2C4CEF1;
	Tue, 21 Oct 2025 20:07:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761077265;
	bh=sWwfiqsn7ELezQN6wZ607n5WtYuSK3l5UzIEKMOmoYY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=z7sySN4p6bOfIHkntuW1HpMrtwA9Jt6DCYFvWzGKVVjwtgD5Y1xvdzs5ayyyfV8YT
	 ANGJUS1szekpRUlRHBb51zqSTTgxVUpRL8leAHfv31ah5UHDQE4xLP/sVO0cd7GqxA
	 1p/iM9PquBoixH2n9C/RvftsQ357Jf4l73CWQtNA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuen-Han Tsai <khtsai@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 052/159] usb: gadget: Introduce free_usb_request helper
Date: Tue, 21 Oct 2025 21:50:29 +0200
Message-ID: <20251021195044.466003935@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251021195043.182511864@linuxfoundation.org>
References: <20251021195043.182511864@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kuen-Han Tsai <khtsai@google.com>

[ Upstream commit 201c53c687f2b55a7cc6d9f4000af4797860174b ]

Introduce the free_usb_request() function that frees both the request's
buffer and the request itself.

This function serves as the cleanup callback for DEFINE_FREE() to enable
automatic, scope-based cleanup for usb_request pointers.

Signed-off-by: Kuen-Han Tsai <khtsai@google.com>
Link: https://lore.kernel.org/r/20250916-ready-v1-2-4997bf277548@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Link: https://lore.kernel.org/r/20250916-ready-v1-2-4997bf277548@google.com
Stable-dep-of: 082289414360 ("usb: gadget: f_rndis: Refactor bind path to use __free()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/usb/gadget.h |   23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

--- a/include/linux/usb/gadget.h
+++ b/include/linux/usb/gadget.h
@@ -15,6 +15,7 @@
 #ifndef __LINUX_USB_GADGET_H
 #define __LINUX_USB_GADGET_H
 
+#include <linux/cleanup.h>
 #include <linux/configfs.h>
 #include <linux/device.h>
 #include <linux/errno.h>
@@ -293,6 +294,28 @@ static inline void usb_ep_fifo_flush(str
 
 /*-------------------------------------------------------------------------*/
 
+/**
+ * free_usb_request - frees a usb_request object and its buffer
+ * @req: the request being freed
+ *
+ * This helper function frees both the request's buffer and the request object
+ * itself by calling usb_ep_free_request(). Its signature is designed to be used
+ * with DEFINE_FREE() to enable automatic, scope-based cleanup for usb_request
+ * pointers.
+ */
+static inline void free_usb_request(struct usb_request *req)
+{
+	if (!req)
+		return;
+
+	kfree(req->buf);
+	usb_ep_free_request(req->ep, req);
+}
+
+DEFINE_FREE(free_usb_request, struct usb_request *, free_usb_request(_T))
+
+/*-------------------------------------------------------------------------*/
+
 struct usb_dcd_config_params {
 	__u8  bU1devExitLat;	/* U1 Device exit Latency */
 #define USB_DEFAULT_U1_DEV_EXIT_LAT	0x01	/* Less then 1 microsec */


