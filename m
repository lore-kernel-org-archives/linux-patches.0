Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A91F64DBD68;
	Mon, 20 Apr 2026 13:33:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776692026; cv=none; b=VdkzRCQiBJ08D5dIW5VtSl6ZH3gsXOXahiEqvvYZAPI6vtWwUS90ODibzCwWfcUc446WDyjSKcQCDStOiKLuDCYWNkjAdgOGEVmoLPgB7n9LezvASEF5jRL+Y7uP9j3fjUSZ/qmYk8YTaGYlwIjUg+If4aEHjpKijU2Fr1KSP3U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776692026; c=relaxed/simple;
	bh=/hLH7lpWN0NxK/1B7vq7ArtZfe/mwA07wt2k72L8ang=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L7sKWuP7hXg3LDU4aTr684Qm7HQ3BvlK8l2uc8P4Eobkt/BlTI+bjHb6qjqkjIaqBooAGjPp2SPus/K5xyJET0FPUrOI5Sw9pFEg4uyXnMGZ4ydEebqmg90TLYX2QUMsM29+dY1iF3/nlGKulTb5k7HFNNideHnPznDTdT8AkXY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WpheV8Op; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WpheV8Op"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 906C3C19425;
	Mon, 20 Apr 2026 13:33:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776692026;
	bh=/hLH7lpWN0NxK/1B7vq7ArtZfe/mwA07wt2k72L8ang=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WpheV8OpSpj1HJ3GrZBKn0XCNCiSo1V/C6tUwDItcyuLl+WFIOpVKn0z0FlvFXIxy
	 Ue4g4h/lMWYjQ2XXQO4o9XWPXary2Jjv/QzylYVn/5VV9LQug9yApfSkj7as63HxM0
	 KeX20bb/mhfDPDzK9iUpBVhEr5o0AneAY4//7PoD2xBekWkhbAFfxn63t6G+Y60gmx
	 ol9nSGctXUJbLQaZmyRX1trYi0WLwYLjLC8EiMyrCCW7/JNOPatPzvQorNjBjT6kFs
	 /iuOYa314CKcdPz3PcoHpaTHDJq7kLdnu8cRigKyMQFKXJ27vhvuSBv2Ps9pahb/FG
	 hHpXmdJxO4N/w==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: "Michael S. Tsirkin" <mst@redhat.com>,
	Petr Tesarik <ptesarik@suse.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Sasha Levin <sashal@kernel.org>,
	iommu@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18] dma-mapping: add DMA_ATTR_CPU_CACHE_CLEAN
Date: Mon, 20 Apr 2026 09:22:05 -0400
Message-ID: <20260420132314.1023554-331-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420132314.1023554-1-sashal@kernel.org>
References: <20260420132314.1023554-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.23
Content-Transfer-Encoding: 8bit

From: "Michael S. Tsirkin" <mst@redhat.com>

[ Upstream commit 61868dc55a119a5e4b912d458fc2c48ba80a35fe ]

When multiple small DMA_FROM_DEVICE or DMA_BIDIRECTIONAL buffers share a
cacheline, and DMA_API_DEBUG is enabled, we get this warning:
	cacheline tracking EEXIST, overlapping mappings aren't supported.

This is because when one of the mappings is removed, while another one
is active, CPU might write into the buffer.

Add an attribute for the driver to promise not to do this, making the
overlapping safe, and suppressing the warning.

Message-ID: <2d5d091f9d84b68ea96abd545b365dd1d00bbf48.1767601130.git.mst@redhat.com>
Reviewed-by: Petr Tesarik <ptesarik@suse.com>
Acked-by: Marek Szyprowski <m.szyprowski@samsung.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Stable-dep-of: 3d48c9fd78dd ("dma-debug: suppress cacheline overlap warning when arch has no DMA alignment requirement")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Error: Failed to generate final synthesis

 include/linux/dma-mapping.h | 7 +++++++
 kernel/dma/debug.c          | 3 ++-
 2 files changed, 9 insertions(+), 1 deletion(-)

diff --git a/include/linux/dma-mapping.h b/include/linux/dma-mapping.h
index 190eab9f5e8c2..3e63046b899bc 100644
--- a/include/linux/dma-mapping.h
+++ b/include/linux/dma-mapping.h
@@ -78,6 +78,13 @@
  */
 #define DMA_ATTR_MMIO		(1UL << 10)
 
+/*
+ * DMA_ATTR_CPU_CACHE_CLEAN: Indicates the CPU will not dirty any cacheline
+ * overlapping this buffer while it is mapped for DMA. All mappings sharing
+ * a cacheline must have this attribute for this to be considered safe.
+ */
+#define DMA_ATTR_CPU_CACHE_CLEAN	(1UL << 11)
+
 /*
  * A dma_addr_t can hold any valid DMA or bus address for the platform.  It can
  * be given to a device to use as a DMA source or target.  It is specific to a
diff --git a/kernel/dma/debug.c b/kernel/dma/debug.c
index 138ede653de40..7e66d863d573f 100644
--- a/kernel/dma/debug.c
+++ b/kernel/dma/debug.c
@@ -595,7 +595,8 @@ static void add_dma_entry(struct dma_debug_entry *entry, unsigned long attrs)
 	if (rc == -ENOMEM) {
 		pr_err_once("cacheline tracking ENOMEM, dma-debug disabled\n");
 		global_disable = true;
-	} else if (rc == -EEXIST && !(attrs & DMA_ATTR_SKIP_CPU_SYNC) &&
+	} else if (rc == -EEXIST &&
+		   !(attrs & (DMA_ATTR_SKIP_CPU_SYNC | DMA_ATTR_CPU_CACHE_CLEAN)) &&
 		   !(IS_ENABLED(CONFIG_DMA_BOUNCE_UNALIGNED_KMALLOC) &&
 		     is_swiotlb_active(entry->dev))) {
 		err_printk(entry->dev, entry,
-- 
2.53.0

