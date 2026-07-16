Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BBBE3FF1BC;
	Thu, 16 Jul 2026 14:11:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784211071; cv=none; b=txACdxkw89q92CuGkevXNLbQaymyyE5IIC2yqnzlYl+hr+BWwYyoNMJf1ocyMtgXwRDuUc3YLyrUC2+c2mIVqXe0QzkVeE7OTDfZq7JUA/3NB0Ojro5MX6XqO1u5amxVam8R0AvxoMapfLSyMHqY6N1rv7MkSTw8xr10CFzzKTw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784211071; c=relaxed/simple;
	bh=rbBKomrGOOQXoJ+8QSeASAJ7lux4TeQ4whgEDfXdZ/g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lD+Sxa15BBd8QVB6h3TcfqpWfnlY/mWwCkQ2UYjErU56Py4os+5NZCBZ4ZFeG0F0CNTZZ3MJf2xTs5rX4D3ypzzGIIGcp9zYhsLg2o7nM0wOtHPTSIvKb8KD1AvGa/8h+/fx21Bawv9Wdothh1TQY415Tm2AckWmGHnHx13qt+o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MgmPPDaI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MgmPPDaI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D4681F000E9;
	Thu, 16 Jul 2026 14:11:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784211069;
	bh=Xs9Gjv1NjbsO4u9Vtr07j/k34TRL5T6R2OwTpmVGSGc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MgmPPDaIHtjA4sO9yaOOt+CFq710Vm/w1GmUcV4BxvKWoEvtZt4p7Im288h6h4TqQ
	 tbr+ncLzyNi6fb5RncPYqXHYIv9CdebpiA4V4pMdUHfL7D9GPyZuk+9AujLx/fKr9p
	 y1/+q7JJUEUbcBTCjwlODL7nVW38nKw5JFKR5V5o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Maoyi Xie <maoyixie.tju@gmail.com>
Subject: [PATCH 6.18 289/480] usb: gadget: composite: fix dead empty check in the USB_DT_OTG handler
Date: Thu, 16 Jul 2026 15:30:36 +0200
Message-ID: <20260716133051.074301035@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133044.672218725@linuxfoundation.org>
References: <20260716133044.672218725@linuxfoundation.org>
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

From: Maoyi Xie <maoyixie.tju@gmail.com>

commit f8f680609c2b3ab795ffcd6f21585b6dfc46d395 upstream.

The OTG branch of composite_setup() falls back to the first
configuration when none is selected:

	if (cdev->config)
		config = cdev->config;
	else
		config = list_first_entry(&cdev->configs,
					  struct usb_configuration, list);
	if (!config)
		goto done;
	...
	memcpy(req->buf, config->descriptors[0], value);

list_first_entry() never returns NULL. On an empty list it returns
container_of() of the list head. So the "if (!config)" check is dead.

When cdev->configs is empty, config points at the head inside struct
usb_composite_dev. config->descriptors[0] reads whatever sits at that
offset. The memcpy copies up to w_length bytes of it into the response
buffer.

cdev->configs can be empty in two cases. One is a teardown race on
gadget unbind with a control transfer in flight. The other is a driver
that sets is_otg before it adds a config. A reproducer that holds
cdev->configs empty triggers a KASAN fault in this branch.

Use list_first_entry_or_null() so the existing check does its job.

Fixes: 53e6242db8d6 ("usb: gadget: composite: add USB_DT_OTG request handling")
Cc: stable <stable@kernel.org>
Signed-off-by: Maoyi Xie <maoyixie.tju@gmail.com>
Link: https://patch.msgid.link/20260527150832.2943293-1-maoyixie.tju@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/gadget/composite.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/usb/gadget/composite.c
+++ b/drivers/usb/gadget/composite.c
@@ -1863,9 +1863,10 @@ composite_setup(struct usb_gadget *gadge
 				if (cdev->config)
 					config = cdev->config;
 				else
-					config = list_first_entry(
+					config = list_first_entry_or_null(
 							&cdev->configs,
-						struct usb_configuration, list);
+							struct usb_configuration,
+							list);
 				if (!config)
 					goto done;
 


