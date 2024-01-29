Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A62C15703E;
	Mon, 29 Jan 2024 17:10:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548242; cv=none; b=LRxm8pskLEXPxeqFSkkCPngbSDbK1oQFKswvHiJaM0WlxRoENBO79Y+zJbIBOdOdjcFjXFk8on8BjBh1pJbdVoOGnLEVKASB9X0oJNupA4h7yh1oOBZJyaMDMO8uSdTofPoAux3C7eBlgjeO6rNyXJvXVggKSg5u1zZcGEdOtRU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548242; c=relaxed/simple;
	bh=5obUmovnegDPzmi3ytJQbQnaIjhUXCRdsehg6h5WvGU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g/zvy2ehCgDNy2HvHpY7fZxtDGrECMfbXrSQz/ZW3k4Iqy6lV0PEVuRSXpCStSffezs+oYrUG6HQsbOk/5xUbg1rlnNwqrQMUqAdrQcorFyShw8u1xh6gt7jpgbD9pqnKID/yujl4P//F9F6uu0ccW9S2lBs9r55X3YW6Mmj0H4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=i/uQ0a9+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="i/uQ0a9+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B4EBC433C7;
	Mon, 29 Jan 2024 17:10:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548242;
	bh=5obUmovnegDPzmi3ytJQbQnaIjhUXCRdsehg6h5WvGU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=i/uQ0a9+VRJ/J1YREneuG3MC7PWBnCmnvfPjGTXX64HZcja2lojYnX83ru78Jyzy8
	 NALj8kIpUEcSQou0WbMycpZAXk0uNTegbVWrX3993+8pw1VpZlUwrHwq+zzB9PZrk0
	 KSWP/rELMBrOV2XkA3REaZW9wnUyJsTU5m7Bx7II=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Amelie Delaunay <amelie.delaunay@foss.st.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 032/185] dmaengine: fix NULL pointer in channel unregistration function
Date: Mon, 29 Jan 2024 09:03:52 -0800
Message-ID: <20240129165959.629150949@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129165958.589924174@linuxfoundation.org>
References: <20240129165958.589924174@linuxfoundation.org>
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
index 8a6e6b60d66f..892e8389232e 100644
--- a/drivers/dma/dmaengine.c
+++ b/drivers/dma/dmaengine.c
@@ -1103,6 +1103,9 @@ EXPORT_SYMBOL_GPL(dma_async_device_channel_register);
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



