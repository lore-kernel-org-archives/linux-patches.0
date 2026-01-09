Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78585335567;
	Fri,  9 Jan 2026 12:25:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767961524; cv=none; b=McDv7njtq5L8hN/3/oHdfug1MGbzy+2u9+PPBessDOekrrYplzlMFZZEXukY0OFjNIZ4uDKT811GYLaB+IQFy+VbHIf3+DrLgkw10c5YPAh7+HK+f+sz+s/HNHU9aaGCB3ay/iy8t1SZDljXNO0FF0tAoHl2lV+FLw+gPEPSO90=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767961524; c=relaxed/simple;
	bh=iT+1eZA3Htg+s8MacbZ8B7GVvzP8PG6iB98H4Dj0akU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iZL/Reln5R57BIXEfjIFNvY1KqgYyEVBKWrhRYSUgLwZTfIkEEMtXYPVlVaKaFe2+VHsDKhrYfU5CsIZQtA2PtAXX+s00ogbWoJXvdBZWAWkJQZHit+XOaA5V3xCcLTquAY1E9FGCDxT0JD1aUWkhiuX7JGzEkoAZ6Gl5GN5U+M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mLqvvh/3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mLqvvh/3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB3FFC4CEF1;
	Fri,  9 Jan 2026 12:25:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767961524;
	bh=iT+1eZA3Htg+s8MacbZ8B7GVvzP8PG6iB98H4Dj0akU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mLqvvh/3fMDkKDcYmt7vJFtoErijWCKrbqBA19bYRrp0PuR5U7j46nTw7eT9enz7j
	 PABD5geQf1pswiJuSxNVvGQ+ZD38XJ+vz5sAjkOZABO7mSj5WlpJIvItCDBElByI9v
	 yvyoU93dL/yTbpjkWxIb7dhjCPmaZ1fU4M78s3Ik=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Seungjin Bae <eeodqql09@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 045/634] USB: Fix descriptor count when handling invalid MBIM extended descriptor
Date: Fri,  9 Jan 2026 12:35:23 +0100
Message-ID: <20260109112119.142238935@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112117.407257400@linuxfoundation.org>
References: <20260109112117.407257400@linuxfoundation.org>
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

From: Seungjin Bae <eeodqql09@gmail.com>

[ Upstream commit 5570ad1423ee60f6e972dadb63fb2e5f90a54cbe ]

In cdc_parse_cdc_header(), the check for the USB_CDC_MBIM_EXTENDED_TYPE
descriptor was using 'break' upon detecting an invalid length.

This was incorrect because 'break' only exits the switch statement,
causing the code to fall through to cnt++, thus incorrectly
incrementing the count of parsed descriptors for a descriptor that was
actually invalid and being discarded.

This patch changes 'break' to 'goto next_desc;' to ensure that the
logic skips the counter increment and correctly proceeds to the next
descriptor in the buffer. This maintains an accurate count of only
the successfully parsed descriptors.

Fixes: e4c6fb7794982 ("usbnet: move the CDC parser into USB core")
Signed-off-by: Seungjin Bae <eeodqql09@gmail.com>
Link: https://lore.kernel.org/r/20250928185611.764589-1-eeodqql09@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/core/message.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/core/message.c b/drivers/usb/core/message.c
index 1673e5d089263..9f65556dc3745 100644
--- a/drivers/usb/core/message.c
+++ b/drivers/usb/core/message.c
@@ -2386,7 +2386,7 @@ int cdc_parse_cdc_header(struct usb_cdc_parsed_header *hdr,
 			break;
 		case USB_CDC_MBIM_EXTENDED_TYPE:
 			if (elength < sizeof(struct usb_cdc_mbim_extended_desc))
-				break;
+				goto next_desc;
 			hdr->usb_cdc_mbim_extended_desc =
 				(struct usb_cdc_mbim_extended_desc *)buffer;
 			break;
-- 
2.51.0



