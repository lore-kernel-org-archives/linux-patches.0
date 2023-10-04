Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B601820B0D
	for <patches@lists.linux.dev>; Wed,  4 Oct 2023 18:32:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CbhHYaxN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33B22C433C7;
	Wed,  4 Oct 2023 18:32:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696444323;
	bh=MBl4Y+j+pXWAk+Fb9ZvyvthEvJYmloRCDijp7rIVYvY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CbhHYaxNK4PjOD+0qXrZSF4knAWpiz+RCR0WkLo09QFCD6CS/4FATg9KVbLSwQYKw
	 u2l7f0aKlGdP4iEzlLAcIDngjkcdai9DmCLF0WPatV2VLFLElCiNpu+0ZtpLDpRIXA
	 38aj6YsS18nYgerAh6E0MJBDjaf/PiXHpJ4VLE6k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexei Starovoitov <ast@kernel.org>,
	Hou Tao <houtao1@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 208/321] bpf: Ensure unit_size is matched with slab cache object size
Date: Wed,  4 Oct 2023 19:55:53 +0200
Message-ID: <20231004175238.880991000@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231004175229.211487444@linuxfoundation.org>
References: <20231004175229.211487444@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hou Tao <houtao1@huawei.com>

[ Upstream commit c930472552022bd09aab3cd946ba3f243070d5c7 ]

Add extra check in bpf_mem_alloc_init() to ensure the unit_size of
bpf_mem_cache is matched with the object_size of underlying slab cache.
If these two sizes are unmatched, print a warning once and return
-EINVAL in bpf_mem_alloc_init(), so the mismatch can be found early and
the potential issue can be prevented.

Suggested-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Hou Tao <houtao1@huawei.com>
Link: https://lore.kernel.org/r/20230908133923.2675053-4-houtao@huaweicloud.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/memalloc.c | 33 +++++++++++++++++++++++++++++++--
 1 file changed, 31 insertions(+), 2 deletions(-)

diff --git a/kernel/bpf/memalloc.c b/kernel/bpf/memalloc.c
index 0668bcd7c926f..bcf84e71f549c 100644
--- a/kernel/bpf/memalloc.c
+++ b/kernel/bpf/memalloc.c
@@ -370,6 +370,24 @@ static void prefill_mem_cache(struct bpf_mem_cache *c, int cpu)
 	alloc_bulk(c, c->unit_size <= 256 ? 4 : 1, cpu_to_node(cpu));
 }
 
+static int check_obj_size(struct bpf_mem_cache *c, unsigned int idx)
+{
+	struct llist_node *first;
+	unsigned int obj_size;
+
+	first = c->free_llist.first;
+	if (!first)
+		return 0;
+
+	obj_size = ksize(first);
+	if (obj_size != c->unit_size) {
+		WARN_ONCE(1, "bpf_mem_cache[%u]: unexpected object size %u, expect %u\n",
+			  idx, obj_size, c->unit_size);
+		return -EINVAL;
+	}
+	return 0;
+}
+
 /* When size != 0 bpf_mem_cache for each cpu.
  * This is typical bpf hash map use case when all elements have equal size.
  *
@@ -380,10 +398,10 @@ static void prefill_mem_cache(struct bpf_mem_cache *c, int cpu)
 int bpf_mem_alloc_init(struct bpf_mem_alloc *ma, int size, bool percpu)
 {
 	static u16 sizes[NUM_CACHES] = {96, 192, 16, 32, 64, 128, 256, 512, 1024, 2048, 4096};
+	int cpu, i, err, unit_size, percpu_size = 0;
 	struct bpf_mem_caches *cc, __percpu *pcc;
 	struct bpf_mem_cache *c, __percpu *pc;
 	struct obj_cgroup *objcg = NULL;
-	int cpu, i, unit_size, percpu_size = 0;
 
 	if (size) {
 		pc = __alloc_percpu_gfp(sizeof(*pc), 8, GFP_KERNEL);
@@ -419,6 +437,7 @@ int bpf_mem_alloc_init(struct bpf_mem_alloc *ma, int size, bool percpu)
 	pcc = __alloc_percpu_gfp(sizeof(*cc), 8, GFP_KERNEL);
 	if (!pcc)
 		return -ENOMEM;
+	err = 0;
 #ifdef CONFIG_MEMCG_KMEM
 	objcg = get_obj_cgroup_from_current();
 #endif
@@ -429,10 +448,20 @@ int bpf_mem_alloc_init(struct bpf_mem_alloc *ma, int size, bool percpu)
 			c->unit_size = sizes[i];
 			c->objcg = objcg;
 			prefill_mem_cache(c, cpu);
+			err = check_obj_size(c, i);
+			if (err)
+				goto out;
 		}
 	}
+
+out:
 	ma->caches = pcc;
-	return 0;
+	/* refill_work is either zeroed or initialized, so it is safe to
+	 * call irq_work_sync().
+	 */
+	if (err)
+		bpf_mem_alloc_destroy(ma);
+	return err;
 }
 
 static void drain_mem_cache(struct bpf_mem_cache *c)
-- 
2.40.1



