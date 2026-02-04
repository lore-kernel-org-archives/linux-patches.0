Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFD6541C2E2;
	Wed,  4 Feb 2026 14:54:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770216858; cv=none; b=AXV9PagYlpWrlscpCm2Elx18mxbsg+E4AXFMnWy9N84HbW//8dkL20iLKZnQfEKA3am8lK02+SpTGflQvIeoKfwNQMCJLBoYVh2cIDamcZqdlofH3wystBEwLxfAbxvyQf1MgL0hDCny0HGo0+1t0Vb48WjjIUcY8x35NZFoUkM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770216858; c=relaxed/simple;
	bh=7xPHfJzmz9bV9xZQXUNwOHoGCajJGF2dOrZApzI3Uns=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jDwq3ze5uXEoyzml3A1STxmnItUJs7qZyUFwl+I/HkLHpvc4wsNUzIxg2Pe9wIrJ9FqFEOPUEcenEPn8Fo3hnPTNtrbTylhIYqKjNA3xjafKAuMLtd1+DqzqVTDsJXgbqCLz+TwTZHyr+iRCbtnHyOT3qFHp1RqJVStN8Ca9L70=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WGKioRUe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WGKioRUe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D368C116C6;
	Wed,  4 Feb 2026 14:54:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770216858;
	bh=7xPHfJzmz9bV9xZQXUNwOHoGCajJGF2dOrZApzI3Uns=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WGKioRUeORt1uzG2hXIl9Nr6KE2HBi8VWx7BaPypaGvuNUQ4hRyjugw6ocY7iAUBI
	 T9zc94FUHg5P+okT75DCf/aF4STH6d3bSqaC1zVUoIaywQ3VGYZqjHk2QXVDINW7tO
	 wcgX8Svp5Gh9e8PIidJZKCobkuwMafJwMOKD3vuM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Ujfalusi <peter.ujfalusi@ti.com>,
	Miaoqian Lin <linmq006@gmail.com>,
	Johan Hovold <johan@kernel.org>,
	Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 5.15 051/206] dmaengine: ti: dma-crossbar: fix device leak on dra7x route allocation
Date: Wed,  4 Feb 2026 15:38:02 +0100
Message-ID: <20260204143900.054226140@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260204143858.193781818@linuxfoundation.org>
References: <20260204143858.193781818@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan@kernel.org>

commit dc7e44db01fc2498644e3106db3e62a9883a93d5 upstream.

Make sure to drop the reference taken when looking up the crossbar
platform device during dra7x route allocation.

Note that commit 615a4bfc426e ("dmaengine: ti: Add missing put_device in
ti_dra7_xbar_route_allocate") fixed the leak in the error paths but the
reference is still leaking on successful allocation.

Fixes: a074ae38f859 ("dmaengine: Add driver for TI DMA crossbar on DRA7x")
Fixes: 615a4bfc426e ("dmaengine: ti: Add missing put_device in ti_dra7_xbar_route_allocate")
Cc: stable@vger.kernel.org	# 4.2: 615a4bfc426e
Cc: Peter Ujfalusi <peter.ujfalusi@ti.com>
Cc: Miaoqian Lin <linmq006@gmail.com>
Signed-off-by: Johan Hovold <johan@kernel.org>
Link: https://patch.msgid.link/20251117161258.10679-14-johan@kernel.org
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/dma/ti/dma-crossbar.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/dma/ti/dma-crossbar.c
+++ b/drivers/dma/ti/dma-crossbar.c
@@ -287,6 +287,8 @@ static void *ti_dra7_xbar_route_allocate
 
 	ti_dra7_xbar_write(xbar->iomem, map->xbar_out, map->xbar_in);
 
+	put_device(&pdev->dev);
+
 	return map;
 }
 


