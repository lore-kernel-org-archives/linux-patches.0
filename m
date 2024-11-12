Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEA5B2144A4;
	Tue, 12 Nov 2024 10:46:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731408394; cv=none; b=LF3UuPzCoLM8xdUVzH+TAPW1OAmKTs13uHDYXnIoqjsVRfUjeMitvnOn2aAvf4yXtqcyJCHf4W4bL490jjKMBOjksizpyZnxcjd3deZYjrmMqDrZTNxkqLGAXihVPfM9H+Siqts+12EtreS4yd9oZwyWPpG9+z0fP+FPYwS9Za8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731408394; c=relaxed/simple;
	bh=iMxsEL4h8RjGzktKT5jl9d7OO+IIF9AktRjlvWm+oG8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nMdy9ud7rYhDDQO0lMt5tjxiGpdxAI2Qd+/VuMDBuOWnNsRMHPuBd+sD5EiOna5b3U/i6g4yD/YKTw7zigqR3UrafKSd/1m3bkvaH3AVRURrkQ1MNuIvOcV0XkhtNOSxTg8ncvjF0D3lVC8ARpdrX1zBjY2bpIn//3MQNuJfUFw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=k8asV82O; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="k8asV82O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51368C4CED4;
	Tue, 12 Nov 2024 10:46:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731408393;
	bh=iMxsEL4h8RjGzktKT5jl9d7OO+IIF9AktRjlvWm+oG8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=k8asV82OsfkBHsfLzmCqsxn60d73KJjWEM/V5UdHQN1zHP/9y7lh+QkismD1ugeq5
	 rhyCdc3UIqb55r0sp4nFs0pVyXkJ2RdLLtPdspwH0E/qkNGAXdZ7OHlPTBGorHWb8H
	 xyWhXthx/VU57dx9Hupza8LpX9/w0Zm8BpLBcdOk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Leo Yan <leo.yan@arm.com>,
	Matt Wu <wuqiang.matt@bytedance.com>,
	Mikel Rychliski <mikel@mikelr.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	Viktor Malik <vmalik@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.11 148/184] objpool: fix to make percpu slot allocation more robust
Date: Tue, 12 Nov 2024 11:21:46 +0100
Message-ID: <20241112101906.550154343@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241112101900.865487674@linuxfoundation.org>
References: <20241112101900.865487674@linuxfoundation.org>
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

From: Masami Hiramatsu (Google) <mhiramat@kernel.org>

commit cb6fcef8b4b6c655b6a25cc3a415cd9eb81b3da8 upstream.

Since gfp & GFP_ATOMIC == GFP_ATOMIC is true for GFP_KERNEL | GFP_HIGH, it
will use kmalloc if user specifies that combination.  Here the reason why
combining the __vmalloc_node() and kmalloc_node() is that the vmalloc does
not support all GFP flag, especially GFP_ATOMIC.  So we should check if
gfp & (GFP_ATOMIC | GFP_KERNEL) != GFP_ATOMIC for vmalloc first.  This
ensures caller can sleep.  And for the robustness, even if vmalloc fails,
it should retry with kmalloc to allocate it.

Link: https://lkml.kernel.org/r/173008598713.1262174.2959179484209897252.stgit@mhiramat.roam.corp.google.com
Fixes: aff1871bfc81 ("objpool: fix choosing allocation for percpu slots")
Signed-off-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Reported-by: Linus Torvalds <torvalds@linux-foundation.org>
Closes: https://lore.kernel.org/all/CAHk-=whO+vSH+XVRio8byJU8idAWES0SPGVZ7KAVdc4qrV0VUA@mail.gmail.com/
Cc: Leo Yan <leo.yan@arm.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Matt Wu <wuqiang.matt@bytedance.com>
Cc: Mikel Rychliski <mikel@mikelr.com>
Cc: Steven Rostedt (Google) <rostedt@goodmis.org>
Cc: Viktor Malik <vmalik@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 lib/objpool.c | 18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

diff --git a/lib/objpool.c b/lib/objpool.c
index fd108fe0d095..b998b720c732 100644
--- a/lib/objpool.c
+++ b/lib/objpool.c
@@ -74,15 +74,21 @@ objpool_init_percpu_slots(struct objpool_head *pool, int nr_objs,
 		 * warm caches and TLB hits. in default vmalloc is used to
 		 * reduce the pressure of kernel slab system. as we know,
 		 * mimimal size of vmalloc is one page since vmalloc would
-		 * always align the requested size to page size
+		 * always align the requested size to page size.
+		 * but if vmalloc fails or it is not available (e.g. GFP_ATOMIC)
+		 * allocate percpu slot with kmalloc.
 		 */
-		if ((pool->gfp & GFP_ATOMIC) == GFP_ATOMIC)
-			slot = kmalloc_node(size, pool->gfp, cpu_to_node(i));
-		else
+		slot = NULL;
+
+		if ((pool->gfp & (GFP_ATOMIC | GFP_KERNEL)) != GFP_ATOMIC)
 			slot = __vmalloc_node(size, sizeof(void *), pool->gfp,
 				cpu_to_node(i), __builtin_return_address(0));
-		if (!slot)
-			return -ENOMEM;
+
+		if (!slot) {
+			slot = kmalloc_node(size, pool->gfp, cpu_to_node(i));
+			if (!slot)
+				return -ENOMEM;
+		}
 		memset(slot, 0, size);
 		pool->cpu_slots[i] = slot;
 
-- 
2.47.0



