Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A04B1FCCE9;
	Wed,  5 Feb 2025 14:47:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738766834; cv=none; b=mChpvqxINaiI1en8qmR4jQ2BSilFQzPmtsI40Y8Swv1aeQ3QfH8AdUkt6o3vPZihb538ii//lNI01IzO/qrUziPRIT2CRI3HWxUpnXfsUeiWHhY35YEF4d95Yn/KvxJQivNqK9c7Gzxu8xJY+ZkWt+H0XAg1vXqa1znOw59BOi4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738766834; c=relaxed/simple;
	bh=bj9MdxXqE8O9OBujwZ0qNja43FhUc5m5oRaGP81uG2Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mrfc2IFeMbUDUJ+/afPSp2WX06ldtKtO2v721VZdIqxVKy+LQx2EfR2O3orzMhdVaCwNxz+E6kg4AyESuChvRdFLcmGRUOnBr4o3S17wHfnLMQqT8hxEXlmnMGz6vG1joHkISzN7r4n/fgaP0k08JPWZsfwrOEOMQuY0VOYEfCI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZouVz6t8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZouVz6t8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C21ABC4CED1;
	Wed,  5 Feb 2025 14:47:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738766834;
	bh=bj9MdxXqE8O9OBujwZ0qNja43FhUc5m5oRaGP81uG2Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZouVz6t8oGMTN4zUGpE6tr2kR4B5Y5CXYM0qA4elbh68+U9eQehVjphwKNL6JpcTP
	 CkXWAcfQUjpKJhyFY9amkWlXEWwp59BGaN9Hza+pnkiSTlhhszv0Z36rdeuAiknXQX
	 OGRFy4deybM/8Fm9RgzhTXIeWA9EY+Uqp7XE2dIQ=
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
Subject: [PATCH 6.12 367/590] RDMA/bnxt_re: Fix to drop reference to the mmap entry in case of error
Date: Wed,  5 Feb 2025 14:42:02 +0100
Message-ID: <20250205134509.312901760@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134455.220373560@linuxfoundation.org>
References: <20250205134455.220373560@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 14e434ff51ede..a7067c3c06797 100644
--- a/drivers/infiniband/hw/bnxt_re/ib_verbs.c
+++ b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
@@ -4395,9 +4395,10 @@ int bnxt_re_mmap(struct ib_ucontext *ib_uctx, struct vm_area_struct *vma)
 	case BNXT_RE_MMAP_TOGGLE_PAGE:
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



