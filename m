Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E2DF356A0D;
	Sat, 12 Sep 2026 10:14:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789208063; cv=none; b=aboNV+aL0K7gcdBLkd1qZK86T7RqL3aD/kaauc54nzU2XWVSRQuqGJ9AaAaNVUndrfucCrzsAeOOjY2Wvn8Yj/2Z9nDmetEezfFyk4P6g6MI1wLdkMZC7ERb3YohDiOWIS3D7Z4CgDlJl6S1pzOGs0+WxEsooB9Gqv5pUL/a1WQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789208063; c=relaxed/simple;
	bh=riF4Xk48w4v5oFbg2iYS2ucR0r9hEquO6RvHMMCWPZ0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iRnQ0W55PrkQLVayI8ijSQgYsDlrC736QQFZMg4DiRdLunCFCBZkohwIsaYvXft7+HIaRyM/sk7411GJVtbKwdi4XTE8t59uyC7SwQnvhIDhbASZeYB+x77zaKjAm5JkQRVZKj6Z3yd42rMqV2YyZ9bcOjLnti91fqiyXKWy4ho=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tAehU7ZP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tAehU7ZP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 730A51F000FF;
	Sat, 12 Sep 2026 10:14:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789208062;
	bh=9JVv3/u1U/IRu8XXkPsNP2bj2rQ1I99ImtPbFxtVFj0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tAehU7ZPtGQxCHlngFacyFscGzNLzY4kQ4mlWG0QLF21vjZbqKRBSBm+fxVrLXl25
	 YHa5c/2aqFnYFtnBUre8h5RAck2t/VBHDNx9HFpQXTE7XbREzyAV9hWCnGlnZMZUdy
	 c6SDu5PbULggLhBe/RRzputQQxeI10MYs/mn5dx0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yousef Alhouseen <alhouseenyousef@gmail.com>,
	Selvin Xavier <selvin.xavier@broadcom.com>,
	Leon Romanovsky <leonro@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0540/1518] RDMA/bnxt_re: Clear VM_MAYWRITE on DBR/toggle page mmap
Date: Sat, 12 Sep 2026 08:45:09 +0200
Message-ID: <20260912065635.660014132@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 25d88c2c5735f..64b6e572e7047 100644
--- a/drivers/infiniband/hw/bnxt_re/ib_verbs.c
+++ b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
@@ -4570,11 +4570,13 @@ int bnxt_re_mmap(struct ib_ucontext *ib_uctx, struct vm_area_struct *vma)
 	case BNXT_RE_MMAP_DBR_PAGE:
 	case BNXT_RE_MMAP_TOGGLE_PAGE:
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



