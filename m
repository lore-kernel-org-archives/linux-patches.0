Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCE6A30E823;
	Fri, 21 Nov 2025 13:22:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763731375; cv=none; b=bQ2a1eMdq90ZOulqLEaFhUHzrx5tz/o6Pn97ZBXK5/qc2Oqap/vdZXKXScjzFhptcNX4tu4DvbhGtZC6s9UrZThSktIY57YyHyeEkjXe+SnZaKHA+jN8UpbRm2wibS/okRr1kAjsqfTFPTkYLhsuxSFjJyPM/xpMSL7MXkqsUI4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763731375; c=relaxed/simple;
	bh=uw377SzjpAau2EnrRhJeBeBktdFyFRPhZ6PCefvFvXk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s+LfTqVBHoDSJybSOzHdqWZD0WwFCKZfJ2ePRQhurJYiqO2+1KXZe7Vv35PaxW6T5NKoUwcpuDV8KJ02ySAgZ9Ptb6ZQoomWAuP5Pjnz02+Z+3TRUVbBbi2XFhpmK37Us6uFH2y/z9p7yAHhi+ZQhfq6jkD1OqJyJxgBt2UN13M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eE44k2GF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eE44k2GF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A5F1C4CEF1;
	Fri, 21 Nov 2025 13:22:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763731375;
	bh=uw377SzjpAau2EnrRhJeBeBktdFyFRPhZ6PCefvFvXk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eE44k2GF8kDP7znRtZGlO07k9RsIANAbAIrk5LefuwcruLHnFrLTDkb9/6caN+Vjp
	 7xqs18oOlYaSRp9YiNt6SWcGBKY+5BQnaBNJfvNF5ZANdYwj05zgMxxWW+ce+M6fGn
	 619dYNAyMrEXBKr04c1zKD7pOBlvWggddd761VzQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aleksei Nikiforov <aleksei.nikiforov@linux.ibm.com>,
	Alexander Potapenko <glider@google.com>,
	Eric Biggers <ebiggers@kernel.org>,
	Alexei Starovoitov <ast@kernel.org>,
	Dmitriy Vyukov <dvyukov@google.com>,
	Ilya Leoshkevich <iii@linux.ibm.com>,
	Marco Elver <elver@google.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.17 185/247] mm/kmsan: fix kmsan kmalloc hook when no stack depots are allocated yet
Date: Fri, 21 Nov 2025 14:12:12 +0100
Message-ID: <20251121130201.363251917@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130154.587656062@linuxfoundation.org>
References: <20251121130154.587656062@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aleksei Nikiforov <aleksei.nikiforov@linux.ibm.com>

commit 7e76b75e5ab3339bebab3a4738226cd9b27d8c42 upstream.

If no stack depot is allocated yet, due to masking out __GFP_RECLAIM flags
kmsan called from kmalloc cannot allocate stack depot.  kmsan fails to
record origin and report issues.  This may result in KMSAN failing to
report issues.

Reusing flags from kmalloc without modifying them should be safe for kmsan.
For example, such chain of calls is possible:
test_uninit_kmalloc -> kmalloc -> __kmalloc_cache_noprof ->
slab_alloc_node -> slab_post_alloc_hook ->
kmsan_slab_alloc -> kmsan_internal_poison_memory.

Only when it is called in a context without flags present should
__GFP_RECLAIM flags be masked.

With this change all kmsan tests start working reliably.

Eric reported:

: Yes, KMSAN seems to be at least partially broken currently.  Besides the
: fact that the kmsan KUnit test is currently failing (which I reported at
: https://lore.kernel.org/r/20250911175145.GA1376@sol), I've confirmed that
: the poly1305 KUnit test causes a KMSAN warning with Aleksei's patch
: applied but does not cause a warning without it.  The warning did get
: reached via syzbot somehow
: (https://lore.kernel.org/r/751b3d80293a6f599bb07770afcef24f623c7da0.1761026343.git.xiaopei01@kylinos.cn/),
: so KMSAN must still work in some cases.  But it didn't work for me.

Link: https://lkml.kernel.org/r/20250930115600.709776-2-aleksei.nikiforov@linux.ibm.com
Link: https://lkml.kernel.org/r/20251022030213.GA35717@sol
Fixes: 97769a53f117 ("mm, bpf: Introduce try_alloc_pages() for opportunistic page allocation")
Signed-off-by: Aleksei Nikiforov <aleksei.nikiforov@linux.ibm.com>
Reviewed-by: Alexander Potapenko <glider@google.com>
Tested-by: Eric Biggers <ebiggers@kernel.org>
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Dmitriy Vyukov <dvyukov@google.com>
Cc: Ilya Leoshkevich <iii@linux.ibm.com>
Cc: Marco Elver <elver@google.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/kmsan/core.c   |    3 ---
 mm/kmsan/hooks.c  |    6 ++++--
 mm/kmsan/shadow.c |    2 +-
 3 files changed, 5 insertions(+), 6 deletions(-)

--- a/mm/kmsan/core.c
+++ b/mm/kmsan/core.c
@@ -72,9 +72,6 @@ depot_stack_handle_t kmsan_save_stack_wi
 
 	nr_entries = stack_trace_save(entries, KMSAN_STACK_DEPTH, 0);
 
-	/* Don't sleep. */
-	flags &= ~(__GFP_DIRECT_RECLAIM | __GFP_KSWAPD_RECLAIM);
-
 	handle = stack_depot_save(entries, nr_entries, flags);
 	return stack_depot_set_extra_bits(handle, extra);
 }
--- a/mm/kmsan/hooks.c
+++ b/mm/kmsan/hooks.c
@@ -84,7 +84,8 @@ void kmsan_slab_free(struct kmem_cache *
 	if (s->ctor)
 		return;
 	kmsan_enter_runtime();
-	kmsan_internal_poison_memory(object, s->object_size, GFP_KERNEL,
+	kmsan_internal_poison_memory(object, s->object_size,
+				     GFP_KERNEL & ~(__GFP_RECLAIM),
 				     KMSAN_POISON_CHECK | KMSAN_POISON_FREE);
 	kmsan_leave_runtime();
 }
@@ -114,7 +115,8 @@ void kmsan_kfree_large(const void *ptr)
 	kmsan_enter_runtime();
 	page = virt_to_head_page((void *)ptr);
 	KMSAN_WARN_ON(ptr != page_address(page));
-	kmsan_internal_poison_memory((void *)ptr, page_size(page), GFP_KERNEL,
+	kmsan_internal_poison_memory((void *)ptr, page_size(page),
+				     GFP_KERNEL & ~(__GFP_RECLAIM),
 				     KMSAN_POISON_CHECK | KMSAN_POISON_FREE);
 	kmsan_leave_runtime();
 }
--- a/mm/kmsan/shadow.c
+++ b/mm/kmsan/shadow.c
@@ -208,7 +208,7 @@ void kmsan_free_page(struct page *page,
 		return;
 	kmsan_enter_runtime();
 	kmsan_internal_poison_memory(page_address(page), page_size(page),
-				     GFP_KERNEL,
+				     GFP_KERNEL & ~(__GFP_RECLAIM),
 				     KMSAN_POISON_CHECK | KMSAN_POISON_FREE);
 	kmsan_leave_runtime();
 }


