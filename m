Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0843B8F57
	for <patches@lists.linux.dev>; Sun, 16 Jul 2023 20:46:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7ED8AC433C9;
	Sun, 16 Jul 2023 20:46:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689540405;
	bh=vOa4xfnWH2DNMJ5fIBOsp/yM5w+kR09OHDqhUZ0z0mg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aWFDulHoyVFHhsqL0QBpeFKgLdswnjlQxGIhPEm9Xmm2f1XBwHjrXfK3XpIk6vX2W
	 uuLq2pOujYibvuwzNnPCJy4qOuypGbCCV73IK21wB987m2xzYRZt2je8mnu2ovSROz
	 lQ73NnPcm14U1HqJH5MDqUfXnI2CVxyLtxL/CyBM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tarun Sahu <tsahu@linux.ibm.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 352/591] dax/kmem: Pass valid argument to memory_group_register_static
Date: Sun, 16 Jul 2023 21:48:11 +0200
Message-ID: <20230716194933.016503344@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230716194923.861634455@linuxfoundation.org>
References: <20230716194923.861634455@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Tarun Sahu <tsahu@linux.ibm.com>

[ Upstream commit 46e66dab8565f742374e9cc4ff7d35f344d774e2 ]

memory_group_register_static takes maximum number of pages as the argument
while dev_dax_kmem_probe passes total_len (in bytes) as the argument.

IIUC, I don't see any crash/panic impact as such. As,
memory_group_register_static just set the max_pages limit which is used in
auto_movable_zone_for_pfn to determine the zone.

which might cause these condition to behave differently,

This will be true always so jump will happen to kernel_zone
    ...
    if (!auto_movable_can_online_movable(NUMA_NO_NODE, group, nr_pages))
        goto kernel_zone;

    ...
    kernel_zone:
        return default_kernel_zone_for_pfn(nid, pfn, nr_pages);

Here, In below, zone_intersects compare range will be larger as nr_pages
will be higher (derived from total_len passed in dev_dax_kmem_probe).

    ...
    static struct zone *default_kernel_zone_for_pfn(int nid, unsigned long start_pfn,
    		unsigned long nr_pages)
    {
    	struct pglist_data *pgdat = NODE_DATA(nid);
    	int zid;

    	for (zid = 0; zid < ZONE_NORMAL; zid++) {
    		struct zone *zone = &pgdat->node_zones[zid];

    		if (zone_intersects(zone, start_pfn, nr_pages))
    			return zone;
    	}

    	return &pgdat->node_zones[ZONE_NORMAL];
    }

Incorrect zone will be returned here, which in later time might cause bigger
problem.

Fixes: eedf634aac3b ("dax/kmem: use a single static memory group for a single probed unit")
Signed-off-by: Tarun Sahu <tsahu@linux.ibm.com>
Link: https://lore.kernel.org/r/20230621155025.370672-1-tsahu@linux.ibm.com
Reviewed-by: Vishal Verma <vishal.l.verma@intel.com>
Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dax/kmem.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/dax/kmem.c b/drivers/dax/kmem.c
index 4aa758a2b3d1b..1a33616ceb06e 100644
--- a/drivers/dax/kmem.c
+++ b/drivers/dax/kmem.c
@@ -99,7 +99,7 @@ static int dev_dax_kmem_probe(struct dev_dax *dev_dax)
 	if (!data->res_name)
 		goto err_res_name;
 
-	rc = memory_group_register_static(numa_node, total_len);
+	rc = memory_group_register_static(numa_node, PFN_UP(total_len));
 	if (rc < 0)
 		goto err_reg_mgid;
 	data->mgid = rc;
-- 
2.39.2



