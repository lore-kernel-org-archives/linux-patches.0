Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829546;
	b=Bn1EiIfY3y5/71COpeXTjz74hQ6V80Tr6IfFlj2G3Laz8xjdXw2L597eJ9pv0xFGldw5
	 n6iQ40HMT1hA1L0tZIx9C3ADEyGLkbXbFolhch1omdeDVjAr8BElmegpeZ2bb+objvUsD
	 xX3yOixB3PlqdDSahUpAjjYnEjGKqWaThqF30Tm07heNlq40vA54Y0bNoXdODxPitPMmG
	 L2C5gCQx+/di1yOmFShzeWLUPDvO2WvMMMZKtmIKTYaOE8+WHP5efG61Xlz3t4D8pnGM8
	 bDOcsNZ097eFqxt5tQh8wrbeveBZvekkTonn90GNRjVIPVpcw7izFryLs1O6AMZyKxA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829546;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=xenYbiw7kG0O/I1G9XkLd69Lkz4Tyxipu08ZyBNXCik=;
	b=AonMlxzefvyIs15NLuijE2LbEj8cqOBywSrwOQVXC2EmhGPIgjY15ePN15Z/famrgUG0
	 6WSVc57p4EAic8+7RWQE/dlY+BDu4lTGi2SYo3yd78WPw2XlkOVB+xvb+/EwLfcg08Jqs
	 9Ef8pMofmyA3gjU66A8V5uvy2yrjifvxV5scADuzLADVVTMSkLLdJr4Dx+p3ucxtCyXbW
	 TQYcNVEH/DGPJmngytQ/+Y3BmyNfeol/F8b6oZwBglKgR6U1p/tkST7Ni7I7TJqeroKU6
	 xFs85vqpk7EVVCGNZpF8jd8oAkrrR9ao3W5bkvh/lVkuUACToHq4mzRx7XfZSrXaOXA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pLljPZup;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A889607526B;
	Wed,  4 Nov 2026 21:59:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pLljPZup
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA87A1F000C1;
	Wed,  4 Nov 2026 21:59:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829546;
	bh=xenYbiw7kG0O/I1G9XkLd69Lkz4Tyxipu08ZyBNXCik=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pLljPZup/HI2nWCVpZiqI8F2fXDuY+qv7WOJWpXkvrzEpw10KM6aWNB9wf4VC0xi+
	 L3XHMjzWgyhVZU9Kd4nNN7xAKvRu9Oj1VNiDntL6RzguhSPItssXhJQZN3I/swQrPb
	 oYHKfW3VYem5/wyqxYuiO3qUEe5SsL20kpD0Umco=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Abbott <abbotti@mev.co.uk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0177/1005] comedi: ni_at_a2150: Fix sanity check in interrupt handler
Date: Wed,  4 Nov 2026 15:58:30 -0500
Message-ID: <20261104211048.737185825@linuxfoundation.org>
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
 drivers/comedi/drivers/ni_at_a2150.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/comedi/drivers/ni_at_a2150.c b/drivers/comedi/drivers/ni_at_a2150.c
index e4e5a0ebd195a..93e9591f5dd4c 100644
--- a/drivers/comedi/drivers/ni_at_a2150.c
+++ b/drivers/comedi/drivers/ni_at_a2150.c
@@ -132,11 +132,11 @@ static irqreturn_t a2150_interrupt(int irq, void *d)
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
@@ -145,6 +145,11 @@ static irqreturn_t a2150_interrupt(int irq, void *d)
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



