Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16C1633D511;
	Fri,  9 Jan 2026 11:50:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767959434; cv=none; b=JMIXQFX4Lj2uH+KzHbw9cpIdF7NJMiPYCc0joYCrBdOI7/QPPpNo232n8kIyB4JrFg/FfAOeWT6mRGxelrNKfek65QnUhGgdwu771nEYLbjxycF6ocgQ7wrBgjL+pDpYS61nT6mPEerFVqujD10aCsqAWnqpUl5Bea7EDrvtBS0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767959434; c=relaxed/simple;
	bh=ia9Ij8aeLsg1PwgIoXMEEmYx/mVTDfvUUmF+BuPX9nI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=usFxsA8DLtKZqwnh7Pcn+IVPQcLtxX0KHvuyWMse2AfbPI+Srtz1oLzTxajN2jVUCPpfpmx5ulXVQ+d37sc2O5gfDkTt6yHMTmwEWM9qEQ52Nn2qgrneMqrN0bAX1sdX9pU20hmTltZQ63jceoz1IVBvsx+3XsFPzewWNLqQSh8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NP6vMDgI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NP6vMDgI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92AB8C4CEF1;
	Fri,  9 Jan 2026 11:50:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767959434;
	bh=ia9Ij8aeLsg1PwgIoXMEEmYx/mVTDfvUUmF+BuPX9nI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NP6vMDgIjkxNnjSyh7iqslF0aoYodJFxrjmtLRpQgxYQwQaBW1kL7V7vD9HOlsg5Q
	 j6+WpNOdO4zOV1Y/EPCiRz6VkPaNRoy96P42N/UZJ/6OhXSSiAVk1b0J4UqFE+Tjo5
	 ThaDgiOg75UUPV4feB8DWTDRt5e8jtOn+V+PaKgQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Seungjin Bae <eeodqql09@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 051/737] USB: Fix descriptor count when handling invalid MBIM extended descriptor
Date: Fri,  9 Jan 2026 12:33:10 +0100
Message-ID: <20260109112135.914100382@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112133.973195406@linuxfoundation.org>
References: <20260109112133.973195406@linuxfoundation.org>
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
index 077dfe48d01c1..5a5dfbf995e3a 100644
--- a/drivers/usb/core/message.c
+++ b/drivers/usb/core/message.c
@@ -2428,7 +2428,7 @@ int cdc_parse_cdc_header(struct usb_cdc_parsed_header *hdr,
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



