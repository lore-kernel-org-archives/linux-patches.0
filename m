Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C93C314A088;
	Tue,  3 Dec 2024 16:17:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733242672; cv=none; b=PO2RxGKEQFAwGfqpw3TxwOA5Ofg1M9DjfpSFjIC24zLxjFbeJEchAitRnSCTDeFIh8EZltQi/J192QLzd9kezC/6rCN5eIIsOReX1mp3WMddOY3xkM08cUFGumbcjZCpjmgf9Y0VN3vqlNbRhwE4ed8qS+ytUHegDkUjOpM/ASc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733242672; c=relaxed/simple;
	bh=WmhqEN/N80820+ss45B163uQ1gFWwvOKeVtGzORnZMI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LcG2YXZ+5urndzXg9JSEcQrYwRRRw7E3lYZfecXb8jJlbiMmk8pYnRSS+RRX09feECFAh8JvuVcx7WLW+wFIcDGNi5NQueicuznFB6nklRnGPYcmJqhzQj9CjkYKOr4Qj+LrEZFIHMbYnkl+WCzAi39UYY6+D6Nl3705I1+Tu6I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XD467e2g; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XD467e2g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA8E4C4CECF;
	Tue,  3 Dec 2024 16:17:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733242672;
	bh=WmhqEN/N80820+ss45B163uQ1gFWwvOKeVtGzORnZMI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XD467e2gsyQmrWhp1p5yFLcVwB0YPp8C44SjNZLW4DYYy4Wj5UkhuCvAr3Y3Dlu6M
	 Bj+FkOm6ZViqMIs6vRh9oXhHicRJIOS+QTHmnDqrJQxxuMV0Y6PInVU2oApliYoaAN
	 sqra+7C2NVREgOMEpDRIo/WePUsilwyGoqhg//9s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 774/826] kfifo: dont include dma-mapping.h in kfifo.h
Date: Tue,  3 Dec 2024 15:48:21 +0100
Message-ID: <20241203144813.960225245@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 6797770474a55..680243751d625 100644
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



