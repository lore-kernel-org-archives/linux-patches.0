Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9430613B79F;
	Tue, 27 Feb 2024 13:39:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709041151; cv=none; b=ZVB1JNkbpHehRSO0UAyhbulmPHZiY2a0YZITJwL/r7gtzzgsflXJnAHKjlIP8X/eoxx0e6foJhmOpDhPWMyHnSkm2jhwkXUzFZn8YIC17dzurRfH9iupaqDePV2KDmEqMh55wZl1nCnCNd6CP2rY0NS2mKF7yCkaV3aLDraG1Us=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709041151; c=relaxed/simple;
	bh=wkGJhHbXr450qrSx66gMFAyoOBtG+1RxIRV2mUPoYuU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jbZoQZuaXnoV8spA951OvvnQOYJrp+wiu0o0cE7/IQyYkDKxbYMZWbAQspU9erXBXtAKVYk1mJGa6wP+DyRal29tB4Lw+tT6fab+5CSE1Nk0TL7uzhGeZasK9fTBLYbnotuCGY0eId5tJ5gt4F8N37+JAnyQoZk0EKirLMr/YAo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=p0fsx332; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="p0fsx332"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1AF7BC43390;
	Tue, 27 Feb 2024 13:39:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709041151;
	bh=wkGJhHbXr450qrSx66gMFAyoOBtG+1RxIRV2mUPoYuU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=p0fsx3324WW8GjLmfZRU2PqaLrjlbjzGdARBho6zBku9/bMSRAVvhZa/nvm99C3WK
	 R8r/bo9/Z/S9OuQ3f8AGM0t/Pd8Ld2X7H+ff7g1+WgSdSnDxsNV99qFlFH3OL2+Oph
	 wphnhao202z4r70F5ojoWPR8amVhRRmGfzZslQIs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shiraz Saleem <shiraz.saleem@intel.com>,
	Sindhu Devale <sindhu.devale@intel.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 238/334] RDMA/irdma: Validate max_send_wr and max_recv_wr
Date: Tue, 27 Feb 2024 14:21:36 +0100
Message-ID: <20240227131638.549610708@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131630.636392135@linuxfoundation.org>
References: <20240227131630.636392135@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

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
index b5eb8d421988c..cb828e3da478e 100644
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



