Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29C2614F9C8;
	Tue, 20 Feb 2024 21:07:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708463274; cv=none; b=KVrFjyXZTnZkX9owSqfhREspIgtMlrNjfxOq8VkhZu3ZDvDwGNO0VZZYwlaz0XMOUMOpgFaGy1PUFZO8DCRXCn9gcrZYwwKcAaukvdihHIHs4HIygR9dag1GDuEaRjWK85uveiOE2iS/2UUWruxRL84iRXqNaWp9eBcuAIyf8DI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708463274; c=relaxed/simple;
	bh=UTBktgDCyYBVrsIFE3iIaRjcWVjX10rpUBZ6mej0oHY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Jr3MozEcDVF8knEC84S2yEUoHmRy7Km1BOzLNPKZtzjbtMgEGfssqHCfG2kqN2/g0wPzxwcW+PlLQ4POYNnM4K+ZVS+jlRn4/98elKg8KN0LNXVfHvSCnOv0zYmGru/lqJG0famq3Wv/tDEwcjvA5z9Fy6kTc4BfHDU4v1kJLUc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NSkirBJy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NSkirBJy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D2CBC433C7;
	Tue, 20 Feb 2024 21:07:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708463274;
	bh=UTBktgDCyYBVrsIFE3iIaRjcWVjX10rpUBZ6mej0oHY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NSkirBJyioTm0ciN6PNWZihoe+jQWFZBYN+uEfrzIxGkaqvSoGn6qvOB50YhOa0YB
	 r9Ggt1+fi4cagnMO5UUVqoCBHbf1eOWLtzow6QO8IskzZZlGRZ/fWUBjizDPq9k/9k
	 qEgZwBtDUe3LKCstu05iNkqO+nvgUTqZDzzyUUIc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mike Marciniszyn <mike.marciniszyn@intel.com>,
	Shiraz Saleem <shiraz.saleem@intel.com>,
	Jason Gunthorpe <jgg@nvidia.com>
Subject: [PATCH 6.1 190/197] RDMA/irdma: Ensure iWarp QP queue memory is OS paged aligned
Date: Tue, 20 Feb 2024 21:52:29 +0100
Message-ID: <20240220204846.768671336@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220204841.073267068@linuxfoundation.org>
References: <20240220204841.073267068@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mike Marciniszyn <mike.marciniszyn@intel.com>

commit 0a5ec366de7e94192669ba08de6ed336607fd282 upstream.

The SQ is shared for between kernel and used by storing the kernel page
pointer and passing that to a kmap_atomic().

This then requires that the alignment is PAGE_SIZE aligned.

Fix by adding an iWarp specific alignment check.

Fixes: e965ef0e7b2c ("RDMA/irdma: Split QP handler into irdma_reg_user_mr_type_qp")
Link: https://lore.kernel.org/r/20231129202143.1434-3-shiraz.saleem@intel.com
Signed-off-by: Mike Marciniszyn <mike.marciniszyn@intel.com>
Signed-off-by: Shiraz Saleem <shiraz.saleem@intel.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/infiniband/hw/irdma/verbs.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/drivers/infiniband/hw/irdma/verbs.c
+++ b/drivers/infiniband/hw/irdma/verbs.c
@@ -2845,6 +2845,13 @@ static struct ib_mr *irdma_reg_user_mr(s
 
 	switch (req.reg_type) {
 	case IRDMA_MEMREG_TYPE_QP:
+		/* iWarp: Catch page not starting on OS page boundary */
+		if (!rdma_protocol_roce(&iwdev->ibdev, 1) &&
+		    ib_umem_offset(iwmr->region)) {
+			err = -EINVAL;
+			goto error;
+		}
+
 		total = req.sq_pages + req.rq_pages + shadow_pgcnt;
 		if (total > iwmr->page_cnt) {
 			err = -EINVAL;


