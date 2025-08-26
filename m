Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAB7B13FD86;
	Tue, 26 Aug 2025 13:36:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756215393; cv=none; b=jD9nEEqzqneW8nGp7qupHlkx3m/WKutECAD1V+EVACTdsweXezP5aHufFH+Q5uQDCJ4l4FZCVPopFEBe6qA2ntvu7A5zZEh9ps3LlFP7v8HL2pPKOhOyZ+n1JjfQzul6nDSJanJsAv1ChBLI7jc0RTGmTxhIj6a6jzciQkWJBoU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756215393; c=relaxed/simple;
	bh=pFboHmy+rIYp7Y2sapFDQGGAHDQb6ZAU7bTZAUoHXVg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Kjlo/HBwdMJt+g08zuEDPsm85oGy9SsfFDNdbs0b4SI6aaqXC0ywy1Wev736Zgls1pfBqlRLuX0/n7o8nMDgYfUeRTOmkSGAbrhLdba3MCwdVS3JHf9tbPOzXck37Pm1brx9Rwvndze37VYXNG4Z+rpNA6crzheMq23Y/28A5OU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IIbgjBWN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IIbgjBWN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C96BC4CEF1;
	Tue, 26 Aug 2025 13:36:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756215393;
	bh=pFboHmy+rIYp7Y2sapFDQGGAHDQb6ZAU7bTZAUoHXVg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IIbgjBWN4+fs37tRYQKJ84SYvlEoyLAeAfi51ozynx2paylcGDH8rp9lf1cItVcGM
	 GwZvQUYTPd1xSZtUeipI+2eDhdB9bqZ0WtFAmfIRhTsh3OSEmnQh/yS8lrLy1fpIhK
	 1ivM+rb3+IRV8z6wSZrT6R77XHOe3S+zQAQ9uwZU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 5.15 017/644] dmaengine: nbpfaxi: Fix memory corruption in probe()
Date: Tue, 26 Aug 2025 13:01:48 +0200
Message-ID: <20250826110946.937595786@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110946.507083938@linuxfoundation.org>
References: <20250826110946.507083938@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1356,7 +1356,7 @@ static int nbpf_probe(struct platform_de
 	if (irqs == 1) {
 		eirq = irqbuf[0];
 
-		for (i = 0; i <= num_channels; i++)
+		for (i = 0; i < num_channels; i++)
 			nbpf->chan[i].irq = irqbuf[0];
 	} else {
 		eirq = platform_get_irq_byname(pdev, "error");
@@ -1366,16 +1366,15 @@ static int nbpf_probe(struct platform_de
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
@@ -1383,7 +1382,7 @@ static int nbpf_probe(struct platform_de
 			else
 				irq = irqbuf[0];
 
-			for (i = 0; i <= num_channels; i++)
+			for (i = 0; i < num_channels; i++)
 				nbpf->chan[i].irq = irq;
 		}
 	}


