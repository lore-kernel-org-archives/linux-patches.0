Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DC122D77E5;
	Mon, 20 Apr 2026 15:49:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776700170; cv=none; b=XUNxX3NHXQIk1Q8xCORtcoWcHlU/ScANiv2VSeS8YZufSN4zPhESRiu0uCsvuqydWWR2ipmC28HuiADy6tbjselTY8sLtTViX+hQLhefNLX/CmTF/RHPSJXfM9jLYvd+gRTVetb6OtFdKBa0hMgg39qYQbH1jV0aaVsnbLtyL5A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776700170; c=relaxed/simple;
	bh=u323AYusz6wyzb2Hh6CTxXcnIafXvOWViU0hOjzTIis=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iFNhm/P+LFy77Cz51YTu0FGNO3yLsKkVqc4ucwsU0TUOasY9BnHX+iALTHiKzJH01T5DVrnV97aZBhF9Uzmm6yFDVgz6CIgh+1hlS3bB2//F90Hb0QxFwQnz0ohJ8+/BH7TMimdxLNcytP2c65hks4K8bB7iAX63g93/p0wGuc8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ckPQ6/d4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ckPQ6/d4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05339C2BCB7;
	Mon, 20 Apr 2026 15:49:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776700170;
	bh=u323AYusz6wyzb2Hh6CTxXcnIafXvOWViU0hOjzTIis=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ckPQ6/d4PX5agtT59bqQKsOIBqyKvVrCN9aAPSihD0arU4bayJa5lGOB035XQueW+
	 2202KPJraOfdUI3eVBk+ilVc9gIpQbZXF9SjT5y7xPPiH1W7JScFaDimjfA5pQhtK5
	 +OCy7jSom+EdmkN4Fn43p1epx651yC8O0XotU6dg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Petr Tesarik <ptesarik@suse.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 068/220] dma-mapping: add DMA_ATTR_CPU_CACHE_CLEAN
Date: Mon, 20 Apr 2026 17:40:09 +0200
Message-ID: <20260420153936.489182200@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420153934.013228280@linuxfoundation.org>
References: <20260420153934.013228280@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael S. Tsirkin <mst@redhat.com>

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



