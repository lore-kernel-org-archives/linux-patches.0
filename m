Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60E211DDC35;
	Tue,  8 Oct 2024 13:02:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728392527; cv=none; b=e6p7N1uTnsmn3GrEaDjjbmCjz1r25WVPHnGQL0IdqR7FJIAf6/1GQ9nTKxUW+b3tVAhJQRvYBFnN17Px54nSAkr4TfUBXlBudWZX/C/TPO0MIjPjXrifOVHo2rRr7M4eQVQnnQCs5uT+p82BZQhUnB9NtMM0E9xOVZ2EvofKBts=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728392527; c=relaxed/simple;
	bh=5s3Q29K6AHPcxmakH2OrZwNdg8a8FudDWZ1/VdyDFQU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TKduEzVsuRYmizthvCCiVQRUSNqv6JnrYaAH2//JbQDKxL3qsRQufci41ssxx9/ROVUo6+7AjATBm+KcAAJw3ZWtTtFg0CsQZEhgglYVw5aq5fSR7WuNUQwndGbNICPGT78+FwSpmq0+WKAjwM0+WYjcLCR6DPt78qR87OPrmYo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eIU7sM9v; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eIU7sM9v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9684C4CEC7;
	Tue,  8 Oct 2024 13:02:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728392527;
	bh=5s3Q29K6AHPcxmakH2OrZwNdg8a8FudDWZ1/VdyDFQU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eIU7sM9vnHz5fTMF5ijb7qlQAdq+4oW6GcfmPIJb2bDvJRHYD6hYL+SHBn1fwSy/V
	 XWlUuBeh90h8baPryFqInjfJhgr1WywA0IBaWcbPM1DwM4c0gUZq9khpdDN4iJaibt
	 kr62DDTNmNQuBwYzPQt/jO/vGYQo+N24SSxFD9Fo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Long Li <longli@microsoft.com>,
	Leon Romanovsky <leon@kernel.org>
Subject: [PATCH 6.11 440/558] RDMA/mana_ib: use the correct page size for mapping user-mode doorbell page
Date: Tue,  8 Oct 2024 14:07:50 +0200
Message-ID: <20241008115719.583600038@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115702.214071228@linuxfoundation.org>
References: <20241008115702.214071228@linuxfoundation.org>
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

From: Long Li <longli@microsoft.com>

commit 4a3b99bc04e501b816db78f70064e26a01257910 upstream.

When mapping doorbell page from user-mode, the driver should use the system
page size as this memory is allocated via mmap() from user-mode.

Cc: stable@vger.kernel.org
Fixes: 0266a177631d ("RDMA/mana_ib: Add a driver for Microsoft Azure Network Adapter")
Signed-off-by: Long Li <longli@microsoft.com>
Link: https://patch.msgid.link/1725030993-16213-2-git-send-email-longli@linuxonhyperv.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/infiniband/hw/mana/main.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/infiniband/hw/mana/main.c
+++ b/drivers/infiniband/hw/mana/main.c
@@ -511,13 +511,13 @@ int mana_ib_mmap(struct ib_ucontext *ibc
 	      PAGE_SHIFT;
 	prot = pgprot_writecombine(vma->vm_page_prot);
 
-	ret = rdma_user_mmap_io(ibcontext, vma, pfn, gc->db_page_size, prot,
+	ret = rdma_user_mmap_io(ibcontext, vma, pfn, PAGE_SIZE, prot,
 				NULL);
 	if (ret)
 		ibdev_dbg(ibdev, "can't rdma_user_mmap_io ret %d\n", ret);
 	else
-		ibdev_dbg(ibdev, "mapped I/O pfn 0x%llx page_size %u, ret %d\n",
-			  pfn, gc->db_page_size, ret);
+		ibdev_dbg(ibdev, "mapped I/O pfn 0x%llx page_size %lu, ret %d\n",
+			  pfn, PAGE_SIZE, ret);
 
 	return ret;
 }


