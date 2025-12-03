Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0AEE307AD9;
	Wed,  3 Dec 2025 15:44:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764776657; cv=none; b=IE5RUXAsen5oLCEZB+t4s8DYP1bFKpIqpc+0XlUCjwkzLd4NnXHVOJci2CTFgcxeaFkuxxKUwpNEvZFdCekdp6x17y65LSkA8IxDYUvl+FsW+Y5acTJ4qMV7DjpJhNxFKVux5W2aOVwPvnIlAQid84/X30gYPCYSBXv0juvf1dU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764776657; c=relaxed/simple;
	bh=ZcQMLq8tQyCGZ8Y2TTYKq1Mkwxd24/WQGltWz64n2/0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IIHgOeU1VQvtgCYykfKg1t7p26vMaX7pBwLKQCH62Xl2cfH61G2WFJ0rEyCBCi+upKxFeJqMuDAA/JZ4lkpnQ2Rx6+fUZ8MrwbEGmdGT2UjuhfM7Fy4ILqhK7wGan9xr0TyWfL6TyfYaPKTOUyl/s0okx6GwApBiI5uhwp7D90I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=G3RT5pdE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="G3RT5pdE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E54AC4CEF5;
	Wed,  3 Dec 2025 15:44:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764776657;
	bh=ZcQMLq8tQyCGZ8Y2TTYKq1Mkwxd24/WQGltWz64n2/0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=G3RT5pdE1aw3msxBToswdwgEsgNvCcAY75lq0PlOfMWHz2s+Poe2Jyw9S+zPArTyk
	 HRB/bilow60EN4GnDwxXFqE58/+s2M5/iV6iuCr+ZslVS7BhkRM3StWoNcNiWf3bby
	 S5J1TzzPIrjdRh030z06aCzPyLf28Yas2zbi7Bdw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Fabio M. De Francesco" <fabio.maria.de.francesco@linux.intel.com>,
	Ira Weiny <ira.weiny@intel.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 249/300] mm/mempool: replace kmap_atomic() with kmap_local_page()
Date: Wed,  3 Dec 2025 16:27:33 +0100
Message-ID: <20251203152409.858206648@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152400.447697997@linuxfoundation.org>
References: <20251203152400.447697997@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Fabio M. De Francesco" <fabio.maria.de.francesco@linux.intel.com>

[ Upstream commit f2bcc99a5e901a13b754648d1dbab60f4adf9375 ]

kmap_atomic() has been deprecated in favor of kmap_local_page().

Therefore, replace kmap_atomic() with kmap_local_page().

kmap_atomic() is implemented like a kmap_local_page() which also disables
page-faults and preemption (the latter only in !PREEMPT_RT kernels).  The
kernel virtual addresses returned by these two API are only valid in the
context of the callers (i.e., they cannot be handed to other threads).

With kmap_local_page() the mappings are per thread and CPU local like in
kmap_atomic(); however, they can handle page-faults and can be called from
any context (including interrupts).  The tasks that call kmap_local_page()
can be preempted and, when they are scheduled to run again, the kernel
virtual addresses are restored and are still valid.

The code blocks between the mappings and un-mappings don't rely on the
above-mentioned side effects of kmap_atomic(), so that mere replacements
of the old API with the new one is all that they require (i.e., there is
no need to explicitly call pagefault_disable() and/or preempt_disable()).

Link: https://lkml.kernel.org/r/20231120142640.7077-1-fabio.maria.de.francesco@linux.intel.com
Signed-off-by: Fabio M. De Francesco <fabio.maria.de.francesco@linux.intel.com>
Cc: Ira Weiny <ira.weiny@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Stable-dep-of: ec33b59542d9 ("mm/mempool: fix poisoning order>0 pages with HIGHMEM")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/mempool.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/mm/mempool.c
+++ b/mm/mempool.c
@@ -63,10 +63,10 @@ static void check_element(mempool_t *poo
 	} else if (pool->free == mempool_free_pages) {
 		/* Mempools backed by page allocator */
 		int order = (int)(long)pool->pool_data;
-		void *addr = kmap_atomic((struct page *)element);
+		void *addr = kmap_local_page((struct page *)element);
 
 		__check_element(pool, addr, 1UL << (PAGE_SHIFT + order));
-		kunmap_atomic(addr);
+		kunmap_local(addr);
 	}
 }
 
@@ -86,10 +86,10 @@ static void poison_element(mempool_t *po
 	} else if (pool->alloc == mempool_alloc_pages) {
 		/* Mempools backed by page allocator */
 		int order = (int)(long)pool->pool_data;
-		void *addr = kmap_atomic((struct page *)element);
+		void *addr = kmap_local_page((struct page *)element);
 
 		__poison_element(addr, 1UL << (PAGE_SHIFT + order));
-		kunmap_atomic(addr);
+		kunmap_local(addr);
 	}
 }
 #else /* CONFIG_DEBUG_SLAB || CONFIG_SLUB_DEBUG_ON */


