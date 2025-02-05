Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F33E8155CBD;
	Wed,  5 Feb 2025 14:22:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738765330; cv=none; b=b/lXjYrAE47dOCIDptVtlGNuDpn+JjlzdWJVQx9tJ/QsSTeXE/cah1nAQhHf7OxMQZ2Lci9Cy80VuiKJoYI1bcO0bZ8O+EyXMmivJtUbdjkFMnOA+6B6mp55TS2V7l4q39nHhGpNykWFEpG0ZHM7c+InOU1PSUq9H9ORUSFL4QU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738765330; c=relaxed/simple;
	bh=ulqMjpW1uus8raRmV/cH61PHd7HhSOtb220PFR0tjg4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pf2RRvvdwG0FQOl5wb+6wsL3de7/NXNJgSxHMPoOit+pC0Kpc8r4v6B1Nbh1NcmyOw3wIpSVWyvylW3oE/AornbPFzhq2/AOMMKsx0DrSgJ0b79OoJMX2L6GKtw83KJBEnZP/KSGg54CW5Jqv9OctUKokdEWua3NPWXgLBBQHrI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MsiLgVQ1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MsiLgVQ1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 636B6C4CED1;
	Wed,  5 Feb 2025 14:22:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738765329;
	bh=ulqMjpW1uus8raRmV/cH61PHd7HhSOtb220PFR0tjg4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MsiLgVQ1J+/D4MHHpEzzarg9y2cqcnGzJIdTUGvR9uuRip9BEmRyBX9tcl2PfIyJy
	 L3Bo7+m0z/f1pA62bPjLc/MnkdGZVOp1KMdsShT3+6pI2nyFG+YQUCR4xdkOzyK3cO
	 CKVWs5Zr8cIOCu4r7W8kLGINwI/PT+sRYk3DfQgA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Saravanan Vajravel <saravanan.vajravel@broadcom.com>,
	Kashyap Desai <kashyap.desai@broadcom.com>,
	Kalesh AP <kalesh-anakkur.purayil@broadcom.com>,
	Selvin Xavier <selvin.xavier@broadcom.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 254/393] RDMA/bnxt_re: Fix to drop reference to the mmap entry in case of error
Date: Wed,  5 Feb 2025 14:42:53 +0100
Message-ID: <20250205134430.026275858@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134420.279368572@linuxfoundation.org>
References: <20250205134420.279368572@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Kalesh AP <kalesh-anakkur.purayil@broadcom.com>

[ Upstream commit c84f0f4f49d81645f49c3269fdcc3b84ce61e795 ]

In the error handling path of bnxt_re_mmap(), driver should invoke
rdma_user_mmap_entry_put() to free the reference of mmap entry in case
the error happens after rdma_user_mmap_entry_get was called.

Fixes: ea2224857882 ("RDMA/bnxt_re: Update alloc_page uapi for pacing")
Reviewed-by: Saravanan Vajravel <saravanan.vajravel@broadcom.com>
Reviewed-by: Kashyap Desai <kashyap.desai@broadcom.com>
Signed-off-by: Kalesh AP <kalesh-anakkur.purayil@broadcom.com>
Signed-off-by: Selvin Xavier <selvin.xavier@broadcom.com>
Link: https://patch.msgid.link/20250104061519.2540178-1-kalesh-anakkur.purayil@broadcom.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/bnxt_re/ib_verbs.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/hw/bnxt_re/ib_verbs.c b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
index 08da793969ee5..f7345e4890a14 100644
--- a/drivers/infiniband/hw/bnxt_re/ib_verbs.c
+++ b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
@@ -4278,9 +4278,10 @@ int bnxt_re_mmap(struct ib_ucontext *ib_uctx, struct vm_area_struct *vma)
 	case BNXT_RE_MMAP_DBR_PAGE:
 		/* Driver doesn't expect write access for user space */
 		if (vma->vm_flags & VM_WRITE)
-			return -EFAULT;
-		ret = vm_insert_page(vma, vma->vm_start,
-				     virt_to_page((void *)bnxt_entry->mem_offset));
+			ret = -EFAULT;
+		else
+			ret = vm_insert_page(vma, vma->vm_start,
+					     virt_to_page((void *)bnxt_entry->mem_offset));
 		break;
 	default:
 		ret = -EINVAL;
-- 
2.39.5



