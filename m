Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54B77213138;
	Tue, 12 Nov 2024 10:44:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731408249; cv=none; b=e88uBbFc3rug2cQnj93O9V7EsOG7I0Q1xEiClqZZ3Kp87+bPhrtdBzBs+MINUeb53KlAsoWoDxQMiYLn0jBOQRep0xcmJJ1eBnQX7JR1PLUSWuEJ1R8KVcNe5bu4ynxxHdBOFvvyrwYd6bE7CdZe6XPFbGw374rT5mdW3mfrZUg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731408249; c=relaxed/simple;
	bh=nvJ80p1/qAx9dWT49vn7cHo+hAjv0Sl0S2YdBGk/Gz0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DtoyN3V6aYEk8+MQDU9JYKMg5vEgHC/iL5IgLGQw6JvU7marTrvQXPuzqQLA2uxSHeJu44sxAVAEGyLczapvwzpGGZfEZod+xcyArBQoj3NpFPzAqOMvD32F055hqsyWSHcKO1KJKEsrYRc4gE9GFSu5K517XSuq5MCh5SCoKUA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1f9v/4HO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1f9v/4HO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5629C4CECD;
	Tue, 12 Nov 2024 10:44:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731408249;
	bh=nvJ80p1/qAx9dWT49vn7cHo+hAjv0Sl0S2YdBGk/Gz0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1f9v/4HOlWSsMEng7fiskRNd5FtQu9tVtDTwBSRAH0xidZ/1bjVpmNh3mxuxbEtWY
	 pGSssRW4F1jzGXLbEP+1SJqULUMTNAHJl2Ff43aMaI4dPjNL2pVxygCu54DjnL44NB
	 aj5yatlYn54yvW549RqUyJyuwjPchNEyX9ULuu3w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jann Horn <jannh@google.com>,
	Boris Brezillon <boris.brezillon@collabora.com>,
	Liviu Dudau <liviu.dudau@arm.com>,
	Steven Price <steven.price@arm.com>
Subject: [PATCH 6.11 106/184] drm/panthor: Be stricter about IO mapping flags
Date: Tue, 12 Nov 2024 11:21:04 +0100
Message-ID: <20241112101904.937667532@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241112101900.865487674@linuxfoundation.org>
References: <20241112101900.865487674@linuxfoundation.org>
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

From: Jann Horn <jannh@google.com>

commit f432a1621f049bb207e78363d9d0e3c6fa2da5db upstream.

The current panthor_device_mmap_io() implementation has two issues:

1. For mapping DRM_PANTHOR_USER_FLUSH_ID_MMIO_OFFSET,
   panthor_device_mmap_io() bails if VM_WRITE is set, but does not clear
   VM_MAYWRITE. That means userspace can use mprotect() to make the mapping
   writable later on. This is a classic Linux driver gotcha.
   I don't think this actually has any impact in practice:
   When the GPU is powered, writes to the FLUSH_ID seem to be ignored; and
   when the GPU is not powered, the dummy_latest_flush page provided by the
   driver is deliberately designed to not do any flushes, so the only thing
   writing to the dummy_latest_flush could achieve would be to make *more*
   flushes happen.

2. panthor_device_mmap_io() does not block MAP_PRIVATE mappings (which are
   mappings without the VM_SHARED flag).
   MAP_PRIVATE in combination with VM_MAYWRITE indicates that the VMA has
   copy-on-write semantics, which for VM_PFNMAP are semi-supported but
   fairly cursed.
   In particular, in such a mapping, the driver can only install PTEs
   during mmap() by calling remap_pfn_range() (because remap_pfn_range()
   wants to **store the physical address of the mapped physical memory into
   the vm_pgoff of the VMA**); installing PTEs later on with a fault
   handler (as panthor does) is not supported in private mappings, and so
   if you try to fault in such a mapping, vmf_insert_pfn_prot() splats when
   it hits a BUG() check.

Fix it by clearing the VM_MAYWRITE flag (userspace writing to the FLUSH_ID
doesn't make sense) and requiring VM_SHARED (copy-on-write semantics for
the FLUSH_ID don't make sense).

Reproducers for both scenarios are in the notes of my patch on the mailing
list; I tested that these bugs exist on a Rock 5B machine.

Note that I only compile-tested the patch, I haven't tested it; I don't
have a working kernel build setup for the test machine yet. Please test it
before applying it.

Cc: stable@vger.kernel.org
Fixes: 5fe909cae118 ("drm/panthor: Add the device logical block")
Signed-off-by: Jann Horn <jannh@google.com>
Reviewed-by: Boris Brezillon <boris.brezillon@collabora.com>
Reviewed-by: Liviu Dudau <liviu.dudau@arm.com>
Reviewed-by: Steven Price <steven.price@arm.com>
Signed-off-by: Steven Price <steven.price@arm.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20241105-panthor-flush-page-fixes-v1-1-829aaf37db93@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/panthor/panthor_device.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/gpu/drm/panthor/panthor_device.c b/drivers/gpu/drm/panthor/panthor_device.c
index 4082c8f2951d..6fbff516c1c1 100644
--- a/drivers/gpu/drm/panthor/panthor_device.c
+++ b/drivers/gpu/drm/panthor/panthor_device.c
@@ -390,11 +390,15 @@ int panthor_device_mmap_io(struct panthor_device *ptdev, struct vm_area_struct *
 {
 	u64 offset = (u64)vma->vm_pgoff << PAGE_SHIFT;
 
+	if ((vma->vm_flags & VM_SHARED) == 0)
+		return -EINVAL;
+
 	switch (offset) {
 	case DRM_PANTHOR_USER_FLUSH_ID_MMIO_OFFSET:
 		if (vma->vm_end - vma->vm_start != PAGE_SIZE ||
 		    (vma->vm_flags & (VM_WRITE | VM_EXEC)))
 			return -EINVAL;
+		vm_flags_clear(vma, VM_MAYWRITE);
 
 		break;
 
-- 
2.47.0



