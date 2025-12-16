Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F9C1345730;
	Tue, 16 Dec 2025 11:37:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765885034; cv=none; b=cE9o4V9xRNXoErSUnXqFU1IVzNvzdUSCzUa1KYjOWPmka8nt1EEznr7PYb/OC8ByV1hJtCSjJzLfn7EaBGuxnbCk8lZ6wDYma2dQfaKwFbGn64juIq5xCrzxU9J/xvkvujXpTFPjv7rSPbf/6xMKYq3W+QxIx2WaWBOYTKGFPWQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765885034; c=relaxed/simple;
	bh=nJNGQe8DdGlhJoFVCJTnlSuZY61Rmjg8V3ilLv7Y0Xo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nUiSKeyX72E7HDt+ok0l4kb+Zgt3u1k6vxNOwJbUQxBy0knBdfy7ri3mPrDLFDATt07tAUZ24hbyVusDtpk5g78Q5lipegsdilshCwBgVN58N8e9gspwvkvE0Z0jGlIhlWeG969Yb65+o0bAwbiX0/AQUz1+QB7CPffiptXc5p0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=N/TAHhae; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="N/TAHhae"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D72DC4CEF1;
	Tue, 16 Dec 2025 11:37:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765885034;
	bh=nJNGQe8DdGlhJoFVCJTnlSuZY61Rmjg8V3ilLv7Y0Xo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=N/TAHhaeJ9d2rdLcgOhmIXhpGF8zjP11WS2Lqt/x8ZmpNAyyWqm0gEMg4f1zLX+ot
	 4MFxDduOSjTC3HokjtYh1RtjEi9U4Yh+eT5VTllZGWEsG78dzU1kanWoaI5nLidZ5C
	 uygPsGMZ0RlPQkJmrdIq7r+LTrOWHEijIgyGVk7s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Seungjin Bae <eeodqql09@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 019/507] USB: Fix descriptor count when handling invalid MBIM extended descriptor
Date: Tue, 16 Dec 2025 12:07:40 +0100
Message-ID: <20251216111346.232537515@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111345.522190956@linuxfoundation.org>
References: <20251216111345.522190956@linuxfoundation.org>
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
index d2b2787be4092..6138468c67c47 100644
--- a/drivers/usb/core/message.c
+++ b/drivers/usb/core/message.c
@@ -2431,7 +2431,7 @@ int cdc_parse_cdc_header(struct usb_cdc_parsed_header *hdr,
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



