Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A5EF3B47E6;
	Mon, 23 Mar 2026 15:05:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774278338; cv=none; b=Npgukx48EL+lGWbdFLIyPbQM820Hj5/KpZoJxjhRBdVSmssSdkBlTTqwpK0Fu3Zt1QypmlnTtIwkjkr7g6hex/Ar8EjAyBl65+H7sGJYNqlKXzYooy8ombHhokVLVflCpoEw3stjgt0YwX5wQdmloTrY6F+Dlh3toiQUGwsIYrE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774278338; c=relaxed/simple;
	bh=U2ONHiB4vf9QGFPCCpLGQ8v01f8yTvEUwFmXxDpbzyc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XPLL9dxQVOwE6DEz1x5OFskc1RVZU433poubZ7KnxNLaDe9MLvysEhqteu8Mqxyc9EngXN+lSKojJIrVItd+LQ6tXpVE5DT7aLo0+QKu2vmHke2u0B091wtpnddnPNb3fG4wzvMRA4p77Z+d+/HrkCORos18kEy7U3Kb5qKxUhI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=i9EvRdij; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="i9EvRdij"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD017C2BC9E;
	Mon, 23 Mar 2026 15:05:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774278338;
	bh=U2ONHiB4vf9QGFPCCpLGQ8v01f8yTvEUwFmXxDpbzyc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=i9EvRdijefWAivwzGBRBjLkTCQbN6aGaJeOVWKMT1s3GX8RWHkBbEBn0nlhgRp1aT
	 ctCWubIapq4qkmREK41OQryJJy4ADOk6gPEPprKzBVTuzTAOQockuolN13zSnFyecC
	 kaWgc7WNrxZkMqRTp3rmn3dY9tD7/eIgHptaffFM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Oliver Neukum <oneukum@suse.com>
Subject: [PATCH 6.6 274/567] usb: yurex: fix race in probe
Date: Mon, 23 Mar 2026 14:43:14 +0100
Message-ID: <20260323134540.608496850@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134533.749096647@linuxfoundation.org>
References: <20260323134533.749096647@linuxfoundation.org>
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


