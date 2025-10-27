Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 546F43164B6;
	Mon, 27 Oct 2025 19:10:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761592250; cv=none; b=VLSMRPcqgefZK0g4+05cDD9YrBtr4tgUkCnCq6dEvp69LL2QBDzUzA/NkTg0yxJLFs73AHDecKhKaauPASkTv2AGjtLb1SQVLNlBfhxpkMg41jMKzpsKX3Xu+ROUVg7XpK1ofynVXB9eVLZr+/6hHGF5yyUWalnZlsJeVqta2tc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761592250; c=relaxed/simple;
	bh=lJqbOsqSTHsb3asoKyX75ZJL7ySCpEoU/yaX2ZiSvYU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NOF+Hiy2zBON6iGVVrE+b5yDQM/2RN73PxpkwShPFjeXczwRzVyScCSvqejsL+iaikc1S50rRvSVl4oj1wL58VHX2A/bFUSTWdl00rsonlU5M2S13tJERpxLZXBzt42zERlgzmLKCJNbSsjwCUWNaprhlf+5ChFm8F/g9Ab3HK4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HozwlbBv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HozwlbBv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3D3CC4CEF1;
	Mon, 27 Oct 2025 19:10:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761592250;
	bh=lJqbOsqSTHsb3asoKyX75ZJL7ySCpEoU/yaX2ZiSvYU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HozwlbBv7H4eWQFYck+YuOvUjAl6jCqcTp3mOq5S6+glLzH/KvEPJ2TLNcHpFxMi0
	 DtzpMxpf1GLCPL85X9TM96l2Y7h1yItQCBv58CpzTYyrcW33dqDdZcpYjvERmu+TbQ
	 ELwYMhAj7snfRFbg5vTmhjmWYFeAjnOmZf7bxLQw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuen-Han Tsai <khtsai@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 018/157] usb: gadget: Introduce free_usb_request helper
Date: Mon, 27 Oct 2025 19:34:39 +0100
Message-ID: <20251027183501.761142444@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183501.227243846@linuxfoundation.org>
References: <20251027183501.227243846@linuxfoundation.org>
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
Stable-dep-of: 75a5b8d4ddd4 ("usb: gadget: f_ncm: Refactor bind path to use __free()")
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
 #include <linux/device.h>
 #include <linux/errno.h>
 #include <linux/init.h>
@@ -290,6 +291,28 @@ static inline void usb_ep_fifo_flush(str
 
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


