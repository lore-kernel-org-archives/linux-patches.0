Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 489D629ACC5;
	Mon, 23 Mar 2026 16:16:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774282577; cv=none; b=MLrb4jSbmaV1B6CUsrri4O5074TonstEWxah7NUSlJhuix9qV3/ej45NSSrJ8XsDLOwnWq9rreF72Cfbqvk9BtyrZE8ylidvxGQd48f7JinVq86sc5oWp4K2JaJcXMXrM1w6iy4eQDWJCsO0fnq3+iPMPv8xNCwimrc8XTLBwuU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774282577; c=relaxed/simple;
	bh=IFxg8ReTWk7OoGNDv9dKvHN5ErnRTNjfFptt9PnyS1M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZZVI0SzbbadcQMEplxDwb6I4wNTsvJZkWCt4PmcLL6z6qOcMM1w3ZvPMYpzIj3W6z+k982Qmrc44bNL09F0ez7HtQbGU7TP6BV7xx/rsbuJF6ZtmgAw5aU1OtSGUPgv3QTHBYs1WOUhnj8T+4c4/kvkQ+3edqf3iVqtTyf+dlEg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kh86JeUY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kh86JeUY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD281C4CEF7;
	Mon, 23 Mar 2026 16:16:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774282577;
	bh=IFxg8ReTWk7OoGNDv9dKvHN5ErnRTNjfFptt9PnyS1M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kh86JeUYa4G1dJQS6ECiTOMj7ow+Axq5M/dk2f6BwkUMcCHbQmDTid9Xa9w2tLgsa
	 u5a3Gie3namVGXDRAGeQ0yPzhjcvnEJihD8S2zKbTL+uDCmlwJJtm4CM7NHpHH5Lsr
	 HGTFcESITRIYHhlkgp6AqfMemRVZbzAAcUbf2Qos=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Oliver Neukum <oneukum@suse.com>
Subject: [PATCH 6.1 208/481] usb: yurex: fix race in probe
Date: Mon, 23 Mar 2026 14:43:10 +0100
Message-ID: <20260323134530.237086250@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134525.256603107@linuxfoundation.org>
References: <20260323134525.256603107@linuxfoundation.org>
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


