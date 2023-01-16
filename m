Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFB5646B5
	for <patches@lists.linux.dev>; Mon, 16 Jan 2023 16:10:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78E9BC433D2;
	Mon, 16 Jan 2023 16:10:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673885456;
	bh=qdreDp/eRVabCX9+GEIUfFO7+Ox3DDa+HnniSye5b6s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CZcnAlc6B4TGgTf3v3qTjNKs+CLgjBeL7KFeEHCxufICKSZV+PIwyG2iw1D1sEhN4
	 U54f4o+FWlVUTkoBWo+r2j518k4iFLoRlIpz7WMT5v1snmZ3Yd6SImZybAhDRzr3DE
	 92yDBe0w5KOWlsFsDj8A1foJQwaqtALTchUAeNLc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	wuchi <wuchi.zero@gmail.com>,
	Waiman Long <longman@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Christoph Hellwig <hch@lst.de>,
	Kees Cook <keescook@chromium.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 057/658] lib/debugobjects: fix stat count and optimize debug_objects_mem_init
Date: Mon, 16 Jan 2023 16:42:25 +0100
Message-Id: <20230116154912.279710189@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154909.645460653@linuxfoundation.org>
References: <20230116154909.645460653@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: wuchi <wuchi.zero@gmail.com>

[ Upstream commit eabb7f1ace53e127309407b2b5e74e8199e85270 ]

1. Var debug_objects_allocated tracks valid kmem_cache_alloc calls, so
   track it in debug_objects_replace_static_objects.  Do similar things in
   object_cpu_offline.

2. In debug_objects_mem_init, there is no need to call function
   cpuhp_setup_state_nocalls when debug_objects_enabled = 0 (out of
   memory).

Link: https://lkml.kernel.org/r/20220611130634.99741-1-wuchi.zero@gmail.com
Fixes: 634d61f45d6f ("debugobjects: Percpu pool lookahead freeing/allocation")
Fixes: c4b73aabd098 ("debugobjects: Track number of kmem_cache_alloc/kmem_cache_free done")
Signed-off-by: wuchi <wuchi.zero@gmail.com>
Reviewed-by: Waiman Long <longman@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Kees Cook <keescook@chromium.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 lib/debugobjects.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/lib/debugobjects.c b/lib/debugobjects.c
index 746b632792b5..7ca6459259fa 100644
--- a/lib/debugobjects.c
+++ b/lib/debugobjects.c
@@ -440,6 +440,7 @@ static int object_cpu_offline(unsigned int cpu)
 	struct debug_percpu_free *percpu_pool;
 	struct hlist_node *tmp;
 	struct debug_obj *obj;
+	unsigned long flags;
 
 	/* Remote access is safe as the CPU is dead already */
 	percpu_pool = per_cpu_ptr(&percpu_obj_pool, cpu);
@@ -447,6 +448,12 @@ static int object_cpu_offline(unsigned int cpu)
 		hlist_del(&obj->node);
 		kmem_cache_free(obj_cache, obj);
 	}
+
+	raw_spin_lock_irqsave(&pool_lock, flags);
+	obj_pool_used -= percpu_pool->obj_free;
+	debug_objects_freed += percpu_pool->obj_free;
+	raw_spin_unlock_irqrestore(&pool_lock, flags);
+
 	percpu_pool->obj_free = 0;
 
 	return 0;
@@ -1327,6 +1334,8 @@ static int __init debug_objects_replace_static_objects(void)
 		hlist_add_head(&obj->node, &objects);
 	}
 
+	debug_objects_allocated += i;
+
 	/*
 	 * debug_objects_mem_init() is now called early that only one CPU is up
 	 * and interrupts have been disabled, so it is safe to replace the
@@ -1395,6 +1404,7 @@ void __init debug_objects_mem_init(void)
 		debug_objects_enabled = 0;
 		kmem_cache_destroy(obj_cache);
 		pr_warn("out of memory.\n");
+		return;
 	} else
 		debug_objects_selftest();
 
-- 
2.35.1



