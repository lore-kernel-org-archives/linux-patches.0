Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 415073161BB;
	Wed, 17 Sep 2025 13:03:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758114193; cv=none; b=n3wBXMl5Hg3biYU6Hn4u7407F5PY6c0bwoYvXI1GkFRuO+5G2j20GTg11zJvauDUIpsUnNUm1m+qnT9rWSM+DOBEk66P4ha26avUWu7a0QpgHdOKk9FzXVv+8M+068E2dNVPZrrKFu6uumb0Drrfv+5shezAGv0xwyfoiGiivdA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758114193; c=relaxed/simple;
	bh=pYQfafa8QwklnhvDRChK5xT3++NsdlEBy7SHh91OeuY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UdlixHAvgrVtDkcLQb4pUbiVWia0AjNx0VL2sYvAHD9wGA335emcuByOqPOwNYq2YvMKkuHfW7gRkb25Fdae8IHFOVfy3yMzcgAUMFU7P9ezl6waHmyvyvDJ9vNKD0vZO88wPpC0LyakuB3iwYFfdvMHm4/pNhW+KO3mMljNYtA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QPzlvGcG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QPzlvGcG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A524C4CEF7;
	Wed, 17 Sep 2025 13:03:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758114192;
	bh=pYQfafa8QwklnhvDRChK5xT3++NsdlEBy7SHh91OeuY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QPzlvGcGbZsUkRxX95IVNmOT4cIRlgZ514OyG9FSiaIFaUW8c55NOBao9prbMs6dP
	 X9MTZDSnlncIQC59OCCz8jUEUVg2YjuSLwtsPUSRtoEGHNeeTpG6fUM61nObPBVDKf
	 HbDmmVMPksXAfSY5byMDX7KCY0OO5dbdd89VQdlY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miaoqian Lin <linmq006@gmail.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 6.1 72/78] dmaengine: dw: dmamux: Fix device reference leak in rzn1_dmamux_route_allocate
Date: Wed, 17 Sep 2025 14:35:33 +0200
Message-ID: <20250917123331.340817429@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250917123329.576087662@linuxfoundation.org>
References: <20250917123329.576087662@linuxfoundation.org>
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

From: Miaoqian Lin <linmq006@gmail.com>

commit aa2e1e4563d3ab689ffa86ca1412ecbf9fd3b308 upstream.

The reference taken by of_find_device_by_node()
must be released when not needed anymore.
Add missing put_device() call to fix device reference leaks.

Fixes: 134d9c52fca2 ("dmaengine: dw: dmamux: Introduce RZN1 DMA router support")
Cc: stable@vger.kernel.org
Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
Reviewed-by: Miquel Raynal <miquel.raynal@bootlin.com>
Link: https://lore.kernel.org/r/20250902090358.2423285-1-linmq006@gmail.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/dma/dw/rzn1-dmamux.c |   15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

--- a/drivers/dma/dw/rzn1-dmamux.c
+++ b/drivers/dma/dw/rzn1-dmamux.c
@@ -46,12 +46,16 @@ static void *rzn1_dmamux_route_allocate(
 	u32 mask;
 	int ret;
 
-	if (dma_spec->args_count != RNZ1_DMAMUX_NCELLS)
-		return ERR_PTR(-EINVAL);
+	if (dma_spec->args_count != RNZ1_DMAMUX_NCELLS) {
+		ret = -EINVAL;
+		goto put_device;
+	}
 
 	map = kzalloc(sizeof(*map), GFP_KERNEL);
-	if (!map)
-		return ERR_PTR(-ENOMEM);
+	if (!map) {
+		ret = -ENOMEM;
+		goto put_device;
+	}
 
 	chan = dma_spec->args[0];
 	map->req_idx = dma_spec->args[4];
@@ -92,12 +96,15 @@ static void *rzn1_dmamux_route_allocate(
 	if (ret)
 		goto clear_bitmap;
 
+	put_device(&pdev->dev);
 	return map;
 
 clear_bitmap:
 	clear_bit(map->req_idx, dmamux->used_chans);
 free_map:
 	kfree(map);
+put_device:
+	put_device(&pdev->dev);
 
 	return ERR_PTR(ret);
 }


