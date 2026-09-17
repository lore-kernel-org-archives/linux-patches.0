Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57DD34848BD;
	Thu, 17 Sep 2026 16:51:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789663887; cv=none; b=kiyvCXJFRG7IZ8vLtjBwMQuPJCCXuupfgsddcmGl9jxS6gydCPHbmzSYnfHr+mq2ispoiNie7oxbuyoLPsEgMzXTGwWCSB1R1D2/FYx98Zac2CkkucJZubU6pA5WXZsRSOgZOLYAPqr206ePs5W9ck52ALA9YQbee83+CdTbSqk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789663887; c=relaxed/simple;
	bh=XpvhRV9PENzaYe3DRQdFiOc1B+ndeClMtHXVxSRMYLk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hLuBKcLpPlaywDCwyVqN2SkmBNjmJWlKV/pOskCpr7chzv+W3RWbKRnjDQt2zgzKBTMY8nhuy+UA7+WVLau6CWXt2Ar+4Cvv8RBnbSHk5ARlBuSVTyOsPdKrtIfkCUi+WBfAkTomu/A3sWj3n8CGFbivpxoaaG7RgVE8MW4otnE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hMIhncg1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hMIhncg1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 776A61F000FF;
	Thu, 17 Sep 2026 16:51:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789663886;
	bh=E5HeVkCrRAXXB1LIaamWi5PNw1OW4SBpzh1DTlYaqWA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hMIhncg1sW7sXwFCfW8zD9tRzg4BXblhekQRxi5SFjvxJnOFnvCiLuqsx80ui6SaR
	 k25fNZKzYD1MsrFwM1DOTWyCU9cXJ1zhnyfo6aC9JoQij6Lwyfsq7Nl5PB3EUbBbVv
	 kXKNCoJ3lXal816SDVnh64Prl5rN7ZeZjEJuUfr4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stepan Ionichev <sozdayvek@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0188/1250] usb: gadget: goku_udc: avoid NULL deref of dev->driver in INT_USBRESET log
Date: Thu, 17 Sep 2026 15:59:43 +0100
Message-ID: <20260917151557.209879040@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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



