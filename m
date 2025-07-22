Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D82972E4271;
	Tue, 22 Jul 2025 13:53:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753192386; cv=none; b=j3jIiI6PAYAALhpSoYtoXHgKbo1+ridYMAnrRXS/WzOf00qhnZlfLtUJyFUftAVSyCSFmTJS2hVwKqqgde2QqebItvF/aeBuyIbJbA6Q53ZwMofkA59KjnyWTraO+xXfTDaXQhhPoSTU1ghUrQsEBz8f6KqcKcMaNQ8RphKEut0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753192386; c=relaxed/simple;
	bh=yZbx8LQVfYE7HKagayAGNv+9cP4Pj5vxUmQO/9oevwY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CLl0zjzSViZoHxOU/jjr6Zh0yw6rkidfpPyBQU4NTefi4B66tHJCUOyfDDXwFMpYOIwzv9t4wAomExCXIZiNa9yYzNJHbguB83KW1Q1B0g3QElFC2/74M6P+ZVH3M+2cpR5TQDc003Hqp+sGJcjpMkHlY9EJDS2Wjotg9zMz6CQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HBnj2GzO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HBnj2GzO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1096C4CEF1;
	Tue, 22 Jul 2025 13:53:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753192386;
	bh=yZbx8LQVfYE7HKagayAGNv+9cP4Pj5vxUmQO/9oevwY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HBnj2GzO0AQgZ1oTEI1HNiuW8SYhAL/1NDFm7FcoSQWtYqAOYe/lH2c1h0HxOEhtj
	 eu+Leso3lPvcpmtPPtN12MTp4oAPWWsLjDX+R6NUby1BMdqOLXLvkgBhA2VOVLM638
	 JaGvI9/czYEBiBJfI2yvqSAU7h17jrimlMkhhy3o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 6.6 033/111] dmaengine: nbpfaxi: Fix memory corruption in probe()
Date: Tue, 22 Jul 2025 15:44:08 +0200
Message-ID: <20250722134334.641437016@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250722134333.375479548@linuxfoundation.org>
References: <20250722134333.375479548@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1351,7 +1351,7 @@ static int nbpf_probe(struct platform_de
 	if (irqs == 1) {
 		eirq = irqbuf[0];
 
-		for (i = 0; i <= num_channels; i++)
+		for (i = 0; i < num_channels; i++)
 			nbpf->chan[i].irq = irqbuf[0];
 	} else {
 		eirq = platform_get_irq_byname(pdev, "error");
@@ -1361,16 +1361,15 @@ static int nbpf_probe(struct platform_de
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
@@ -1378,7 +1377,7 @@ static int nbpf_probe(struct platform_de
 			else
 				irq = irqbuf[0];
 
-			for (i = 0; i <= num_channels; i++)
+			for (i = 0; i < num_channels; i++)
 				nbpf->chan[i].irq = irq;
 		}
 	}


