Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D6C7208A7;
	Sun,  1 Sep 2024 16:57:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725209833; cv=none; b=CrvVlbG2yvQGI5s5UJarNbaNlxFxMGEcrhiLnzcwQqKNo5TRFf2j2O52Ks9QTJsr6kf7Wj71BcpRQAkZ8mZ+AbFSWoXkKZHcZjXmtKNXWReFfNMVQETFKQC1lOo3kEaiYEaJ+aXpgpypy+SkMBTbHHzQG+lHZ/mL9bVVZhe5S0Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725209833; c=relaxed/simple;
	bh=RLKmvVjs2w6wNKOZvyWENsUt4CvhUO4NOucUZUulo9s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IiCOWQfMB/p21qvKgtkfYa/jvFJA2eUFU5ZvrMzBKZTQvM+b2h4T5es+XCUMK/7MlDdsFKatrAaiE249LFxjfpafX7SBhQzBAhIum+54ux0BaDDjYvV1a0qS6wHqZI3I6dI4CRz09zt+ZG214CtBgsMbYUhaQlOhDnReQfRllHY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VpKvuoKM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VpKvuoKM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E02A1C4CEC3;
	Sun,  1 Sep 2024 16:57:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725209833;
	bh=RLKmvVjs2w6wNKOZvyWENsUt4CvhUO4NOucUZUulo9s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VpKvuoKMafkFtt8PNvdxPrTplStOECKe2qBZbuycVjsslspYitNbiidWln3fWaO8j
	 Dk/3FJe35xTnfZtzOb/VF2Tp0e14Kfb9Sli67B6qXeOGWm5JbQhww9O7A1LDJqpuvy
	 aI08xKHDvE9ruf73Yy0OCuL/vvR3hUbkCZ96WLBE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Kuehling <felix.kuehling@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.10 128/151] drm/amdkfd: dont allow mapping the MMIO HDP page with large pages
Date: Sun,  1 Sep 2024 18:18:08 +0200
Message-ID: <20240901160818.923608914@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160814.090297276@linuxfoundation.org>
References: <20240901160814.090297276@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1311,7 +1311,7 @@ static int kfd_ioctl_alloc_memory_of_gpu
 			goto err_unlock;
 		}
 		offset = amdgpu_amdkfd_get_mmio_remap_phys_addr(dev->kgd);
-		if (!offset) {
+		if (!offset || (PAGE_SIZE > 4096)) {
 			err = -ENOMEM;
 			goto err_unlock;
 		}
@@ -1969,6 +1969,9 @@ static int kfd_mmio_mmap(struct kfd_dev
 	if (vma->vm_end - vma->vm_start != PAGE_SIZE)
 		return -EINVAL;
 
+	if (PAGE_SIZE > 4096)
+		return -EINVAL;
+
 	address = amdgpu_amdkfd_get_mmio_remap_phys_addr(dev->kgd);
 
 	vma->vm_flags |= VM_IO | VM_DONTCOPY | VM_DONTEXPAND | VM_NORESERVE |


