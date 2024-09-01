Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84C372B9C7;
	Sun,  1 Sep 2024 16:43:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725209027; cv=none; b=cT+8f4/kK34flSEyBj0YwLiYFcHCo2sClJtzIGRq+tpcu9HEbdtw5r0coX/Hu1YjlNVDzjDP82fhUwKgq5u0ENrvZXK9d80ooFeiA0G28Tk/KTmvFanyVRuY5XoRWN8RxjtLwirQUC9RVWFIR5LD/VBB2uz7deFCG2di3DjWALA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725209027; c=relaxed/simple;
	bh=fPKPuQ0VYzdJOc4SAQBLQ08GBwe6ni6JDlWpq5yOG9w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fEniBkhGmnU+tgvH0KpQqzxx6Sd83B/vCF4ri4sbq/y/O6zkMjGbbv+NWmmPiTNE4t//WmhsvzF5ySNxOg8il2lyVVShyrbMPG5CeXmTnysanHoEHGZrH3oBdXQneQ6ppRP1poDHtwi4+3ID1m3ry6ZbtCyeMbVPAjSUl5ATv+8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BfRrdrfm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BfRrdrfm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E119C4CEC3;
	Sun,  1 Sep 2024 16:43:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725209027;
	bh=fPKPuQ0VYzdJOc4SAQBLQ08GBwe6ni6JDlWpq5yOG9w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BfRrdrfmmPg9LB+XZ4Dwi3FnKuGKXDOIygZrKaqgb/kDLXDo+ESsyBqhkMvKv0ztm
	 ByuiXr1ka4bKzIiiDuYTziJuEq2mb83AD/pE9XiaRVKWD8SV1TxG5ORhhdXOJC9aZg
	 wf5drV5Uuho0NX1yzgcGxaL2auMDzbmeGMrnrqYI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Kuehling <felix.kuehling@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.4 111/134] drm/amdkfd: dont allow mapping the MMIO HDP page with large pages
Date: Sun,  1 Sep 2024 18:17:37 +0200
Message-ID: <20240901160814.261481646@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160809.752718937@linuxfoundation.org>
References: <20240901160809.752718937@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1278,7 +1278,7 @@ static int kfd_ioctl_alloc_memory_of_gpu
 		if (args->size != PAGE_SIZE)
 			return -EINVAL;
 		offset = amdgpu_amdkfd_get_mmio_remap_phys_addr(dev->kgd);
-		if (!offset)
+		if (!offset || (PAGE_SIZE > 4096))
 			return -ENOMEM;
 	}
 
@@ -1872,6 +1872,9 @@ static int kfd_mmio_mmap(struct kfd_dev
 	if (vma->vm_end - vma->vm_start != PAGE_SIZE)
 		return -EINVAL;
 
+	if (PAGE_SIZE > 4096)
+		return -EINVAL;
+
 	address = amdgpu_amdkfd_get_mmio_remap_phys_addr(dev->kgd);
 
 	vma->vm_flags |= VM_IO | VM_DONTCOPY | VM_DONTEXPAND | VM_NORESERVE |


