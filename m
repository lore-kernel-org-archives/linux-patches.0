Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9784C46BA0;
	Mon,  4 Mar 2024 21:46:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709588761; cv=none; b=I3EAVYS9HUgZZaJAxyNs2wEAkIJwdWDCz3OKad6fst7iAUpd1ObZnEjGt/o+B5wA0zPfg+rcKMpLh/NBzcv7Dxf/4c14p8b1+Zt/BWE5kX8hYO/uAU3FzO46WL/UfNj8gx4bT6E7FnPdTr6qwrh2NMYhDufg17M9ZJyhxmwoQMk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709588761; c=relaxed/simple;
	bh=Jn+kB99f+z90vL2KdP4yaZ54+f61+1KCC/1i2vHzmKI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ETpvZDyd7U0ihgF4H+Zz0zE5NFoZekwia87ZgvRate+JsGlq/KSUnxsDPV7W6XndMAIo54wXUH/QEYdknVp2KoPBKDQqchchRVq7vLIenXK49xG30QQpwFYvA/OtzQt/ICigHD8DG7owvgYgKExN8NMo4nZ93EyW9B3DOwXXbOM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=t2wlDMi9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="t2wlDMi9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A5F4C433F1;
	Mon,  4 Mar 2024 21:46:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709588761;
	bh=Jn+kB99f+z90vL2KdP4yaZ54+f61+1KCC/1i2vHzmKI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=t2wlDMi9UC+nDA1bB9WJpgb10zLDiIlpSSx1lVtDKLNqEI0F7TAqcrNz1KPSsWJmf
	 Dab7wu6PoahGOB4wT1Mq42XGJFhnqsN3O+U26X5YPYGS4e9R0zlB16Fqpgl/1DVpyo
	 oCPpK+P3dTCOxJO1ZauO6HNSSnnoVJm9kzGKfJ2E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Basavaraj Natikar <Basavaraj.Natikar@amd.com>,
	Tadeusz Struk <tstruk@gigaio.com>,
	Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 6.1 086/215] dmaengine: ptdma: use consistent DMA masks
Date: Mon,  4 Mar 2024 21:22:29 +0000
Message-ID: <20240304211559.724903381@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240304211556.993132804@linuxfoundation.org>
References: <20240304211556.993132804@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Tadeusz Struk <tstruk@gigaio.com>

commit df2515a17914ecfc2a0594509deaf7fcb8d191ac upstream.

The PTDMA driver sets DMA masks in two different places for the same
device inconsistently. First call is in pt_pci_probe(), where it uses
48bit mask. The second call is in pt_dmaengine_register(), where it
uses a 64bit mask. Using 64bit dma mask causes IO_PAGE_FAULT errors
on DMA transfers between main memory and other devices.
Without the extra call it works fine. Additionally the second call
doesn't check the return value so it can silently fail.
Remove the superfluous dma_set_mask() call and only use 48bit mask.

Cc: stable@vger.kernel.org
Fixes: b0b4a6b10577 ("dmaengine: ptdma: register PTDMA controller as a DMA resource")
Reviewed-by: Basavaraj Natikar <Basavaraj.Natikar@amd.com>
Signed-off-by: Tadeusz Struk <tstruk@gigaio.com>
Link: https://lore.kernel.org/r/20240222163053.13842-1-tstruk@gigaio.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/dma/ptdma/ptdma-dmaengine.c |    2 --
 1 file changed, 2 deletions(-)

--- a/drivers/dma/ptdma/ptdma-dmaengine.c
+++ b/drivers/dma/ptdma/ptdma-dmaengine.c
@@ -385,8 +385,6 @@ int pt_dmaengine_register(struct pt_devi
 	chan->vc.desc_free = pt_do_cleanup;
 	vchan_init(&chan->vc, dma_dev);
 
-	dma_set_mask_and_coherent(pt->dev, DMA_BIT_MASK(64));
-
 	ret = dma_async_device_register(dma_dev);
 	if (ret)
 		goto err_reg;


