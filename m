Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACFEE8837;
	Mon, 28 Oct 2024 06:51:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730098296; cv=none; b=iQTIY8xn8UWW+7NpOHLxG8VSjSO0MGPsxDUoW+baXuwizEzHaQnezGUEp7rzG5pQIYuFAV8q8m1dyjmOBiLKehpeNK+bpJmaVyWXMYJBrf7J7kvqQFZtIhJir/e44OR6MKd6AFBZ3AAj3K8kNE+LhVLrte8kZuL+gQbl6XkfP3w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730098296; c=relaxed/simple;
	bh=IZru7iNaXlNS0r9if6A2PrPlPzgADz+QyMvj7yU6ITc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OHeABwIGZWaesZR8LPWE4d/ua4HJvXALJXutMEgHVQUXlAlmDsvR6mRdgyTu59QdDGfRvdwwAjKI+ez3lo127JaghJO/M5LDRxxLqQ5SNZizrdvP2uVOd4gk6RSmuvV1gY3cywCzxErjbYkEI3H6mzDYLWG293QkP7+gHHtrEy8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VIymj9NK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VIymj9NK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4EAC1C4CEC3;
	Mon, 28 Oct 2024 06:51:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730098296;
	bh=IZru7iNaXlNS0r9if6A2PrPlPzgADz+QyMvj7yU6ITc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VIymj9NKVXe6LYXPpYK1QL+DYlaC1UfTxVcSH+ap9H3qPkRnV8DygR7Eib+DvD5/8
	 hWTEDka1gD+QCdM9MXBTxtWoYxiN2cU/ADi3dKO/gWJebUKMwNORE69tf7dols7SW2
	 /LE8xJ5Vyl0Jo4Z350bL/EbCSnuVb0yyYEf8EtHg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Viktor Malik <vmalik@redhat.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Matt Wu <wuqiang.matt@bytedance.com>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 137/261] objpool: fix choosing allocation for percpu slots
Date: Mon, 28 Oct 2024 07:24:39 +0100
Message-ID: <20241028062315.477268242@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241028062312.001273460@linuxfoundation.org>
References: <20241028062312.001273460@linuxfoundation.org>
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

From: Viktor Malik <vmalik@redhat.com>

[ Upstream commit aff1871bfc81e9dffa7d2a77e67cc5441cc37f81 ]

objpool intends to use vmalloc for default (non-atomic) allocations of
percpu slots and objects. However, the condition checking if GFP flags
set any bit of GFP_ATOMIC is wrong b/c GFP_ATOMIC is a combination of bits
(__GFP_HIGH|__GFP_KSWAPD_RECLAIM) and so `pool->gfp & GFP_ATOMIC` will
be true if either bit is set. Since GFP_ATOMIC and GFP_KERNEL share the
___GFP_KSWAPD_RECLAIM bit, kmalloc will be used in cases when GFP_KERNEL
is specified, i.e. in all current usages of objpool.

This may lead to unexpected OOM errors since kmalloc cannot allocate
large amounts of memory.

For instance, objpool is used by fprobe rethook which in turn is used by
BPF kretprobe.multi and kprobe.session probe types. Trying to attach
these to all kernel functions with libbpf using

    SEC("kprobe.session/*")
    int kprobe(struct pt_regs *ctx)
    {
        [...]
    }

fails on objpool slot allocation with ENOMEM.

Fix the condition to truly use vmalloc by default.

Link: https://lore.kernel.org/all/20240826060718.267261-1-vmalik@redhat.com/

Fixes: b4edb8d2d464 ("lib: objpool added: ring-array based lockless MPMC")
Signed-off-by: Viktor Malik <vmalik@redhat.com>
Acked-by: Andrii Nakryiko <andrii@kernel.org>
Reviewed-by: Matt Wu <wuqiang.matt@bytedance.com>
Signed-off-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 lib/objpool.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/objpool.c b/lib/objpool.c
index 234f9d0bd081a..fd108fe0d095a 100644
--- a/lib/objpool.c
+++ b/lib/objpool.c
@@ -76,7 +76,7 @@ objpool_init_percpu_slots(struct objpool_head *pool, int nr_objs,
 		 * mimimal size of vmalloc is one page since vmalloc would
 		 * always align the requested size to page size
 		 */
-		if (pool->gfp & GFP_ATOMIC)
+		if ((pool->gfp & GFP_ATOMIC) == GFP_ATOMIC)
 			slot = kmalloc_node(size, pool->gfp, cpu_to_node(i));
 		else
 			slot = __vmalloc_node(size, sizeof(void *), pool->gfp,
-- 
2.43.0



