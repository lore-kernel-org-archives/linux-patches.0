Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EE78261B9E;
	Sat, 30 May 2026 17:55:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780163719; cv=none; b=s8EQxUCOY2ggjrTJL0vFaITn2c02TuipSn7wkmDnUEq2zSXcuevZHry/h/XXsrp7dZWabRoEDdMlKfM77YRiukRGLtMCgQ+okidCY+9w7FjqnetODdWWLN0K5adF7xDa0rhOLL+pxtxaFfa3Xtq/s4bTv8jc2Ql8aunNBR06XS8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780163719; c=relaxed/simple;
	bh=WDwbYK6w6zcut0v58qvaTnz3gCfGQ7NE9Zah7EP1XrA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pMm2ImAnYTZbwAkON/2G6cRKnktqCsg69UJSF7Rrn/0WvV+LmA1fDMArz8JYx13Ify06vnrY0VlbMC4cVku81ld+KcT4LV3Wj+5/A6pQ8t4rZouZKaQc7nVmog64zPA4qOuYJX5ZSW4/LoTvPSEOggTHybb5vXjM9O8IIYudxmA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HrZahqLr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HrZahqLr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 933921F00893;
	Sat, 30 May 2026 17:55:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780163718;
	bh=/M+oG3ZOLWIhUA2wf1reROE4ES4j4+ROjyLiq6X+Pco=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HrZahqLrlcaWi/q4bmEkLEQsOTkHRiOkk9QIvpwYBwfa5GcKJoklanewrNfDVVVIj
	 yX6leoBZ6jAVgo7b+SXeXMrtRSyofvIGl9cUtlq9eeegLwQd6XwXTjL4l7V7192otW
	 GL4deW/5zznfEraGi+J5Y3mtWkfd3iC8dA1cWaOo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jason Gunthorpe <jgg@nvidia.com>
Subject: [PATCH 5.15 342/776] RDMA/mlx4: Fix resource leak on error in mlx4_ib_create_srq()
Date: Sat, 30 May 2026 18:00:56 +0200
Message-ID: <20260530160249.415080320@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160240.228940103@linuxfoundation.org>
References: <20260530160240.228940103@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jason Gunthorpe <jgg@nvidia.com>

commit c54c7e4cb679c0aaa1cb489b9c3f2cd98e63a44c upstream.

Sashiko points out that mlx4_srq_alloc() was not undone during error
unwind, add the missing call to mlx4_srq_free().

Cc: stable@vger.kernel.org
Fixes: 225c7b1feef1 ("IB/mlx4: Add a driver Mellanox ConnectX InfiniBand adapters")
Link: https://sashiko.dev/#/patchset/0-v1-e911b76a94d1%2B65d95-rdma_udata_rep_jgg%40nvidia.com?part=8
Link: https://patch.msgid.link/r/11-v1-41f3135e5565+9d2-rdma_ai_fixes1_jgg@nvidia.com
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/infiniband/hw/mlx4/srq.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/infiniband/hw/mlx4/srq.c
+++ b/drivers/infiniband/hw/mlx4/srq.c
@@ -193,13 +193,15 @@ int mlx4_ib_create_srq(struct ib_srq *ib
 	if (udata)
 		if (ib_copy_to_udata(udata, &srq->msrq.srqn, sizeof (__u32))) {
 			err = -EFAULT;
-			goto err_wrid;
+			goto err_srq;
 		}
 
 	init_attr->attr.max_wr = srq->msrq.max - 1;
 
 	return 0;
 
+err_srq:
+	mlx4_srq_free(dev->dev, &srq->msrq);
 err_wrid:
 	if (udata)
 		mlx4_ib_db_unmap_user(ucontext, &srq->db);


