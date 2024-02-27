Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95AC513F01E;
	Tue, 27 Feb 2024 13:58:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709042292; cv=none; b=gafEgd5+Jj6Z9jExr7CDbLRm7NsUNeoOu+QK28iI4WNqpToAvG95QH0dN4FmD3DrUfJNXu6T72DXSaQc4pVM7FGqIKjHCcEw8zQjZUQXbgO0IRcHPHkpqaHQuakHjCrWtzNaqq5WooIkNEZK9YRdZ5KZvneTeR2X5eu2buXx1NY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709042292; c=relaxed/simple;
	bh=TR5UBfZ1d9BzfCK13J9WxvEBJk6FsvR7wpT76d766Og=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f+XjMpieq1vRQiCpCZHCmqA/VLPpK5PJyi4kNGF+GajEA/MU3weeg6YevkdSfqCeLBKZjcMf88woDXujIeBSwbudh+6KnNQYn5mXl69UdZFoEO11D5u3HCOnQSG1lxQdTlcA6UeG4ki7bbnefXfrnDhHGXsEPixT9S9XxbvEg3E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Qfa5og2v; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Qfa5og2v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8FF7C433C7;
	Tue, 27 Feb 2024 13:58:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709042292;
	bh=TR5UBfZ1d9BzfCK13J9WxvEBJk6FsvR7wpT76d766Og=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Qfa5og2vjszrtN3c7JM95pxz2x1hZBXF6h8W/izs8AR+YH6xEHOLYZXrrzKzdjlhS
	 ZPqgDcOA1xyS8hlD3dA+UIpkRA3g09gq/Y7GCzK1eTqVTW3HaHoCkekDthNJBB3mpf
	 P/1Aoba4zV1ESgIFApkJoaTfNL153acmIJHZHTaQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shiraz Saleem <shiraz.saleem@intel.com>,
	Sindhu Devale <sindhu.devale@intel.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 217/299] RDMA/irdma: Validate max_send_wr and max_recv_wr
Date: Tue, 27 Feb 2024 14:25:28 +0100
Message-ID: <20240227131632.759993027@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131625.847743063@linuxfoundation.org>
References: <20240227131625.847743063@linuxfoundation.org>
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

From: Shiraz Saleem <shiraz.saleem@intel.com>

[ Upstream commit ee107186bcfd25d7873258f3f75440e20f5e6416 ]

Validate that max_send_wr and max_recv_wr is within the
supported range.

Fixes: b48c24c2d710 ("RDMA/irdma: Implement device supported verb APIs")
Change-Id: I2fc8b10292b641fddd20b36986a9dae90a93f4be
Signed-off-by: Shiraz Saleem <shiraz.saleem@intel.com>
Signed-off-by: Sindhu Devale <sindhu.devale@intel.com>
Link: https://lore.kernel.org/r/20240131233849.400285-3-sindhu.devale@intel.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/irdma/verbs.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/irdma/verbs.c b/drivers/infiniband/hw/irdma/verbs.c
index 2f1bedd3a5201..d9750901c5990 100644
--- a/drivers/infiniband/hw/irdma/verbs.c
+++ b/drivers/infiniband/hw/irdma/verbs.c
@@ -839,7 +839,9 @@ static int irdma_validate_qp_attrs(struct ib_qp_init_attr *init_attr,
 
 	if (init_attr->cap.max_inline_data > uk_attrs->max_hw_inline ||
 	    init_attr->cap.max_send_sge > uk_attrs->max_hw_wq_frags ||
-	    init_attr->cap.max_recv_sge > uk_attrs->max_hw_wq_frags)
+	    init_attr->cap.max_recv_sge > uk_attrs->max_hw_wq_frags ||
+	    init_attr->cap.max_send_wr > uk_attrs->max_hw_wq_quanta ||
+	    init_attr->cap.max_recv_wr > uk_attrs->max_hw_rq_quanta)
 		return -EINVAL;
 
 	if (rdma_protocol_roce(&iwdev->ibdev, 1)) {
-- 
2.43.0



