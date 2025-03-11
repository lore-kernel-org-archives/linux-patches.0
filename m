Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60E121E98EC;
	Tue, 11 Mar 2025 15:39:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741707572; cv=none; b=oTdWD2gtGdJFV5ZcSYHk+NBFF9mOPH9rHOnsuW5UrUeYqFIvaY/MBhnOmVUPyYoCwFdbTBCVoy6mO8K8ydykteEHGx7Mj1SNhBWQYwKx4vK5IsbAihe/i8tgCSjM3gFNwy6rsGpeYQI0l/08Z56HoQAcmn5kM911Qg2SZy2EvAg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741707572; c=relaxed/simple;
	bh=AjcUD/0FcfQlBzg9t4KQYlKP7yHsWvHIepgiOvB6OEw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pAhbgUCN2iVXRPTLlUrENkSwtzIPSGYOxkM9B8vpkaPi9VpCJYlnkyByB/quZA6nNItYDA5GSpbboX9PjavzzdEjFI+v1/Hgz2BjDiqT1dZCpcW1N2VXuZ7S7qlnGpk5o8eDqcJcgPUh11hjWeU7LqCcRk0T3N1WyT8ax2nZS/w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dblxXya9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dblxXya9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC673C4CEE9;
	Tue, 11 Mar 2025 15:39:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741707572;
	bh=AjcUD/0FcfQlBzg9t4KQYlKP7yHsWvHIepgiOvB6OEw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dblxXya9aYE63f22xLC2Oj5JuUVzP3wO62qcWuXGeMfi+/FkV5HbHJpNG4MFMCVt8
	 OmFyOLkQkC8vrtaOZBl947jc5rvmZb3fLUsc2xeFYg0exX8+YDww048yD8/bNSQCqw
	 3B+TLbkkK5KLi3b5D2gPx4mk06hEGNDq9cFREJkA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Marek Szyprowski <m.szyprowski@samsung.com>
Subject: [PATCH 5.10 434/462] usb: gadget: Fix setting self-powered state on suspend
Date: Tue, 11 Mar 2025 16:01:40 +0100
Message-ID: <20250311145815.478538286@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250311145758.343076290@linuxfoundation.org>
References: <20250311145758.343076290@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Marek Szyprowski <m.szyprowski@samsung.com>

commit c783e1258f29c5caac9eea0aea6b172870f1baf8 upstream.

cdev->config might be NULL, so check it before dereferencing.

CC: stable <stable@kernel.org>
Fixes: 40e89ff5750f ("usb: gadget: Set self-powered based on MaxPower and bmAttributes")
Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
Link: https://lore.kernel.org/r/20250220120314.3614330-1-m.szyprowski@samsung.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/gadget/composite.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/usb/gadget/composite.c
+++ b/drivers/usb/gadget/composite.c
@@ -2366,7 +2366,8 @@ void composite_suspend(struct usb_gadget
 
 	cdev->suspended = 1;
 
-	if (cdev->config->bmAttributes & USB_CONFIG_ATT_SELFPOWER)
+	if (cdev->config &&
+	    cdev->config->bmAttributes & USB_CONFIG_ATT_SELFPOWER)
 		usb_gadget_set_selfpowered(gadget);
 
 	usb_gadget_vbus_draw(gadget, 2);


