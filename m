Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 868A5302774;
	Wed, 17 Sep 2025 12:45:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758113146; cv=none; b=TLfPv3DcGJmf6byNZJCpvxuestIcWGNoEnHdA/i+EpR5FBBzikUN15wmfrEybhy8koRJcKzRRoJqLWA93+0Mh4MUIXEV3jNeFmjk3PLyUwDylwO9nM0fGf3NQiMB3i6Hd1gOc/baEqkga1QYbwgy9420I6qhLpcsqeAg2U3F2j4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758113146; c=relaxed/simple;
	bh=K3QWWGi7wf34z9YMIcIhG2bvxg4WWpUrIantirL6T/E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D8PNND/8c3lzqpNxPcEu8a2F+LHyRHo49rUF9XIYswyClSbxZe+V9XAdCZgBNnuhBFWOpGe5INn9ahou03n60s4TkrN/BAjKC19b7AMIX3X5thd45+SgXdS7QDSvC/IaOfW9MmBXjKuckUUDvQcUPsb8hFBzxUULRieD10WrCAw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=i9qiFc/7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="i9qiFc/7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F41D5C4CEF0;
	Wed, 17 Sep 2025 12:45:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758113146;
	bh=K3QWWGi7wf34z9YMIcIhG2bvxg4WWpUrIantirL6T/E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=i9qiFc/7tYTe3DRGkb1Fz3YEu9dO82vwb1vqqANPSpfi+FzANs84KLDwBk7cyUQ5o
	 LRxIT/JIARdXhk3fbV7/lqp2z/0hSpuvdTXvWh6stdpq8FUQlfvKimhr6Ou8gbyApc
	 Qmn8qED+kVZdYlikoTG8AcNq1yFg9LWKdlJBaCXE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miaoqian Lin <linmq006@gmail.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 6.16 185/189] dmaengine: dw: dmamux: Fix device reference leak in rzn1_dmamux_route_allocate
Date: Wed, 17 Sep 2025 14:34:55 +0200
Message-ID: <20250917123356.408694701@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250917123351.839989757@linuxfoundation.org>
References: <20250917123351.839989757@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

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
@@ -48,12 +48,16 @@ static void *rzn1_dmamux_route_allocate(
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
@@ -94,12 +98,15 @@ static void *rzn1_dmamux_route_allocate(
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


