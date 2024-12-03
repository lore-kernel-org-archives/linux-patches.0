Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 104351F76A8;
	Tue,  3 Dec 2024 15:48:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733240893; cv=none; b=FBMUiGGGobJhnlMNrMGMOL912eodAvOdFo265ZyiaWzmaxO2dXtCjsx6e0rCI9u/kV3o44dfXJiBAxw9G/ANrrxdBuvOrTrT66hLq+sS2A3/Ig2hDSTOyQ9p1Dz77XUvRxS1jETrz3Z9saotk4PJ/bpA63O5UpwA6h1ih+FmkbI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733240893; c=relaxed/simple;
	bh=/v4KmSMWeQ/jfy4H0OliA54muV2Q3mPjNvu/k8ES0/I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NUHSWlzjzRcg3jcz5bgLyS+nh6+nE/K5Y8r4NNfUk7z13gLbFuhGcXoPzOetZxcFU0MWyVqCZC9UGUvWpTElqrOe3lSq9bPQITd8Gf0llrLUrZmKjsCSEnyeh9wyEW6s4Duph5Y/bX0DflXvpiDn5t0cfQkpNLAJA3eLgRSvlEI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HvXK1sCy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HvXK1sCy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 754F2C4CECF;
	Tue,  3 Dec 2024 15:48:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733240892;
	bh=/v4KmSMWeQ/jfy4H0OliA54muV2Q3mPjNvu/k8ES0/I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HvXK1sCyxYoyhQkd7qD2s1X4TuCbAHFLnQe3BBOc0GLdNCVJfO7bVBBi7iFOjoGvp
	 Nk1QapKidMzm6YGLk8eFZ1+ZUe5Yi82p2/krndNa+KV17aGjMpMm+1z90mCRtxuAKg
	 mLFdgiLeZcHBXUsxTgkGvikZIDv7eaeejYGEpVUw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alastair Robertson <ajor@meta.com>,
	Jonathan Wiepert <jwiepert@meta.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 266/826] libbpf: move global data mmap()ing into bpf_object__load()
Date: Tue,  3 Dec 2024 15:39:53 +0100
Message-ID: <20241203144754.137682638@linuxfoundation.org>
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

From: Andrii Nakryiko <andrii@kernel.org>

[ Upstream commit 137978f422516a128326df55c0ba23605f925e21 ]

Since BPF skeleton inception libbpf has been doing mmap()'ing of global
data ARRAY maps in bpf_object__load_skeleton() API, which is used by
code generated .skel.h files (i.e., by BPF skeletons only).

This is wrong because if BPF object is loaded through generic
bpf_object__load() API, global data maps won't be re-mmap()'ed after
load step, and memory pointers returned from bpf_map__initial_value()
would be wrong and won't reflect the actual memory shared between BPF
program and user space.

bpf_map__initial_value() return result is rarely used after load, so
this went unnoticed for a really long time, until bpftrace project
attempted to load BPF object through generic bpf_object__load() API and
then used BPF subskeleton instantiated from such bpf_object. It turned
out that .data/.rodata/.bss data updates through such subskeleton was
"blackholed", all because libbpf wouldn't re-mmap() those maps during
bpf_object__load() phase.

Long story short, this step should be done by libbpf regardless of BPF
skeleton usage, right after BPF map is created in the kernel. This patch
moves this functionality into bpf_object__populate_internal_map() to
achieve this. And bpf_object__load_skeleton() is now simple and almost
trivial, only propagating these mmap()'ed pointers into user-supplied
skeleton structs.

We also do trivial adjustments to error reporting inside
bpf_object__populate_internal_map() for consistency with the rest of
libbpf's map-handling code.

Reported-by: Alastair Robertson <ajor@meta.com>
Reported-by: Jonathan Wiepert <jwiepert@meta.com>
Fixes: d66562fba1ce ("libbpf: Add BPF object skeleton support")
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Link: https://lore.kernel.org/r/20241023043908.3834423-3-andrii@kernel.org
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/lib/bpf/libbpf.c | 83 ++++++++++++++++++++----------------------
 1 file changed, 40 insertions(+), 43 deletions(-)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index 1a54ea3a9208d..5ff643e60d09c 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -5094,6 +5094,7 @@ bpf_object__populate_internal_map(struct bpf_object *obj, struct bpf_map *map)
 	enum libbpf_map_type map_type = map->libbpf_type;
 	char *cp, errmsg[STRERR_BUFSIZE];
 	int err, zero = 0;
+	size_t mmap_sz;
 
 	if (obj->gen_loader) {
 		bpf_gen__map_update_elem(obj->gen_loader, map - obj->maps,
@@ -5107,8 +5108,8 @@ bpf_object__populate_internal_map(struct bpf_object *obj, struct bpf_map *map)
 	if (err) {
 		err = -errno;
 		cp = libbpf_strerror_r(err, errmsg, sizeof(errmsg));
-		pr_warn("Error setting initial map(%s) contents: %s\n",
-			map->name, cp);
+		pr_warn("map '%s': failed to set initial contents: %s\n",
+			bpf_map__name(map), cp);
 		return err;
 	}
 
@@ -5118,11 +5119,43 @@ bpf_object__populate_internal_map(struct bpf_object *obj, struct bpf_map *map)
 		if (err) {
 			err = -errno;
 			cp = libbpf_strerror_r(err, errmsg, sizeof(errmsg));
-			pr_warn("Error freezing map(%s) as read-only: %s\n",
-				map->name, cp);
+			pr_warn("map '%s': failed to freeze as read-only: %s\n",
+				bpf_map__name(map), cp);
 			return err;
 		}
 	}
+
+	/* Remap anonymous mmap()-ed "map initialization image" as
+	 * a BPF map-backed mmap()-ed memory, but preserving the same
+	 * memory address. This will cause kernel to change process'
+	 * page table to point to a different piece of kernel memory,
+	 * but from userspace point of view memory address (and its
+	 * contents, being identical at this point) will stay the
+	 * same. This mapping will be released by bpf_object__close()
+	 * as per normal clean up procedure.
+	 */
+	mmap_sz = bpf_map_mmap_sz(map);
+	if (map->def.map_flags & BPF_F_MMAPABLE) {
+		void *mmaped;
+		int prot;
+
+		if (map->def.map_flags & BPF_F_RDONLY_PROG)
+			prot = PROT_READ;
+		else
+			prot = PROT_READ | PROT_WRITE;
+		mmaped = mmap(map->mmaped, mmap_sz, prot, MAP_SHARED | MAP_FIXED, map->fd, 0);
+		if (mmaped == MAP_FAILED) {
+			err = -errno;
+			pr_warn("map '%s': failed to re-mmap() contents: %d\n",
+				bpf_map__name(map), err);
+			return err;
+		}
+		map->mmaped = mmaped;
+	} else if (map->mmaped) {
+		munmap(map->mmaped, mmap_sz);
+		map->mmaped = NULL;
+	}
+
 	return 0;
 }
 
@@ -5439,8 +5472,7 @@ bpf_object__create_maps(struct bpf_object *obj)
 				err = bpf_object__populate_internal_map(obj, map);
 				if (err < 0)
 					goto err_out;
-			}
-			if (map->def.type == BPF_MAP_TYPE_ARENA) {
+			} else if (map->def.type == BPF_MAP_TYPE_ARENA) {
 				map->mmaped = mmap((void *)(long)map->map_extra,
 						   bpf_map_mmap_sz(map), PROT_READ | PROT_WRITE,
 						   map->map_extra ? MAP_SHARED | MAP_FIXED : MAP_SHARED,
@@ -13881,46 +13913,11 @@ int bpf_object__load_skeleton(struct bpf_object_skeleton *s)
 	for (i = 0; i < s->map_cnt; i++) {
 		struct bpf_map_skeleton *map_skel = (void *)s->maps + i * s->map_skel_sz;
 		struct bpf_map *map = *map_skel->map;
-		size_t mmap_sz = bpf_map_mmap_sz(map);
-		int prot, map_fd = map->fd;
-		void **mmaped = map_skel->mmaped;
-
-		if (!mmaped)
-			continue;
-
-		if (!(map->def.map_flags & BPF_F_MMAPABLE)) {
-			*mmaped = NULL;
-			continue;
-		}
 
-		if (map->def.type == BPF_MAP_TYPE_ARENA) {
-			*mmaped = map->mmaped;
+		if (!map_skel->mmaped)
 			continue;
-		}
-
-		if (map->def.map_flags & BPF_F_RDONLY_PROG)
-			prot = PROT_READ;
-		else
-			prot = PROT_READ | PROT_WRITE;
 
-		/* Remap anonymous mmap()-ed "map initialization image" as
-		 * a BPF map-backed mmap()-ed memory, but preserving the same
-		 * memory address. This will cause kernel to change process'
-		 * page table to point to a different piece of kernel memory,
-		 * but from userspace point of view memory address (and its
-		 * contents, being identical at this point) will stay the
-		 * same. This mapping will be released by bpf_object__close()
-		 * as per normal clean up procedure, so we don't need to worry
-		 * about it from skeleton's clean up perspective.
-		 */
-		*mmaped = mmap(map->mmaped, mmap_sz, prot, MAP_SHARED | MAP_FIXED, map_fd, 0);
-		if (*mmaped == MAP_FAILED) {
-			err = -errno;
-			*mmaped = NULL;
-			pr_warn("failed to re-mmap() map '%s': %d\n",
-				 bpf_map__name(map), err);
-			return libbpf_err(err);
-		}
+		*map_skel->mmaped = map->mmaped;
 	}
 
 	return 0;
-- 
2.43.0



