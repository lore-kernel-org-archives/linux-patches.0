Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFF201C03
	for <patches@lists.linux.dev>; Mon, 20 Mar 2023 15:21:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E27EC433D2;
	Mon, 20 Mar 2023 15:21:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1679325679;
	bh=wnXLSYdOtPwWTzOW70MLofEFjxHN6DtpqNqEXo76lb8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pwaGA04+yRgbZPE/qO0JnViQA6nJvyisNoJvYRjIfckxuzcY2pRFMNE0HuNS+gvHw
	 NC9DyPJ1tNbS3flR6y+DOt1PmKj9EAmpIxzpQUt1PJfOZuVt036bIDcoUhDoHe4GuT
	 tbTwJ0JuBfXJUDerqncEYsokx7vtx8nHk1J3WT54=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vladimir Oltean <vladimir.oltean@nxp.com>,
	Simon Horman <simon.horman@corigine.com>,
	Florian Fainelli <f.fainelli@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 081/211] net: dsa: dont error out when drivers return ETH_DATA_LEN in .port_max_mtu()
Date: Mon, 20 Mar 2023 15:53:36 +0100
Message-Id: <20230320145516.687581662@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230320145513.305686421@linuxfoundation.org>
References: <20230320145513.305686421@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Vladimir Oltean <vladimir.oltean@nxp.com>

[ Upstream commit 636e8adf7878eab3614250234341bde45537f47a ]

Currently, when dsa_slave_change_mtu() is called on a user port where
dev->max_mtu is 1500 (as returned by ds->ops->port_max_mtu()), the code
will stumble upon this check:

	if (new_master_mtu > mtu_limit)
		return -ERANGE;

because new_master_mtu is adjusted for the tagger overhead but mtu_limit
is not.

But it would be good if the logic went through, for example if the DSA
master really depends on an MTU adjustment to accept DSA-tagged frames.

To make the code pass through the check, we need to adjust mtu_limit for
the overhead as well, if the minimum restriction was caused by the DSA
user port's MTU (dev->max_mtu). A DSA user port MTU and a DSA master MTU
are always offset by the protocol overhead.

Currently no drivers return 1500 .port_max_mtu(), but this is only
temporary and a bug in itself - mv88e6xxx should have done that, but
since commit b9c587fed61c ("dsa: mv88e6xxx: Include tagger overhead when
setting MTU for DSA and CPU ports") it no longer does. This is a
preparation for fixing that.

Fixes: bfcb813203e6 ("net: dsa: configure the MTU for switch ports")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Simon Horman <simon.horman@corigine.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/dsa/slave.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index aab79c3552249..6711ddc0a3c7d 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -1899,6 +1899,7 @@ int dsa_slave_change_mtu(struct net_device *dev, int new_mtu)
 	int new_master_mtu;
 	int old_master_mtu;
 	int mtu_limit;
+	int overhead;
 	int cpu_mtu;
 	int err;
 
@@ -1927,9 +1928,10 @@ int dsa_slave_change_mtu(struct net_device *dev, int new_mtu)
 			largest_mtu = slave_mtu;
 	}
 
-	mtu_limit = min_t(int, master->max_mtu, dev->max_mtu);
+	overhead = dsa_tag_protocol_overhead(cpu_dp->tag_ops);
+	mtu_limit = min_t(int, master->max_mtu, dev->max_mtu + overhead);
 	old_master_mtu = master->mtu;
-	new_master_mtu = largest_mtu + dsa_tag_protocol_overhead(cpu_dp->tag_ops);
+	new_master_mtu = largest_mtu + overhead;
 	if (new_master_mtu > mtu_limit)
 		return -ERANGE;
 
@@ -1964,8 +1966,7 @@ int dsa_slave_change_mtu(struct net_device *dev, int new_mtu)
 
 out_port_failed:
 	if (new_master_mtu != old_master_mtu)
-		dsa_port_mtu_change(cpu_dp, old_master_mtu -
-				    dsa_tag_protocol_overhead(cpu_dp->tag_ops));
+		dsa_port_mtu_change(cpu_dp, old_master_mtu - overhead);
 out_cpu_failed:
 	if (new_master_mtu != old_master_mtu)
 		dev_set_mtu(master, old_master_mtu);
-- 
2.39.2



