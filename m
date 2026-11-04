Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829532;
	b=1tPBSV0FzExK8UtusvGAa2W2rFpu2RRXv7FgxEY4BJK9qsoY+l8C49I4QFvzWKYzR9Wl
	 Elh+FI1NanbioMeMAb6XkrtneawXcC5ExOCYrBgwtYggAEnzFBA87S+iW570Iac5fgEV9
	 BnSjg8/kRjTDAOhCGP6Tr5CZe34SqELjr6xlSwgjPgIOYkBrylcBfBob0D6Fu8SsqpQjM
	 TKAfKKOrlqNlJv5TVifyxD0Q6B3TJ9rmatu79cMvn/vonLCvx/ThHd9dk9L/L0FLaMkrj
	 +SPfuFhyvXTHA0yM0xsbbEsMAP1IpL18VDFgl/zKZJEBC7D54eddutn07J1x80iRqyg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829532;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=9CPLFq14QLgTvfeIrY2TV/gfA3NnUGjgALo79yyh1PU=;
	b=mmK9n/t+XohQO1I+3kErn8TDw5ldOmsuMmtnkAAATjz5f/1LlCYUyB/jejKY8N5bQix0
	 1MzbJijH3afqMUmpDe6cfbqPYYdlKdDAgWT4UMv+KjbPWl9bEhlp8SUgXWnpj9IA7Ap1a
	 4bL4MiCYr3460FIiHNZH5/DV85Dmnur791fI/m3wHjVjhWRm6TSrFH+n5hae/i8Kf+0h9
	 PkG2LLA9HUPXSMsHYDVmd6n1k1cyUFGImH4aefBYLP7rdjfIJ5Oi9x5rwL2WvTZQhE04a
	 G0ndY+AZGxsPAfkC8nwVKCuHD+kyP/3doJZwf435eHALMeeaa1HJabdQT/F031Df5KA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NaUwyR3n;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C61E606AB38;
	Wed,  4 Nov 2026 21:58:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NaUwyR3n
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E15871F000C1;
	Wed,  4 Nov 2026 21:58:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829532;
	bh=9CPLFq14QLgTvfeIrY2TV/gfA3NnUGjgALo79yyh1PU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NaUwyR3nJRrksqlrmbuMNrMmPqxwSodHDBWYqYsND+1k61nJqLM7uXai1ZBjxpptD
	 7Qzzccoun0YNUKaK+BZuOuc9BsLcbkEbzzn8I15RTT/ephKSmlFfmqdnPSUwnG9xRG
	 JXXl9X3G5oacTgTIPbXEdJoPCGTjx2H88MxBzEDY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Abbott <abbotti@mev.co.uk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0186/1005] comedi: pcmuio: Add sanity check to interrupt handler
Date: Wed,  4 Nov 2026 15:58:39 -0500
Message-ID: <20261104211048.993986072@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
 drivers/comedi/drivers/pcmuio.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/comedi/drivers/pcmuio.c b/drivers/comedi/drivers/pcmuio.c
index 33b24dbbb9199..1c5fe065a91f5 100644
--- a/drivers/comedi/drivers/pcmuio.c
+++ b/drivers/comedi/drivers/pcmuio.c
@@ -362,12 +362,15 @@ static irqreturn_t pcmuio_interrupt(int irq, void *d)
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



