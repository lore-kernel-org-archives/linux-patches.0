Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6706370D71;
	Tue, 12 May 2026 18:15:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778609702; cv=none; b=WWY8K+/EysWhkS5dYdST69fkahL0jDif5GDwDKiiOOrofqfcN7SYQmItDkIMoQw/5G9c2UrSbY1das/0dnwg9M/sh04GGqVgQECD/rYtEnzVjvB6brS/2Rt3t9jjE8xdz3qjUpdl80uMWZkrGPr1DmqyLpfBEa58St0BHHQw2a8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778609702; c=relaxed/simple;
	bh=Sn2CAaVgyxvez5ZB7Eygr/iZVdQYKZ0tNcCi+HlbLJ4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XyI3e4cYCgjqMOm63BHh9I0sguXHeV98aIEc5HZVmloRbeW7INrkY3M2zC0mqojJTtq9uJRrHzba0KFK9UZECNGJutlp0SVjzx4XYL9LEXhM9g3lpjVRu9tVOv0EddSS94QADWm1LHQJSLPIxsjPfUSmRLS+iqKppO3e7JWjc6I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qIulWqyP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qIulWqyP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A0B8C2BCC7;
	Tue, 12 May 2026 18:15:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778609702;
	bh=Sn2CAaVgyxvez5ZB7Eygr/iZVdQYKZ0tNcCi+HlbLJ4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qIulWqyPJoOaePjnA6DKNq9qhrNlvjnzieF9JPVUO/cf1K0xpK2BcVFFAZ2H1nmxq
	 8WNAzLiiumIuACrrfKtv1zb+xIZDXUCulVcuEzYvCZOFXos5+leTr7/EN8iegT7q6R
	 BYaiY81MJFpQBXW1c8D2F50/kEmlNHGVEnToLW5Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Weiming Shi <bestswngs@gmail.com>,
	Xiang Mei <xmei5@asu.edu>,
	Emil Tsalapatis <emil@etsalapatis.com>,
	Alexei Starovoitov <ast@kernel.org>
Subject: [PATCH 7.0 291/307] bpf: Fix use-after-free in arena_vm_close on fork
Date: Tue, 12 May 2026 19:41:26 +0200
Message-ID: <20260512173946.267600923@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260512173940.117428952@linuxfoundation.org>
References: <20260512173940.117428952@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexei Starovoitov <ast@kernel.org>

commit 4fddde2a732de60bb97e3307d4eb69ac5f1d2b74 upstream.

arena_vm_open() only bumps vml->mmap_count but never registers the
child VMA in arena->vma_list. The vml->vma always points at the
parent VMA, so after parent munmap the pointer dangles. If the child
then calls bpf_arena_free_pages(), zap_pages() reads the stale
vml->vma triggering use-after-free.

Fix this by preventing the arena VMA from being inherited across
fork with VM_DONTCOPY, and preventing VMA splits via the may_split
callback.

Also reject mremap with a .mremap callback returning -EINVAL. A
same-size mremap(MREMAP_FIXED) on the full arena VMA reaches
copy_vma() through the following path:

  check_prep_vma()       - returns 0 early: new_len == old_len
                           skips VM_DONTEXPAND check
  prep_move_vma()        - vm_start == old_addr and
                           vm_end == old_addr + old_len
                           so may_split is never called
  move_vma()
    copy_vma_and_data()
      copy_vma()
        vm_area_dup()    - copies vm_private_data (vml pointer)
        vm_ops->open()   - bumps vml->mmap_count
      vm_ops->mremap()   - returns -EINVAL, rollback unmaps new VMA

The refcount ensures the rollback's arena_vm_close does not free
the vml shared with the original VMA.

Reported-by: Weiming Shi <bestswngs@gmail.com>
Reported-by: Xiang Mei <xmei5@asu.edu>
Fixes: 317460317a02 ("bpf: Introduce bpf_arena.")
Reviewed-by: Emil Tsalapatis <emil@etsalapatis.com>
Link: https://lore.kernel.org/r/20260413194245.21449-1-alexei.starovoitov@gmail.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/bpf/arena.c |   19 ++++++++++++++++---
 1 file changed, 16 insertions(+), 3 deletions(-)

--- a/kernel/bpf/arena.c
+++ b/kernel/bpf/arena.c
@@ -341,6 +341,16 @@ static void arena_vm_open(struct vm_area
 	refcount_inc(&vml->mmap_count);
 }
 
+static int arena_vm_may_split(struct vm_area_struct *vma, unsigned long addr)
+{
+	return -EINVAL;
+}
+
+static int arena_vm_mremap(struct vm_area_struct *vma)
+{
+	return -EINVAL;
+}
+
 static void arena_vm_close(struct vm_area_struct *vma)
 {
 	struct bpf_map *map = vma->vm_file->private_data;
@@ -417,6 +427,8 @@ out_unlock_sigsegv:
 
 static const struct vm_operations_struct arena_vm_ops = {
 	.open		= arena_vm_open,
+	.may_split	= arena_vm_may_split,
+	.mremap		= arena_vm_mremap,
 	.close		= arena_vm_close,
 	.fault          = arena_vm_fault,
 };
@@ -486,10 +498,11 @@ static int arena_map_mmap(struct bpf_map
 	arena->user_vm_end = vma->vm_end;
 	/*
 	 * bpf_map_mmap() checks that it's being mmaped as VM_SHARED and
-	 * clears VM_MAYEXEC. Set VM_DONTEXPAND as well to avoid
-	 * potential change of user_vm_start.
+	 * clears VM_MAYEXEC. Set VM_DONTEXPAND to avoid potential change
+	 * of user_vm_start. Set VM_DONTCOPY to prevent arena VMA from
+	 * being copied into the child process on fork.
 	 */
-	vm_flags_set(vma, VM_DONTEXPAND);
+	vm_flags_set(vma, VM_DONTEXPAND | VM_DONTCOPY);
 	vma->vm_ops = &arena_vm_ops;
 	return 0;
 }


