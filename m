Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795043161;
	b=qU6VUyc+mj79Ojor2P+DVsvHckZtNdtI1hJMo+axpv3in1T7BnbueulkBBx4JsPuAka8
	 9a6pTO4+DR2m/lJbhg2E5qhttNCSjHdp+ykDiKBBFB2rZRYInSg7/5OD2wtpbhGJmhEV2
	 0cd5eVppdP6OJm0Gvq1LdvxhLyjf0MbJeLLh5mInaahiLYi5aXbmw6liz0gUDcnvyf44S
	 mL9nYoGzar7derTTU/QdqNKJ17hkCFu6HYvftf0x9py46oqIu4K2oe7ERVV77/xUr78/F
	 89lHqdwXizxsAALcUBaOJTU8Ahq+F0GuCN50tu0J1eMfGi5sKPuEVuHAk0AJOX+oGuQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795043161;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=PykTvdCfEwTLDCvtrj7ajj6u9gK1zXSTbV0vm/WdS6k=;
	b=iCupLlHYG9sFgrRJXGk33GHvfQua0Gw/9xPVDwJ+R8I5GPGAUitg/sHCXbAYoW4IiVPe
	 mFxL6KHLmaHYDEpsrldZhLYPil9ar1vwGP5fWHtTtVXECnSNgNrjF35BQFgOViNBC+E89
	 ldgiu5a/UeludGytsJW1q9VoOjvoNJY2DTQd2rwj0kD7ELsiPLD+iOud4Cut42zovMmQD
	 3fwmu4MsjO7R4r2qEZcCgVOlvBRCEylwV4hettBr3lAwlRnDRIGRbWcVpDS2N01jhErZ5
	 Ti7AYnspx1LVqjnxrUgzk2f3kx0gBRBJbn6MOt0s0Y/6jJ6NBYd5ywfH21ZRY2z0VHg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=w0Izexls;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2253606A331;
	Wed, 18 Nov 2026 23:06:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=w0Izexls
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE5471F000C4;
	Wed, 18 Nov 2026 23:06:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795043161;
	bh=PykTvdCfEwTLDCvtrj7ajj6u9gK1zXSTbV0vm/WdS6k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=w0IzexlsXy5q8Us8/aP/tSwUWEleRN7emYydU2NM/1cNuf6588pmWjDNe+JNhTioQ
	 e3H4xoJAeH0EQtniOZ/wDJ+MafHn3ChdUD6hhmy2tmt7Y249uh3VNEB2r5t2exMMqf
	 7B2UWa3kn6NTb+4/N08naOCfc4yvdZsACWayI6cA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Abbott <abbotti@mev.co.uk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0113/2857] comedi: pcm816: Fix sanity check in interrupt handler
Date: Wed, 18 Nov 2026 15:19:07 +0100
Message-ID: <20261118150205.419191381@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ian Abbott <abbotti@mev.co.uk>

[ Upstream commit 4fdac5090ce3616283216d9a1d2b9664e8e20747 ]

The driver requests an interrupt handler for the device before it is
fully set up.

For safety, the interrupt handler checks the dev->attached flag to
ensure the device is fully set up, but it currently does that after
dereferencing the devpriv->dma pointer which may be NULL if
dev->attached is false.  Move the dereference of the devpriv->dma
pointer after dev->attached has been checked to avoid the possible null
pointer dereference.

Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
Link: https://patch.msgid.link/20260618102949.26607-8-abbotti@mev.co.uk
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/comedi/drivers/pcl816.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/comedi/drivers/pcl816.c b/drivers/comedi/drivers/pcl816.c
index a5e5320be648c..fc7b4ece9d115 100644
--- a/drivers/comedi/drivers/pcl816.c
+++ b/drivers/comedi/drivers/pcl816.c
@@ -242,7 +242,7 @@ static irqreturn_t pcl816_interrupt(int irq, void *d)
 	struct comedi_subdevice *s = dev->read_subdev;
 	struct pcl816_private *devpriv = dev->private;
 	struct comedi_isadma *dma = devpriv->dma;
-	struct comedi_isadma_desc *desc = &dma->desc[dma->cur_dma];
+	struct comedi_isadma_desc *desc;
 	unsigned int nsamples;
 	unsigned int bufptr;
 
@@ -257,6 +257,7 @@ static irqreturn_t pcl816_interrupt(int irq, void *d)
 		return IRQ_HANDLED;
 	}
 
+	desc = &dma->desc[dma->cur_dma];
 	nsamples = comedi_bytes_to_samples(s, desc->size) -
 		   devpriv->ai_poll_ptr;
 	bufptr = devpriv->ai_poll_ptr;
-- 
2.53.0



