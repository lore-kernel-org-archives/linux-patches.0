Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96E5634CFC2;
	Wed,  3 Dec 2025 16:52:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764780775; cv=none; b=fF6tYQovX4T4tu8X+6F/sg5sQBa5gNTYaeHxa5LWh4mt0cANwE7Egx0DqKJNnewAtAoDNTLydt4RQSLa4FGD2Gsk8jjHg/qA1dVyLsGSDdT/YIE5mARMwMAoljoeQ6u7RIxdDldwUWrS347RXtfvxyURL+JqgQYmx8NkC6C2+oE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764780775; c=relaxed/simple;
	bh=PoZ2tugIh26XDP/3wlLyhppgB9xDy760mUaFfaMHX3I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u74f8IlPzmbDELlWhCUDAFpCsQ80gT5N5vqjM9mIuKMg29VCqm4V0S6LQO6l7SvWggOz2Nlhwinm4Zcql+Qs/hcm0dxWhP7GETTzw7Taa0K4YH3viS6LjzpZv7JESwVmyktB+h0AaWGj3Mxp5lw3F8adyqMQJ/O9tJd8ux7Aq5Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iK1YGe20; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iK1YGe20"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E263FC4CEF5;
	Wed,  3 Dec 2025 16:52:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764780775;
	bh=PoZ2tugIh26XDP/3wlLyhppgB9xDy760mUaFfaMHX3I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iK1YGe20Ik0LKa48lFXR5bZUaTipzPRhIm2cG0w47HQORWYRn4EJWWuFO71PjeBSI
	 Zbag2sWZK5amwjk90luVA/NGMyU4KHBrVFxXgLYyhUDeeFaSB3i8U0M7lZ4oJkrIVC
	 N/6FQYPPoj9cyt/XdTnhBQTgpzbiQ9AWcLbr5LWI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Miaoqian Lin <linmq006@gmail.com>,
	Gregory CLEMENT <gregory.clement@bootlin.com>
Subject: [PATCH 6.12 086/132] serial: amba-pl011: prefer dma_mapping_error() over explicit address checking
Date: Wed,  3 Dec 2025 16:29:25 +0100
Message-ID: <20251203152346.479383972@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152343.285859633@linuxfoundation.org>
References: <20251203152343.285859633@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Miaoqian Lin <linmq006@gmail.com>

commit eb4917f557d43c7a1c805dd73ffcdfddb2aba39a upstream.

Check for returned DMA addresses using specialized dma_mapping_error()
helper which is generally recommended for this purpose by
Documentation/core-api/dma-api.rst:

  "In some circumstances dma_map_single(), ...
will fail to create a mapping. A driver can check for these errors
by testing the returned DMA address with dma_mapping_error()."

Found via static analysis and this is similar to commit fa0308134d26
("ALSA: memalloc: prefer dma_mapping_error() over explicit address checking")

Fixes: 58ac1b379979 ("ARM: PL011: Fix DMA support")
Cc: stable <stable@kernel.org>
Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
Reviewed-by: Gregory CLEMENT <gregory.clement@bootlin.com>
Link: https://patch.msgid.link/20251027092053.87937-1-linmq006@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/amba-pl011.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/tty/serial/amba-pl011.c
+++ b/drivers/tty/serial/amba-pl011.c
@@ -618,7 +618,7 @@ static int pl011_dma_tx_refill(struct ua
 	dmatx->len = count;
 	dmatx->dma = dma_map_single(dma_dev->dev, dmatx->buf, count,
 				    DMA_TO_DEVICE);
-	if (dmatx->dma == DMA_MAPPING_ERROR) {
+	if (dma_mapping_error(dma_dev->dev, dmatx->dma)) {
 		uap->dmatx.queued = false;
 		dev_dbg(uap->port.dev, "unable to map TX DMA\n");
 		return -EBUSY;


