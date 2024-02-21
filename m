Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6264677A03;
	Wed, 21 Feb 2024 13:25:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708521903; cv=none; b=ZB2Dds/w6I/JlKmRwJrCVBAJBTvXbefuW5rGtZNQs7TjPfOVadc8+FYCCxA7n6Rp3slXg25BIwqbJu4g/jnkZxD9MLSzNtt4ePloczQxXCnrj9U3cgPSACfHe5lFE66ZIimFE1jcrPKSKKUS5j67zRCaA63PyMHHrqaekcGxCfA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708521903; c=relaxed/simple;
	bh=hB1/Zf1tdQ7GK4C4F5r3CHOA77+m0vnvY5qNtpi5K/A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mKfWVu5FT5/98LEsPzaVZvrLxeMrBgg/DWaaoj0T78Q5Qe2xZqM0KgjNGsg/t634V1RWAbf8LLZaH57eUFI+iBhAyz5yESuIrJTpRddIQqPJtamYzTNPPMFqJvBJomxQTJpJL4UIsmjaBrU4nYD6DI5+7S4QMcMgBstlYlZmNfI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0MBigRH4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0MBigRH4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF093C433C7;
	Wed, 21 Feb 2024 13:25:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708521903;
	bh=hB1/Zf1tdQ7GK4C4F5r3CHOA77+m0vnvY5qNtpi5K/A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0MBigRH4ifDp42FeHk1NdyAUM6fY0Zw01U9+Urcm6sjYkdp7tiiCJIJxpwGUkOgZv
	 sr4ol4aigHWv0YcRcPXf6UJCxL9/D96JwiV5VrJfUy1dHm5X0NM1irpFOWDiWZU35D
	 aYTl5jOT8W8wr+bodxbhy6pWQyoGzTULWGIXVbQ0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Amelie Delaunay <amelie.delaunay@foss.st.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 009/476] dmaengine: fix NULL pointer in channel unregistration function
Date: Wed, 21 Feb 2024 14:01:00 +0100
Message-ID: <20240221130008.215222902@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221130007.738356493@linuxfoundation.org>
References: <20240221130007.738356493@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Amelie Delaunay <amelie.delaunay@foss.st.com>

[ Upstream commit f5c24d94512f1b288262beda4d3dcb9629222fc7 ]

__dma_async_device_channel_register() can fail. In case of failure,
chan->local is freed (with free_percpu()), and chan->local is nullified.
When dma_async_device_unregister() is called (because of managed API or
intentionally by DMA controller driver), channels are unconditionally
unregistered, leading to this NULL pointer:
[    1.318693] Unable to handle kernel NULL pointer dereference at virtual address 00000000000000d0
[...]
[    1.484499] Call trace:
[    1.486930]  device_del+0x40/0x394
[    1.490314]  device_unregister+0x20/0x7c
[    1.494220]  __dma_async_device_channel_unregister+0x68/0xc0

Look at dma_async_device_register() function error path, channel device
unregistration is done only if chan->local is not NULL.

Then add the same condition at the beginning of
__dma_async_device_channel_unregister() function, to avoid NULL pointer
issue whatever the API used to reach this function.

Fixes: d2fb0a043838 ("dmaengine: break out channel registration")
Signed-off-by: Amelie Delaunay <amelie.delaunay@foss.st.com>
Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Link: https://lore.kernel.org/r/20231213160452.2598073-1-amelie.delaunay@foss.st.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/dmaengine.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/dma/dmaengine.c b/drivers/dma/dmaengine.c
index 4ec7bb58c195..9559ebd61f3b 100644
--- a/drivers/dma/dmaengine.c
+++ b/drivers/dma/dmaengine.c
@@ -1108,6 +1108,9 @@ EXPORT_SYMBOL_GPL(dma_async_device_channel_register);
 static void __dma_async_device_channel_unregister(struct dma_device *device,
 						  struct dma_chan *chan)
 {
+	if (chan->local == NULL)
+		return;
+
 	WARN_ONCE(!device->device_release && chan->client_count,
 		  "%s called while %d clients hold a reference\n",
 		  __func__, chan->client_count);
-- 
2.43.0



