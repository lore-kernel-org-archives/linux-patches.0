Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795057304;
	b=TjddPsC1WJOgD01MbnIGDqOcxEacRrUZSGVBhGrOdNA9KeDjYgc7zjRFfIoHque4TMDZ
	 hqFBbhOrMwcPvh35iDjFz2zadyc4jeLH9otHlnnNu18KBFD7FdVilt0kHbXT6G/tme+67
	 vgwUF68h3cceGsYTFBj9W/m25THIQMIHBBVS/FiA0QubDyIC2bZlqEEgRlZxtuDyabTj3
	 cGAqTpcYs5hJ3MX0gXMl8HZOau2J5nzxEQ8uRiJRAdLlYtzskuHr/FX6F13q+UcRA/RVJ
	 wf35wjnq9sEGiAuYHLdadVKROXcfswcd+sVmeisHO3gjQqpzn7PXxaX4sNl/ZowqjbA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795057304;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=HabGkjpSzlVgkEq5dfK01d0dSTsQ+lucENZ/2N5foQw=;
	b=4s+EjJqau8dCHMZ7F09wboR3XCQCWoLw5NLWZTX1zVym2Mjzn+kcG4PZqhOtMwluTyJZ
	 vZ0Tj413/EO1Ep1S1HC8PJgWeCX7u2E595KHWvpRaxNuku8Tcv43Pkso/svrZ1U4CTGcF
	 Jrxfmzk37xfOEZyKb/oytu0aTZcilxKBosDg55e/PsC/NXgJGnDgKPfnnOkDB8FqSaiNy
	 UaJTOkeokhee89dP9uqVcPIqW01gNaaxhoR24HmlRS2BSJvq6lQMQ/uAuIUkvMEr+v0EC
	 eSesfuaBN4InNOi3BAHRASfj0SDo+I4fosp5pJblc0Y60oAVLwGa8UfPC4p92jdkOTQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2CtITfo3;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4256260A263B;
	Thu, 19 Nov 2026 03:01:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2CtITfo3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67C891F000CA;
	Thu, 19 Nov 2026 03:01:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795057303;
	bh=HabGkjpSzlVgkEq5dfK01d0dSTsQ+lucENZ/2N5foQw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2CtITfo3bSupZgaS3cuw03HZEHllySK0CQS+Q2G3hUukznDv+p1jcRA8TP7dFp2MB
	 uzg4+XBhLSLHYtA5fNOfTJD51QwdnPFkmC41ueCq4nU2p8mRVFCmFv7LB4BW5AXbNa
	 jRRVc2cDdW0JW1w/9bZB4TV2NzaLne0WJnnuZf1U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Abbott <abbotti@mev.co.uk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0082/1848] comedi: ni_at_a2150: Fix sanity check in interrupt handler
Date: Wed, 18 Nov 2026 15:35:20 +0100
Message-ID: <20261118145914.547460311@linuxfoundation.org>
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

[ Upstream commit e7356cdc7077a4f30fc5232a18e9fc6a4d404581 ]

The driver requests an interrupt handler for the device before it is
fully set up.

For safety, the interrupt handler checks the dev->attached flag to
ensure the device is fully set up, but it currently does that after
dereferencing various pointers which may be NULL if dev->attached is
false.  Move the check to avoid the possible null pointer dereferences.

Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
Link: https://patch.msgid.link/20260618102949.26607-5-abbotti@mev.co.uk
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/comedi/drivers/ni_at_a2150.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/comedi/drivers/ni_at_a2150.c b/drivers/staging/comedi/drivers/ni_at_a2150.c
index 10ad7b88713e9..c3dae81fa8234 100644
--- a/drivers/staging/comedi/drivers/ni_at_a2150.c
+++ b/drivers/staging/comedi/drivers/ni_at_a2150.c
@@ -134,11 +134,11 @@ static irqreturn_t a2150_interrupt(int irq, void *d)
 	struct comedi_device *dev = d;
 	struct a2150_private *devpriv = dev->private;
 	struct comedi_isadma *dma = devpriv->dma;
-	struct comedi_isadma_desc *desc = &dma->desc[0];
+	struct comedi_isadma_desc *desc;
 	struct comedi_subdevice *s = dev->read_subdev;
-	struct comedi_async *async = s->async;
-	struct comedi_cmd *cmd = &async->cmd;
-	unsigned short *buf = desc->virt_addr;
+	struct comedi_async *async;
+	struct comedi_cmd *cmd;
+	unsigned short *buf;
 	unsigned int max_points, num_points, residue, leftover;
 	unsigned short dpnt;
 	int status;
@@ -147,6 +147,11 @@ static irqreturn_t a2150_interrupt(int irq, void *d)
 	if (!dev->attached)
 		return IRQ_HANDLED;
 
+	desc = &dma->desc[0];
+	async = s->async;
+	cmd = &async->cmd;
+	buf = desc->virt_addr;
+
 	status = inw(dev->iobase + STATUS_REG);
 	if ((status & INTR_BIT) == 0)
 		return IRQ_NONE;
-- 
2.53.0



