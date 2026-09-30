Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49FAE4F4CF1;
	Wed, 30 Sep 2026 17:10:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790788233; cv=none; b=K/WP7VnNoWulzjCb3SrodTqimW7nXIjfea9l5bqdRbLS7ARRQr9WJF/BxTngNcgMRJK7HS6mVJerSVuuPtkPy3pgRNvqb6zmVtnLIpBVXzgy7rGH+VjihtihbNUrvdJ1RKxW3HZi1BMMdIRk8rw5GQe8uc7uxt5fFim+dYEltsQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790788233; c=relaxed/simple;
	bh=pldeimZ/ecWWmIQBQtVKUHQvflKXAOsnKLJVeH0wyes=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IRqqSkn0sfEGupEPM2NmCbwERp05pczslRr9Qj4w+T9TL44iS33hLghW1zyrybV0aDQx67bhw0yv+zxOS08vILNsibrkP5v1p33YNOrmq2302WN5m8Zx7N/n4VlYV753W248ThsZOwaPAXMvVJ3Cb6yZBWM2X9K8fDZijMR9vzY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iVMYN8xn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iVMYN8xn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95D3C1F000FF;
	Wed, 30 Sep 2026 17:10:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790788232;
	bh=K9bGTOU7xOMlrhUALPgqBBs3bQ+40XDY98MC8It/rYQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iVMYN8xnjSu4+MlmMD07vV4jzEqnjq/tn92Dm7W8veWDE+lgwlZdSPoQ3FM1r+kt1
	 6YenO77Hk7vyOPq4hbEUs3DL6ItnEI27J1uJr1phJOmkjiu19aFj4U5xr1g4SfrkDy
	 LB7ZvC18d6POwAK16CC4d85fTXrHXN8fO8YhvS/I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Donggeun Yoo <donggeunyoo.kernel@gmail.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 051/877] dma-coherent: report a failed reserved memory assignment
Date: Wed, 30 Sep 2026 17:16:02 +0200
Message-ID: <20260930152415.849025806@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152414.738996857@linuxfoundation.org>
References: <20260930152414.738996857@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 77c8d9487a9ab..87f2f02e921a6 100644
--- a/kernel/dma/coherent.c
+++ b/kernel/dma/coherent.c
@@ -351,8 +351,7 @@ static int rmem_dma_device_init(struct reserved_mem *rmem, struct device *dev)
 	    min_not_zero(dev->coherent_dma_mask, dev->bus_dma_limit))
 		dev_warn(dev, "reserved memory is beyond device's set DMA address range\n");
 
-	dma_assign_coherent_memory(dev, mem);
-	return 0;
+	return dma_assign_coherent_memory(dev, mem);
 }
 
 static void rmem_dma_device_release(struct reserved_mem *rmem,
-- 
2.53.0



