Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAA6C1F754A;
	Tue,  3 Dec 2024 15:51:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733241115; cv=none; b=tq6Lrm905lvwHZ9Htmzw1DbrM49eSVJJ+cAuWn6j/TbT8pF2SsxJCgdnBYvyEf1sx1jqfYMOEl8If5VeDfvOPRP3EV53highx1THxIN/q6u/koNEpotU1uCCOy7k7VoX5w2ugKFruobE6mjl1eyS9GOVTKYzNNjxzDUZq10tVTo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733241115; c=relaxed/simple;
	bh=027zST1bQEb3FKELCx310JRMakbtT+URtDuW+79LMK0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZtAAYB4j58xqun42Tafpaf+Fqh/D2uGNeq5cblMQdKwLaQZiLfDMlgXd+yb8sv72BS16GLGZU6wCPEZgRWZqSTi3GjPkBiTGVQi0Jq+5fWgDzfh+6PKK5UBQ+Y8xX6gxaGsvSS7bQvDmIn1Z6LkKTvevxYKC96Cts54R+GxoS6c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=H8a4OwC0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="H8a4OwC0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19BEBC4CECF;
	Tue,  3 Dec 2024 15:51:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733241115;
	bh=027zST1bQEb3FKELCx310JRMakbtT+URtDuW+79LMK0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=H8a4OwC0Yr6l/ywUnafkj0I+HnrH30UTJwtCsr4vhr/0Hp9dmcuqMkr1UYnkn2ZSv
	 VKm2eRwkdrhOTDb0cdvRAbQS+DQ2aI4ANJ/AFjZhbP5rjAkUklLdU6HdYTdyqZKdHf
	 xprI6bEsJQ8RSWvqfErzTo4JPUjJo521grOEGk6A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Martin KaFai Lau <martin.lau@linux.dev>,
	Xu Kuohai <xukuohai@huawei.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 329/826] bpf: Use function pointers count as struct_ops links count
Date: Tue,  3 Dec 2024 15:40:56 +0100
Message-ID: <20241203144756.594364245@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xu Kuohai <xukuohai@huawei.com>

[ Upstream commit 821a3fa32bbe3bc0fa23b3189325d3720a49a24c ]

Only function pointers in a struct_ops structure can be linked to bpf
progs, so set the links count to the function pointers count, instead
of the total members count in the structure.

Suggested-by: Martin KaFai Lau <martin.lau@linux.dev>
Signed-off-by: Xu Kuohai <xukuohai@huawei.com>
Link: https://lore.kernel.org/r/20241112145849.3436772-3-xukuohai@huaweicloud.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Stable-dep-of: 7c8ce4ffb684 ("bpf: Add kernel symbol for struct_ops trampoline")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/bpf_struct_ops.c | 35 +++++++++++++++++++++++++----------
 1 file changed, 25 insertions(+), 10 deletions(-)

diff --git a/kernel/bpf/bpf_struct_ops.c b/kernel/bpf/bpf_struct_ops.c
index fda3dd2ee9844..5058d1536c554 100644
--- a/kernel/bpf/bpf_struct_ops.c
+++ b/kernel/bpf/bpf_struct_ops.c
@@ -32,7 +32,7 @@ struct bpf_struct_ops_map {
 	 * (in kvalue.data).
 	 */
 	struct bpf_link **links;
-	u32 links_cnt;
+	u32 funcs_cnt;
 	u32 image_pages_cnt;
 	/* image_pages is an array of pages that has all the trampolines
 	 * that stores the func args before calling the bpf_prog.
@@ -481,11 +481,11 @@ static void bpf_struct_ops_map_put_progs(struct bpf_struct_ops_map *st_map)
 {
 	u32 i;
 
-	for (i = 0; i < st_map->links_cnt; i++) {
-		if (st_map->links[i]) {
-			bpf_link_put(st_map->links[i]);
-			st_map->links[i] = NULL;
-		}
+	for (i = 0; i < st_map->funcs_cnt; i++) {
+		if (!st_map->links[i])
+			break;
+		bpf_link_put(st_map->links[i]);
+		st_map->links[i] = NULL;
 	}
 }
 
@@ -601,6 +601,7 @@ static long bpf_struct_ops_map_update_elem(struct bpf_map *map, void *key,
 	int prog_fd, err;
 	u32 i, trampoline_start, image_off = 0;
 	void *cur_image = NULL, *image = NULL;
+	struct bpf_link **plink;
 
 	if (flags)
 		return -EINVAL;
@@ -639,6 +640,7 @@ static long bpf_struct_ops_map_update_elem(struct bpf_map *map, void *key,
 	udata = &uvalue->data;
 	kdata = &kvalue->data;
 
+	plink = st_map->links;
 	module_type = btf_type_by_id(btf_vmlinux, st_ops_ids[IDX_MODULE_ID]);
 	for_each_member(i, t, member) {
 		const struct btf_type *mtype, *ptype;
@@ -714,7 +716,7 @@ static long bpf_struct_ops_map_update_elem(struct bpf_map *map, void *key,
 		}
 		bpf_link_init(&link->link, BPF_LINK_TYPE_STRUCT_OPS,
 			      &bpf_struct_ops_link_lops, prog);
-		st_map->links[i] = &link->link;
+		*plink++ = &link->link;
 
 		trampoline_start = image_off;
 		err = bpf_struct_ops_prepare_trampoline(tlinks, link,
@@ -895,6 +897,19 @@ static int bpf_struct_ops_map_alloc_check(union bpf_attr *attr)
 	return 0;
 }
 
+static u32 count_func_ptrs(const struct btf *btf, const struct btf_type *t)
+{
+	int i;
+	u32 count;
+	const struct btf_member *member;
+
+	count = 0;
+	for_each_member(i, t, member)
+		if (btf_type_resolve_func_ptr(btf, member->type, NULL))
+			count++;
+	return count;
+}
+
 static struct bpf_map *bpf_struct_ops_map_alloc(union bpf_attr *attr)
 {
 	const struct bpf_struct_ops_desc *st_ops_desc;
@@ -961,9 +976,9 @@ static struct bpf_map *bpf_struct_ops_map_alloc(union bpf_attr *attr)
 	map = &st_map->map;
 
 	st_map->uvalue = bpf_map_area_alloc(vt->size, NUMA_NO_NODE);
-	st_map->links_cnt = btf_type_vlen(t);
+	st_map->funcs_cnt = count_func_ptrs(btf, t);
 	st_map->links =
-		bpf_map_area_alloc(st_map->links_cnt * sizeof(struct bpf_links *),
+		bpf_map_area_alloc(st_map->funcs_cnt * sizeof(struct bpf_link *),
 				   NUMA_NO_NODE);
 	if (!st_map->uvalue || !st_map->links) {
 		ret = -ENOMEM;
@@ -994,7 +1009,7 @@ static u64 bpf_struct_ops_map_mem_usage(const struct bpf_map *map)
 	usage = sizeof(*st_map) +
 			vt->size - sizeof(struct bpf_struct_ops_value);
 	usage += vt->size;
-	usage += btf_type_vlen(vt) * sizeof(struct bpf_links *);
+	usage += st_map->funcs_cnt * sizeof(struct bpf_link *);
 	usage += PAGE_SIZE;
 	return usage;
 }
-- 
2.43.0



