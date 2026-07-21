Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EFC83B47E2;
	Tue, 21 Jul 2026 20:40:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784666457; cv=none; b=pVgshLEksxc8ESUuRjtg3O13tmOhFJIVF7EXBOTt+wLPDo6F1ChEQMKa5aMozzxm8BZx9C+en2AakQ0M2eHopIeNBOoUyQGWuFZwTQnXg/GQzU5x5/clcqfUl1kekXN8AMF57QjZpYUQf0ol3l5dTRpLAinjwDxP9GXXWLpe2m0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784666457; c=relaxed/simple;
	bh=dcELZ964h++vjNjaXBxegCg7O7XLcrdyNmSlbtnH++g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=uHnouADquaCKo5m0AHaKmZBHnUns6QIZ7+8s23kRH9hK38gIEVxAfkOZI38lZ1DbZMxtCXvlFulLgJd8Cofn+bJ5BvkNu67z1l+qNXEEnxP1TR+FzovwBJeBuaH3hsPexf9Qjf66OjzyqHNJWydxoDnt+j6h1Tp16uX3jbJr+80=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=in+DdYz6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="in+DdYz6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D51151F000E9;
	Tue, 21 Jul 2026 20:40:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784666456;
	bh=jtCQGauqi+6QysK+zPMLLDyD+VvSUKebJtZRvGsxD00=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=in+DdYz64d/XLu07r0sxnw9C6YVlUbN6yBu40AL3obpX04LnkHqMPUF9ZaPa5UiDM
	 /l4R9ds2Spo5itWXZDYYocbCC2id739fYRXHXSJ7YWLU7u/wzptUr/VKBC61DyEJUl
	 +dY860vPKfUwuCX0TpP6uIJpCSbcNwRKSLybkORw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>,
	Frank Li <Frank.Li@nxp.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0647/1266] dmaengine: Fix possible use after free
Date: Tue, 21 Jul 2026 17:18:04 +0200
Message-ID: <20260721152456.337571330@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nuno Sá <nuno.sa@analog.com>

[ Upstream commit 92f853f0645aebf1d05d333e97ab7c342ace1892 ]

In dma_release_channel(), check chan->device->privatecnt after call
dma_chan_put(). However, dma_chan_put() call dma_device_put() which could
release the last reference of the device if the DMA provider is already
gone and hence free it.

Fixes it by moving dma_chan_put() after the check.

Fixes: 0f571515c332 ("dmaengine: Add privatecnt to revert DMA_PRIVATE property")
Signed-off-by: Nuno Sá <nuno.sa@analog.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Link: https://patch.msgid.link/20260424-dma-dmac-handle-vunmap-v4-1-90f43412fdc0@analog.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/dmaengine.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/dma/dmaengine.c b/drivers/dma/dmaengine.c
index 491b222402216a..b1c9187602d532 100644
--- a/drivers/dma/dmaengine.c
+++ b/drivers/dma/dmaengine.c
@@ -905,11 +905,12 @@ void dma_release_channel(struct dma_chan *chan)
 	mutex_lock(&dma_list_mutex);
 	WARN_ONCE(chan->client_count != 1,
 		  "chan reference count %d != 1\n", chan->client_count);
-	dma_chan_put(chan);
 	/* drop PRIVATE cap enabled by __dma_request_channel() */
 	if (--chan->device->privatecnt == 0)
 		dma_cap_clear(DMA_PRIVATE, chan->device->cap_mask);
 
+	dma_chan_put(chan);
+
 	if (chan->slave) {
 		sysfs_remove_link(&chan->dev->device.kobj, DMA_SLAVE_NAME);
 		sysfs_remove_link(&chan->slave->kobj, chan->name);
-- 
2.53.0



