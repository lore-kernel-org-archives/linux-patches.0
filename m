Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88C85538F
	for <patches@lists.linux.dev>; Mon, 19 Jun 2023 10:47:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 105B4C433C8;
	Mon, 19 Jun 2023 10:47:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1687171631;
	bh=cBfI6GTn13YnAm+D63GhBrCwxK8v/1sztJEXE5FP/es=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=D5PSxlJE+KSAOv1YO8OhH9OctB7tm6veEG6pXjxLl4K7OojRfvXK1zLSaVQh/wAqk
	 Kb5NsXyO+cgpKecGVUsupDBInJRHqspy+YuJsKXbP6ZpGlx2WtLiaIwWe0yhNqtE5Q
	 0EXiPB9fRWLs9z3HVAVDyVCIsZPZM9LXmk3JdSmM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wei Fang <wei.fang@nxp.com>,
	Vladimir Oltean <vladimir.oltean@nxp.com>,
	Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 100/166] net: enetc: correct the indexes of highest and 2nd highest TCs
Date: Mon, 19 Jun 2023 12:29:37 +0200
Message-ID: <20230619102159.631831205@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230619102154.568541872@linuxfoundation.org>
References: <20230619102154.568541872@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Wei Fang <wei.fang@nxp.com>

[ Upstream commit 21225873be1472b7c59ed3650396af0e40578112 ]

For ENETC hardware, the TCs are numbered from 0 to N-1, where N
is the number of TCs. Numerically higher TC has higher priority.
It's obvious that the highest priority TC index should be N-1 and
the 2nd highest priority TC index should be N-2.

However, the previous logic uses netdev_get_prio_tc_map() to get
the indexes of highest priority and 2nd highest priority TCs, it
does not make sense and is incorrect to give a "tc" argument to
netdev_get_prio_tc_map(). So the driver may get the wrong indexes
of the two highest priotiry TCs which would lead to failed to set
the CBS for the two highest priotiry TCs.

e.g.
$ tc qdisc add dev eno0 parent root handle 100: mqprio num_tc 6 \
	map 0 0 1 1 2 3 4 5 queues 1@0 1@1 1@2 1@3 2@4 2@6 hw 1
$ tc qdisc replace dev eno0 parent 100:6 cbs idleslope 100000 \
	sendslope -900000 hicredit 12 locredit -113 offload 1
$ Error: Specified device failed to setup cbs hardware offload.
  ^^^^^

In this example, the previous logic deems the indexes of the two
highest priotiry TCs should be 3 and 2. Actually, the indexes are
5 and 4, because the number of TCs is 6. So it would be failed to
configure the CBS for the two highest priority TCs.

Fixes: c431047c4efe ("enetc: add support Credit Based Shaper(CBS) for hardware offload")
Signed-off-by: Wei Fang <wei.fang@nxp.com>
Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/freescale/enetc/enetc_qos.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/freescale/enetc/enetc_qos.c b/drivers/net/ethernet/freescale/enetc/enetc_qos.c
index a8539a8554a13..762849959cc1b 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_qos.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc_qos.c
@@ -189,8 +189,8 @@ int enetc_setup_tc_cbs(struct net_device *ndev, void *type_data)
 	int bw_sum = 0;
 	u8 bw;
 
-	prio_top = netdev_get_prio_tc_map(ndev, tc_nums - 1);
-	prio_next = netdev_get_prio_tc_map(ndev, tc_nums - 2);
+	prio_top = tc_nums - 1;
+	prio_next = tc_nums - 2;
 
 	/* Support highest prio and second prio tc in cbs mode */
 	if (tc != prio_top && tc != prio_next)
-- 
2.39.2



