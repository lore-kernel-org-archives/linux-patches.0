Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0490437CD22;
	Wed, 30 Sep 2026 16:29:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790785760; cv=none; b=qpk36kWH2HCDh2R+N6+W4+lQPuSgD2NfWyvs6XnMwcJ5toOdUEOzkGuVO9ea/uCbCVyRlM4HEfMhqHczu5b4e2g1DA1ZILH+4Ss6XS8+tHv8Ms5UHtzrO3ahaGa9zccEAc9DGaF/HjmOy2eBvByRVFAXD0UojOovNW386BKsxgg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790785760; c=relaxed/simple;
	bh=+EQtR09v6ZRHFZphz7BGoo2w+08psGpnVscn0FFXuEM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KlK0c8IfsTGPop51UYYoxNvubSMl2gkqpkWaxZECYx6FAu9nahkUE3CDXSpSimNN7//QaeOWAYcbI6as9wSY9QpAjMLruz6XmAc9BtVk9u/kUj7O9JAWaBJHWOX3RqHJ+hrYpKXB+ekb8Q8YXiUOmMbcQD0B+zcfsoaiNCkiD1M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=r1yazZVp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="r1yazZVp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E6811F000FF;
	Wed, 30 Sep 2026 16:29:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790785758;
	bh=n74ox2KiCFnZ5QGHeO/8kI6aOUwVyA94LD7yHWi/EEI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=r1yazZVp3uvz8O7GU2bmntKKEDWRvfvbd1rTwLdqRKyPrK5mbtMK9CnSBQMsBqLmB
	 i6NnH5sBH7kklGxjwbK5A45Xfgi1HdFxbLDNSBhFl+9FFMIvEsDVzcyVomGKaFYwy2
	 Bb6aw/2D6D943RUq1oieLxgbrVdn+hmmEaBm14y8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Donggeun Yoo <donggeunyoo.kernel@gmail.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 621/982] dma-coherent: report a failed reserved memory assignment
Date: Wed, 30 Sep 2026 17:22:37 +0200
Message-ID: <20260930152430.113987062@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Donggeun Yoo <donggeunyoo.kernel@gmail.com>

[ Upstream commit 504981db4f69bdd28054fb98c96a3a67f7248dde ]

rmem_dma_device_init() drops the return value of
dma_assign_coherent_memory() and always reports success. That call fails
with -EBUSY when the device already has a coherent pool, and the file
allows only "*one* such region of memory" per device.

of_reserved_mem_device_init_by_idx() reads the zero as success. It logs
"assigned reserved memory node" for a region that was not assigned and
records the pairing, so of_reserved_mem_device_release() later runs
rmem_dma_device_release() for it. That clears dev->dma_mem without
looking at which region it was called for, dropping the pool the device
did get and leaving it on ordinary memory.

dma_declare_coherent_memory() checks the same call and releases the
memory on failure, and rmem_swiotlb_device_init() propagates its own
errors. Return the error here as well, so a device tree that assigns two
pools to one device fails the probe instead of half working.

Fixes: 7bfa5ab6fa1b ("drivers: dma-coherent: add initialization from device tree")
Signed-off-by: Donggeun Yoo <donggeunyoo.kernel@gmail.com>
Link: https://lore.kernel.org/r/20260905074727.108029-1-donggeunyoo.kernel@gmail.com
Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/dma/coherent.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/kernel/dma/coherent.c b/kernel/dma/coherent.c
index b3a6d904c0b92..133d13428714d 100644
--- a/kernel/dma/coherent.c
+++ b/kernel/dma/coherent.c
@@ -350,8 +350,7 @@ static int rmem_dma_device_init(struct reserved_mem *rmem, struct device *dev)
 	    min_not_zero(dev->coherent_dma_mask, dev->bus_dma_limit))
 		dev_warn(dev, "reserved memory is beyond device's set DMA address range\n");
 
-	dma_assign_coherent_memory(dev, mem);
-	return 0;
+	return dma_assign_coherent_memory(dev, mem);
 }
 
 static void rmem_dma_device_release(struct reserved_mem *rmem,
-- 
2.53.0



