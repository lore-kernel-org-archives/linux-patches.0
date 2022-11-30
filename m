Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 269A76FA1
	for <patches@lists.linux.dev>; Wed, 30 Nov 2022 18:28:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76B3FC433D6;
	Wed, 30 Nov 2022 18:28:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1669832896;
	bh=UV+0nHrSa7yUpsFqeWau9e23bfLf2BcKWsZVkITrMp4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IbXX1dP5EW2U+2WLDRhSDJKiHrmlQxEDts7s9STrbhmqemfkAxRWLAMkUAYRZzK/t
	 uOf0m/MYDSz6QDLVbwSau56gVHk9tXH1RLrCUSpH4dsaDQgE8h+NlYQGE1GE76r/jT
	 i44htWpig6i3OfK7Fvjp6VT7o1lnH36+QSIWAmck=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chad Monroe <chad.monroe@smartrg.com>,
	Felix Fietkau <nbd@nbd.name>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 079/162] netfilter: flowtable_offload: add missing locking
Date: Wed, 30 Nov 2022 19:22:40 +0100
Message-Id: <20221130180530.645716293@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221130180528.466039523@linuxfoundation.org>
References: <20221130180528.466039523@linuxfoundation.org>
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
index d1862782be45..28306cb66719 100644
--- a/net/netfilter/nf_flow_table_offload.c
+++ b/net/netfilter/nf_flow_table_offload.c
@@ -910,6 +910,7 @@ static int nf_flow_table_block_setup(struct nf_flowtable *flowtable,
 	struct flow_block_cb *block_cb, *next;
 	int err = 0;
 
+	down_write(&flowtable->flow_block_lock);
 	switch (cmd) {
 	case FLOW_BLOCK_BIND:
 		list_splice(&bo->cb_list, &flowtable->flow_block.cb_list);
@@ -924,6 +925,7 @@ static int nf_flow_table_block_setup(struct nf_flowtable *flowtable,
 		WARN_ON_ONCE(1);
 		err = -EOPNOTSUPP;
 	}
+	up_write(&flowtable->flow_block_lock);
 
 	return err;
 }
@@ -980,7 +982,9 @@ static int nf_flow_table_offload_cmd(struct flow_block_offload *bo,
 
 	nf_flow_table_block_offload_init(bo, dev_net(dev), cmd, flowtable,
 					 extack);
+	down_write(&flowtable->flow_block_lock);
 	err = dev->netdev_ops->ndo_setup_tc(dev, TC_SETUP_FT, bo);
+	up_write(&flowtable->flow_block_lock);
 	if (err < 0)
 		return err;
 
-- 
2.35.1



