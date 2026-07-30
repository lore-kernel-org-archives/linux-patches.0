Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88E3319CD1D;
	Thu, 30 Jul 2026 15:41:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785426116; cv=none; b=F/5ODqEyyrVFW3FG6pMSPzUbmbYv+0NHqPgYKNzRh0D+GAjWHY5I14JPyDHHwtOX1h5Gu9/OYBLxGMuXUT1VhnvjD28PXV3QbSa5hKct+6CSYPMmTK8uMc717LEky5rFIeyeev3a6PsMq5vTTf98QOM02uqhZsLTrn0Hb5wObmg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785426116; c=relaxed/simple;
	bh=Fk23LBSkQ//2P0ZkS9i4kR28Ej5PIzcz9uTwO3zYar8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N0fkoadjomjqQBloMC4S4ilvojab3BG61M5I9EI0RVtkLU3fUABZcz0FwicHdaIJouHjwI5Psr2sY0vTLz4Az/N+AWHWZMTDO3txRm2YyN+/UqEvspbK1AeaQh7/tzxeggq5VzHAtJVR7nKTjDFcxHgoePrVXeFZhN+EtULL5o8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GdE1K9jK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GdE1K9jK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4E381F000E9;
	Thu, 30 Jul 2026 15:41:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785426115;
	bh=zB/2yKSr8kt5YClcbSXbbW7iJUJ+9AQx2fa3TjCDbcE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GdE1K9jKgLlSOzLD3IiMYTMQWx0F03qax1KsNF04eTRL1Glzef0ijS4A6zsrxLi7i
	 DLUmskIx3ePou9YFSDZNy44QiDPvq2Fto/3/YSNUysoYTe/11cgajD6QP8UnoABBLF
	 swmlLl5e/89IEfbhK6EvCtu+D76gIDbK7E7P7XnE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan@kernel.org>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 6.12 306/602] media: cx231xx: fix devres lifetime
Date: Thu, 30 Jul 2026 16:11:38 +0200
Message-ID: <20260730141442.398111464@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141435.976815864@linuxfoundation.org>
References: <20260730141435.976815864@linuxfoundation.org>
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

From: Johan Hovold <johan@kernel.org>

commit 7d6358ab02866e5b7ed8d3a00805297617bbb0ec upstream.

USB drivers bind to USB interfaces and any device managed resources
should have their lifetime tied to the interface rather than parent USB
device. This avoids issues like memory leaks when drivers are unbound
without their devices being physically disconnected (e.g. on probe
deferral or configuration changes).

Fix the driver state lifetime so that it is released on driver unbind.

Fixes: 184a82784d50 ("[media] cx231xx: use devm_ functions to allocate memory")
Cc: stable@vger.kernel.org	# 3.17
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/usb/cx231xx/cx231xx-cards.c |   16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

--- a/drivers/media/usb/cx231xx/cx231xx-cards.c
+++ b/drivers/media/usb/cx231xx/cx231xx-cards.c
@@ -1577,7 +1577,8 @@ static int cx231xx_init_v4l2(struct cx23
 		 dev->video_mode.end_point_addr,
 		 dev->video_mode.num_alt);
 
-	dev->video_mode.alt_max_pkt_size = devm_kmalloc_array(&udev->dev, 32, dev->video_mode.num_alt, GFP_KERNEL);
+	dev->video_mode.alt_max_pkt_size = devm_kmalloc_array(&interface->dev, 32,
+							      dev->video_mode.num_alt, GFP_KERNEL);
 	if (dev->video_mode.alt_max_pkt_size == NULL)
 		return -ENOMEM;
 
@@ -1618,7 +1619,8 @@ static int cx231xx_init_v4l2(struct cx23
 		 dev->vbi_mode.num_alt);
 
 	/* compute alternate max packet sizes for vbi */
-	dev->vbi_mode.alt_max_pkt_size = devm_kmalloc_array(&udev->dev, 32, dev->vbi_mode.num_alt, GFP_KERNEL);
+	dev->vbi_mode.alt_max_pkt_size = devm_kmalloc_array(&interface->dev, 32,
+							    dev->vbi_mode.num_alt, GFP_KERNEL);
 	if (dev->vbi_mode.alt_max_pkt_size == NULL)
 		return -ENOMEM;
 
@@ -1660,7 +1662,9 @@ static int cx231xx_init_v4l2(struct cx23
 		 "sliced CC EndPoint Addr 0x%x, Alternate settings: %i\n",
 		 dev->sliced_cc_mode.end_point_addr,
 		 dev->sliced_cc_mode.num_alt);
-	dev->sliced_cc_mode.alt_max_pkt_size = devm_kmalloc_array(&udev->dev, 32, dev->sliced_cc_mode.num_alt, GFP_KERNEL);
+	dev->sliced_cc_mode.alt_max_pkt_size = devm_kmalloc_array(&interface->dev, 32,
+								  dev->sliced_cc_mode.num_alt,
+								  GFP_KERNEL);
 	if (dev->sliced_cc_mode.alt_max_pkt_size == NULL)
 		return -ENOMEM;
 
@@ -1724,7 +1728,7 @@ static int cx231xx_usb_probe(struct usb_
 	udev = usb_get_dev(interface_to_usbdev(interface));
 
 	/* allocate memory for our device state and initialize it */
-	dev = devm_kzalloc(&udev->dev, sizeof(*dev), GFP_KERNEL);
+	dev = devm_kzalloc(&interface->dev, sizeof(*dev), GFP_KERNEL);
 	if (dev == NULL) {
 		retval = -ENOMEM;
 		goto err_if;
@@ -1854,7 +1858,9 @@ static int cx231xx_usb_probe(struct usb_
 			 dev->ts1_mode.end_point_addr,
 			 dev->ts1_mode.num_alt);
 
-		dev->ts1_mode.alt_max_pkt_size = devm_kmalloc_array(&udev->dev, 32, dev->ts1_mode.num_alt, GFP_KERNEL);
+		dev->ts1_mode.alt_max_pkt_size = devm_kmalloc_array(&interface->dev, 32,
+								    dev->ts1_mode.num_alt,
+								    GFP_KERNEL);
 		if (dev->ts1_mode.alt_max_pkt_size == NULL) {
 			retval = -ENOMEM;
 			goto err_video_alt;


