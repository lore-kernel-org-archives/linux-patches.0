Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9002178381;
	Tue,  2 Jul 2024 17:06:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719940006; cv=none; b=B5iBv6psQa0T27gYGyt5NNZvctcDAbB0ByrwEV5GXN5hf8eMpFmGmTssfReZWDCks9B8yLhsjDwePBtBleEA5SFJ2tPsnmBJC3OclVo4PY13o+0BLcGLNaAfny5qnY5sBBHlOQAjR8P6WqnNj82J95LzEaidqhJ7lo+jZ5l4chU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719940006; c=relaxed/simple;
	bh=Si9yyLwBsdAXec9KugBTRojaOVcIcjLEm3DvYH4tmNo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e5Ry1V42BuQETunEc3dVTrlentCKwLOqQ417Ye/1kB6jKRtrq4yIW1mFv+u1oqOb2a7M0t21nfQXQnuUHRfTm8KXpDYc1/IgDeRQD0TIy91dRh6mqJ5o5jmhcgcxkk3xvnXKkELNVfsmPdsjRUkQn98DlbDFnpTZHlK37jOcBVc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fag/sY88; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fag/sY88"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34625C116B1;
	Tue,  2 Jul 2024 17:06:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719940006;
	bh=Si9yyLwBsdAXec9KugBTRojaOVcIcjLEm3DvYH4tmNo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fag/sY883rcEYFcDnhYuI9kFNAU48dQoiO1DV8Vlyv78SvedMQaJOpsAZHw/gCyiq
	 KBTCesZRaqysSXkXd9kA+qYZ0KpWP1nuUsnZOEArkz0I3LlaeKoaHA6cnkePUiduKM
	 lh3GL2e89T0JlMcqt5GXccKlOVYYjowpuopEFvdI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengfei Xu <pengfei.xu@intel.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Barret Rhoden <brho@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 025/222] bpf: Fix remap of arena.
Date: Tue,  2 Jul 2024 19:01:03 +0200
Message-ID: <20240702170244.940325506@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240702170243.963426416@linuxfoundation.org>
References: <20240702170243.963426416@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexei Starovoitov <ast@kernel.org>

[ Upstream commit b90d77e5fd784ada62ddd714d15ee2400c28e1cf ]

The bpf arena logic didn't account for mremap operation. Add a refcnt for
multiple mmap events to prevent use-after-free in arena_vm_close.

Fixes: 317460317a02 ("bpf: Introduce bpf_arena.")
Reported-by: Pengfei Xu <pengfei.xu@intel.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Reviewed-by: Barret Rhoden <brho@google.com>
Tested-by: Pengfei Xu <pengfei.xu@intel.com>
Closes: https://lore.kernel.org/bpf/Zmuw29IhgyPNKnIM@xpf.sh.intel.com
Link: https://lore.kernel.org/bpf/20240617171812.76634-1-alexei.starovoitov@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/arena.c | 16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff --git a/kernel/bpf/arena.c b/kernel/bpf/arena.c
index 343c3456c8ddf..a59ae9c582253 100644
--- a/kernel/bpf/arena.c
+++ b/kernel/bpf/arena.c
@@ -212,6 +212,7 @@ static u64 arena_map_mem_usage(const struct bpf_map *map)
 struct vma_list {
 	struct vm_area_struct *vma;
 	struct list_head head;
+	atomic_t mmap_count;
 };
 
 static int remember_vma(struct bpf_arena *arena, struct vm_area_struct *vma)
@@ -221,20 +222,30 @@ static int remember_vma(struct bpf_arena *arena, struct vm_area_struct *vma)
 	vml = kmalloc(sizeof(*vml), GFP_KERNEL);
 	if (!vml)
 		return -ENOMEM;
+	atomic_set(&vml->mmap_count, 1);
 	vma->vm_private_data = vml;
 	vml->vma = vma;
 	list_add(&vml->head, &arena->vma_list);
 	return 0;
 }
 
+static void arena_vm_open(struct vm_area_struct *vma)
+{
+	struct vma_list *vml = vma->vm_private_data;
+
+	atomic_inc(&vml->mmap_count);
+}
+
 static void arena_vm_close(struct vm_area_struct *vma)
 {
 	struct bpf_map *map = vma->vm_file->private_data;
 	struct bpf_arena *arena = container_of(map, struct bpf_arena, map);
-	struct vma_list *vml;
+	struct vma_list *vml = vma->vm_private_data;
 
+	if (!atomic_dec_and_test(&vml->mmap_count))
+		return;
 	guard(mutex)(&arena->lock);
-	vml = vma->vm_private_data;
+	/* update link list under lock */
 	list_del(&vml->head);
 	vma->vm_private_data = NULL;
 	kfree(vml);
@@ -287,6 +298,7 @@ static vm_fault_t arena_vm_fault(struct vm_fault *vmf)
 }
 
 static const struct vm_operations_struct arena_vm_ops = {
+	.open		= arena_vm_open,
 	.close		= arena_vm_close,
 	.fault          = arena_vm_fault,
 };
-- 
2.43.0



