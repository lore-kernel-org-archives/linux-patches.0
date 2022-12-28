Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFBED1863
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 15:18:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30462C433D2;
	Wed, 28 Dec 2022 15:18:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672240708;
	bh=YB0JO5wa4WIkRmrXgnzwLPoxgR82+OvvjwEP/0XFvCk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=N+LED0LuXqy1J3f+CQ1vRv2wBCyOrWixaY4vXNHkxOtCJwBDHPFHR/WQ0LGcnqaAl
	 WXTpaCcMtqFaRU4+QkClbbXHT/XETLZOmedyU7p6WSnFVmp+k5r0TkuQpZYMIqJzRj
	 kcsnEPON/7QCNZG3FlRb9IYuC9rom+dtbhqKOxbY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Zhang <markzhang@nvidia.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 388/731] RDMA/nldev: Return "-EAGAIN" if the cm_id isnt from expected port
Date: Wed, 28 Dec 2022 15:38:15 +0100
Message-Id: <20221228144307.807966255@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144256.536395940@linuxfoundation.org>
References: <20221228144256.536395940@linuxfoundation.org>
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

[ Upstream commit ecacb3751f254572af0009b9501e2cdc83a30b6a ]

When filling a cm_id entry, return "-EAGAIN" instead of 0 if the cm_id
doesn'the have the same port as requested, otherwise an incomplete entry
may be returned, which causes "rdam res show cm_id" to return an error.

For example on a machine with two rdma devices with "rping -C 1 -v -s"
running background, the "rdma" command fails:
  $ rdma -V
  rdma utility, iproute2-5.19.0
  $ rdma res show cm_id
  link mlx5_0/- cm-idn 0 state LISTEN ps TCP pid 28056 comm rping src-addr 0.0.0.0:7174
  error: Protocol not available

While with this fix it succeeds:
  $ rdma res show cm_id
  link mlx5_0/- cm-idn 0 state LISTEN ps TCP pid 26395 comm rping src-addr 0.0.0.0:7174
  link mlx5_1/- cm-idn 0 state LISTEN ps TCP pid 26395 comm rping src-addr 0.0.0.0:7174

Fixes: 00313983cda6 ("RDMA/nldev: provide detailed CM_ID information")
Signed-off-by: Mark Zhang <markzhang@nvidia.com>
Link: https://lore.kernel.org/r/a08e898cdac5e28428eb749a99d9d981571b8ea7.1667810736.git.leonro@nvidia.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/core/nldev.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/core/nldev.c b/drivers/infiniband/core/nldev.c
index cd89e59cbe33..6f3799698634 100644
--- a/drivers/infiniband/core/nldev.c
+++ b/drivers/infiniband/core/nldev.c
@@ -550,7 +550,7 @@ static int fill_res_cm_id_entry(struct sk_buff *msg, bool has_cap_net_admin,
 	struct rdma_cm_id *cm_id = &id_priv->id;
 
 	if (port && port != cm_id->port_num)
-		return 0;
+		return -EAGAIN;
 
 	if (cm_id->port_num &&
 	    nla_put_u32(msg, RDMA_NLDEV_ATTR_PORT_INDEX, cm_id->port_num))
-- 
2.35.1



