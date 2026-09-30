Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1669F5383D8;
	Wed, 30 Sep 2026 17:52:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790790749; cv=none; b=Hujkce56dJzhTeEuevNNGSY4vfzSE72enQky0sAJW6P+YetCNIBWNu3o4kbFSaJh1MYO5uz+EqGNURpxbUSnYXPld5Ik0Iz5VCof9GEz6S4FvYFzb5mvQGcaWUd031MifURWgXmCaD7j8e6o8aG214td4zHDdne1qnr/rmIZCxs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790790749; c=relaxed/simple;
	bh=yuINZAg/DdMEhO/cm2MV6n89JvBIjA2BRSsiTP9UYLQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cVkGvMuv3oFAbk0+zDZ1vhgq66riBYpqDYvCGewj0+ax+AXufpDbhKG8TiIO5LM8dR4wkaP9/u+NsYYusQMCPIyBf0EYhT7Iqp4uigVverqLZDYn9+COgncOZ6Ge9Eb6mC9/pVJjeNeZ5hj+zheTsVaqjTF8m0CVNYkrBcFHpy4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ggCKLe3X; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ggCKLe3X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44B1E1F000FF;
	Wed, 30 Sep 2026 17:52:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790790747;
	bh=/C+JmLsOpcKGQ3bC6dY4yywVnGEnHzR+hjJMYQuy+zw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ggCKLe3Xo3yJhC/+YQbHMxZ1JsJushTiUha7ZUYrTNuEyaeMHZaFRlO8vsBvf5OLX
	 orVKYkqLfKwDWpif8yo6nLPaNg09n1DawdwaxR//4ebWlYCFFVgr7zlh/jWmgVuy16
	 fJ/l5JbmaCTWEW0WmQHCL3bkR/bq0a6+8cRKvOUQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stepan Ionichev <sozdayvek@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 059/752] usb: gadget: goku_udc: avoid NULL deref of dev->driver in INT_USBRESET log
Date: Wed, 30 Sep 2026 17:18:49 +0200
Message-ID: <20260930152359.435956627@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152358.131179731@linuxfoundation.org>
References: <20260930152358.131179731@linuxfoundation.org>
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

From: Stepan Ionichev <sozdayvek@gmail.com>

[ Upstream commit 5bf5e3fba9bc7dfd69701521dbe9809f8ccbdb02 ]

goku_irq() handles a number of bus events under a single ep0 path.
It already guards the gadget driver suspend/resume callbacks against a
NULL ->driver:

	if (dev->gadget.speed != USB_SPEED_UNKNOWN
			&& dev->driver
			&& dev->driver->resume) {
		spin_unlock(&dev->lock);
		dev->driver->resume(&dev->gadget);
		...
	}

but the very next branch unconditionally dereferences dev->driver
when an INT_USBRESET arrives:

	if (stat & INT_USBRESET) {
		ACK(INT_USBRESET);
		INFO(dev, "USB reset done, gadget %s\n",
			dev->driver->driver.name);
	}

If the controller raises INT_USBRESET before any gadget driver has
been bound (or after one has been unbound), dev->driver is NULL and
the printk dereferences NULL.

smatch flags the inconsistency:

  drivers/usb/gadget/udc/goku_udc.c:1618 goku_irq() error:
  we previously assumed 'dev->driver' could be null (see line 1607)

Fall back to a placeholder when the gadget driver is not bound.

No functional change while a gadget driver is bound.

Signed-off-by: Stepan Ionichev <sozdayvek@gmail.com>
Link: https://patch.msgid.link/20260509110636.19762-1-sozdayvek@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/gadget/udc/goku_udc.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/gadget/udc/goku_udc.c b/drivers/usb/gadget/udc/goku_udc.c
index 3e1267d38774f..b9c4adb767efa 100644
--- a/drivers/usb/gadget/udc/goku_udc.c
+++ b/drivers/usb/gadget/udc/goku_udc.c
@@ -1615,7 +1615,8 @@ static irqreturn_t goku_irq(int irq, void *_dev)
 		if (stat & INT_USBRESET) {		/* hub reset done */
 			ACK(INT_USBRESET);
 			INFO(dev, "USB reset done, gadget %s\n",
-				dev->driver->driver.name);
+				dev->driver ? dev->driver->driver.name :
+					      "<not bound>");
 		}
 		// and INT_ERR on some endpoint's crc/bitstuff/... problem
 	}
-- 
2.53.0



