Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9779933F8DA;
	Thu, 15 Jan 2026 16:59:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768496343; cv=none; b=Op6f29cT512D/3KTF8lK8FU/v+TBnczkv48mk1kFDCOjDfR8JSMPpVkXLNWWd52cbbgpJZofkDTJ27VlidMRj8jumLRn6z4PeRNBJxTVmYHg6w2C/Oxyv48FdXflz/m+QItFlrKzrRaHtUajlzmU/HXn3PtKsBC/P+QH+otufzs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768496343; c=relaxed/simple;
	bh=AOG2Z2l11pibM858gAzRUDLXIRtLt8NR+XsvI9jXPAg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fELuq5B84MYBy/I4LIB5bemCUNIXaDDYgr/46r74EYCGXuM47sUawCIfEw53PcDUwBC8UNL7dosXt8zOp4kVHOUp2NXPjTJWOWzAzy9vhVZC8sA6BCewNGEl+xbIJfERgEQAG9gUE26eCqmFllGWRBA736ntlW3RGM37mPBwgGk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jrv559aB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jrv559aB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24815C16AAE;
	Thu, 15 Jan 2026 16:59:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768496341;
	bh=AOG2Z2l11pibM858gAzRUDLXIRtLt8NR+XsvI9jXPAg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jrv559aB/r1IS7TU70PFD1aELg8F2WG+iZrHAbr9FERzQQr9gh6n/JjER6V2qqc6B
	 UEEwy02NtXxj9yRJjEK6yYBC6PbBngESqxjV8GMqwpR4QvuYxHPNeU1Yc0h3g/Q5rT
	 UdJwkMzqTvAZKvDG7muG6fApz/s5+7rwOJmI5pJ0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abdun Nihaal <nihaal@cse.iitm.ac.in>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 162/181] gpio: mpsse: fix reference leak in gpio_mpsse_probe() error paths
Date: Thu, 15 Jan 2026 17:48:19 +0100
Message-ID: <20260115164208.163480265@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164202.305475649@linuxfoundation.org>
References: <20260115164202.305475649@linuxfoundation.org>
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

From: Abdun Nihaal <nihaal@cse.iitm.ac.in>

[ Upstream commit 1e876e5a0875e71e34148c9feb2eedd3bf6b2b43 ]

The reference obtained by calling usb_get_dev() is not released in the
gpio_mpsse_probe() error paths. Fix that by using device managed helper
functions. Also remove the usb_put_dev() call in the disconnect function
since now it will be released automatically.

Cc: stable@vger.kernel.org
Fixes: c46a74ff05c0 ("gpio: add support for FTDI's MPSSE as GPIO")
Signed-off-by: Abdun Nihaal <nihaal@cse.iitm.ac.in>
Link: https://lore.kernel.org/r/20251226060414.20785-1-nihaal@cse.iitm.ac.in
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpio/gpio-mpsse.c |   12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

--- a/drivers/gpio/gpio-mpsse.c
+++ b/drivers/gpio/gpio-mpsse.c
@@ -538,6 +538,13 @@ static void gpio_mpsse_ida_remove(void *
 	ida_free(&gpio_mpsse_ida, priv->id);
 }
 
+static void gpio_mpsse_usb_put_dev(void *data)
+{
+	struct mpsse_priv *priv = data;
+
+	usb_put_dev(priv->udev);
+}
+
 static int mpsse_init_valid_mask(struct gpio_chip *chip,
 				 unsigned long *valid_mask,
 				 unsigned int ngpios)
@@ -582,6 +589,10 @@ static int gpio_mpsse_probe(struct usb_i
 	INIT_LIST_HEAD(&priv->workers);
 
 	priv->udev = usb_get_dev(interface_to_usbdev(interface));
+	err = devm_add_action_or_reset(dev, gpio_mpsse_usb_put_dev, priv);
+	if (err)
+		return err;
+
 	priv->intf = interface;
 	priv->intf_id = interface->cur_altsetting->desc.bInterfaceNumber;
 
@@ -703,7 +714,6 @@ static void gpio_mpsse_disconnect(struct
 
 	priv->intf = NULL;
 	usb_set_intfdata(intf, NULL);
-	usb_put_dev(priv->udev);
 }
 
 static struct usb_driver gpio_mpsse_driver = {


