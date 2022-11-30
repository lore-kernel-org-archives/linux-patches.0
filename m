Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 898A66FA1
	for <patches@lists.linux.dev>; Wed, 30 Nov 2022 18:37:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FA1FC433C1;
	Wed, 30 Nov 2022 18:37:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1669833472;
	bh=1dXlkYfPcscpwhzwb8qWm+fLg/FuYGd/RBEZFt+jJ48=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lEJnhYAqvNUudj2ATUjuE2XA+4hvB9xI80fyE+q+QmYnkF2NqeCN4f66WHX0BCmA1
	 8YoopvDe29AVgJsvFX1svvFCEsmagy3kMOehG61acXUB+UDe4qwXKmnzDKPEPP+2hK
	 vsmr2lch+WOURRoBs0C6r8zcHjGa9FF7MkNmg67k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chad Monroe <chad.monroe@smartrg.com>,
	Felix Fietkau <nbd@nbd.name>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 118/206] netfilter: flowtable_offload: add missing locking
Date: Wed, 30 Nov 2022 19:22:50 +0100
Message-Id: <20221130180536.045262744@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221130180532.974348590@linuxfoundation.org>
References: <20221130180532.974348590@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Felix Fietkau <nbd@nbd.name>

[ Upstream commit bcd9e3c1656d0f7dd9743598c65c3ae24efb38d0 ]

nf_flow_table_block_setup and the driver TC_SETUP_FT call can modify the flow
block cb list while they are being traversed elsewhere, causing a crash.
Add a write lock around the calls to protect readers

Fixes: c29f74e0df7a ("netfilter: nf_flow_table: hardware offload support")
Reported-by: Chad Monroe <chad.monroe@smartrg.com>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_flow_table_offload.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/netfilter/nf_flow_table_offload.c b/net/netfilter/nf_flow_table_offload.c
index c4559fae8acd..66c9a6c2b9cf 100644
--- a/net/netfilter/nf_flow_table_offload.c
+++ b/net/netfilter/nf_flow_table_offload.c
@@ -1074,6 +1074,7 @@ static int nf_flow_table_block_setup(struct nf_flowtable *flowtable,
 	struct flow_block_cb *block_cb, *next;
 	int err = 0;
 
+	down_write(&flowtable->flow_block_lock);
 	switch (cmd) {
 	case FLOW_BLOCK_BIND:
 		list_splice(&bo->cb_list, &flowtable->flow_block.cb_list);
@@ -1088,6 +1089,7 @@ static int nf_flow_table_block_setup(struct nf_flowtable *flowtable,
 		WARN_ON_ONCE(1);
 		err = -EOPNOTSUPP;
 	}
+	up_write(&flowtable->flow_block_lock);
 
 	return err;
 }
@@ -1144,7 +1146,9 @@ static int nf_flow_table_offload_cmd(struct flow_block_offload *bo,
 
 	nf_flow_table_block_offload_init(bo, dev_net(dev), cmd, flowtable,
 					 extack);
+	down_write(&flowtable->flow_block_lock);
 	err = dev->netdev_ops->ndo_setup_tc(dev, TC_SETUP_FT, bo);
+	up_write(&flowtable->flow_block_lock);
 	if (err < 0)
 		return err;
 
-- 
2.35.1



