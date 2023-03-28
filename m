Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DDE28BE0
	for <patches@lists.linux.dev>; Tue, 28 Mar 2023 15:00:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7DCDC4339B;
	Tue, 28 Mar 2023 15:00:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1680015627;
	bh=Ch8xmVFoFAeB8JWHwlyotTwrME0To3rFSw8EEP2tmWI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2nOjS4B8IpuL2d2TyNrxA31nhc8cBySUoMUrEDdQLiBDV54WEAbIl8wOEB3mPnxhj
	 /O5VCYkJ3KXCGGdtuMjgSvNTeBSg9CPTmfoIxPhpOnky4B0iECbVGyeTCM9PrspdMA
	 iaa3UxuUaejsDXKftDg91r50otDytgWWSFQMKjOI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joshua Washington <joshwash@google.com>,
	Simon Horman <simon.horman@corigine.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 085/224] gve: Cache link_speed value from device
Date: Tue, 28 Mar 2023 16:41:21 +0200
Message-Id: <20230328142620.813987850@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230328142617.205414124@linuxfoundation.org>
References: <20230328142617.205414124@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Joshua Washington <joshwash@google.com>

[ Upstream commit 68c3e4fc8628b1487c965aabb29207249657eb5f ]

The link speed is never changed for the uptime of a VM, and the current
implementation sends an admin queue command for each call. Admin queue
command invocations have nontrivial overhead (e.g., VM exits), which can
be disruptive to users if triggered frequently. Our telemetry data shows
that there are VMs that make frequent calls to this admin queue command.
Caching the result of the original admin queue command would eliminate
the need to send multiple admin queue commands on subsequent calls to
retrieve link speed.

Fixes: 7e074d5a76ca ("gve: Enable Link Speed Reporting in the driver.")
Signed-off-by: Joshua Washington <joshwash@google.com>
Reviewed-by: Simon Horman <simon.horman@corigine.com>
Link: https://lore.kernel.org/r/20230321172332.91678-1-joshwash@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/google/gve/gve_ethtool.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/google/gve/gve_ethtool.c b/drivers/net/ethernet/google/gve/gve_ethtool.c
index 7b9a2d9d96243..38df602f2869c 100644
--- a/drivers/net/ethernet/google/gve/gve_ethtool.c
+++ b/drivers/net/ethernet/google/gve/gve_ethtool.c
@@ -535,7 +535,10 @@ static int gve_get_link_ksettings(struct net_device *netdev,
 				  struct ethtool_link_ksettings *cmd)
 {
 	struct gve_priv *priv = netdev_priv(netdev);
-	int err = gve_adminq_report_link_speed(priv);
+	int err = 0;
+
+	if (priv->link_speed == 0)
+		err = gve_adminq_report_link_speed(priv);
 
 	cmd->base.speed = priv->link_speed;
 	return err;
-- 
2.39.2



