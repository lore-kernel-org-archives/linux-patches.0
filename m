Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44FF44DE720;
	Thu, 17 Sep 2026 17:54:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789667674; cv=none; b=fJ8jDGQM+//4ybv+dGbVyK5LnbVVyVZepiLME/eCUZHIC+wEK9+a/u3v5WHbdFyxwzuBRwtb9vaIuqqRNkseb0QVtK1vXkdyymLva4oBhkMS8Kj7kpYuyqLNwuxCukwxcXE4Ueo6U3hN35u34nfyNHdQMeDkDImEkyDZ93Dut3Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789667674; c=relaxed/simple;
	bh=VnAvblg49qAJvZCBk5BcJM9gCWNJZQ09AIbSPvAgylU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B5gsiSmpomWmkTF4K+x4IydCSY8vgsgyz5yrrecS5NgFTo8MKGnu+6+vnZR56oJtZOYDJWzfYoXgeYVPcPAi2mtttlbBnugU6a7M5WahgRLBKhyoFXoxvVWuQfPNG+7Xt0fKaeHjhQCqlcfaDNgxWOtEe/eDqUckJjm9rSBYVnU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WDyoA2nz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WDyoA2nz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E90C1F000FF;
	Thu, 17 Sep 2026 17:54:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789667672;
	bh=R8xyHjNrJvIIpTZoz/oX5C2CjUQaHTwOYh1AkI0eF10=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WDyoA2nze9ibITJ3Vb7rwrV8QNzxATddpDnuLdH6XD3oUWe6aCH4j9EpusMSlBFWL
	 aPxXTmjTgLJAOAHVSevnGjwSsFvFk69Q03Nwa1O0tlirNvgp7Pz+L4VwOP7tQMjWEv
	 6Xz8KlYnokMNf3JGDePDnffHLfoKnacAAexuTGeM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stepan Ionichev <sozdayvek@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0133/1102] usb: gadget: goku_udc: avoid NULL deref of dev->driver in INT_USBRESET log
Date: Thu, 17 Sep 2026 16:01:16 +0100
Message-ID: <20260917151542.860205791@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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
index b860c2e764494..c262749a29cc7 100644
--- a/drivers/usb/gadget/udc/goku_udc.c
+++ b/drivers/usb/gadget/udc/goku_udc.c
@@ -1616,7 +1616,8 @@ static irqreturn_t goku_irq(int irq, void *_dev)
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



