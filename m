Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D06182ECD09;
	Tue, 22 Jul 2025 14:14:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753193677; cv=none; b=ND3eFdZdficFNC1Xo/PJb8u3fSkARNQJFrkSFPkPxp7HKLr4rV+1VpSa/gCFoQcxUfM1915RstZHg0ExLfSh2P4oKET9lT3cuGg7Qv/gGLJlpkuoLQXc/wh3wFvOaY5zCC6PJZzysbxSuVilEkkopwS6F1aXZLf8tMdcVUukkm0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753193677; c=relaxed/simple;
	bh=fNeGOtfLTec5lGoaUdsVEkFNJvn76QLynwjDQ4ze1B8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nV5AJHd1K7IwuLV4lZItOLk1UqhZ6ULDsoUsujkShEloiy98lZbasBxLfig0FCx0y8Lp96G0xaEhgQRdBxwpeZXL4e8gzRciK0O9lFu+bHTpGfTROMZ2r3aYARxSStYeb6pAE7WgbIQvWn0R+97nD+R9Ob4pBUO2TcJxEEiooU8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AIGFE4rL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AIGFE4rL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FB35C4CEEB;
	Tue, 22 Jul 2025 14:14:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753193677;
	bh=fNeGOtfLTec5lGoaUdsVEkFNJvn76QLynwjDQ4ze1B8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AIGFE4rLzyPF4AgecJSe6Tn2kp4O70DPkniDzzAsBMcz1sonm/mVrBlWVkC45coBr
	 UA6vy6fTSYRijeQtLyXWJGVzrLBSw6UR1YeUGLMsKQI4tiv3i4G0+ky4KAX11j0R0V
	 kU7MRxJQOLxOSPAPGe4IFYlq5SqqPUyLjc6XmDVE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrii Nakryiko <andrii@kernel.org>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 164/187] libbpf: Fix handling of BPF arena relocations
Date: Tue, 22 Jul 2025 15:45:34 +0200
Message-ID: <20250722134351.882861712@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250722134345.761035548@linuxfoundation.org>
References: <20250722134345.761035548@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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
index 97605ea8093ff..c8e29c52d28c0 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -735,7 +735,7 @@ struct bpf_object {
 
 	struct usdt_manager *usdt_man;
 
-	struct bpf_map *arena_map;
+	int arena_map_idx;
 	void *arena_data;
 	size_t arena_data_sz;
 
@@ -1517,6 +1517,7 @@ static struct bpf_object *bpf_object__new(const char *path,
 	obj->efile.obj_buf_sz = obj_buf_sz;
 	obj->efile.btf_maps_shndx = -1;
 	obj->kconfig_map_idx = -1;
+	obj->arena_map_idx = -1;
 
 	obj->kern_version = get_kernel_version();
 	obj->state  = OBJ_OPEN;
@@ -2964,7 +2965,7 @@ static int init_arena_map_data(struct bpf_object *obj, struct bpf_map *map,
 	const long page_sz = sysconf(_SC_PAGE_SIZE);
 	size_t mmap_sz;
 
-	mmap_sz = bpf_map_mmap_sz(obj->arena_map);
+	mmap_sz = bpf_map_mmap_sz(map);
 	if (roundup(data_sz, page_sz) > mmap_sz) {
 		pr_warn("elf: sec '%s': declared ARENA map size (%zu) is too small to hold global __arena variables of size %zu\n",
 			sec_name, mmap_sz, data_sz);
@@ -3038,12 +3039,12 @@ static int bpf_object__init_user_btf_maps(struct bpf_object *obj, bool strict,
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
@@ -3053,7 +3054,7 @@ static int bpf_object__init_user_btf_maps(struct bpf_object *obj, bool strict,
 				return err;
 		}
 	}
-	if (obj->efile.arena_data && !obj->arena_map) {
+	if (obj->efile.arena_data && obj->arena_map_idx < 0) {
 		pr_warn("elf: sec '%s': to use global __arena variables the ARENA map should be explicitly declared in SEC(\".maps\")\n",
 			ARENA_SEC);
 		return -ENOENT;
@@ -4583,8 +4584,13 @@ static int bpf_program__record_reloc(struct bpf_program *prog,
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



