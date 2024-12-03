Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52D5F1F76AB;
	Tue,  3 Dec 2024 15:31:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733239885; cv=none; b=eoIuRgD+WKl2MjFnotYegbspEz30qYxPWFSgdItg9eLGMXMLjXFh2XA64ct8vKWCz5FB6a9+SMaaR/xnWBvlHXVQ1Q23aGxUWj6gjVs9AjAoo7oHk09MmhaHiOkwqkMkXBsn8Jt2qVV2JFT222q5qtreisa1DCFfko42n4hIHNg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733239885; c=relaxed/simple;
	bh=Rc8C3tSFKNZBAGaLaqOOrZETvtWdh+qvh1vHQgkAHR8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PaKK7TH9TJ1z+PmZUMP3uxMXC6hKP2LJdz78MGqKemWzx7VSzwN0DH/UXHSq7KGzxntappu0xp8VFq2t0UXKnIXbz6rWVzPwgao6Egq4ReLTEu01MBiDyD3UMY8EGxr55I4bG8nE1vRzpvOv5NrGlwHxA+qRPQGExBmmFms4SY8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KrZg9Nhl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KrZg9Nhl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA593C4CECF;
	Tue,  3 Dec 2024 15:31:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733239885;
	bh=Rc8C3tSFKNZBAGaLaqOOrZETvtWdh+qvh1vHQgkAHR8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KrZg9Nhlk//izQtB6FWULzibUDLCM+E58Y0Hx+WcpfLSin4R0s11vRg0Cn2ThUlOW
	 L8FcSWcyddriOfYxOccpS+BF13UL0Eb/rex3YzmB6R508JG6cIrsN9sSEIS8uqLBMI
	 VYa4fGa8zF8tq1hWRFY/2LqP+7nfdBFC8rJas9As=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 767/817] kfifo: dont include dma-mapping.h in kfifo.h
Date: Tue,  3 Dec 2024 15:45:39 +0100
Message-ID: <20241203144025.950551339@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christoph Hellwig <hch@lst.de>

[ Upstream commit 44059790a5cb9258ae6137387e4c39b717fd2ced ]

Nothing in kfifo.h directly needs dma-mapping.h, only two macros
use DMA_MAPPING_ERROR when actually instantiated.  Drop the
dma-mapping.h include to reduce include bloat.

Add an explicity <linux/io.h> include to drivers/mailbox/omap-mailbox.c
as that file uses __raw_readl and __raw_writel through a complicated
include chain involving <linux/dma-mapping.h>

Fixes: d52b761e4b1a ("kfifo: add kfifo_dma_out_prepare_mapped()")
Signed-off-by: Christoph Hellwig <hch@lst.de>
Link: https://lore.kernel.org/r/20241023055317.313234-1-hch@lst.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mailbox/omap-mailbox.c | 1 +
 include/linux/kfifo.h          | 1 -
 samples/kfifo/dma-example.c    | 1 +
 3 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/mailbox/omap-mailbox.c b/drivers/mailbox/omap-mailbox.c
index 7a87424657a15..bd0b9762cef4f 100644
--- a/drivers/mailbox/omap-mailbox.c
+++ b/drivers/mailbox/omap-mailbox.c
@@ -15,6 +15,7 @@
 #include <linux/slab.h>
 #include <linux/kfifo.h>
 #include <linux/err.h>
+#include <linux/io.h>
 #include <linux/module.h>
 #include <linux/of.h>
 #include <linux/platform_device.h>
diff --git a/include/linux/kfifo.h b/include/linux/kfifo.h
index 564868bdce898..fd743d4c4b4bd 100644
--- a/include/linux/kfifo.h
+++ b/include/linux/kfifo.h
@@ -37,7 +37,6 @@
  */
 
 #include <linux/array_size.h>
-#include <linux/dma-mapping.h>
 #include <linux/spinlock.h>
 #include <linux/stddef.h>
 #include <linux/types.h>
diff --git a/samples/kfifo/dma-example.c b/samples/kfifo/dma-example.c
index 48df719dac8c6..8076ac410161a 100644
--- a/samples/kfifo/dma-example.c
+++ b/samples/kfifo/dma-example.c
@@ -9,6 +9,7 @@
 #include <linux/kfifo.h>
 #include <linux/module.h>
 #include <linux/scatterlist.h>
+#include <linux/dma-mapping.h>
 
 /*
  * This module shows how to handle fifo dma operations.
-- 
2.43.0



