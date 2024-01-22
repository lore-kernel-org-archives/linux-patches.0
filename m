Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2592C63127;
	Tue, 23 Jan 2024 01:56:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705975008; cv=none; b=UY9/MY0uTeAllfN85xDOdDGswPxNuCAVO8FwFyrWoT3rz1EFhvrzLduqBLo3OeEYwyu/kOWv4fPhGmmEYS8E0m72XC/m7o93dLFAwD15aAjqfs8ZKeiWwhSaK+sYWcE2QbEYM9DwR80PTv4ih5eiQKXq1KIsFbGHZhGBpw/X8Hg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705975008; c=relaxed/simple;
	bh=3Nnzgaw1deQLGHux3FGVgHkNinRCh4iOjouOJ/TKIkA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nIHMapE6+H9xDPcOCkoY4cMKLDBt+7jyl+Vl0R3RCcBDEHcyu6/60Z36Ls0iYaY37LE7s5sHhT8fnTUdOZe1TPyNdXk3ZVdaq1IS8hGdXBE4UEjWgoZBCB1BHZI5KADK31iJeCfolPqHYlPGTUrsC1PYqjWpMkaiVGJu1yt3DRU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=H+KxDbG1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="H+KxDbG1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C5D4C433F1;
	Tue, 23 Jan 2024 01:56:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705975007;
	bh=3Nnzgaw1deQLGHux3FGVgHkNinRCh4iOjouOJ/TKIkA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=H+KxDbG1EwwfK0rXr9pNZgr0R8BEC7ikgnCCUaWcl+UlOAJk8axyQ5dG8YM+n5r9I
	 xea5ZzRgFRxU7wVLQ68LN+vjAxIka6n4CkMCkFbq/vKP6SY2QccaLslNuj8SomS8RX
	 ZeldQCt0mPVU4ZiLabmyfJRN0su82wzrfEvjtXdU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hou Tao <houtao1@huawei.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 189/583] bpf: Use pcpu_alloc_size() in bpf_mem_free{_rcu}()
Date: Mon, 22 Jan 2024 15:54:00 -0800
Message-ID: <20240122235817.781314641@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235812.238724226@linuxfoundation.org>
References: <20240122235812.238724226@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hou Tao <houtao1@huawei.com>

[ Upstream commit 3f2189e4f77b7a3e979d143dc4ff586488c7e8a5 ]

For bpf_global_percpu_ma, the pointer passed to bpf_mem_free_rcu() is
allocated by kmalloc() and its size is fixed (16-bytes on x86-64). So
no matter which cache allocates the dynamic per-cpu area, on x86-64
cache[2] will always be used to free the per-cpu area.

Fix the unbalance by checking whether the bpf memory allocator is
per-cpu or not and use pcpu_alloc_size() instead of ksize() to
find the correct cache for per-cpu free.

Signed-off-by: Hou Tao <houtao1@huawei.com>
Link: https://lore.kernel.org/r/20231020133202.4043247-5-houtao@huaweicloud.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Stable-dep-of: 7ac5c53e0073 ("bpf: Use c->unit_size to select target cache during free")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/bpf_mem_alloc.h |  1 +
 kernel/bpf/memalloc.c         | 17 +++++++++++++++--
 2 files changed, 16 insertions(+), 2 deletions(-)

diff --git a/include/linux/bpf_mem_alloc.h b/include/linux/bpf_mem_alloc.h
index d644bbb298af..bb1223b21308 100644
--- a/include/linux/bpf_mem_alloc.h
+++ b/include/linux/bpf_mem_alloc.h
@@ -11,6 +11,7 @@ struct bpf_mem_caches;
 struct bpf_mem_alloc {
 	struct bpf_mem_caches __percpu *caches;
 	struct bpf_mem_cache __percpu *cache;
+	bool percpu;
 	struct work_struct work;
 };
 
diff --git a/kernel/bpf/memalloc.c b/kernel/bpf/memalloc.c
index 9657d5951d78..5f93bafa4a26 100644
--- a/kernel/bpf/memalloc.c
+++ b/kernel/bpf/memalloc.c
@@ -522,6 +522,8 @@ int bpf_mem_alloc_init(struct bpf_mem_alloc *ma, int size, bool percpu)
 	struct bpf_mem_cache *c, __percpu *pc;
 	struct obj_cgroup *objcg = NULL;
 
+	ma->percpu = percpu;
+
 	if (size) {
 		pc = __alloc_percpu_gfp(sizeof(*pc), 8, GFP_KERNEL);
 		if (!pc)
@@ -866,6 +868,17 @@ void notrace *bpf_mem_alloc(struct bpf_mem_alloc *ma, size_t size)
 	return !ret ? NULL : ret + LLIST_NODE_SZ;
 }
 
+static notrace int bpf_mem_free_idx(void *ptr, bool percpu)
+{
+	size_t size;
+
+	if (percpu)
+		size = pcpu_alloc_size(*((void **)ptr));
+	else
+		size = ksize(ptr - LLIST_NODE_SZ);
+	return bpf_mem_cache_idx(size);
+}
+
 void notrace bpf_mem_free(struct bpf_mem_alloc *ma, void *ptr)
 {
 	int idx;
@@ -873,7 +886,7 @@ void notrace bpf_mem_free(struct bpf_mem_alloc *ma, void *ptr)
 	if (!ptr)
 		return;
 
-	idx = bpf_mem_cache_idx(ksize(ptr - LLIST_NODE_SZ));
+	idx = bpf_mem_free_idx(ptr, ma->percpu);
 	if (idx < 0)
 		return;
 
@@ -887,7 +900,7 @@ void notrace bpf_mem_free_rcu(struct bpf_mem_alloc *ma, void *ptr)
 	if (!ptr)
 		return;
 
-	idx = bpf_mem_cache_idx(ksize(ptr - LLIST_NODE_SZ));
+	idx = bpf_mem_free_idx(ptr, ma->percpu);
 	if (idx < 0)
 		return;
 
-- 
2.43.0



