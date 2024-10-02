Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5C541D1502;
	Wed,  2 Oct 2024 14:35:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727879702; cv=none; b=t5j2WS0SHL77CckjTOe7N2yTXiCZVWvwcuqV2eAdD7p/BE1BS6SWnS7KxhuaNblrXkghaN1E74AFSYiGj6vzSc7VHom/gy/k2l3dHDEETknEuzTQZGxwhpZFIqrkgY81oqomThYdo0cW05yxJbApUQJkNrsiCVhcqGzu9XHTiPg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727879702; c=relaxed/simple;
	bh=SqRTbXYWot76thI9jp86UWwzFcuBPt5qUIFD/1viHiI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DYeC9V5cjHfFZriKDG0tCMUA2h8UJSmcr+wDpiOmY4vN/pNrejqhUJZtg31y2T+kBLsGaZLjr2wLjuL01bHUzgL0kXY1BNcFKujBunyA1xiyLZH4fb7ILlYjr4BD3lBTeYY1Cx6aObMz7q6m/BTrfrYfiYIjLmlqLh8C1J4ccPk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Wuz2Us/z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Wuz2Us/z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FBA4C4CED4;
	Wed,  2 Oct 2024 14:35:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727879702;
	bh=SqRTbXYWot76thI9jp86UWwzFcuBPt5qUIFD/1viHiI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Wuz2Us/zi0GhzT8WJGPsMuB3+ihzNW4simdOLagbOfDWy6WcN7GeLs1Exh359yETQ
	 TPctbyDl1KVIax071vihDiXt5tKwko2h86jzlkX7uUzwJUz1PY9gvdKOf0b7AZku71
	 AixGtX/hpYliExsu2J0yr3XX2RPkYcm3o9U21po0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kui-Feng Lee <thinker.li@gmail.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 210/538] libbpf: Convert st_ops->data to shadow type.
Date: Wed,  2 Oct 2024 14:57:29 +0200
Message-ID: <20241002125800.546913355@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125751.964700919@linuxfoundation.org>
References: <20241002125751.964700919@linuxfoundation.org>
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

From: Kui-Feng Lee <thinker.li@gmail.com>

[ Upstream commit 69e4a9d2b3f5adf5af4feeab0a9f505da971265a ]

Convert st_ops->data to the shadow type of the struct_ops map. The shadow
type of a struct_ops type is a variant of the original struct type
providing a way to access/change the values in the maps of the struct_ops
type.

bpf_map__initial_value() will return st_ops->data for struct_ops types. The
skeleton is going to use it as the pointer to the shadow type of the
original struct type.

One of the main differences between the original struct type and the shadow
type is that all function pointers of the shadow type are converted to
pointers of struct bpf_program. Users can replace these bpf_program
pointers with other BPF programs. The st_ops->progs[] will be updated
before updating the value of a map to reflect the changes made by users.

Signed-off-by: Kui-Feng Lee <thinker.li@gmail.com>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Link: https://lore.kernel.org/bpf/20240229064523.2091270-3-thinker.li@gmail.com
Stable-dep-of: 04a94133f1b3 ("libbpf: Don't take direct pointers into BTF data from st_ops")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/lib/bpf/libbpf.c | 40 ++++++++++++++++++++++++++++++++++++++--
 1 file changed, 38 insertions(+), 2 deletions(-)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index a2b765e419c16..c91917868b557 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -994,6 +994,19 @@ static bool bpf_map__is_struct_ops(const struct bpf_map *map)
 	return map->def.type == BPF_MAP_TYPE_STRUCT_OPS;
 }
 
+static bool is_valid_st_ops_program(struct bpf_object *obj,
+				    const struct bpf_program *prog)
+{
+	int i;
+
+	for (i = 0; i < obj->nr_programs; i++) {
+		if (&obj->programs[i] == prog)
+			return prog->type == BPF_PROG_TYPE_STRUCT_OPS;
+	}
+
+	return false;
+}
+
 /* Init the map's fields that depend on kern_btf */
 static int bpf_map__init_kern_struct_ops(struct bpf_map *map)
 {
@@ -1082,9 +1095,16 @@ static int bpf_map__init_kern_struct_ops(struct bpf_map *map)
 		if (btf_is_ptr(mtype)) {
 			struct bpf_program *prog;
 
-			prog = st_ops->progs[i];
+			/* Update the value from the shadow type */
+			prog = *(void **)mdata;
+			st_ops->progs[i] = prog;
 			if (!prog)
 				continue;
+			if (!is_valid_st_ops_program(obj, prog)) {
+				pr_warn("struct_ops init_kern %s: member %s is not a struct_ops program\n",
+					map->name, mname);
+				return -ENOTSUP;
+			}
 
 			kern_mtype = skip_mods_and_typedefs(kern_btf,
 							    kern_mtype->type,
@@ -9165,7 +9185,9 @@ static struct bpf_map *find_struct_ops_map_by_offset(struct bpf_object *obj,
 	return NULL;
 }
 
-/* Collect the reloc from ELF and populate the st_ops->progs[] */
+/* Collect the reloc from ELF, populate the st_ops->progs[], and update
+ * st_ops->data for shadow type.
+ */
 static int bpf_object__collect_st_ops_relos(struct bpf_object *obj,
 					    Elf64_Shdr *shdr, Elf_Data *data)
 {
@@ -9279,6 +9301,14 @@ static int bpf_object__collect_st_ops_relos(struct bpf_object *obj,
 		}
 
 		st_ops->progs[member_idx] = prog;
+
+		/* st_ops->data will be exposed to users, being returned by
+		 * bpf_map__initial_value() as a pointer to the shadow
+		 * type. All function pointers in the original struct type
+		 * should be converted to a pointer to struct bpf_program
+		 * in the shadow type.
+		 */
+		*((struct bpf_program **)(st_ops->data + moff)) = prog;
 	}
 
 	return 0;
@@ -9730,6 +9760,12 @@ int bpf_map__set_initial_value(struct bpf_map *map,
 
 void *bpf_map__initial_value(struct bpf_map *map, size_t *psize)
 {
+	if (bpf_map__is_struct_ops(map)) {
+		if (psize)
+			*psize = map->def.value_size;
+		return map->st_ops->data;
+	}
+
 	if (!map->mmaped)
 		return NULL;
 	*psize = map->def.value_size;
-- 
2.43.0



