Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C6801E1024;
	Sat, 12 Sep 2026 07:52:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789199567; cv=none; b=OJX7aAAXIBrvweqceCnbtK+ZM01nhF0okToj1aY8noQZWnQ/88PfFfw1OrX2Zknhl/2mmIAY8Zi8kBHXxPfPrCiiwkwfYzg7g8XhIQsbEZ5Mj1zUrQKByd3pFqc8VJ7WZt6Np9XfuvUhPYPZcY/Ny2GCT13FMc2rj8Y2UkZNbz4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789199567; c=relaxed/simple;
	bh=xwE0cZffgFH9SR/zNkmDWpJ5iId0mqQka8LMx8mkDvI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Mu6Tf2DTNljHNIydHloPCFB2o9F4MX4oH7d1f6GXFG44/0RUoy4+We8GQyISfecainSjZUzeCtoTyvuJeWWnyQwzz93XdGtX5SiQXKrTS15urutYELGgJtkdMGIqHdIYobga87Z+DQpAGtXAdck5VmF4VrEaY7Hb1dirjXMo7ys=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sMhcxYB2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sMhcxYB2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7AEE91F000FF;
	Sat, 12 Sep 2026 07:52:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789199566;
	bh=R8eCd+uB/gHd4pY5DjNow1PSVgSWjP8TVoxwA1mNqic=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sMhcxYB21ICJUV/HojDMEcXbfuePjBEd+DDRWj0SB72XmzlhS1loIVTFUhFcDgN+0
	 0605fsioiFt3QefnaoZC5YQQHCEwgnQgwoBJcHoEm4it8ghtEivrYIjL36j5GAaNii
	 C7tnYq9W5ZZXogxtd7kyTCbruDdPv8W1bEzq1SlU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yousef Alhouseen <alhouseenyousef@gmail.com>,
	Selvin Xavier <selvin.xavier@broadcom.com>,
	Leon Romanovsky <leonro@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0611/1815] RDMA/bnxt_re: Clear VM_MAYWRITE on DBR/toggle page mmap
Date: Sat, 12 Sep 2026 08:39:21 +0200
Message-ID: <20260912065703.225301416@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
index 9918ecac464c0..3890049e25822 100644
--- a/drivers/infiniband/hw/bnxt_re/ib_verbs.c
+++ b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
@@ -4986,11 +4986,13 @@ int bnxt_re_mmap(struct ib_ucontext *ib_uctx, struct vm_area_struct *vma)
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



