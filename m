Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6871244062A;
	Thu, 20 Aug 2026 17:46:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787247978; cv=none; b=K5iN6jSfO7V4W79xBxx1HPMbRuFtuUcbJQ4GWj95eeQnwnsm5+CcdmcDMOfL3CWQCRFvRkp03EOFi0HaVrHEXpsatzDLWmrJNOQf8rZT3bc8ZeVSmQzs2JSaN0xP+Gqfa3WdzLCvdz8VQxIpM7LzWEsNgZq4nwrOmqnLwxir4eU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787247978; c=relaxed/simple;
	bh=B34B8oyij1CVAK60me5ml/NRmpoN/gsNANl0TmUort4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TW1OIF9tDXUA+7st8rfghambUjlTSdnFuGg6je3byyQubka5knixFgteX+Y9Je4airyX1RlLmtq0R3pVg9vlQTwb/Y5JAVzEbA8imvMYXr20I9d/96JeiKl76YusGd/ebW3c6HRhvWkPN85hhuAxAz4lZaPMrwD7wrzj0Ie8xCU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=X+g4L4P7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="X+g4L4P7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C35D91F000E9;
	Thu, 20 Aug 2026 17:46:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787247977;
	bh=tiKns7svOLz+nS+cAit9l0OdwZbocomEuOFza78SOVk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=X+g4L4P7NmUEMyEWYSibuTiX7fLGL29HO+HGpPrYJLBU4iq+cnhYpzXDepc3yk+jS
	 Dp6XBxsZZGOqmj6P3OWS0AmsCswuIJRMu/kAm2OkXzHWfGPp3te4x++W3/cfXQFhl7
	 0Ibgyoq2LsD4XSxDKnUcrkuGRyI1/Pt4UpUu4/e8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>,
	Vivek Kasireddy <vivek.kasireddy@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 061/303] dma-buf/udmabuf: skip redundant cpu sync to fix cacheline EEXIST warning
Date: Thu, 20 Aug 2026 16:53:17 +0200
Message-ID: <20260820145254.998785696@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145253.200766705@linuxfoundation.org>
References: <20260820145253.200766705@linuxfoundation.org>
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

From: Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>

[ Upstream commit 504e2b4ab97a51d56d966cd36d0997ad30b65b2d ]

When CONFIG_DMA_API_DEBUG_SG is enabled, importing a udmabuf into a DRM
driver (e.g. amdgpu for video playback in GNOME Videos / Showtime)
triggers a spurious warning:

  DMA-API: amdgpu 0000:03:00.0: cacheline tracking EEXIST, \
      overlapping mappings aren't supported
  WARNING: kernel/dma/debug.c:619 at add_dma_entry+0x473/0x5f0

The call chain is:

  amdgpu_cs_ioctl
   -> amdgpu_ttm_backend_bind
    -> dma_buf_map_attachment
     -> [udmabuf] map_udmabuf -> get_sg_table
      -> dma_map_sgtable(dev, sg, direction, 0)  // attrs=0
       -> debug_dma_map_sg -> add_dma_entry -> EEXIST

This happens because udmabuf builds a per-page scatter-gather list via
sg_set_folio().  When begin_cpu_udmabuf() has already created an sg
table mapped for the misc device, and an importer such as amdgpu maps
the same pages for its own device via map_udmabuf(), the DMA debug
infrastructure sees two active mappings whose physical addresses share
cacheline boundaries and warns about the overlap.

The DMA_ATTR_SKIP_CPU_SYNC flag suppresses this check in
add_dma_entry() because it signals that no CPU cache maintenance is
performed at map/unmap time, making the cacheline overlap harmless.

All other major dma-buf exporters already pass this flag:
  - drm_gem_map_dma_buf() passes DMA_ATTR_SKIP_CPU_SYNC
  - amdgpu_dma_buf_map() passes DMA_ATTR_SKIP_CPU_SYNC

The CPU sync at map/unmap time is also redundant for udmabuf:
begin_cpu_udmabuf() and end_cpu_udmabuf() already perform explicit
cache synchronization via dma_sync_sgtable_for_cpu/device() when CPU
access is requested through the dma-buf interface.

Pass DMA_ATTR_SKIP_CPU_SYNC to dma_map_sgtable() and
dma_unmap_sgtable() in udmabuf to suppress the spurious warning and
skip the redundant sync.

Fixes: 284562e1f348 ("udmabuf: implement begin_cpu_access/end_cpu_access hooks")
Cc: stable@vger.kernel.org
Signed-off-by: Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>
Acked-by: Vivek Kasireddy <vivek.kasireddy@intel.com>
Signed-off-by: Vivek Kasireddy <vivek.kasireddy@intel.com>
Link: https://patch.msgid.link/20260331061657.79983-1-mikhail.v.gavrilov@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/dma-buf/udmabuf.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/dma-buf/udmabuf.c
+++ b/drivers/dma-buf/udmabuf.c
@@ -74,7 +74,7 @@ static struct sg_table *get_sg_table(str
 	if (ret < 0)
 		goto err_alloc;
 
-	ret = dma_map_sgtable(dev, sg, direction, 0);
+	ret = dma_map_sgtable(dev, sg, direction, DMA_ATTR_SKIP_CPU_SYNC);
 	if (ret < 0)
 		goto err_map;
 	return sg;
@@ -89,7 +89,7 @@ err_alloc:
 static void put_sg_table(struct device *dev, struct sg_table *sg,
 			 enum dma_data_direction direction)
 {
-	dma_unmap_sgtable(dev, sg, direction, 0);
+	dma_unmap_sgtable(dev, sg, direction, DMA_ATTR_SKIP_CPU_SYNC);
 	sg_free_table(sg);
 	kfree(sg);
 }


