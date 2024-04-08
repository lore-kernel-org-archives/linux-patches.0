Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AABD980617;
	Mon,  8 Apr 2024 14:05:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712585142; cv=none; b=uYOWBl1/rr436yWZNNByiGC7RD2wNpXcdKG1XnmW1YAjObmMoE/eCccPC1IasKieyhK9UPKJqFTajyCAIGw8/9bjfIvbfcRhNaj77U8ptUpq49OX75tJj/5jhNNKQpEeB4zSeUNMBRQJxVLtk2VZQe5EZ9J8NaRfS4gTgsvk7zg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712585142; c=relaxed/simple;
	bh=BjQS7e01G7c5lldkMD2vn99bzs6EsHMuC+HCskdrzD4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KI0WdmEYkYK6hKKJi79I2LYag+D591mYGG2RUjAI2YTW6QARrl8kRhsd/hhZ1I9Ro3YupEPD6juKIdZj//YzXE7fegFbRKk5DASfUdQmQc258+B0N5Nle4GWohrxJERj6oI2P1Tt3EYISYVq6yLkUdoxcZOOouSjRC+dW+3Xbw0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=J03HqzC0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="J03HqzC0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC357C433F1;
	Mon,  8 Apr 2024 14:05:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712585142;
	bh=BjQS7e01G7c5lldkMD2vn99bzs6EsHMuC+HCskdrzD4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=J03HqzC0awT750aITyGufN6taLNItijNFqdBuvZrY48U3htwZbu9Hg7AInak5n4qU
	 Sz6VeBHUwtT7darXx5+wEi42Rpf/K3Ebipjw/b0V6ci1489poNhd1pLiGhpoi4SUQ3
	 2m4YxI5cu8JKAFnMrC+PLla0Qj9kFaTJewK/FlkQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jann Horn <jannh@google.com>,
	Stafford Horne <shorne@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 676/690] openrisc: Fix pagewalk usage in arch_dma_{clear, set}_uncached
Date: Mon,  8 Apr 2024 14:59:02 +0200
Message-ID: <20240408125424.199793721@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125359.506372836@linuxfoundation.org>
References: <20240408125359.506372836@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jann Horn <jannh@google.com>

[ Upstream commit 28148a17c988b614534f457da86893f83664ad43 ]

Since commit 8782fb61cc848 ("mm: pagewalk: Fix race between unmap and page
walker"), walk_page_range() on kernel ranges won't work anymore,
walk_page_range_novma() must be used instead.

Note: I don't have an openrisc development setup, so this is completely
untested.

Fixes: 8782fb61cc848 ("mm: pagewalk: Fix race between unmap and page walker")
Signed-off-by: Jann Horn <jannh@google.com>
Signed-off-by: Stafford Horne <shorne@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/openrisc/kernel/dma.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/arch/openrisc/kernel/dma.c b/arch/openrisc/kernel/dma.c
index a82b2caaa560d..b3edbb33b621d 100644
--- a/arch/openrisc/kernel/dma.c
+++ b/arch/openrisc/kernel/dma.c
@@ -74,10 +74,10 @@ void *arch_dma_set_uncached(void *cpu_addr, size_t size)
 	 * We need to iterate through the pages, clearing the dcache for
 	 * them and setting the cache-inhibit bit.
 	 */
-	mmap_read_lock(&init_mm);
-	error = walk_page_range(&init_mm, va, va + size, &set_nocache_walk_ops,
-			NULL);
-	mmap_read_unlock(&init_mm);
+	mmap_write_lock(&init_mm);
+	error = walk_page_range_novma(&init_mm, va, va + size,
+			&set_nocache_walk_ops, NULL, NULL);
+	mmap_write_unlock(&init_mm);
 
 	if (error)
 		return ERR_PTR(error);
@@ -88,11 +88,11 @@ void arch_dma_clear_uncached(void *cpu_addr, size_t size)
 {
 	unsigned long va = (unsigned long)cpu_addr;
 
-	mmap_read_lock(&init_mm);
+	mmap_write_lock(&init_mm);
 	/* walk_page_range shouldn't be able to fail here */
-	WARN_ON(walk_page_range(&init_mm, va, va + size,
-			&clear_nocache_walk_ops, NULL));
-	mmap_read_unlock(&init_mm);
+	WARN_ON(walk_page_range_novma(&init_mm, va, va + size,
+			&clear_nocache_walk_ops, NULL, NULL));
+	mmap_write_unlock(&init_mm);
 }
 
 void arch_sync_dma_for_device(phys_addr_t addr, size_t size,
-- 
2.43.0



