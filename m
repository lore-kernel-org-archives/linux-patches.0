Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E33A11DF979;
	Tue,  8 Oct 2024 13:24:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728393856; cv=none; b=L4pqGyoAVwH3t6G228s6C3gaNGVp9vhlLyIyLQ13vNohQ5AU42HfebT4YvwUCIfeIpCzFc9TeCScBV+xHrdt/9Xo+ICPwqmEO3evs3QZnkxwaFp4AFgr4/IWs/7K/z2HlXGGyU4ueO/yOulDHN2vn/PP/v9nU9xt9RFzQFtjN14=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728393856; c=relaxed/simple;
	bh=0RnWVrhgbDqr7uLn/mqwQYPNDl7uIGJoSJJb4Zaegf8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AKPN14RCjhXlP/QdhSfqsVmkFb9sSi8lv9er2uYLRHvOdvRW7kCO4mIatYQvC8giWJXX+yx+eTuUEdimeJ+z0NQX0j/Q50PJuYLkcrG1hJKr5Te6J8uKxkbA3aOD4kUbIec7HoF5NAoNlAzSuVR7wZLfpFbotIKJyoociWeAppE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fAbO+1VA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fAbO+1VA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 533A2C4CEC7;
	Tue,  8 Oct 2024 13:24:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728393855;
	bh=0RnWVrhgbDqr7uLn/mqwQYPNDl7uIGJoSJJb4Zaegf8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fAbO+1VALGclRxdYAsFUnhvTc90FkZbo2BHRtVFC6x1tIqW5YGqQb+t83nliY78x2
	 aJfIZ5O2SVVUOew1tHYq10RTxEqDQnE1cqJTbC76byrjPxYYDI+VnlwfpyBl/XTenl
	 X4Eh8PBFscxj1qlRTOLZIFg0X84K/O+RIsu1heMQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Long Li <longli@microsoft.com>,
	Leon Romanovsky <leon@kernel.org>
Subject: [PATCH 6.6 276/386] RDMA/mana_ib: use the correct page size for mapping user-mode doorbell page
Date: Tue,  8 Oct 2024 14:08:41 +0200
Message-ID: <20241008115640.250640155@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115629.309157387@linuxfoundation.org>
References: <20241008115629.309157387@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -460,13 +460,13 @@ int mana_ib_mmap(struct ib_ucontext *ibc
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


