Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 910D3198E7B;
	Wed,  5 Feb 2025 14:56:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738767397; cv=none; b=p/J5YOszXGKR2Ocf6NDC+ZZVrIO7TUq2u6Yg8MrkR5a+dZmCQh6eumlv/Q/morFSvT1ED2mi3/QCV0+TUqamffTqLguP5Ox1Y6zhlPYCiSJd4Fhs8eoCz52IsN26oYXCSlQHtVle8cdPb6CpqeebVDx2RsMXB8v+93C2FwVduYU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738767397; c=relaxed/simple;
	bh=v5VzlRnki/aqmq6u+dqrJeoX4f5mI0KiIsp/ouHS31c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n6j/Od5LkNmDGNXaI7ylyMr/NYS19OPyofjoMFbzsOUUF+qlcJnPI0QWxgPcwvLhL5LmyBT0giK42gmHWOoNJdlGuSL4QPCN3Zl4HEMWRK08VVPHF/4g5sDD3WkMDYN8A0tklv8Cy0/nPR0+SSjAFVIEXFP6TqLHVfRasQqhEMM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=R9+ybnAC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="R9+ybnAC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00247C4CED1;
	Wed,  5 Feb 2025 14:56:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738767397;
	bh=v5VzlRnki/aqmq6u+dqrJeoX4f5mI0KiIsp/ouHS31c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=R9+ybnACR5fYAedVEqjozqoFT7DCj8/rZEq5SB3gNtF9+Pz3PqMkwHZFgadWuAIbP
	 Yf3kFD9LyhlVWVH31P6lqOIWXuLEjIZjNU4OiUxTf+oUEak9IdZMFz+QxW29pXh3jQ
	 UgaHiR9tEusLnmL03XWG9gUBee8TGSzhoPsw9XTo=
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
Subject: [PATCH 6.13 399/623] RDMA/bnxt_re: Fix to drop reference to the mmap entry in case of error
Date: Wed,  5 Feb 2025 14:42:21 +0100
Message-ID: <20250205134511.485720218@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134456.221272033@linuxfoundation.org>
References: <20250205134456.221272033@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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
index e3d26bd6de05a..1ff2e176b0369 100644
--- a/drivers/infiniband/hw/bnxt_re/ib_verbs.c
+++ b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
@@ -4467,9 +4467,10 @@ int bnxt_re_mmap(struct ib_ucontext *ib_uctx, struct vm_area_struct *vma)
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



