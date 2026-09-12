Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB45C2FD67D;
	Sat, 12 Sep 2026 14:36:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789223816; cv=none; b=M2+BHmW1Q/s3nkgJHUafzP2fhBFpL+cwIohZSer4aXDR0uIAxOtR93jppX5uutuBGJ8dxk9g9UdzZ33TbJWUoIKVOMBOoe/eVwio1IsX4UcPG3fCg9RHFgCDCsFoyzyfYvoMibs5HvZeNzCusDTfHTJl+LNHTtoRgW67/mwT2gA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789223816; c=relaxed/simple;
	bh=ilgRd1nMSjDFStKH9gbgxjSF/Bw5QL6XnWVtfCDv38Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EDZg4aQODE8fch+wgUBPXy/uFmJ5aF8VqNfJK0wlMMF4Z9pC9xWBnAPXnFXssbAIGBdSJ+mEcniW+HLNopzqEVAfh7vOpjgQEPCRKC5AC5xsqjT7lxvMYlbwwyS1fysVUm/HOIiwUHfjZbyzyjc61RSUHOCDQAXeCKCq/9izl2o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2rjuBI/8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2rjuBI/8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 743E91F000FF;
	Sat, 12 Sep 2026 14:36:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789223815;
	bh=nnwVLRiKFmlHQc54cC2IMmwYLgZ1Co3/MjTgfrIvVLc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2rjuBI/81KccVjM2MQlQju6B81E2W2lzXOIlfwnORgmhmRPZGim6xvPM68fyI9DFb
	 5lZgQ4sAsf8EDjkAgjjl2m136egxO3QqwgFoe37hppVBBLk6pwY6fYEQj4eWyijktp
	 BK1QmEdObU9msJZgJ5Pd+fZcVP6QwcV92iU2ZW2k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yousef Alhouseen <alhouseenyousef@gmail.com>,
	Selvin Xavier <selvin.xavier@broadcom.com>,
	Leon Romanovsky <leonro@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0859/1424] RDMA/bnxt_re: Clear VM_MAYWRITE on DBR/toggle page mmap
Date: Sat, 12 Sep 2026 08:54:51 +0200
Message-ID: <20260912065626.553346558@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Selvin Xavier <selvin.xavier@broadcom.com>

[ Upstream commit 9b66c9af7172ffcf727214fa0ebe9a5e1ed6eb16 ]

bnxt_re_mmap() rejects VM_WRITE for the DBR_PAGE and TOGGLE_PAGE mmap
flags, but a read-only mapping can still retain VM_MAYWRITE. nd later
be upgraded with mprotect(PROT_WRITE). This can bypass the write check
that only runs at mmap time.

Clear VM_MAYWRITE before vm_insert_page() in the shared DBR/toggle-page
branch, matching the existing policy that userspace writes are not
expected for these pages.

Fixes: ea222485788208 ("RDMA/bnxt_re: Update alloc_page uapi for pacing")
Suggested-by: Yousef Alhouseen <alhouseenyousef@gmail.com>
Signed-off-by: Selvin Xavier <selvin.xavier@broadcom.com>
Link: https://patch.msgid.link/20260721115440.24021-5-selvin.xavier@broadcom.com
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/bnxt_re/ib_verbs.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/bnxt_re/ib_verbs.c b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
index 8f7e9a5285d05..7d6c296da3b6e 100644
--- a/drivers/infiniband/hw/bnxt_re/ib_verbs.c
+++ b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
@@ -4268,11 +4268,13 @@ int bnxt_re_mmap(struct ib_ucontext *ib_uctx, struct vm_area_struct *vma)
 		break;
 	case BNXT_RE_MMAP_DBR_PAGE:
 		/* Driver doesn't expect write access for user space */
-		if (vma->vm_flags & VM_WRITE)
+		if (vma->vm_flags & VM_WRITE) {
 			ret = -EFAULT;
-		else
+		} else {
+			vm_flags_clear(vma, VM_MAYWRITE);
 			ret = vm_insert_page(vma, vma->vm_start,
 					     virt_to_page((void *)bnxt_entry->mem_offset));
+		}
 		break;
 	default:
 		ret = -EINVAL;
-- 
2.53.0



