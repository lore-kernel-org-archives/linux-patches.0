Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 426D68F58;
	Mon,  4 Mar 2024 21:39:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709588392; cv=none; b=h0GERTVYsWOygI5uWun8wN1WBfF/L15YL/Xx55umG4Llm71EjiQx/DVi+Q7Yekv6puW1KSYNP800fdK7UADdJwJYllsyS+turwCl0YQNrM923YXVGeczIuiAZ0xf5DjD3r7EGfDj0FoAHPjj/aJ5xZo5Mhjq//dylo6wXLCVpDE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709588392; c=relaxed/simple;
	bh=W4TdRzWeAvz8oHiKq72WmdaBVH3h6TMA38gw0AP+HBY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NZvG49idNMZmDl7ffLLdr6jq/V+UMVtGGti3U9FFItghkggHpWSOYJI4HZXvfgEzuwGVIral318qnuiKB3D7kiPJ5aful1vNlQsJBWZLy4khA8zunjNOPXwtT1GPY1Mx419RlAatAmcTzSS61VvBaNwJ9zQOwBw0tu3bqt933Ek=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TAMrJ5Pv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TAMrJ5Pv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB733C433F1;
	Mon,  4 Mar 2024 21:39:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709588392;
	bh=W4TdRzWeAvz8oHiKq72WmdaBVH3h6TMA38gw0AP+HBY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TAMrJ5PvbLpA8944jvvWQmYB7xKPGkNm2RT436fMXUdcPA7BA8I2nPzTW+Hvt5vx0
	 rWgBDYeB6DZyHDJoB33qe16sdoeO2jFZEk63QnOYxLlemuNGFSZy1FU2BvVCXg91+a
	 xQvwC1A4fReJykv16lw229fbZ4Idk4lFgmlR3YnI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Basavaraj Natikar <Basavaraj.Natikar@amd.com>,
	Tadeusz Struk <tstruk@gigaio.com>,
	Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 6.6 090/143] dmaengine: ptdma: use consistent DMA masks
Date: Mon,  4 Mar 2024 21:23:30 +0000
Message-ID: <20240304211552.794295111@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240304211549.876981797@linuxfoundation.org>
References: <20240304211549.876981797@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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


