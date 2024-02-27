Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4CD013A259;
	Tue, 27 Feb 2024 14:10:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709043019; cv=none; b=sXsELPp37lOyXhSC1qYqVGZEDPjoWUYICHVtf5Pcwln53kzC/t349gGa5aRLD/AXijLzFcu9jmNGP2nBLcX+gGjfXOHA7otWEf4hOSt1KGV+ChKlsLQwiHly6gcO7z1M1TF8eHVDf5n14n/xJzCxWsdHqOwaRBhgZuZ85JM4a38=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709043019; c=relaxed/simple;
	bh=spRjEvaWYS7ASxit3MlJaf9TYItjj38l/tMyD3NlZkc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EPNiNiaJ6/AL9wO7qBccvxvdnceenUqwTMcbhTXpebo8TbJjQ0U9nJeWuzXUDGVEp2MERiLc5mc2eDhdIvSemTzvzdixBJ4rYB48AqZ7tAkGizVTrW5fO2qm5qTCtpa34hpOhJ9u4CB6Hw5pJOSpBBYti57gk6wiligqYGLXe4k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SNStD0DZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SNStD0DZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09EA8C433F1;
	Tue, 27 Feb 2024 14:10:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709043019;
	bh=spRjEvaWYS7ASxit3MlJaf9TYItjj38l/tMyD3NlZkc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SNStD0DZwmJ8ELsaD+Q4lsloxC+Q0Qggh9ITU3ClTncWIk6UIMmnKpySds4X4TNF/
	 dl1hmLHvv/iRP3qUCVPVwhfHcNo4Tt6OL5XFNnZ+ldmUZ7JUI3yxiTDyPJWNZ4T2qR
	 gR0nlR1ls08Y5v297WvcaCYM1Kn8JZakRxEurRHE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shiraz Saleem <shiraz.saleem@intel.com>,
	Sindhu Devale <sindhu.devale@intel.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 204/245] RDMA/irdma: Validate max_send_wr and max_recv_wr
Date: Tue, 27 Feb 2024 14:26:32 +0100
Message-ID: <20240227131621.829203601@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131615.098467438@linuxfoundation.org>
References: <20240227131615.098467438@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 8981bf834a581..c15af65cba333 100644
--- a/drivers/infiniband/hw/irdma/verbs.c
+++ b/drivers/infiniband/hw/irdma/verbs.c
@@ -749,7 +749,9 @@ static int irdma_validate_qp_attrs(struct ib_qp_init_attr *init_attr,
 
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



