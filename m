Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFE4D1586DC;
	Mon, 29 Jan 2024 17:07:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548050; cv=none; b=saM7o9rnUSzgkFYrvOgEEoOYEp+Z1uzh2gXUXpEOpod6eCPND/niRLWCW6JDtHIRHkTFlx3j/toQGb2YUl3XqEZGQH2DUYwo/tMW7vXREzl19WOhIZAsbawZj9KdXRBwxer1+yYVtgKDuc2kQOQrhlksei/Uyr7oHkuMEn4Jb30=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548050; c=relaxed/simple;
	bh=XrDsMqoVnQxTnOllqqzKKlehP3InEVnXsb8nLZVe4Rs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cBaZ1xPR3rYWLKJsfdK6BDwcHchnpO1/KjlPMLEAwHjxt/5BQ3edTRxCHwPVezEyx6udK05cb2WJvn7f+otMlzNbJoA+xzxJDfKBIFUeeZIah0Xcs3HfVDLw+mun5zVHkBWYFQ60pzzQRl5scAZy2hEUn19sAGsD8xGS/A6P62w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jPBVKyMb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jPBVKyMb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94E97C43394;
	Mon, 29 Jan 2024 17:07:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548050;
	bh=XrDsMqoVnQxTnOllqqzKKlehP3InEVnXsb8nLZVe4Rs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jPBVKyMbw5iXXmGMN7DzYye1bBDY6pIs/4aCgvlPGp2lVtPLtIGnATK9AjQG/3dgG
	 0lE3YCzqW9s5Q5rIJfZaKctbbqfuE8idauwfqoC1FfmWDc7f5uS8owFk/f9/di4Tjg
	 ryXlLdPC9BMgJUcB2Q9eY2thqqBnJQFMb+EIoe98=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Amelie Delaunay <amelie.delaunay@foss.st.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 052/346] dmaengine: fix NULL pointer in channel unregistration function
Date: Mon, 29 Jan 2024 09:01:23 -0800
Message-ID: <20240129170017.918693757@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129170016.356158639@linuxfoundation.org>
References: <20240129170016.356158639@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

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
index b7388ae62d7f..491b22240221 100644
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



