Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DF591DF251;
	Wed,  6 Nov 2024 12:28:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730896080; cv=none; b=k61kAJQLt/B7Ctu1ZyObgcI1daNXhr5OeZlqheeEyTuESVTMe4sMWQv2YlZsUps/4BlGb/tOTGE+OBYk0bCZPVinq6sf8BtYUxIrDemZ94kPzQ+HWNO+08vC9/yMnlS3chLLhpjlNSocTb0+P7jWOweOI5uU8IZ2kub6Md/wkoQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730896080; c=relaxed/simple;
	bh=+C+7ciEw/I5oXXy/sCTP9uKgvOdFYlO/79m5uaUvuiw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O18OuFBrYivAbdSYJX6UA4GUreJMl7fKPYmNgvfsDR3OP2zS8MgUAPxbf8W3rxvMa8xKgQXJC1+Yk6cOFgOTqFnX7bHHyqkyHZlatN4B/dqGStjgFKtUqoHXpXDpAVaoyWV4L3xolp8bKU0ipBmlA1Xm10ORc7FQHeL9NpOIHoQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=b700Sz7z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="b700Sz7z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D63E9C4CECD;
	Wed,  6 Nov 2024 12:27:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730896080;
	bh=+C+7ciEw/I5oXXy/sCTP9uKgvOdFYlO/79m5uaUvuiw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=b700Sz7zP/VZ4buN6Oh9rQbw35NF4ku0V7Z+1X6WEho9d1AdJQDNDVncufae6l0Ei
	 GrOILzWrbF7OJEff519PRbm4N7OV7XbWxcgclZmfmtw4hnV3BiZ5tOCfvBqt6739Kw
	 EWWyWN5mjkn3UscXxtSKoepZT50sBRY2AK/eO/Mo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hou Tao <houtao1@huawei.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 047/245] bpf: Add bpf_mem_alloc_check_size() helper
Date: Wed,  6 Nov 2024 13:01:40 +0100
Message-ID: <20241106120320.383534823@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120319.234238499@linuxfoundation.org>
References: <20241106120319.234238499@linuxfoundation.org>
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

From: Hou Tao <houtao1@huawei.com>

[ Upstream commit 62a898b07b83f6f407003d8a70f0827a5af08a59 ]

Introduce bpf_mem_alloc_check_size() to check whether the allocation
size exceeds the limitation for the kmalloc-equivalent allocator. The
upper limit for percpu allocation is LLIST_NODE_SZ bytes larger than
non-percpu allocation, so a percpu argument is added to the helper.

The helper will be used in the following patch to check whether the size
parameter passed to bpf_mem_alloc() is too big.

Signed-off-by: Hou Tao <houtao1@huawei.com>
Link: https://lore.kernel.org/r/20241030100516.3633640-3-houtao@huaweicloud.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Stable-dep-of: 393397fbdcad ("bpf: Check the validity of nr_words in bpf_iter_bits_new()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/bpf_mem_alloc.h |  3 +++
 kernel/bpf/memalloc.c         | 14 +++++++++++++-
 2 files changed, 16 insertions(+), 1 deletion(-)

diff --git a/include/linux/bpf_mem_alloc.h b/include/linux/bpf_mem_alloc.h
index aaf004d943228..e45162ef59bb1 100644
--- a/include/linux/bpf_mem_alloc.h
+++ b/include/linux/bpf_mem_alloc.h
@@ -33,6 +33,9 @@ int bpf_mem_alloc_percpu_init(struct bpf_mem_alloc *ma, struct obj_cgroup *objcg
 int bpf_mem_alloc_percpu_unit_init(struct bpf_mem_alloc *ma, int size);
 void bpf_mem_alloc_destroy(struct bpf_mem_alloc *ma);
 
+/* Check the allocation size for kmalloc equivalent allocator */
+int bpf_mem_alloc_check_size(bool percpu, size_t size);
+
 /* kmalloc/kfree equivalent: */
 void *bpf_mem_alloc(struct bpf_mem_alloc *ma, size_t size);
 void bpf_mem_free(struct bpf_mem_alloc *ma, void *ptr);
diff --git a/kernel/bpf/memalloc.c b/kernel/bpf/memalloc.c
index dec892ded031e..b2c7a4c49be77 100644
--- a/kernel/bpf/memalloc.c
+++ b/kernel/bpf/memalloc.c
@@ -35,6 +35,8 @@
  */
 #define LLIST_NODE_SZ sizeof(struct llist_node)
 
+#define BPF_MEM_ALLOC_SIZE_MAX 4096
+
 /* similar to kmalloc, but sizeof == 8 bucket is gone */
 static u8 size_index[24] __ro_after_init = {
 	3,	/* 8 */
@@ -65,7 +67,7 @@ static u8 size_index[24] __ro_after_init = {
 
 static int bpf_mem_cache_idx(size_t size)
 {
-	if (!size || size > 4096)
+	if (!size || size > BPF_MEM_ALLOC_SIZE_MAX)
 		return -1;
 
 	if (size <= 192)
@@ -1005,3 +1007,13 @@ void notrace *bpf_mem_cache_alloc_flags(struct bpf_mem_alloc *ma, gfp_t flags)
 
 	return !ret ? NULL : ret + LLIST_NODE_SZ;
 }
+
+int bpf_mem_alloc_check_size(bool percpu, size_t size)
+{
+	/* The size of percpu allocation doesn't have LLIST_NODE_SZ overhead */
+	if ((percpu && size > BPF_MEM_ALLOC_SIZE_MAX) ||
+	    (!percpu && size > BPF_MEM_ALLOC_SIZE_MAX - LLIST_NODE_SZ))
+		return -E2BIG;
+
+	return 0;
+}
-- 
2.43.0



