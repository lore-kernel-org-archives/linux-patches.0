Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5D14146D40;
	Mon,  6 Jan 2025 15:23:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736177002; cv=none; b=GW6IjfPGlmdj7H1dYhzp4siiC/o2/TVrH0m/5jr7Ogn4Exs47gMqNjIUX87vKb8giN/M/jGCvKiNxsJwYRjmNV6iuhqdoXdGlJgy4HOfcsJRgS7dMmydadqG952kXt4+GVCiexY7nebkwgjpJCxkWHM2WD4wruAK8PwAna+ib3M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736177002; c=relaxed/simple;
	bh=2tgDnPcWw6QlNZu+33u6IkbRCwRYD6fXG8Gbe0Oobl0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i19Kr4QHSG79PDSAXZ2et8Az5n3SZRJYSr4ZrXiAXJpA3bH+P2CDgSKSktHO1YhJXvfflpHtowkwUx3IPiU8g99KG05wC4rUxBKDwR+pyZUj1WEAqZEPoSoU3g8qMnWueneCv21Neeu6W8dsj6lQ5MC6ePFPGv+tfKGsaMSg7m0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Hvtl6rpe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Hvtl6rpe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CE11C4CED2;
	Mon,  6 Jan 2025 15:23:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736177002;
	bh=2tgDnPcWw6QlNZu+33u6IkbRCwRYD6fXG8Gbe0Oobl0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Hvtl6rpefa+6d8FdWVwO8fNwFnKAFIvXH+QUKGNtbqLXTAYRMYScvNfQ9Li5+7+Jv
	 QGTnTsd1kHLi12sELKEbO4L881b7gU6BRH6ooI+1hudtFfCZ/p7r+jfaff8Rvd6QLp
	 OuJfxMGP9otWf9Gruw2Bt+nRykyi+RHp/jSDE5v8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Mike Rapoport (Microsoft)" <rppt@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 019/222] memblock: allow zero threshold in validate_numa_converage()
Date: Mon,  6 Jan 2025 16:13:43 +0100
Message-ID: <20250106151151.327685907@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151150.585603565@linuxfoundation.org>
References: <20250106151150.585603565@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mike Rapoport (Microsoft) <rppt@kernel.org>

[ Upstream commit 9cdc6423acb49055efb444ecd895d853a70ef931 ]

Currently memblock validate_numa_converage() returns false negative when
threshold set to zero.

Make the check if the memory size with invalid node ID is greater than
the threshold exclusive to fix that.

Link: https://lore.kernel.org/all/Z0mIDBD4KLyxyOCm@kernel.org/
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/memblock.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/memblock.c b/mm/memblock.c
index 3a3ab73546f5..87a2b4340ce4 100644
--- a/mm/memblock.c
+++ b/mm/memblock.c
@@ -738,7 +738,7 @@ int __init_memblock memblock_add(phys_addr_t base, phys_addr_t size)
 /**
  * memblock_validate_numa_coverage - check if amount of memory with
  * no node ID assigned is less than a threshold
- * @threshold_bytes: maximal number of pages that can have unassigned node
+ * @threshold_bytes: maximal memory size that can have unassigned node
  * ID (in bytes).
  *
  * A buggy firmware may report memory that does not belong to any node.
@@ -758,7 +758,7 @@ bool __init_memblock memblock_validate_numa_coverage(unsigned long threshold_byt
 			nr_pages += end_pfn - start_pfn;
 	}
 
-	if ((nr_pages << PAGE_SHIFT) >= threshold_bytes) {
+	if ((nr_pages << PAGE_SHIFT) > threshold_bytes) {
 		mem_size_mb = memblock_phys_mem_size() >> 20;
 		pr_err("NUMA: no nodes coverage for %luMB of %luMB RAM\n",
 		       (nr_pages << PAGE_SHIFT) >> 20, mem_size_mb);
-- 
2.39.5



