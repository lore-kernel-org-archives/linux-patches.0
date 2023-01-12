Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8E38749D
	for <patches@lists.linux.dev>; Thu, 12 Jan 2023 14:16:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71F4DC433D2;
	Thu, 12 Jan 2023 14:16:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673532967;
	bh=hr8dfGb7sFxPmP+8L9OLMpwHK1fp9KEgdfgknyvG/go=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=F1Ztwhu2NDfeKqJDKjH6U9vqAE0tlHGMydmvnBX3QlAtnvJOxP2N369v3er7WnY6Q
	 VS9BqkNUCsci0hdbdOs0rzdWC725MRZIlr41hR8716SFTp7tnVhU526CzWyRAcMERM
	 dlTb8H+JufEcS/mysOeYlT13M2LpTq+72UIX+aB8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Zhang <markzhang@nvidia.com>,
	Patrisious Haddad <phaddad@nvidia.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 328/783] RDMA/nldev: Fix failure to send large messages
Date: Thu, 12 Jan 2023 14:50:44 +0100
Message-Id: <20230112135539.512840158@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230112135524.143670746@linuxfoundation.org>
References: <20230112135524.143670746@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Mark Zhang <markzhang@nvidia.com>

[ Upstream commit fc8f93ad3e5485d45c992233c96acd902992dfc4 ]

Return "-EMSGSIZE" instead of "-EINVAL" when filling a QP entry, so that
new SKBs will be allocated if there's not enough room in current SKB.

Fixes: 65959522f806 ("RDMA: Add support to dump resource tracker in RAW format")
Signed-off-by: Mark Zhang <markzhang@nvidia.com>
Reviewed-by: Patrisious Haddad <phaddad@nvidia.com>
Link: https://lore.kernel.org/r/b5e9c62f6b8369acab5648b661bf539cbceeffdc.1669636336.git.leonro@nvidia.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/core/nldev.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/core/nldev.c b/drivers/infiniband/core/nldev.c
index 78534340d282..f7f80707af4b 100644
--- a/drivers/infiniband/core/nldev.c
+++ b/drivers/infiniband/core/nldev.c
@@ -502,7 +502,7 @@ static int fill_res_qp_entry(struct sk_buff *msg, bool has_cap_net_admin,
 
 	/* In create_qp() port is not set yet */
 	if (qp->port && nla_put_u32(msg, RDMA_NLDEV_ATTR_PORT_INDEX, qp->port))
-		return -EINVAL;
+		return -EMSGSIZE;
 
 	ret = nla_put_u32(msg, RDMA_NLDEV_ATTR_RES_LQPN, qp->qp_num);
 	if (ret)
-- 
2.35.1



