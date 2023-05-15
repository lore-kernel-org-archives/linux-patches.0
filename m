Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 421FEFBF6
	for <patches@lists.linux.dev>; Mon, 15 May 2023 17:47:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7C9BC4339B;
	Mon, 15 May 2023 17:47:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684172855;
	bh=E96wm37hDQN0w5JwnNAUziKWKUfQ63CLexhqGYF9EUA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=F4T+gwMOP1RDEDptyy7EbzPwI3wKzzvAfY8RW2bfJJ/wGA735//GOwWMdB2AP0vOc
	 6wmMsgLPnR6CIKt0tc9uFfTqOsQiDQV9dtv42p1yaDDm5giiYGujPdWt1PYWH3FI/E
	 WHA5artDy04MHlwCEloILSo2gM3HFtSHkzk76ygs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Zhang <markzhang@nvidia.com>,
	Maor Gottlieb <maorg@nvidia.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 258/381] RDMA/mlx5: Use correct device num_ports when modify DC
Date: Mon, 15 May 2023 18:28:29 +0200
Message-Id: <20230515161748.382059558@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230515161736.775969473@linuxfoundation.org>
References: <20230515161736.775969473@linuxfoundation.org>
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

[ Upstream commit 746aa3c8cb1a650ff2583497ac646e505831b9b9 ]

Just like other QP types, when modify DC, the port_num should be compared
with dev->num_ports, instead of HCA_CAP.num_ports.  Otherwise Multi-port
vHCA on DC may not work.

Fixes: 776a3906b692 ("IB/mlx5: Add support for DC target QP")
Link: https://lore.kernel.org/r/20230420013906.1244185-1-markzhang@nvidia.com
Signed-off-by: Mark Zhang <markzhang@nvidia.com>
Reviewed-by: Maor Gottlieb <maorg@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/mlx5/qp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/mlx5/qp.c b/drivers/infiniband/hw/mlx5/qp.c
index 0caff276f2c18..0c47e3e24b2a4 100644
--- a/drivers/infiniband/hw/mlx5/qp.c
+++ b/drivers/infiniband/hw/mlx5/qp.c
@@ -4164,7 +4164,7 @@ static int mlx5_ib_modify_dct(struct ib_qp *ibqp, struct ib_qp_attr *attr,
 			return -EINVAL;
 
 		if (attr->port_num == 0 ||
-		    attr->port_num > MLX5_CAP_GEN(dev->mdev, num_ports)) {
+		    attr->port_num > dev->num_ports) {
 			mlx5_ib_dbg(dev, "invalid port number %d. number of ports is %d\n",
 				    attr->port_num, dev->num_ports);
 			return -EINVAL;
-- 
2.39.2



