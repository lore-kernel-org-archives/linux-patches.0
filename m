Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B31C64C651B;
	Wed, 30 Sep 2026 16:03:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790784220; cv=none; b=qwmf66ID3bo3ME8Y5g2gPAZcEt6tYiV7q7SR24KbssX5yhSn+YoXakpv24aIeE3CPFuZabalxrRan3OwlI60u7VVYJlLGOPDkV3fcvkrNBYBnLI+/5eaesmXoBLXkO106fvA7e6BHfiOC4xMe59uMKkw4zPLQJ4NGZdOPzZXiDA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790784220; c=relaxed/simple;
	bh=I0SzEY1gDorMCc1umCMmaPKMwkTfOIt4W1GbLPvxibQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XRvjlLMvKcgmSrt/KGjH6yid5OpEvaDsbgaSyYNro+gnCVWCxH37flCBtEd9SuDa/2UaTGm5pWxPBC1xjWEyxQvV7kH+l1sr5Di40UzlLpOrf7XpknizPP1iN7b2Nx8htN5tVrOfi3CBmyP4kJWW/Qr3ROroLpGqTbR/qxWkdKY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gQfCLPvh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gQfCLPvh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CDB21F00893;
	Wed, 30 Sep 2026 16:03:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790784215;
	bh=EHG314EflsrhOnTvXkZRRHZ5laMjoUNtYOrCH4KPxR8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gQfCLPvh6DOxFiGN9IZ2JQ00ZFeyoe737DbwsQvvBCW+f4xxglR85h3d4FmfXaHx9
	 ODG2IwTQ3qW8Y9kvkDmIMoQZqKJYzJsfRDFEk/ij/nPYYCDYwHAXdpA9sRbUCWeFhR
	 n4+e5sL6Ie0h9QenJAdJ1Eou+/KJmvSbLVDNUepg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stepan Ionichev <sozdayvek@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 078/982] usb: gadget: goku_udc: avoid NULL deref of dev->driver in INT_USBRESET log
Date: Wed, 30 Sep 2026 17:13:34 +0200
Message-ID: <20260930152418.482940223@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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
index 5ffb3d5c635be..f9b094b04847e 100644
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



