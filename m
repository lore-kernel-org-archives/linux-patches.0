Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CECFE35C1A6;
	Tue, 16 Dec 2025 12:05:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765886754; cv=none; b=vFzPtobDvpD3/O9tGwf3lOcCOs6JQnwqM8wGZkL1g1/fgzD4IcQo4t12WrG0YxhmtYULyGn2Bkuv8JidU+PEu+6K59Mj2v4dslize3aHoWLNkonG4ZF5+gfa04sPmwsl5PH3QpT32Fr6Zf/6Tud3mUgXeIAy3SRnL+56lHPEfk4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765886754; c=relaxed/simple;
	bh=swTKBCvomBpuvn1ufPT83MQYU+iRxk5C1MN/5Kz0J+c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jhCp6x5QRu1vn6ECX15qhd89Iq4SvwPvFEHHX4NbxIh6vVzkj6kJIq+u7Dw/+J0r+3cArfq6E13rfmmf5GjL4UODag6dAq8FHiwJdo24y4ahvlm1snBzytsslP/FLvKsPgeR8outyPqmp4uxvtQisW8ao3NMLgeq+ugC/GGYtTU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=J/8x22zb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="J/8x22zb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC28CC4CEF1;
	Tue, 16 Dec 2025 12:05:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765886754;
	bh=swTKBCvomBpuvn1ufPT83MQYU+iRxk5C1MN/5Kz0J+c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=J/8x22zbw5pV/oI84fiTE+zDA7rj+ImZFStxL4iAhYnaeD9o1dIv5HDuFTMxBAFtI
	 yooCx+VDiGuXloQEq9s6Ru6/PKLpUecmTZ6YXWPHf9rbKoC25VTG5RsTgwj+f6yEjA
	 W9sr4RGe5AR6dXnRYHhja/D0I20IWa+llUkXL798=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Seungjin Bae <eeodqql09@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 022/614] USB: Fix descriptor count when handling invalid MBIM extended descriptor
Date: Tue, 16 Dec 2025 12:06:29 +0100
Message-ID: <20251216111402.108137776@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111401.280873349@linuxfoundation.org>
References: <20251216111401.280873349@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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



