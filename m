Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98C9033F38A
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:52:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301143; cv=none; b=VLtyWfpF2IVESimmrIgURSzoZy6OL/UR6yEPSjQO9gIAVpLh3NkkuSZhs4znZqpGpbuZZB3umQknVC9aQamTqfQ3C0L9NBAMHheJ6ct6mxPd2Y/XLkj5BoUk/F+iBRio5JQP8qITBnjOPkWqhAdbRMbxZzQikA7ivMpuekJ2Ydg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301143; c=relaxed/simple;
	bh=r4lrx2nj3u2+CGFN1JGcpYkK+fPBSPbhx/8GeLZs6mg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UlXL9wDbOKvHJYXaxx8X5AdhIpXwuZ5K81faVjR620Z9mWc47rc2P8mGleJA0wdQM1+zJuH4OQOmS55U4IpnV/8nEyR/tWQE30AT3Gx/myP6zdaFGw0kyLScoJc1cAIKbAx3ZEYXHUUHcDIHgfwbRsOOI45Oec0wXpPmtcUQQYc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AloVxPfU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AloVxPfU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD128C19423;
	Sat, 28 Feb 2026 17:52:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301143;
	bh=r4lrx2nj3u2+CGFN1JGcpYkK+fPBSPbhx/8GeLZs6mg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AloVxPfUUCYCC6eAz1IEeUvC6/tgysT7MUSUxUOZtbE+7rL+9DObN6k2wB8pJKLlx
	 QSCEhXjyxGVcC5mVpteQt+pMEO5QrOn5fHQkq53DsPNp5kpqcNLDSreLgAyOVtnhbV
	 nvMdt/ppLGX3PajdWTUFRk/UQo844asMFghJDvYp8ILMYJ/jpfcIHet1pXOY7yoFGR
	 oDCxPnTe1DFHvapqB0QQ9+BneCyyBebah/KZIxuUoZNMMDZgLcrpZiCrUEBkiGq6RM
	 +pz/DNDlXnI+wVKYI7U7sxCkMzzoD0urG7pIjuxtZAYMgO3EKmCOJliofeWR1pbvjB
	 0Fo05KQQj3x1g==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Kommula Shiva Shankar <kshankar@marvell.com>,
	Jason Wang <jasowang@redhat.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 305/752] vhost: fix caching attributes of MMIO regions by setting them explicitly
Date: Sat, 28 Feb 2026 12:40:16 -0500
Message-ID: <20260228174750.1542406-305-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Kommula Shiva Shankar <kshankar@marvell.com>

[ Upstream commit 5145b277309f3818e2db507f525d19ac3b910922 ]

Explicitly set non-cached caching attributes for MMIO regions.
Default write-back mode can cause CPU to cache device memory,
causing invalid reads and unpredictable behavior.

Invalid read and write issues were observed on ARM64 when mapping the
notification area to userspace via mmap.

Signed-off-by: Kommula Shiva Shankar <kshankar@marvell.com>
Acked-by: Jason Wang <jasowang@redhat.com>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Message-Id: <20260102065703.656255-1-kshankar@marvell.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vhost/vdpa.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
index 05a481e4c385a..b0179e8567aba 100644
--- a/drivers/vhost/vdpa.c
+++ b/drivers/vhost/vdpa.c
@@ -1527,6 +1527,7 @@ static int vhost_vdpa_mmap(struct file *file, struct vm_area_struct *vma)
 	if (vma->vm_end - vma->vm_start != notify.size)
 		return -ENOTSUPP;
 
+	vma->vm_page_prot = pgprot_noncached(vma->vm_page_prot);
 	vm_flags_set(vma, VM_IO | VM_PFNMAP | VM_DONTEXPAND | VM_DONTDUMP);
 	vma->vm_ops = &vhost_vdpa_vm_ops;
 	return 0;
-- 
2.51.0

