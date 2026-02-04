Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 156A142AA9;
	Wed,  4 Feb 2026 15:27:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770218829; cv=none; b=sU00IdLv0UeGYXHvdp8U4swdizoYaN2VWw0lRhPdtShs4992wEMrtOw08LBNXs3ubkmL+ZraqKsakf7rsOGZLg1ajTFiX6w3SovbRNwuLZjx3nGSqMR5Or8U/M5ypqtrI6dl2gsFlzkEiYc5wKmfqRE3h62WJphM0pI6jaj1xaI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770218829; c=relaxed/simple;
	bh=CV+NGFmnddkliklHT1sRpLNsGowXYsEot06rchwf2CA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ABFreDhTqGh2Q28inyNzCjg62XOL0vQNxzQI/5tzmOMbQ5XiWtinDvaCg9EL5Pg1fwghNlTJsQDqA5rYRWxp/LRIPAFKU4qyJuQ6rg5zNze6Jv8aTHTsgIp8l2VOnj7apXJIC5CG7hy07J79wXGVxHRfqC0NPlD+4MgITeQajhM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=j3U3Zb/E; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="j3U3Zb/E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E954C4CEF7;
	Wed,  4 Feb 2026 15:27:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770218828;
	bh=CV+NGFmnddkliklHT1sRpLNsGowXYsEot06rchwf2CA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=j3U3Zb/ELZDnwu2oSDW17Nb42yoPj0wZ6SHm3t7JCNI5El70c8krohmKRuGo2b/FG
	 p9Ae+gEZwZEN6+oUjJJpevRvLTruLNU2XC8RwlI+w4c3WYAjuw4cMefAspszdVAvhJ
	 RYAMJ1MmrS+s+I56zPT+KcpllPstNzS8fppwQ0mc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pimyn Girgis <pimyn@google.com>,
	Alexander Potapenko <glider@google.com>,
	Dmitry Vyukov <dvyukov@google.com>,
	Marco Elver <elver@google.com>,
	Ernesto Martnez Garca <ernesto.martinezgarcia@tugraz.at>,
	Kees Cook <kees@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.12 73/87] mm/kfence: randomize the freelist on initialization
Date: Wed,  4 Feb 2026 15:41:11 +0100
Message-ID: <20260204143849.546505288@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260204143846.906385641@linuxfoundation.org>
References: <20260204143846.906385641@linuxfoundation.org>
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

From: Pimyn Girgis <pimyn@google.com>

commit 870ff19251bf3910dda7a7245da826924045fedd upstream.

Randomize the KFENCE freelist during pool initialization to make
allocation patterns less predictable.  This is achieved by shuffling the
order in which metadata objects are added to the freelist using
get_random_u32_below().

Additionally, ensure the error path correctly calculates the address range
to be reset if initialization fails, as the address increment logic has
been moved to a separate loop.

Link: https://lkml.kernel.org/r/20260120161510.3289089-1-pimyn@google.com
Fixes: 0ce20dd84089 ("mm: add Kernel Electric-Fence infrastructure")
Signed-off-by: Pimyn Girgis <pimyn@google.com>
Reviewed-by: Alexander Potapenko <glider@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Marco Elver <elver@google.com>
Cc: Ernesto Martnez Garca <ernesto.martinezgarcia@tugraz.at>
Cc: Greg KH <gregkh@linuxfoundation.org>
Cc: Kees Cook <kees@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Pimyn Girgis <pimyn@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/kfence/core.c |   23 +++++++++++++++++++----
 1 file changed, 19 insertions(+), 4 deletions(-)

--- a/mm/kfence/core.c
+++ b/mm/kfence/core.c
@@ -596,7 +596,7 @@ static unsigned long kfence_init_pool(vo
 {
 	unsigned long addr;
 	struct page *pages;
-	int i;
+	int i, rand;
 
 	if (!arch_kfence_init_pool())
 		return (unsigned long)__kfence_pool;
@@ -645,13 +645,27 @@ static unsigned long kfence_init_pool(vo
 		INIT_LIST_HEAD(&meta->list);
 		raw_spin_lock_init(&meta->lock);
 		meta->state = KFENCE_OBJECT_UNUSED;
-		meta->addr = addr; /* Initialize for validation in metadata_to_pageaddr(). */
-		list_add_tail(&meta->list, &kfence_freelist);
+		/* Use addr to randomize the freelist. */
+		meta->addr = i;
 
 		/* Protect the right redzone. */
-		if (unlikely(!kfence_protect(addr + PAGE_SIZE)))
+		if (unlikely(!kfence_protect(addr + 2 * i * PAGE_SIZE + PAGE_SIZE)))
 			goto reset_slab;
+	}
+
+	for (i = CONFIG_KFENCE_NUM_OBJECTS; i > 0; i--) {
+		rand = get_random_u32_below(i);
+		swap(kfence_metadata_init[i - 1].addr, kfence_metadata_init[rand].addr);
+	}
 
+	for (i = 0; i < CONFIG_KFENCE_NUM_OBJECTS; i++) {
+		struct kfence_metadata *meta_1 = &kfence_metadata_init[i];
+		struct kfence_metadata *meta_2 = &kfence_metadata_init[meta_1->addr];
+
+		list_add_tail(&meta_2->list, &kfence_freelist);
+	}
+	for (i = 0; i < CONFIG_KFENCE_NUM_OBJECTS; i++) {
+		kfence_metadata_init[i].addr = addr;
 		addr += 2 * PAGE_SIZE;
 	}
 
@@ -664,6 +678,7 @@ static unsigned long kfence_init_pool(vo
 	return 0;
 
 reset_slab:
+	addr += 2 * i * PAGE_SIZE;
 	for (i = 0; i < KFENCE_POOL_SIZE / PAGE_SIZE; i++) {
 		struct slab *slab = page_slab(nth_page(pages, i));
 


