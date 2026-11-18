Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795057332;
	b=z2F/AOhWmV3/ofwx0ykMRcPmwBsypQc0ZoJrV0prhGZBCOlsd6LKNWuydQLTJGyuqEw1
	 djMvEqt+QpCOpOWtzNtvssTFTeoG2PrNARrW/JG/vQ5aLk06PGjF71XMsrvVoTrpMcRXm
	 0EbdPEFsFFjggCUmGorsu57chO2IzdzFoltDYqpLrXU+K/OTw2OZ7Uc+yPjrcpxO3V7T2
	 9d93KROR4HvYty/NaNlW8pPxpWCgUwOei4asfAwQcE0ybWNfqisZrjUqV7NehoQGigLsI
	 L5OUkzNdX7KGQHcqAiwu7EEQILBk2g9rGjOHrwwBYrMI4pZm5HpaHe0XgfKKaEb450w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795057332;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=JcU9aZOd80B/e5/jRaMPFzJsWpGplN1DleB5/coa5aQ=;
	b=kYxnxjdCOU4+vRSYjwvREfmHH+oqr8xiNKeLt+7syju4iyNrLtLkaZqloN/PlUw+2one
	 KfKcz/VeoifzLz9L9bdWtoBqXoJHD/+IcstV33vn7fruQO79vxsJaSpLtoq7wnUmWpeMw
	 UiWl6tVt0vjecC7h1RN1T5XqtfheSVariBhY4dAADHIx/ErXkQ973KPkDne1z4CM2WpdV
	 m36zeGqyGlBOc/xbqLgMqIUhj5O5FX6TwiWRa+bCWq60qp80madAaEUR+bZ+R7X9lBgwu
	 pgXl/r0UV4LjUQ9jtJDpR+Azv2UezleItYAQtG3/ixuvrAbEqjW+tXeJL/hjbUDMHZg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SwJjyj6d;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E33560A260C;
	Thu, 19 Nov 2026 03:02:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SwJjyj6d
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 400C81F000C4;
	Thu, 19 Nov 2026 03:02:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795057331;
	bh=JcU9aZOd80B/e5/jRaMPFzJsWpGplN1DleB5/coa5aQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SwJjyj6d7GcM0HqscAeYAeAxoRmaHeTabu2HEp2BoK+Zr1jGI8ZXCdnSpBPdNMzsZ
	 knTEUOMpfUoGXnvscc9jfja6RWSHoUU/M/yRvhrxYvsshThhmTGgbOhnbZDTqwk7C0
	 gPKOWUWiBljyU/QwUKZDLJ+cfUlBjTa087jiK4uE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Abbott <abbotti@mev.co.uk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0091/1848] comedi: pcmuio: Add sanity check to interrupt handler
Date: Wed, 18 Nov 2026 15:35:29 +0100
Message-ID: <20261118145914.934394616@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ian Abbott <abbotti@mev.co.uk>

[ Upstream commit 6f6f6644e011fa910db744e9978127a443b94001 ]

The driver requests an interrupt handler for the device, after setting
device registers to disable interrupt generation.  The interrupt handler
should not be called prematurely unless the user-configured I/O port
base address and/or IRQ number are incorrect or the hardware is bad.

For safety, check the dev->attached flag in the interrupt handler
pcmuio_interrupt() to ensure the device has been fully set up, avoiding
a possible null pointer dereference of dev->subdevices by
pcmuio_handle_asic_interrupt().

Also make use of the IRQ_HANDLED(x) macro for the normal return path of
the interrupt handler.

Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
Link: https://patch.msgid.link/20260618102949.26607-11-abbotti@mev.co.uk
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/comedi/drivers/pcmuio.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/comedi/drivers/pcmuio.c b/drivers/staging/comedi/drivers/pcmuio.c
index b299d648a0eb6..ae12a70534151 100644
--- a/drivers/staging/comedi/drivers/pcmuio.c
+++ b/drivers/staging/comedi/drivers/pcmuio.c
@@ -363,12 +363,15 @@ static irqreturn_t pcmuio_interrupt(int irq, void *d)
 	struct pcmuio_private *devpriv = dev->private;
 	int handled = 0;
 
+	if (!dev->attached)
+		return IRQ_NONE;
+
 	if (irq == dev->irq)
 		handled += pcmuio_handle_asic_interrupt(dev, 0);
 	if (irq == devpriv->irq2)
 		handled += pcmuio_handle_asic_interrupt(dev, 1);
 
-	return handled ? IRQ_HANDLED : IRQ_NONE;
+	return IRQ_RETVAL(handled);
 }
 
 /* chip->spinlock is already locked */
-- 
2.53.0



