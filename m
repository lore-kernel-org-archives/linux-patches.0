Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACA51289340;
	Tue, 22 Jul 2025 13:46:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753192018; cv=none; b=IpS/Hmcbxmlq/K6BfBNEV3X2L4QW3ZU676fKlv6ByiVqeqamQs9j/CqVWqIlU0Vd3BQBr0JlWfhWE5UWA/SJNA8d8hsXK9y6AX1YyYEKH2sW6wHnejyIfdc1rGrZlWGNpDaLjDKy74hIX9mbGpag+CtUZzEWCrfIGjqwm56f4BM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753192018; c=relaxed/simple;
	bh=FfbWPCfQhi1M5qi8lpgA4vtcYxkHAWGNuTS9GacZmko=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Htj7VpU7Yii8LMyM+pwOw2L6qAqeZ07URPUdHsJASfvYFB3NgZtMz7byhMYUKDb/Lsth3N2m+VH9z12wlYG5wueAACqqWM9L9A5Ikwj95JsifLKidumcMzvxCC7Hk6AhDbSR23FLu/pZg/MmrKMGYMM/dLf0+idUhX0e+GUNadI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=U37WRx6l; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="U37WRx6l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C78E4C4CEEB;
	Tue, 22 Jul 2025 13:46:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753192017;
	bh=FfbWPCfQhi1M5qi8lpgA4vtcYxkHAWGNuTS9GacZmko=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=U37WRx6lDC00rKQGnrmIE2P9L8WODZHvKgjlDyuD8/QRac2/2axxdhRemJU9h2ejs
	 I/d+fJU1V4KvHIA4jxcBby4SzMqTQ8PEc7EkVsviFMHUaQl7rHjkRTwToBZYQKzjJ8
	 GizO+5ZiUK+M5CZ86C1SQrb3KGHnv3tHdIQRUDh8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 6.1 20/79] dmaengine: nbpfaxi: Fix memory corruption in probe()
Date: Tue, 22 Jul 2025 15:44:16 +0200
Message-ID: <20250722134329.122144456@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250722134328.384139905@linuxfoundation.org>
References: <20250722134328.384139905@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Dan Carpenter <dan.carpenter@linaro.org>

commit 188c6ba1dd925849c5d94885c8bbdeb0b3dcf510 upstream.

The nbpf->chan[] array is allocated earlier in the nbpf_probe() function
and it has "num_channels" elements.  These three loops iterate one
element farther than they should and corrupt memory.

The changes to the second loop are more involved.  In this case, we're
copying data from the irqbuf[] array into the nbpf->chan[] array.  If
the data in irqbuf[i] is the error IRQ then we skip it, so the iterators
are not in sync.  I added a check to ensure that we don't go beyond the
end of the irqbuf[] array.  I'm pretty sure this can't happen, but it
seemed harmless to add a check.

On the other hand, after the loop has ended there is a check to ensure
that the "chan" iterator is where we expect it to be.  In the original
code we went one element beyond the end of the array so the iterator
wasn't in the correct place and it would always return -EINVAL.  However,
now it will always be in the correct place.  I deleted the check since
we know the result.

Cc: stable@vger.kernel.org
Fixes: b45b262cefd5 ("dmaengine: add a driver for AMBA AXI NBPF DMAC IP cores")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Link: https://lore.kernel.org/r/b13c5225-7eff-448c-badc-a2c98e9bcaca@sabinyo.mountain
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/dma/nbpfaxi.c |   11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

--- a/drivers/dma/nbpfaxi.c
+++ b/drivers/dma/nbpfaxi.c
@@ -1354,7 +1354,7 @@ static int nbpf_probe(struct platform_de
 	if (irqs == 1) {
 		eirq = irqbuf[0];
 
-		for (i = 0; i <= num_channels; i++)
+		for (i = 0; i < num_channels; i++)
 			nbpf->chan[i].irq = irqbuf[0];
 	} else {
 		eirq = platform_get_irq_byname(pdev, "error");
@@ -1364,16 +1364,15 @@ static int nbpf_probe(struct platform_de
 		if (irqs == num_channels + 1) {
 			struct nbpf_channel *chan;
 
-			for (i = 0, chan = nbpf->chan; i <= num_channels;
+			for (i = 0, chan = nbpf->chan; i < num_channels;
 			     i++, chan++) {
 				/* Skip the error IRQ */
 				if (irqbuf[i] == eirq)
 					i++;
+				if (i >= ARRAY_SIZE(irqbuf))
+					return -EINVAL;
 				chan->irq = irqbuf[i];
 			}
-
-			if (chan != nbpf->chan + num_channels)
-				return -EINVAL;
 		} else {
 			/* 2 IRQs and more than one channel */
 			if (irqbuf[0] == eirq)
@@ -1381,7 +1380,7 @@ static int nbpf_probe(struct platform_de
 			else
 				irq = irqbuf[0];
 
-			for (i = 0; i <= num_channels; i++)
+			for (i = 0; i < num_channels; i++)
 				nbpf->chan[i].irq = irq;
 		}
 	}


