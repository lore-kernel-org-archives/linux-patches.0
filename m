Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18F0F3A1E8C;
	Tue, 31 Mar 2026 17:00:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774976402; cv=none; b=L4YTGAQz2RrahfVrtX8ia/RCIHyyih+c21EAsMnUREJ/oDC5dk/K5UGu7QgaVOTh/ldmrdnqvnxJ/QevpModFl3wZXTIyze272cyZeF3Vca5auhKOcMQDL+yZzz28QfWOS45JClfP3a8FgOJK/kyIvJE9DvbBZs/IIYL+R5kDPk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774976402; c=relaxed/simple;
	bh=QdddpCzNslIpHjyyP2he+/toZzTcaX64KQUk/bs4JoA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=raN4zfHqpU44AtRZZGNnjrxV/DuDA8npadFFsAykCfL9bV57wcTTTVzo/3HfsdjtSlNGJOSTMQgHUVIqwybkGzZUkKend8HSmchggLFumaqZlOh6BK5DA0hudBzrNKtpP42O5J/KYUa6YrnVgXpKA8RSUDFNMisRFKrtcXmOEXs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=d1xP40oE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="d1xP40oE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4EA52C19423;
	Tue, 31 Mar 2026 17:00:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774976402;
	bh=QdddpCzNslIpHjyyP2he+/toZzTcaX64KQUk/bs4JoA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=d1xP40oE4RrSQUVDoy5rPyEiweP73MDRCBu5Ib0bfhzAr7p+oY3Ug6nqE/7c+3WQk
	 XQbGQ9WJsL9Od/Eyr2eCaPoTbJU6VZUQhaRq9gus+ED30pTRMYFNlCjd8Hza2S+sAp
	 GvKksXLArXJodY3UYyn6WQS81nHn1Fl5TyFJqGR4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Potapenko <glider@google.com>,
	Shigeru Yoshida <syoshida@redhat.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 078/309] dma: swiotlb: add KMSAN annotations to swiotlb_bounce()
Date: Tue, 31 Mar 2026 18:19:41 +0200
Message-ID: <20260331161756.358866019@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161753.468533260@linuxfoundation.org>
References: <20260331161753.468533260@linuxfoundation.org>
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

From: Shigeru Yoshida <syoshida@redhat.com>

[ Upstream commit 6f770b73d0311a5b099277653199bb6421c4fed2 ]

When a device performs DMA to a bounce buffer, KMSAN is unaware of
the write and does not mark the data as initialized.  When
swiotlb_bounce() later copies the bounce buffer back to the original
buffer, memcpy propagates the uninitialized shadow to the original
buffer, causing false positive uninit-value reports.

Fix this by calling kmsan_unpoison_memory() on the bounce buffer
before copying it back in the DMA_FROM_DEVICE path, so that memcpy
naturally propagates initialized shadow to the destination.

Suggested-by: Alexander Potapenko <glider@google.com>
Link: https://lore.kernel.org/CAG_fn=WUGta-paG1BgsGRoAR+fmuCgh3xo=R3XdzOt_-DqSdHw@mail.gmail.com/
Fixes: 7ade4f10779c ("dma: kmsan: unpoison DMA mappings")
Signed-off-by: Shigeru Yoshida <syoshida@redhat.com>
Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
Link: https://lore.kernel.org/r/20260315082750.2375581-1-syoshida@redhat.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/dma/swiotlb.c | 21 +++++++++++++++++++--
 1 file changed, 19 insertions(+), 2 deletions(-)

diff --git a/kernel/dma/swiotlb.c b/kernel/dma/swiotlb.c
index 0d37da3d95b65..e27225f8aeb27 100644
--- a/kernel/dma/swiotlb.c
+++ b/kernel/dma/swiotlb.c
@@ -30,6 +30,7 @@
 #include <linux/gfp.h>
 #include <linux/highmem.h>
 #include <linux/io.h>
+#include <linux/kmsan-checks.h>
 #include <linux/iommu-helper.h>
 #include <linux/init.h>
 #include <linux/memblock.h>
@@ -903,10 +904,19 @@ static void swiotlb_bounce(struct device *dev, phys_addr_t tlb_addr, size_t size
 
 			local_irq_save(flags);
 			page = pfn_to_page(pfn);
-			if (dir == DMA_TO_DEVICE)
+			if (dir == DMA_TO_DEVICE) {
+				/*
+				 * Ideally, kmsan_check_highmem_page()
+				 * could be used here to detect infoleaks,
+				 * but callers may map uninitialized buffers
+				 * that will be written by the device,
+				 * causing false positives.
+				 */
 				memcpy_from_page(vaddr, page, offset, sz);
-			else
+			} else {
+				kmsan_unpoison_memory(vaddr, sz);
 				memcpy_to_page(page, offset, vaddr, sz);
+			}
 			local_irq_restore(flags);
 
 			size -= sz;
@@ -915,8 +925,15 @@ static void swiotlb_bounce(struct device *dev, phys_addr_t tlb_addr, size_t size
 			offset = 0;
 		}
 	} else if (dir == DMA_TO_DEVICE) {
+		/*
+		 * Ideally, kmsan_check_memory() could be used here to detect
+		 * infoleaks (uninitialized data being sent to device), but
+		 * callers may map uninitialized buffers that will be written
+		 * by the device, causing false positives.
+		 */
 		memcpy(vaddr, phys_to_virt(orig_addr), size);
 	} else {
+		kmsan_unpoison_memory(vaddr, size);
 		memcpy(phys_to_virt(orig_addr), vaddr, size);
 	}
 }
-- 
2.51.0



