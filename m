Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20EC635C682;
	Tue, 21 Jul 2026 22:10:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784671845; cv=none; b=I3SaGbv6aC1FY5H573xk9fDSZ6QYFtJlbhc8KEBJg75TooGqiA+q8a+oU8B8u8hrWEZlsFOukq2nn+0Jsr0n1LHhW4csbHGyrX+yPWRYG/P2Z0Lj5110ANvCz1nwa5JHRL18dTlgZDmd3ESGDjq7eOWcMEXjRMa5DW/9ASpGiws=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784671845; c=relaxed/simple;
	bh=jTwMjo3HUyX2kYR0JHQcxKdPQ69OOzSGio89N18NpKI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=IkpCb3vtffYXaJnkweiA6hAwDQTanxP34SM3htHUks5TmbK+l6MyRyCS5yT7R74hz/SOO0omGpVkPexv5IN9cjgCrL4tZtwh0Ox0QP1nKvwdGwfmVQdweySnq/iPbbhW7dLJvDdKEj+vlvMdgZCb5QBbtG5j9YKaj9pmmGqjuyU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=o6RMcj2g; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="o6RMcj2g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47EF31F00A3A;
	Tue, 21 Jul 2026 22:10:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784671843;
	bh=4oNw5WzGTxSL6ZcLtmANVW0BsZNLPJQph2vUlLBGCb4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=o6RMcj2gkV3weIKx595sO0+XfjMz/eC+oUGM5hzn4NbHYanxxSLNLkyWh6eeprdZR
	 oA/I56dEPYvV+lx9ss8mq05dmg8rYIAsXNpemKBY4H1rldZJy+g43AtvPgAMCIv82Y
	 O2pL7NLbGy5AkbauFZ1Lro4mnXBvpwJ8QaYVej9k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>,
	Frank Li <Frank.Li@nxp.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 398/843] dmaengine: Fix possible use after free
Date: Tue, 21 Jul 2026 17:20:33 +0200
Message-ID: <20260721152414.993314500@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152405.946368001@linuxfoundation.org>
References: <20260721152405.946368001@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 9559ebd61f3bb6..68078e83d57560 100644
--- a/drivers/dma/dmaengine.c
+++ b/drivers/dma/dmaengine.c
@@ -906,11 +906,12 @@ void dma_release_channel(struct dma_chan *chan)
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



