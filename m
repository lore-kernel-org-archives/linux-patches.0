Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 885092DF3EA;
	Tue, 21 Jul 2026 18:52:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784659970; cv=none; b=L87AHT/Xh6aPQcw4/VOLLErE69PV1zL9JVJt0RlWltqNP3a/f1BBZ9frtw75jO1bdIZVracN58nuzHoyWKyczCzSo5UT/s07iwT9gkoeM0ZYHQ6wF+HJvMd/rDOeenz8A9yvUWQw8n4Kk37CURlusvRC05CpqTCfWp7Q4ju2TSk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784659970; c=relaxed/simple;
	bh=nN7g0Q+8/EYV+Shkbz0uQqGGSOBQIPBf1v2oJSHghyA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n7N+e7K7vDbjJqqYDZUc5ojuslRJuQEYwajCTHTBbhV6JjXhX04ssT13mQT7BfyZG/0zWr4HZvxR8/oVp8OsRFS+Zcz4yjOc6AuJzCjSAkoiPMfuAMLk8bHegYYZ01BVXqjezT4gC7usUVJr0AjCwJtnOwkpLBHBUPCaVnaUwQM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PZQBoEGn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PZQBoEGn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7B1A1F000E9;
	Tue, 21 Jul 2026 18:52:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784659969;
	bh=xOOgMrpIEotfqmJn/nP8LACIpOVqK2rKIlAaYfA9fNM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PZQBoEGnqlvEjgXwkCFK2dWh0k5u4XETwajlnnMe/rfP48lGt2Jmcic/u/gHuZqcO
	 qTBUwVbU7hbxeC7+PeGcvA9aZyJMNy6PjtfaKjmQzcYPxxzph2SwouX9SzXGX3pU9B
	 1kkiOArjDRzWbAvB7wr7a3ThLsvnRZltEwuPZ92E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Brett Creeley <brett.creeley@amd.com>,
	Eric Joyner <eric.joyner@amd.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0802/2077] ionic: Fix check in ionic_get_link_ext_stats
Date: Tue, 21 Jul 2026 17:07:55 +0200
Message-ID: <20260721152611.708851777@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Brett Creeley <brett.creeley@amd.com>

[ Upstream commit 7678e69079c10b2fb10977f28f44ddb22971ea5b ]

The current check will fail if SR-IOV is not initialized for the
physical function; this is because is_physfn is 0 if sriov_init() isn't
run or fails. Change the check that prevents getting the link down count
to use is_virtfn instead so that VFs don't get this functionality, which
was the original intent.

Fixes: 132b4ebfa090 ("ionic: add support for ethtool extended stat link_down_count")
Signed-off-by: Brett Creeley <brett.creeley@amd.com>
Signed-off-by: Eric Joyner <eric.joyner@amd.com>
Link: https://patch.msgid.link/20260614205303.48088-2-eric.joyner@amd.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/pensando/ionic/ionic_ethtool.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_ethtool.c b/drivers/net/ethernet/pensando/ionic/ionic_ethtool.c
index 78a802eb159f0a..6069fa46091318 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_ethtool.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_ethtool.c
@@ -116,8 +116,15 @@ static void ionic_get_link_ext_stats(struct net_device *netdev,
 {
 	struct ionic_lif *lif = netdev_priv(netdev);
 
-	if (lif->ionic->pdev->is_physfn)
-		stats->link_down_events = lif->link_down_count;
+	if (lif->ionic->pdev->is_virtfn)
+		return;
+
+	if (!lif->ionic->idev.port_info) {
+		netdev_err_once(netdev, "port_info not initialized\n");
+		return;
+	}
+
+	stats->link_down_events = lif->link_down_count;
 }
 
 static int ionic_get_link_ksettings(struct net_device *netdev,
-- 
2.53.0



