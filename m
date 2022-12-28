Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CD5C1C07
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 16:11:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E370CC433D2;
	Wed, 28 Dec 2022 16:11:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672243909;
	bh=sBVBxC3idSlA6Fa2PoZPiNDNc5jGQgjGW2Vq+uhcgFk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZBej95hCHmKydWpR818iW2gt8nnvSQpIFg579/6kgK8nS6mYDqe4j6rr8WZqfZq0a
	 lxOiMkv0Cg8fO3FE0rxhxNiE8WFSk/3htfESBnCE6KIKOpOkqpxPaqQ06qGkZ+Y7ko
	 o5SpyAuBPkEgDe1CdQNvZXyui+BRMX1aV3+KIlZc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mustafa Ismail <mustafa.ismail@intel.com>,
	Shiraz Saleem <shiraz.saleem@intel.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0608/1073] RDMA/irdma: Initialize net_type before checking it
Date: Wed, 28 Dec 2022 15:36:36 +0100
Message-Id: <20221228144344.560420325@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Mustafa Ismail <mustafa.ismail@intel.com>

[ Upstream commit 9907526d25c4ad8a6e3006487a544140776ba005 ]

The av->net_type is not initialized before it is checked in
irdma_modify_qp_roce. This leads to an incorrect update to the ARP cache
and QP context. RoCEv2 connections might fail as result.

Set the net_type using rdma_gid_attr_network_type.

Fixes: 80005c43d4c8 ("RDMA/irdma: Use net_type to check network type")
Signed-off-by: Mustafa Ismail <mustafa.ismail@intel.com>
Signed-off-by: Shiraz Saleem <shiraz.saleem@intel.com>
Link: https://lore.kernel.org/r/20221122004410.1471-1-shiraz.saleem@intel.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/irdma/verbs.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/infiniband/hw/irdma/verbs.c b/drivers/infiniband/hw/irdma/verbs.c
index dc3f5f3fee90..f6973ea55eda 100644
--- a/drivers/infiniband/hw/irdma/verbs.c
+++ b/drivers/infiniband/hw/irdma/verbs.c
@@ -1213,6 +1213,7 @@ int irdma_modify_qp_roce(struct ib_qp *ibqp, struct ib_qp_attr *attr,
 		av->attrs = attr->ah_attr;
 		rdma_gid2ip((struct sockaddr *)&av->sgid_addr, &sgid_attr->gid);
 		rdma_gid2ip((struct sockaddr *)&av->dgid_addr, &attr->ah_attr.grh.dgid);
+		av->net_type = rdma_gid_attr_network_type(sgid_attr);
 		if (av->net_type == RDMA_NETWORK_IPV6) {
 			__be32 *daddr =
 				av->dgid_addr.saddr_in6.sin6_addr.in6_u.u6_addr32;
-- 
2.35.1



