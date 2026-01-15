Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FEFC30214B;
	Thu, 15 Jan 2026 17:41:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768498879; cv=none; b=qAyFcxWG1uFRZQgCqL2AGCpPQ3o0UUAPEizuXolZazpv4f5yQ3Gg5Cxej6byTyH9T+2JzQvesKqyE0bFCKaqi4GPSCi/m2n+SC1p7QHbo3kQuAdJ8DeHorelzkpXIJokAD62MBgQy+DKz7FqLFP48/zn0suqqypa1Ql3m0S2d3s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768498879; c=relaxed/simple;
	bh=mVZTK6wm0PAAGI7k1r4QYFlOsHGl4XUyAuezsJRlS2g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cUw3ZFtaGd2J4vaUnyPlkQGUQjsK6TTIU/PafTZaGQphQTOIp3rpHWj+flaf963MryKKVgvO5I/d0Nd7npRbgQvGpaitFfPPiCHs6V8qPcs0Yc0B85juW0NWsWuJHdEF9fvzjucnuiH6u5DeU64hT7FmcptlZp3YBGoeYztd9HA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xb0wLX2i; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xb0wLX2i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADECBC116D0;
	Thu, 15 Jan 2026 17:41:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768498879;
	bh=mVZTK6wm0PAAGI7k1r4QYFlOsHGl4XUyAuezsJRlS2g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xb0wLX2isEJZoUylgxqx42bv1dIG6pDWvAqxb4sW87Gr7+suTaZ5WRnQW8onNNn3p
	 ERAfo2iM+VFa/ys3CmuX1iIynZy63IUFyKDDGqGwPCa/Q0ibSLQjdsS8XocbRLaqWt
	 9MgnYbX57esmRm9txO68+SCVFAogQBLP/xGGFCOE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Seungjin Bae <eeodqql09@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 031/451] USB: Fix descriptor count when handling invalid MBIM extended descriptor
Date: Thu, 15 Jan 2026 17:43:52 +0100
Message-ID: <20260115164232.019372777@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164230.864985076@linuxfoundation.org>
References: <20260115164230.864985076@linuxfoundation.org>
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
index d64aaff223e79..059ea576c6c1d 100644
--- a/drivers/usb/core/message.c
+++ b/drivers/usb/core/message.c
@@ -2381,7 +2381,7 @@ int cdc_parse_cdc_header(struct usb_cdc_parsed_header *hdr,
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



