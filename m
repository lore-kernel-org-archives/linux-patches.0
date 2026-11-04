Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829531;
	b=dKQ2m0VUNI2sWrC7iRAL+ro1gQTrRIn8yEUnGtQS4jMf8AwS8yBHhBJji57UVHy0Rc69
	 cn5CtUxbYak6In+O2vRxnzhKKxjPECK0RgaLNbo+A292ZJ36ZfZA4cI59zPNz156JhJ0r
	 +LT3TXyH5qJxyN8JnXrI4CRJUcdl8qAfFfyFZ0DmJcP+BfoNr7nborP1ue012Fyi/tHT1
	 zTlhtVAtKwAMb6XGYByWm7TUhlcRvblBRx82H26ZwTlVa7LzftE11Y6OoGMY0co7ylzan
	 IXICINnNbU7LuK1Kqm6jbGb9pJ9pyQGLaowpxYAwCWtUA+QH3GyFptK1NBK0cH0uUqQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829531;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=GXvHj5yNJvbNCV/MLN+1pczmnNb3PTT+R9aRCcM8xJI=;
	b=ANxHjmEj+iXGRJyXxfc6TYadus2t987lRNMMj8gVpWzOF3OJtfwyRmatZBdk7xT7QF9A
	 rzqGnX9KwgLnwUaLYAL2J3SEnunBR2WAdcovEvg6uQd8Er1O4I7+t6NeIB2kLugMLzuap
	 XaydkHCnrE8O7cqqdyoi1KKYVbG3RqpERN3jQq0ujY1a/rLk061ce8Ssny9vyBnwc0rzd
	 MnUlQM7fMLkLnoGA+otoEScWNX2mqERJFh4+DTmWBbTEynZyqSO094gMaloAHEK/6EQpg
	 Ar02lGmo1F364OnT+ATyNBMSeXwfKIpSsEndBLc6gCHr0hdoKP+P/qVd5T/7lN8u+PQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rywRZ6uy;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8D72606AB38;
	Wed,  4 Nov 2026 21:58:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rywRZ6uy
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 674DE1F000C1;
	Wed,  4 Nov 2026 21:58:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829530;
	bh=GXvHj5yNJvbNCV/MLN+1pczmnNb3PTT+R9aRCcM8xJI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rywRZ6uyk7c7U43n4nPKs791W6XkV6FPZlTm3o6M3+kuXyFbwHoo/sgnUE32H0tEy
	 YgOYl5mmPYS6ohqJvaYZ0nrcdCayp7TdScPigCsnfWibE3S4BhIRg0HpUIogjqvsUM
	 fJ0rLy1FitASCzuYSf0h8ImdfjLFjHHIa1syNScI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Abbott <abbotti@mev.co.uk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0185/1005] comedi: pcm816: Fix sanity check in interrupt handler
Date: Wed,  4 Nov 2026 15:58:38 -0500
Message-ID: <20261104211048.963973126@linuxfoundation.org>
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
index 28d1a88c50f65..3c295647e2ed5 100644
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



