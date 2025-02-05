Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CF991FDE14;
	Wed,  5 Feb 2025 14:41:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738766504; cv=none; b=gjGiY3GJCq5seMIUJ7GbvpZGbzxxoTEFBT5bfIjRPDupHIUIoOcqe8mn5b9K5Hufa+/nBo3w3Zwe7SKXn5P0FlKhSvF9ZI8Xza9w0g4diPmec31/wcMs3a0jQroQxcpGjXKDKr/XqIa3b0FIZ0QSFmzT7KBRVFS/3YqpV0Bu78g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738766504; c=relaxed/simple;
	bh=OKSLxRZYrKlzFz+AAMcS3v+ZH4y5Mk9lBX7tRFniT+g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=atrd6WzdfSjd5EkoLBSnBo0SjC2804BMNKnHB5A7XhgA3mUI4YX2Ks9PxqrA4mFS32UIWDuNIGNi1Z0TfGyNVAQCipFsZMpxxQwSn30jDQFZugCZX2EkkW9i54AjNDb6S0FQJpihFa7dIjo3d5Cij5KaoBkEK3yF4+JCmUIRk3g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ywtx6uW0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ywtx6uW0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54585C4CEDD;
	Wed,  5 Feb 2025 14:41:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738766503;
	bh=OKSLxRZYrKlzFz+AAMcS3v+ZH4y5Mk9lBX7tRFniT+g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ywtx6uW0V0/b/9yyw3aNiPlt4KZddQShDbCA+BqvK1LoOHVp4SzQ76/uUvjaFTAvt
	 wqk9xrDDZ6t3reSKkAxIptVxh9vsCPO2u2H7e11j6uCq2THGFAlTpnJHMb1oJ0/ryE
	 M2Wqa6yAQGj11zqxz9ojOh/7jFLSV2CcVlXB85lE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Pei Xiao <xiaopei01@kylinos.cn>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 282/623] bpf: Use refcount_t instead of atomic_t for mmap_count
Date: Wed,  5 Feb 2025 14:40:24 +0100
Message-ID: <20250205134507.019607953@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134456.221272033@linuxfoundation.org>
References: <20250205134456.221272033@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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
index 945a5680f6a54..8caf56a308d96 100644
--- a/kernel/bpf/arena.c
+++ b/kernel/bpf/arena.c
@@ -218,7 +218,7 @@ static u64 arena_map_mem_usage(const struct bpf_map *map)
 struct vma_list {
 	struct vm_area_struct *vma;
 	struct list_head head;
-	atomic_t mmap_count;
+	refcount_t mmap_count;
 };
 
 static int remember_vma(struct bpf_arena *arena, struct vm_area_struct *vma)
@@ -228,7 +228,7 @@ static int remember_vma(struct bpf_arena *arena, struct vm_area_struct *vma)
 	vml = kmalloc(sizeof(*vml), GFP_KERNEL);
 	if (!vml)
 		return -ENOMEM;
-	atomic_set(&vml->mmap_count, 1);
+	refcount_set(&vml->mmap_count, 1);
 	vma->vm_private_data = vml;
 	vml->vma = vma;
 	list_add(&vml->head, &arena->vma_list);
@@ -239,7 +239,7 @@ static void arena_vm_open(struct vm_area_struct *vma)
 {
 	struct vma_list *vml = vma->vm_private_data;
 
-	atomic_inc(&vml->mmap_count);
+	refcount_inc(&vml->mmap_count);
 }
 
 static void arena_vm_close(struct vm_area_struct *vma)
@@ -248,7 +248,7 @@ static void arena_vm_close(struct vm_area_struct *vma)
 	struct bpf_arena *arena = container_of(map, struct bpf_arena, map);
 	struct vma_list *vml = vma->vm_private_data;
 
-	if (!atomic_dec_and_test(&vml->mmap_count))
+	if (!refcount_dec_and_test(&vml->mmap_count))
 		return;
 	guard(mutex)(&arena->lock);
 	/* update link list under lock */
-- 
2.39.5



