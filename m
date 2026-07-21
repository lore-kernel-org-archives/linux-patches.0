Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DF84418A48;
	Tue, 21 Jul 2026 22:43:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784673802; cv=none; b=mr6prtqWyJc0O0injeVduB4yJmXdYXRjLF0LcmZ1rA4NoSpUpogJ26SFnEZBrHr8Mdw9IbsDkMsf+8wIkmVvW7ndWG0NjtFzL91J4rwMdW0uIN3+1OqQmclvrnQnDz5yZ1Z4wRAh0AcmmIc3Pk77Lv9/h5MECCDGhGUONH5JUXM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784673802; c=relaxed/simple;
	bh=x3Di5Ft0KTTmKpudvm5+7/jufVkd89WJP5ehV+Yc+RQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=U694THj/zAHV4dFwjnarA/a48+uueUb7tpxO/GTOaw5V0A0i7PkOkNr2oZuZtxQlEYd0lTGxDi4QjXUe3P3c8ZHJJkCAv6+KF99l77nHt0f08eURRF08+9K6qz2IDAkGT3DqENyQ6nax0qMtlpvlUxy9vwb7IBGBmF7XnxlwRTg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UHmNcpj7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UHmNcpj7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 844C91F00A3D;
	Tue, 21 Jul 2026 22:43:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784673801;
	bh=jbvXtR3NFVSfJmTd2NY7yNrCS4fJXKmQDzHalVfGG7k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UHmNcpj7+WoSbs4MQw+wgIxVrcAS2x70ByCx4lz7WXFk8CrvwPJV2htnprQPBsCRV
	 HHXLOHv+ocxdLh1AywQyDeajFHvRK22dudxMK3Kjvwh0oUmqyy46M5GW8agIImBTiC
	 9IS5LRfl1bfCvyG+IwDJd2pzqINyMrOz1BPBFBFM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>,
	Frank Li <Frank.Li@nxp.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 299/699] dmaengine: Fix possible use after free
Date: Tue, 21 Jul 2026 17:20:58 +0200
Message-ID: <20260721152402.442144245@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152355.667394603@linuxfoundation.org>
References: <20260721152355.667394603@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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



