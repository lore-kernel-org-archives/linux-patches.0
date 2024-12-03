Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F05D1F756A;
	Tue,  3 Dec 2024 15:08:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733238486; cv=none; b=tvzmYQPxqcbDCDQv9ZGepU98x+Jm4yfssX5fTb7EG11hf3D+7q2fqTX2p15HXH4AkSxM5FWoL6reLNDH/2mZbeAOpEWiSKfZSK3yN162SPxCQFgeXwGVMrV0M7boJH3c8OfU1aizWWxxJZtbL7P4JNGv/2EhxECRQSvGN1FA9Ss=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733238486; c=relaxed/simple;
	bh=ek8tEbnJb+jepy0CyTngRKbetNPmy4FiPPfe5IFTB48=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GX4tHgbs8Kd3g6ae6RcCsLhmKpu2tfEyEimT4d2Ww5No0gajoAs51jKmxovq2mimRLaG5cp/WSkqFExG9EOjYvpxajfFQrzJk6xIQgywv7FxQftpjoSgP+NCsptnGyyNgR8mJfIY8XHSyeHl4eP6hjInRR1clnP5gOWtAQpTcAE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bYPFpeG0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bYPFpeG0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E654C4CECF;
	Tue,  3 Dec 2024 15:08:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733238485;
	bh=ek8tEbnJb+jepy0CyTngRKbetNPmy4FiPPfe5IFTB48=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bYPFpeG0FGADzdYawvlfFHW4zhoSe8wn1bns1B1w8YqbTNQ2b++TZhsrhUqu2QiHm
	 v8MOfaRpboZRnOZQdYccia1W0uuSKqlniqRZtSCVaUpevixk7VzlY5izPtH5pJ3R20
	 M3pyck1XVIW3mZg0jhOdElIG21VqPcaFWlDWcvbg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alastair Robertson <ajor@meta.com>,
	Jonathan Wiepert <jwiepert@meta.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 293/817] libbpf: move global data mmap()ing into bpf_object__load()
Date: Tue,  3 Dec 2024 15:37:45 +0100
Message-ID: <20241203144007.253827782@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
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
index 12d99b9ddb7c1..f1da986ab9217 100644
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
@@ -13876,46 +13908,11 @@ int bpf_object__load_skeleton(struct bpf_object_skeleton *s)
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



