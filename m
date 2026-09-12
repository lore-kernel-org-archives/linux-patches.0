Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 306F53BE643;
	Sat, 12 Sep 2026 12:26:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789216021; cv=none; b=EjUniE4glIryHDk7wJc4v++HntlHDMzWtxvaHdmZeInBJwFx4zG1Mo0Lcjhm0yWuUkGNy8K/JFGhAl4bthpbgU6TWTdhFcs4QLhYh1Mt11fCOrn0qNzckgbJMQhVHBlJIIsFklRXQ0b2K8OF10Ay+N4ilvBvSVMk8TQvIgk7vjo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789216021; c=relaxed/simple;
	bh=VkT0GW2w9DqfT7IwBtUPaGEkqjkS+lKlhBvFbnyoCdg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S8Zksc4I25V8Kyo6Fj8xnmGl9/LcdIx7kX/XLOGcQycnYUIn76/mFvA5HYJq3RM6HEEXy8urJziiT1K/71etBDy97ohA/q3ztqvOzyY4lKKpaF0RzACCuw/tHXd876x699bX7jZWvZd1/PO2tOxDGVxRvRfPsr7YuFStA6j47hA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NNKkb+4N; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NNKkb+4N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDFF01F000FF;
	Sat, 12 Sep 2026 12:26:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789216018;
	bh=0Bdz6ksPtoTy2pX08C3IGpMiyFWeUWqgHhmajW9ojJ8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NNKkb+4N6gG36ckVzc5YqMl9jOap+233yhYCbtBVjrXJ6G9ddk+fQ+74SG6+CHar9
	 QAotLPPF9o9TtWN7qdu2TMQQu5Gxt0K95sy6zKyOqddMX+KMNrz65fsm22u4aPxaFT
	 NbQ4b9rbqjXeP052KCzAbLchscuXpcDPdDAQO/+Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yousef Alhouseen <alhouseenyousef@gmail.com>,
	Selvin Xavier <selvin.xavier@broadcom.com>,
	Leon Romanovsky <leonro@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0649/1376] RDMA/bnxt_re: Clear VM_MAYWRITE on DBR/toggle page mmap
Date: Sat, 12 Sep 2026 08:51:15 +0200
Message-ID: <20260912065622.008727513@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 7ad5d88358b03..467bdfea6c92c 100644
--- a/drivers/infiniband/hw/bnxt_re/ib_verbs.c
+++ b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
@@ -4389,11 +4389,13 @@ int bnxt_re_mmap(struct ib_ucontext *ib_uctx, struct vm_area_struct *vma)
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



