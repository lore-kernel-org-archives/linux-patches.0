Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C85112D94A7;
	Thu, 15 Jan 2026 17:15:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768497315; cv=none; b=iax5q5KUEfYSvcWSbXDkebRxAPdFe7m97GYbv3DV81wUvK9Jw5XNdU/kG4cmineFogO7FA7WxhVKkv3EW7h8vGrdVfSYGIp34ihruP24/OAvkKq7nQtAztSZPJKy5cqJVnrpRlYllqp7HNjrbvJq5Gb4wPPRMPSv8uo4XZ3CRzA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768497315; c=relaxed/simple;
	bh=U7u1TUh0OHomWijcF4ztdVl9skDRxy/26AolChJj8Ls=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bvKzBG9BZKzWhX83pKH1niF0mKO+5fwvRUP9BRgh+GCGAj371SNjjHYSf0m81smXpjmK9PnqOoTdW5yi95hVMpG6wR2xmlIfLMWq3CR6YGaqz9X5Oh5Z+hdZPaG6d/1N2c8pZHJYiU/7ucKGZrXe5HtneQSncm8OU7YVypdt84U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=D+6YgUlS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="D+6YgUlS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FD66C116D0;
	Thu, 15 Jan 2026 17:15:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768497315;
	bh=U7u1TUh0OHomWijcF4ztdVl9skDRxy/26AolChJj8Ls=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=D+6YgUlS23UROizlElO2v7HHFcLhh20LGajY5wAr+P23lnGjXRL/w9r72Hqa+3KuS
	 r22f4bdg1kJV0LckV4bUus6lGLEsGtBiUzlGH64QKrvN/iJdgJxKsmXkqnDI4cz5tr
	 BOtDjGmsDs0CVyJsuKybXNn89p5Bk/OBNTLWfkWk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Seungjin Bae <eeodqql09@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 039/554] USB: Fix descriptor count when handling invalid MBIM extended descriptor
Date: Thu, 15 Jan 2026 17:41:45 +0100
Message-ID: <20260115164247.655029150@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164246.225995385@linuxfoundation.org>
References: <20260115164246.225995385@linuxfoundation.org>
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



