Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFCA7342524;
	Tue, 12 May 2026 18:01:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778608886; cv=none; b=FxBBICrBzI/65f9M1PgXs9AcNsZOQsO9gjbPTBb4L98Bxa/sUrjnijWNHXUZDZ320rdZN2mriwUf3dGDYsQbzUTOeQayP33+cD0d5c6oJmiTXAlePy76Cb9gq7NLJyHgpby+naEkiJkmzmZCEkt86tkkbDUEhH61RUNGLXdxiHI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778608886; c=relaxed/simple;
	bh=Fqo2Jf4Jx4BnxkPew6/dIV9Tvz4O8wy42XiGWABj+N0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Rv5Q+LK9cxNdt3JrZt944dMTarSVZMpvCJHmZcsraajjhpFTpW2WX+Vvn4iGxXi4J5xopMmXjUTuu4xpmAQhzezeNkHEat6gxqx/A8spUmFmJKDORG6WPxLuCsbHoa+VKay+t8fEFdlGOju0tZQpI0TixGVU3OOAgIQBVFRys5Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=b1gsMIxH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="b1gsMIxH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 752D8C2BCB0;
	Tue, 12 May 2026 18:01:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778608886;
	bh=Fqo2Jf4Jx4BnxkPew6/dIV9Tvz4O8wy42XiGWABj+N0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=b1gsMIxHvLaRXVNnUZ3k7wjj1L/VHwA/WYaae0ljY8iMs0n3+mjgffblJ+pBAEXWR
	 t0D8wfHF8k97cC3ChgIpBwj2bCDTHBCS5B26/o15tdwRCAcYK3IZ20aXvOg/RCP594
	 AJaWbG6usmaDTWtOYX5n3UUi3LB6qto8jGvcb9L4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Petr Tesarik <ptesarik@suse.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 251/270] dma-mapping: add __dma_from_device_group_begin()/end()
Date: Tue, 12 May 2026 19:40:52 +0200
Message-ID: <20260512173943.725526389@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260512173938.452574370@linuxfoundation.org>
References: <20260512173938.452574370@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Michael S. Tsirkin" <mst@redhat.com>

[ Upstream commit ca085faabb42c31ee204235facc5a430cb9e78a9 ]

When a structure contains a buffer that DMA writes to alongside fields
that the CPU writes to, cache line sharing between the DMA buffer and
CPU-written fields can cause data corruption on non-cache-coherent
platforms.

Add __dma_from_device_group_begin()/end() annotations to ensure proper
alignment to prevent this:

struct my_device {
	spinlock_t lock1;
	__dma_from_device_group_begin();
	char dma_buffer1[16];
	char dma_buffer2[16];
	__dma_from_device_group_end();
	spinlock_t lock2;
};

Message-ID: <19163086d5e4704c316f18f6da06bc1c72968904.1767601130.git.mst@redhat.com>
Acked-by: Marek Szyprowski <m.szyprowski@samsung.com>
Reviewed-by: Petr Tesarik <ptesarik@suse.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Stable-dep-of: 3023c050af36 ("hwmon: (powerz) Avoid cacheline sharing for DMA buffer")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/dma-mapping.h |   13 +++++++++++++
 1 file changed, 13 insertions(+)

--- a/include/linux/dma-mapping.h
+++ b/include/linux/dma-mapping.h
@@ -7,6 +7,7 @@
 #include <linux/dma-direction.h>
 #include <linux/scatterlist.h>
 #include <linux/bug.h>
+#include <linux/cache.h>
 
 /**
  * List of possible attributes associated with a DMA mapping. The semantics
@@ -710,6 +711,18 @@ static inline int dma_get_cache_alignmen
 }
 #endif
 
+#ifdef ARCH_HAS_DMA_MINALIGN
+#define ____dma_from_device_aligned __aligned(ARCH_DMA_MINALIGN)
+#else
+#define ____dma_from_device_aligned
+#endif
+/* Mark start of DMA buffer */
+#define __dma_from_device_group_begin(GROUP)			\
+	__cacheline_group_begin(GROUP) ____dma_from_device_aligned
+/* Mark end of DMA buffer */
+#define __dma_from_device_group_end(GROUP)			\
+	__cacheline_group_end(GROUP) ____dma_from_device_aligned
+
 static inline void *dmam_alloc_coherent(struct device *dev, size_t size,
 		dma_addr_t *dma_handle, gfp_t gfp)
 {


