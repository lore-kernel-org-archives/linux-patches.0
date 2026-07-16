Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51D4742F70B;
	Thu, 16 Jul 2026 14:33:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784212430; cv=none; b=hUKTjCCju4Ffyb6WKsDf9Npc5SdgNGcTiAch3ziWZFCBN0bhYETpWyayobItrifR1pH3WMF37fYBmJ/3Rw4eYbp9pFzSMl/JPDj5Xc7lqMItAILUwDFHF+KRdtdK7m5HsHu1APutcxSP2T30Xccmkq+1kMKaIY14tRRKsVl6T2U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784212430; c=relaxed/simple;
	bh=blfSaxpcnh5Z3fu3Bo0T8AwtROmSMsqTsWJoRZSB/uk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PIz9DGiJtSYcRjHrawdKwBTeB98tJfXxNwM/ZGlzNKzyZYxZZ9nQeCleDKDDTUzMi4JUv9xcShSIpcC3cMo5GcxqyvsoUCpPnwZ5S7+XyNfUGaRW96uqcSkGDlm4sRfrU5ay5ficp7v3akHdOfSJFDgwMMFMpzcYzPvLJMOZy7k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=p0FWHRvm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="p0FWHRvm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 634F51F000E9;
	Thu, 16 Jul 2026 14:33:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784212428;
	bh=btsu+W2hEttHsVfKeS1dwtPAPQNBp/lUzZxPCKTbch8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=p0FWHRvm6j3qIOSKZZujy11zHj0jCuP8L8cxaN8yatwAuooOmI9l2+vEuVABKyND9
	 o5SYcWwfbGEmaKFxnENGxHItDoMJBjYdgY9qcyMmmXrKZr2q+8RRilom3NeHeMqRuD
	 B+Z8vypU7VpJKLgiueLPC5nuq5UJhd1UA5h6716g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>,
	Vivek Kasireddy <vivek.kasireddy@intel.com>
Subject: [PATCH 6.12 322/349] dma-buf/udmabuf: skip redundant cpu sync to fix cacheline EEXIST warning
Date: Thu, 16 Jul 2026 15:34:16 +0200
Message-ID: <20260716133040.520933282@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133033.287196923@linuxfoundation.org>
References: <20260716133033.287196923@linuxfoundation.org>
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

From: Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>

commit 504e2b4ab97a51d56d966cd36d0997ad30b65b2d upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/dma-buf/udmabuf.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/dma-buf/udmabuf.c
+++ b/drivers/dma-buf/udmabuf.c
@@ -127,7 +127,7 @@ static struct sg_table *get_sg_table(str
 		sg_set_folio(sgl, ubuf->folios[i], PAGE_SIZE,
 			     ubuf->offsets[i]);
 
-	ret = dma_map_sgtable(dev, sg, direction, 0);
+	ret = dma_map_sgtable(dev, sg, direction, DMA_ATTR_SKIP_CPU_SYNC);
 	if (ret < 0)
 		goto err_map;
 	return sg;
@@ -142,7 +142,7 @@ err_alloc:
 static void put_sg_table(struct device *dev, struct sg_table *sg,
 			 enum dma_data_direction direction)
 {
-	dma_unmap_sgtable(dev, sg, direction, 0);
+	dma_unmap_sgtable(dev, sg, direction, DMA_ATTR_SKIP_CPU_SYNC);
 	sg_free_table(sg);
 	kfree(sg);
 }


