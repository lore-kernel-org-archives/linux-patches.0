Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2FBC2EA15F;
	Tue, 22 Jul 2025 14:05:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753193132; cv=none; b=sFbRVew/sbWirgVr8ObxkzRBIknAKFePnZyFxq6gdkMyS6THdKOlWtJManh6WhnEJ1uiryvBhiiawzWe+H2dEXXTBi8qgkRuCgQg9Y83VsbE1KXJ2kGSFHAAx+fz3IwOxh95TOpnuT4sQ2P1yXr1sD+JpvkaomyUVKZLDOwvusE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753193132; c=relaxed/simple;
	bh=LghWn5fmU2ubh2W+HqwQIjOF+J4IeDGYC1TZ53dJ+vs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Oh8Or8xxO0E6B4VqeqX5rT6Etaw15xDZA57vIr6GrN9lGS65sD58Pbhob3rr+H5smj/0O47ISunHOBPxjpdCfSSsWy0UhaCjlW+T9xgjBK079FBBLaBY4R+nrR9N8hW0PcdA+SJp0qgiEjf7RtzmySgrRwA7Oozj5W5hsDhAFng=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zAvo29H6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zAvo29H6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42D47C4CEF5;
	Tue, 22 Jul 2025 14:05:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753193132;
	bh=LghWn5fmU2ubh2W+HqwQIjOF+J4IeDGYC1TZ53dJ+vs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zAvo29H6P78Ro0A0e/D5BudciudLnlIYP40QwLIP7W9H11FKRqIIGHUY/bS6YRyyQ
	 /F7WXPqzBF3ai5U2Ipid+lDQrVFEB+xZr0Z0Zkr7t2Jd9U5CJclB71Rb53YmXfcnMB
	 f0mz8z4CUSSDPe8zx5pq4NGup7SqZ5drYWBOuQ7U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrii Nakryiko <andrii@kernel.org>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 138/158] libbpf: Fix handling of BPF arena relocations
Date: Tue, 22 Jul 2025 15:45:22 +0200
Message-ID: <20250722134345.878506951@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250722134340.596340262@linuxfoundation.org>
References: <20250722134340.596340262@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Andrii Nakryiko <andrii@kernel.org>

[ Upstream commit 0238c45fbbf8228f52aa4642f0cdc21c570d1dfe ]

Initial __arena global variable support implementation in libbpf
contains a bug: it remembers struct bpf_map pointer for arena, which is
used later on to process relocations. Recording this pointer is
problematic because map pointers are not stable during ELF relocation
collection phase, as an array of struct bpf_map's can be reallocated,
invalidating all the pointers. Libbpf is dealing with similar issues by
using a stable internal map index, though for BPF arena map specifically
this approach wasn't used due to an oversight.

The resulting behavior is non-deterministic issue which depends on exact
layout of ELF object file, number of actual maps, etc. We didn't hit
this until very recently, when this bug started triggering crash in BPF
CI when validating one of sched-ext BPF programs.

The fix is rather straightforward: we just follow an established pattern
of remembering map index (just like obj->kconfig_map_idx, for example)
instead of `struct bpf_map *`, and resolving index to a pointer at the
point where map information is necessary.

While at it also add debug-level message for arena-related relocation
resolution information, which we already have for all other kinds of
maps.

Fixes: 2e7ba4f8fd1f ("libbpf: Recognize __arena global variables.")
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Tested-by: Eduard Zingerman <eddyz87@gmail.com>
Link: https://lore.kernel.org/r/20250718001009.610955-1-andrii@kernel.org
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/lib/bpf/libbpf.c | 20 +++++++++++++-------
 1 file changed, 13 insertions(+), 7 deletions(-)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index 36e341b4b77bf..747cef47e685b 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -726,7 +726,7 @@ struct bpf_object {
 
 	struct usdt_manager *usdt_man;
 
-	struct bpf_map *arena_map;
+	int arena_map_idx;
 	void *arena_data;
 	size_t arena_data_sz;
 
@@ -1494,6 +1494,7 @@ static struct bpf_object *bpf_object__new(const char *path,
 	obj->efile.obj_buf_sz = obj_buf_sz;
 	obj->efile.btf_maps_shndx = -1;
 	obj->kconfig_map_idx = -1;
+	obj->arena_map_idx = -1;
 
 	obj->kern_version = get_kernel_version();
 	obj->loaded = false;
@@ -2935,7 +2936,7 @@ static int init_arena_map_data(struct bpf_object *obj, struct bpf_map *map,
 	const long page_sz = sysconf(_SC_PAGE_SIZE);
 	size_t mmap_sz;
 
-	mmap_sz = bpf_map_mmap_sz(obj->arena_map);
+	mmap_sz = bpf_map_mmap_sz(map);
 	if (roundup(data_sz, page_sz) > mmap_sz) {
 		pr_warn("elf: sec '%s': declared ARENA map size (%zu) is too small to hold global __arena variables of size %zu\n",
 			sec_name, mmap_sz, data_sz);
@@ -3009,12 +3010,12 @@ static int bpf_object__init_user_btf_maps(struct bpf_object *obj, bool strict,
 		if (map->def.type != BPF_MAP_TYPE_ARENA)
 			continue;
 
-		if (obj->arena_map) {
+		if (obj->arena_map_idx >= 0) {
 			pr_warn("map '%s': only single ARENA map is supported (map '%s' is also ARENA)\n",
-				map->name, obj->arena_map->name);
+				map->name, obj->maps[obj->arena_map_idx].name);
 			return -EINVAL;
 		}
-		obj->arena_map = map;
+		obj->arena_map_idx = i;
 
 		if (obj->efile.arena_data) {
 			err = init_arena_map_data(obj, map, ARENA_SEC, obj->efile.arena_data_shndx,
@@ -3024,7 +3025,7 @@ static int bpf_object__init_user_btf_maps(struct bpf_object *obj, bool strict,
 				return err;
 		}
 	}
-	if (obj->efile.arena_data && !obj->arena_map) {
+	if (obj->efile.arena_data && obj->arena_map_idx < 0) {
 		pr_warn("elf: sec '%s': to use global __arena variables the ARENA map should be explicitly declared in SEC(\".maps\")\n",
 			ARENA_SEC);
 		return -ENOENT;
@@ -4547,8 +4548,13 @@ static int bpf_program__record_reloc(struct bpf_program *prog,
 	if (shdr_idx == obj->efile.arena_data_shndx) {
 		reloc_desc->type = RELO_DATA;
 		reloc_desc->insn_idx = insn_idx;
-		reloc_desc->map_idx = obj->arena_map - obj->maps;
+		reloc_desc->map_idx = obj->arena_map_idx;
 		reloc_desc->sym_off = sym->st_value;
+
+		map = &obj->maps[obj->arena_map_idx];
+		pr_debug("prog '%s': found arena map %d (%s, sec %d, off %zu) for insn %u\n",
+			 prog->name, obj->arena_map_idx, map->name, map->sec_idx,
+			 map->sec_offset, insn_idx);
 		return 0;
 	}
 
-- 
2.39.5



