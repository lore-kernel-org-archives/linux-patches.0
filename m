Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95C7812E1DA;
	Tue, 14 May 2024 11:38:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715686734; cv=none; b=PrB0n9Kl4BvMLm/RnSTlpBZ/SJs+Jr7xlfkiC9XrRwFTuCHq0h+rEda4etIGbVpXoSwWLgI8RQumbzaXlkgHcNykLYQkwcSN/ilPj1KFvqTkf3lhT39BD16q/ngulpt6ibuivRffJVPLwF3STFf9nIRRVGu4Clr9Ps96BLd1YbI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715686734; c=relaxed/simple;
	bh=AI6C4XACa46aMitUWRusQ7aVS15SmNokgEzUEBV21Uw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hPNO2dohMIk1dNxIAKT1vA/vCOn3V2d3B/5QL9K1z2yz18B4M5yqlDN5WKNIumYm2dT8baAXb20DZghTargV0qnFd2bzjUF9yea+xaZfn0ECq6wxZtNhc4quUBTVUdfm52ehOLmtwf6RPgvd2oBtylssGOSzijaDDhUkSUZpYUE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=w9Zn3Hte; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="w9Zn3Hte"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C6CAC2BD10;
	Tue, 14 May 2024 11:38:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715686734;
	bh=AI6C4XACa46aMitUWRusQ7aVS15SmNokgEzUEBV21Uw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=w9Zn3HteTVKQs7ni4pgvJh/EUZL+z+49qyO/CwikTEjmaDO7+891nBpxcZj2MaLak
	 OJfCkId6Fk2H+kZKwRbbYGE9yzFqUjvYZ8ORfaOgGH56J7YphGtlkabMFaA1Fp84Wn
	 cJ/DKfTl3b3oX6ZBGuMpEUwoCJxEkm3bAlM+zfMM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Kuehling <felix.kuehling@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.1 220/236] drm/amdkfd: dont allow mapping the MMIO HDP page with large pages
Date: Tue, 14 May 2024 12:19:42 +0200
Message-ID: <20240514101028.708058293@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101020.320785513@linuxfoundation.org>
References: <20240514101020.320785513@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdkfd/kfd_chardev.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/amd/amdkfd/kfd_chardev.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_chardev.c
@@ -1106,7 +1106,7 @@ static int kfd_ioctl_alloc_memory_of_gpu
 			goto err_unlock;
 		}
 		offset = dev->adev->rmmio_remap.bus_addr;
-		if (!offset) {
+		if (!offset || (PAGE_SIZE > 4096)) {
 			err = -ENOMEM;
 			goto err_unlock;
 		}
@@ -2215,7 +2215,7 @@ static int criu_restore_memory_of_gpu(st
 			return -EINVAL;
 		}
 		offset = pdd->dev->adev->rmmio_remap.bus_addr;
-		if (!offset) {
+		if (!offset || (PAGE_SIZE > 4096)) {
 			pr_err("amdgpu_amdkfd_get_mmio_remap_phys_addr failed\n");
 			return -ENOMEM;
 		}
@@ -2886,6 +2886,9 @@ static int kfd_mmio_mmap(struct kfd_dev
 	if (vma->vm_end - vma->vm_start != PAGE_SIZE)
 		return -EINVAL;
 
+	if (PAGE_SIZE > 4096)
+		return -EINVAL;
+
 	address = dev->adev->rmmio_remap.bus_addr;
 
 	vma->vm_flags |= VM_IO | VM_DONTCOPY | VM_DONTEXPAND | VM_NORESERVE |


