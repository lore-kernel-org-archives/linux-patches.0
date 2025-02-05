Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 723DA70825;
	Wed,  5 Feb 2025 14:31:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738765871; cv=none; b=HlfCK+4f0ZpY3A/AHVShl4I3J2SrXSSfx/iF16Bu4rwgpueM1qb1S3K0PNcW8uXo9wLAD+xtGKz/9xSRGznfy4hUPr9j1cREI6YXD/bbjVy90dRRlNf+xwd4mnEI8D3RVuvOt3FMGmI8ItBsMDQzzvgUUOTDd3BiC6FREt8NSy0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738765871; c=relaxed/simple;
	bh=GRk0FtJobpWPjooub5emkbbSfECeRAwWMgAw7sg5kJY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dgixyt/KZmYTqGJMnFNGRHehVYsxhdGFKxrkn3Oyc7q/a/R3RaUQffSHtVvUsd4TdBWzLwZafDdrYlr/c/oOh8S+guECP6FlpP8wrpQpCFQHAsek0aszZrPVNoybIq6AZ1Xr6TPOKyCjDN3GgwNxTFTBH2R8Rvbac8CC8eSzDWc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CNx5cWCc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CNx5cWCc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3BB0C4CED1;
	Wed,  5 Feb 2025 14:31:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738765871;
	bh=GRk0FtJobpWPjooub5emkbbSfECeRAwWMgAw7sg5kJY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CNx5cWCctNLvOKO43Y3q7c2ewrv1oXI33pyvbfDztmu5P4ZZu5A7eCa2FGqVysCDl
	 GGv8RfWsAGnPGre2NKZiewGqE2Yyxu0KOv8sdRPiaGoFh3LdbaKDebBbQvkMqRqCBb
	 PQLKuR/G6OeSeWmzImpFW68OW+blkMxue4Alkzo8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Pei Xiao <xiaopei01@kylinos.cn>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 263/590] bpf: Use refcount_t instead of atomic_t for mmap_count
Date: Wed,  5 Feb 2025 14:40:18 +0100
Message-ID: <20250205134505.337855931@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134455.220373560@linuxfoundation.org>
References: <20250205134455.220373560@linuxfoundation.org>
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

From: Pei Xiao <xiaopei01@kylinos.cn>

[ Upstream commit dfa94ce54f4139c893b9c4ec17df6f7c6a7515d3 ]

Use an API that resembles more the actual use of mmap_count.

Found by cocci:
kernel/bpf/arena.c:245:6-25: WARNING: atomic_dec_and_test variation before object free at line 249.

Fixes: b90d77e5fd78 ("bpf: Fix remap of arena.")
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202412292037.LXlYSHKl-lkp@intel.com/
Signed-off-by: Pei Xiao <xiaopei01@kylinos.cn>
Link: https://lore.kernel.org/r/6ecce439a6bc81adb85d5080908ea8959b792a50.1735542814.git.xiaopei01@kylinos.cn
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/arena.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/kernel/bpf/arena.c b/kernel/bpf/arena.c
index e52b3ad231b9c..93e48c7cad4ef 100644
--- a/kernel/bpf/arena.c
+++ b/kernel/bpf/arena.c
@@ -212,7 +212,7 @@ static u64 arena_map_mem_usage(const struct bpf_map *map)
 struct vma_list {
 	struct vm_area_struct *vma;
 	struct list_head head;
-	atomic_t mmap_count;
+	refcount_t mmap_count;
 };
 
 static int remember_vma(struct bpf_arena *arena, struct vm_area_struct *vma)
@@ -222,7 +222,7 @@ static int remember_vma(struct bpf_arena *arena, struct vm_area_struct *vma)
 	vml = kmalloc(sizeof(*vml), GFP_KERNEL);
 	if (!vml)
 		return -ENOMEM;
-	atomic_set(&vml->mmap_count, 1);
+	refcount_set(&vml->mmap_count, 1);
 	vma->vm_private_data = vml;
 	vml->vma = vma;
 	list_add(&vml->head, &arena->vma_list);
@@ -233,7 +233,7 @@ static void arena_vm_open(struct vm_area_struct *vma)
 {
 	struct vma_list *vml = vma->vm_private_data;
 
-	atomic_inc(&vml->mmap_count);
+	refcount_inc(&vml->mmap_count);
 }
 
 static void arena_vm_close(struct vm_area_struct *vma)
@@ -242,7 +242,7 @@ static void arena_vm_close(struct vm_area_struct *vma)
 	struct bpf_arena *arena = container_of(map, struct bpf_arena, map);
 	struct vma_list *vml = vma->vm_private_data;
 
-	if (!atomic_dec_and_test(&vml->mmap_count))
+	if (!refcount_dec_and_test(&vml->mmap_count))
 		return;
 	guard(mutex)(&arena->lock);
 	/* update link list under lock */
-- 
2.39.5



