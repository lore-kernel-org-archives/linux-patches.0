Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64465175BF;
	Mon, 12 May 2025 18:03:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747072996; cv=none; b=iyNgOZof37EeU6PTzKNXwH943lv1ruZRqY9Lm7KeLlqylSGHfe7FzMxOdj7B3qIuIEiD1kE3hOb4BrMo0VwC6/vYDYDKTvi0ibPKEmE7yvsft7i0Y/HlWUso/udFZoQFzvT3vSuj8XHHgIJq+pErLab7KP9yxH/fslMg6TwR8Ds=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747072996; c=relaxed/simple;
	bh=i89B6QdUCELWPw9LqYgQXpBnzvds08uyL8snpdi8gV4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jwAT8xvvlSsHJrHIpLXUDay7LCnM2ZmhRQ7USP23a4FpthkpSN4nR8UIZczG1zvHj+BtibJe2EIMAXHPFPgPBk+MiEnjDkWvlfyCXmIvxrHPB6mH/36nH2KfFPv8tye2VKXFpuOPsDu8WTB0jCbzR0CXBSFcBM7MyUkI8jreXL4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kXOIZX02; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kXOIZX02"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D619BC4CEE7;
	Mon, 12 May 2025 18:03:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747072996;
	bh=i89B6QdUCELWPw9LqYgQXpBnzvds08uyL8snpdi8gV4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kXOIZX02Kw/MppxguSox2JQJWvD4xT/Y4ykwETOEixm1gqMPFFOHQkyxqLwZnH+0Z
	 NCsLkBUmP2/kghJHLfmyvZrIFnJCvr8DTTh7ElQi7jYna6mm16rA/n+IG30S1lioN8
	 iII5S/rdhnu4HcaYtViWKlvYopZeD9cY3f/wv0OI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Prashanth K <prashanth.k@oss.qualcomm.com>,
	Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Subject: [PATCH 6.12 121/184] usb: gadget: Use get_status callback to set remote wakeup capability
Date: Mon, 12 May 2025 19:45:22 +0200
Message-ID: <20250512172046.748193192@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250512172041.624042835@linuxfoundation.org>
References: <20250512172041.624042835@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Prashanth K <prashanth.k@oss.qualcomm.com>

commit 5977a58dd5a4865198b0204b998adb0f634abe19 upstream.

Currently when the host sends GET_STATUS request for an interface,
we use get_status callbacks to set/clear remote wakeup capability
of that interface. And if get_status callback isn't present for
that interface, then we assume its remote wakeup capability based
on bmAttributes.

Now consider a scenario, where we have a USB configuration with
multiple interfaces (say ECM + ADB), here ECM is remote wakeup
capable and as of now ADB isn't. And bmAttributes will indicate
the device as wakeup capable. With the current implementation,
when host sends GET_STATUS request for both interfaces, we will
set FUNC_RW_CAP for both. This results in USB3 CV Chapter 9.15
(Function Remote Wakeup Test) failures as host expects remote
wakeup from both interfaces.

The above scenario is just an example, and the failure can be
observed if we use configuration with any interface except ECM.
Hence avoid configuring remote wakeup capability from composite
driver based on bmAttributes, instead use get_status callbacks
and let the function drivers decide this.

Cc: stable <stable@kernel.org>
Fixes: 481c225c4802 ("usb: gadget: Handle function suspend feature selector")
Signed-off-by: Prashanth K <prashanth.k@oss.qualcomm.com>
Reviewed-by: Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Link: https://lore.kernel.org/r/20250422103231.1954387-3-prashanth.k@oss.qualcomm.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/gadget/composite.c |   12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

--- a/drivers/usb/gadget/composite.c
+++ b/drivers/usb/gadget/composite.c
@@ -2011,15 +2011,13 @@ composite_setup(struct usb_gadget *gadge
 
 		if (f->get_status) {
 			status = f->get_status(f);
+
 			if (status < 0)
 				break;
-		} else {
-			/* Set D0 and D1 bits based on func wakeup capability */
-			if (f->config->bmAttributes & USB_CONFIG_ATT_WAKEUP) {
-				status |= USB_INTRF_STAT_FUNC_RW_CAP;
-				if (f->func_wakeup_armed)
-					status |= USB_INTRF_STAT_FUNC_RW;
-			}
+
+			/* if D5 is not set, then device is not wakeup capable */
+			if (!(f->config->bmAttributes & USB_CONFIG_ATT_WAKEUP))
+				status &= ~(USB_INTRF_STAT_FUNC_RW_CAP | USB_INTRF_STAT_FUNC_RW);
 		}
 
 		put_unaligned_le16(status & 0x0000ffff, req->buf);


