Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 436A526AC1;
	Sun,  1 Sep 2024 17:06:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725210414; cv=none; b=YWo3AoDD1FshQO5JzBxkYHOBFHlOifndBUWjVXSTwCAiITw3L1jHtEx0J9YetN5EYLm0B0ntkVqBU/GmvxUfAjcEQwTnPWpz6j6h9BsgK414eCQNzJg/NhrzIJj/l3kwgtiFTfZTDoTidHPkwtmlXpSs/kKQDBPX0aaZeXE3MsY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725210414; c=relaxed/simple;
	bh=36SH7qnbjBick///m4Z9H9kvin7X+F8zKNnjGKOCLs8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q1CXV80mG9DlLwOgzo8OyqyFq7FRNrl8Wwe4fkOW8iFnl+Jml1BoQrwpJIIuR1ETmXaeUkBsvfAv+oy3WkjMYaJ4LlW4nCAW9ZhnC7Ngz4rxZbQa3AxJfQCZgxPXPTM5n/wug4k8U0c9Ew7XcNE0IrkmlS79dFnlZXiDrvHYDXg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sjv9HWKw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sjv9HWKw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE10CC4CEC3;
	Sun,  1 Sep 2024 17:06:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725210414;
	bh=36SH7qnbjBick///m4Z9H9kvin7X+F8zKNnjGKOCLs8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sjv9HWKwTP98pR4K/MyCSOUXijT0hyEmvc6r3q2riEKJvXfqYK+TSFsMjsp9ohBOF
	 c9S/TbELusmx/DD6gyRHvVfzI8ebz4+ypKT/8fTOB5vvpY6vwSLATlTcgG+zf7u5Nu
	 3wqctQwVfik5DzFygZ3ONt+5XXyCP8PcvjeEEH4g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Kuehling <felix.kuehling@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.15 183/215] drm/amdkfd: dont allow mapping the MMIO HDP page with large pages
Date: Sun,  1 Sep 2024 18:18:15 +0200
Message-ID: <20240901160830.276988875@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160823.230213148@linuxfoundation.org>
References: <20240901160823.230213148@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit be4a2a81b6b90d1a47eaeaace4cc8e2cb57b96c7 upstream.

We don't get the right offset in that case.  The GPU has
an unused 4K area of the register BAR space into which you can
remap registers.  We remap the HDP flush registers into this
space to allow userspace (CPU or GPU) to flush the HDP when it
updates VRAM.  However, on systems with >4K pages, we end up
exposing PAGE_SIZE of MMIO space.

Fixes: d8e408a82704 ("drm/amdkfd: Expose HDP registers to user space")
Reviewed-by: Felix Kuehling <felix.kuehling@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Felix Kuehling <felix.kuehling@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdkfd/kfd_chardev.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/amdkfd/kfd_chardev.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_chardev.c
@@ -1290,7 +1290,7 @@ static int kfd_ioctl_alloc_memory_of_gpu
 			goto err_unlock;
 		}
 		offset = amdgpu_amdkfd_get_mmio_remap_phys_addr(dev->kgd);
-		if (!offset) {
+		if (!offset || (PAGE_SIZE > 4096)) {
 			err = -ENOMEM;
 			goto err_unlock;
 		}
@@ -2029,6 +2029,9 @@ static int kfd_mmio_mmap(struct kfd_dev
 	if (vma->vm_end - vma->vm_start != PAGE_SIZE)
 		return -EINVAL;
 
+	if (PAGE_SIZE > 4096)
+		return -EINVAL;
+
 	address = amdgpu_amdkfd_get_mmio_remap_phys_addr(dev->kgd);
 
 	vma->vm_flags |= VM_IO | VM_DONTCOPY | VM_DONTEXPAND | VM_NORESERVE |


