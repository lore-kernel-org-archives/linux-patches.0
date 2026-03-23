Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C622823DD;
	Mon, 23 Mar 2026 14:19:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774275571; cv=none; b=ukwWh6Y2I33Hoi4Kf8CH+3z34bAAGzh5kadYA8aVPnDj3Q7S/ack2A2sQSQrgCIeUhosTMNGdZJp6zSUrQlTZs9ws94MrUeCeSUcyokEMPQmI7uH9jvc7dkBGBRKJUEaoFwUePd/HMQGbiTiyK/lLGArVmNs2HUKa8hQX6fGQjQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774275571; c=relaxed/simple;
	bh=iblsEpQca5t5AecYe+LPlAQ5v65dLvQXo5FySdS5pjc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jxTErLzq2WMh3+LQo198bqVY3KdfJg0hqN1BHF68zW/h3C7ImttCe0W5Xxo8ZCafMeKbRmOguPib1fP+AHn539kBZcuhMYoibv/uyHcQOGZHf+XZ9TInaKw45BkuXtc1e+RzTZajE0VlsrW99qySok/dlHv33BM0xeanbYYD4GA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XwoBoa77; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XwoBoa77"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00120C4CEF7;
	Mon, 23 Mar 2026 14:19:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774275571;
	bh=iblsEpQca5t5AecYe+LPlAQ5v65dLvQXo5FySdS5pjc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XwoBoa77sAWv7+K2ErZEgocmvDHHoqsUp/zg1z8lNUy7uUZlFFEszpPM3SctYqC15
	 cJTgtzeb6bkWXBfZiaxv0Hm/dumKkPWi+1cGlOrhIx1kVPcdUaNa0uxsDNzQrWJFy/
	 NXKp69Tmh3yykHQmL2zZ5zqJgZim1EuooT91/sr8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Oliver Neukum <oneukum@suse.com>
Subject: [PATCH 6.12 103/460] usb: yurex: fix race in probe
Date: Mon, 23 Mar 2026 14:41:39 +0100
Message-ID: <20260323134529.181834918@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134526.647552166@linuxfoundation.org>
References: <20260323134526.647552166@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Oliver Neukum <oneukum@suse.com>

commit 7a875c09899ba0404844abfd8f0d54cdc481c151 upstream.

The bbu member of the descriptor must be set to the value
standing for uninitialized values before the URB whose
completion handler sets bbu is submitted. Otherwise there is
a window during which probing can overwrite already retrieved
data.

Cc: stable <stable@kernel.org>
Signed-off-by: Oliver Neukum <oneukum@suse.com>
Link: https://patch.msgid.link/20260209143720.1507500-1-oneukum@suse.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/misc/yurex.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/usb/misc/yurex.c
+++ b/drivers/usb/misc/yurex.c
@@ -272,6 +272,7 @@ static int yurex_probe(struct usb_interf
 			 dev->int_buffer, YUREX_BUF_SIZE, yurex_interrupt,
 			 dev, 1);
 	dev->urb->transfer_flags |= URB_NO_TRANSFER_DMA_MAP;
+	dev->bbu = -1;
 	if (usb_submit_urb(dev->urb, GFP_KERNEL)) {
 		retval = -EIO;
 		dev_err(&interface->dev, "Could not submitting URB\n");
@@ -280,7 +281,6 @@ static int yurex_probe(struct usb_interf
 
 	/* save our data pointer in this interface device */
 	usb_set_intfdata(interface, dev);
-	dev->bbu = -1;
 
 	/* we can register the device now, as it is ready */
 	retval = usb_register_dev(interface, &yurex_class);


