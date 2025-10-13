Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE446309DB1;
	Mon, 13 Oct 2025 15:40:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760370058; cv=none; b=qNGGgOB7Nr+yqfh+tMirpW/gG9I+dBJ8RoV2c+e8nIl/zxqQMRpFl5ZwqUYJkN4HoAdYJFAKEAcx6CciWTT7jJQxLVvklSp5iKH7YkgKyxZwWv1ghdq0Cfe3qpsFr8axcmI3bi8wqFq3z4zFr0bVkdxVMvMUK1Wh0mbz8c4CT+o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760370058; c=relaxed/simple;
	bh=y+bVw2MLvxyZrYACkGesOScrlQtoo9QGmUMvyFmFoog=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s0Ontl77niUg0ah1xdswcp0IEh8EFmAXMKsfpSNBWFrymSEarSzHGcbW16F7LaHD1INl40pERCufHFqAdrDUjEBEV2T1/6D3eXpaQKvGUM1FPglPcoT+ExrZyxlWGmXJsvqhVn1oIACBkl81G8kXSBdLGhfNlNswXZEwz+18tfE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NHDXTfsb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NHDXTfsb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A1B4C4CEE7;
	Mon, 13 Oct 2025 15:40:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760370057;
	bh=y+bVw2MLvxyZrYACkGesOScrlQtoo9QGmUMvyFmFoog=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NHDXTfsblkVTzcHgL3xoMsMknkCJsymi0rf9cG95+s8b3EkFoQu6c4KktvYGYaxhm
	 8jsSb4tcXXuQIbZFR6S5CNYzoaJxH07ryr6xgg9eQ7k9MFL9yRpbZ0QSn237WjnhYn
	 eRaO5B+lPMWkI4P8BpTVD7CkaDL/JKGQ8FoVzHek=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alistair Popple <apopple@nvidia.com>,
	Dev Jain <dev.jain@arm.com>,
	David Hildenbrand <david@redhat.com>,
	Haiyue Wang <haiyuewa@163.com>,
	Nicolas Pitre <nico@fluxnic.net>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 464/563] cramfs: fix incorrect physical page address calculation
Date: Mon, 13 Oct 2025 16:45:25 +0200
Message-ID: <20251013144428.096306835@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144411.274874080@linuxfoundation.org>
References: <20251013144411.274874080@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alistair Popple <apopple@nvidia.com>

[ Upstream commit 20a8e0454d833d80d0c0cae304841a50a2a126bd ]

Commit 21aa65bf82a7 ("mm: remove callers of pfn_t functionality")
incorrectly replaced the pfn with the physical address when calling
vmf_insert_mixed().  Instead the phys_to_pfn_t() call should have been
replaced with PHYS_PFN().

Found by inspection after a similar issue was noted in fuse virtio_fs.

Link: https://lkml.kernel.org/r/20250923005333.3165032-1-apopple@nvidia.com
Fixes: 21aa65bf82a7 ("mm: remove callers of pfn_t functionality")
Signed-off-by: Alistair Popple <apopple@nvidia.com>
Reviewed-by: Dev Jain <dev.jain@arm.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Cc: Haiyue Wang <haiyuewa@163.com>
Cc: Nicolas Pitre <nico@fluxnic.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/cramfs/inode.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/cramfs/inode.c b/fs/cramfs/inode.c
index b002e9b734f99..56c8005b24a34 100644
--- a/fs/cramfs/inode.c
+++ b/fs/cramfs/inode.c
@@ -412,7 +412,7 @@ static int cramfs_physmem_mmap(struct file *file, struct vm_area_struct *vma)
 			vm_fault_t vmf;
 			unsigned long off = i * PAGE_SIZE;
 			vmf = vmf_insert_mixed(vma, vma->vm_start + off,
-					address + off);
+					PHYS_PFN(address + off));
 			if (vmf & VM_FAULT_ERROR)
 				ret = vm_fault_to_errno(vmf, 0);
 		}
-- 
2.51.0



