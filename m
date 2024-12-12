Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 516B821504F;
	Thu, 12 Dec 2024 15:14:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734016480; cv=none; b=bm+Vnq5Oc8/XmaYtO44H9R1CR/mbAYlP8b18pum9b13UdUFSbelvTb2+pmdJVbr0axOUm+jSQK0en2CUOwieEVufyl2w0ep4vTsEnj6vNVDsm7qoc/0vOy7fRBZxjGrKkME2GWASjXsFoTm+BHyfS7hkxo42VHhFVgmrGeu3QtY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734016480; c=relaxed/simple;
	bh=jxeIciw1eZw3NUE/XjbIwo2PajEK8VYG7s4i/pxkxY4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YWjJfTVyds+f/oAqJbOdhY5U35d3+Q3w0jme0NXPWbLJrFPTo5iJ5hQm5nniR2ucHq9QAEjaadKgeCJmipjxdCHoQScS3JOCs3IqTaOXjj61DPW8AX2ellVKocyDSeQ+wEDgL5Zz5Yk+UYXjIaPuv8oK49fYjoTsYHvL/ADLjCw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yTsrtkZr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yTsrtkZr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8789CC4CED0;
	Thu, 12 Dec 2024 15:14:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734016480;
	bh=jxeIciw1eZw3NUE/XjbIwo2PajEK8VYG7s4i/pxkxY4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yTsrtkZrjMI098BNmRRWAVGM74S2zvb2ZVEnFSPaxPN5P2BLaOp/vVI7ASvJk0eGh
	 mcjx7K2HvgR4DPCaURoTTkFW7m+jEA8LM5XCUV51o1OsfLDV8zx1DrrTtDjulMndQv
	 4HMA3nzhfWZGmICiyKewjU8P5reKz7981OaMfFbU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Mike Rapoport (Microsoft)" <rppt@kernel.org>
Subject: [PATCH 6.12 210/466] memblock: allow zero threshold in validate_numa_converage()
Date: Thu, 12 Dec 2024 15:56:19 +0100
Message-ID: <20241212144315.087020635@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144306.641051666@linuxfoundation.org>
References: <20241212144306.641051666@linuxfoundation.org>
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

From: Mike Rapoport (Microsoft) <rppt@kernel.org>

commit 9cdc6423acb49055efb444ecd895d853a70ef931 upstream.

Currently memblock validate_numa_converage() returns false negative when
threshold set to zero.

Make the check if the memory size with invalid node ID is greater than
the threshold exclusive to fix that.

Link: https://lore.kernel.org/all/Z0mIDBD4KLyxyOCm@kernel.org/
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/memblock.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/memblock.c
+++ b/mm/memblock.c
@@ -735,7 +735,7 @@ int __init_memblock memblock_add(phys_ad
 /**
  * memblock_validate_numa_coverage - check if amount of memory with
  * no node ID assigned is less than a threshold
- * @threshold_bytes: maximal number of pages that can have unassigned node
+ * @threshold_bytes: maximal memory size that can have unassigned node
  * ID (in bytes).
  *
  * A buggy firmware may report memory that does not belong to any node.
@@ -755,7 +755,7 @@ bool __init_memblock memblock_validate_n
 			nr_pages += end_pfn - start_pfn;
 	}
 
-	if ((nr_pages << PAGE_SHIFT) >= threshold_bytes) {
+	if ((nr_pages << PAGE_SHIFT) > threshold_bytes) {
 		mem_size_mb = memblock_phys_mem_size() >> 20;
 		pr_err("NUMA: no nodes coverage for %luMB of %luMB RAM\n",
 		       (nr_pages << PAGE_SHIFT) >> 20, mem_size_mb);


