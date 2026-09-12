Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDAB33B19DB;
	Sat, 12 Sep 2026 20:05:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789243530; cv=none; b=Elws+XH9bUc6HOFmkV1tzq1X4+Z7vZY+E3+HZLaC01y6tj603yLmHJ1XS79nPOy+3GfmlBY4gCO4smGaxtAsMqIpRhd1BzhkQdooIrzp4eXAZDrfC1FmEtuGQdwK9vaDwhdTMRD50HmoiodD9FU3CZN5q/y89u6+nuHkz37MLs4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789243530; c=relaxed/simple;
	bh=j3rs8717DUzw+jask72lj5QKgg1FRQ1nJSujI1mv+ew=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HAciZy+6wlhq6t3aZNocPCwcUv2WPpQTlkft6npKGSE7otvImp7awJNHlxiZoftrtfF3CmICQNzcvTEAfxj03A1q9nDf4Iiv4PRC1arRyC4ZkYyPson6WHT8k6mhbuAEPOpl2rPAxcC3gCSXlu4MvBq4WiPrgIrohFQ/455u9ig=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Y/DWPNxQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Y/DWPNxQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDDF81F00893;
	Sat, 12 Sep 2026 20:05:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789243521;
	bh=ZEy1iGA1eg9qIe+jbqyoi83Z+6ZVcI7HaV2a9IaAh4Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Y/DWPNxQaHWSkh8Rsc5q0fphhqT01ljPOZ2oyRTpzG1SA9lPVUhzEQqVGJqxx6BQj
	 /g3m2L1en8+gXE7/t5ZxpfvtrbBFZjqYQXyJ6HT6QOsRtuZrrDQBfkoc3wfHxs+uu3
	 9wr/hVfjW7dMtLbVlzV2jReN7PHGGy2qQqo8dclc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maxime Chevallier <maxime.chevallier@bootlin.com>,
	Andrew Lunn <andrew@lunn.ch>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 782/798] net: stmmac: selftests: Account for the UC filter list for filtering tests
Date: Sat, 12 Sep 2026 09:06:50 +0200
Message-ID: <20260912065534.989219837@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Maxime Chevallier <maxime.chevallier@bootlin.com>

[ Upstream commit cd8c3b2752c684141eab2282e294cae2971a9759 ]

On dwmac, one of the Unicast filter entries is used to store the local
HW addr. This means that we have to use promisc mode for any kind of
unicast filtering if we only have one slot in our unicast filter.

The number of slots available depends on how the IP is integrated, and
we can't autodiscover how many of these slots we have available, so
the DT property snps,perfect-filter-entries can be used to specify how
many are available.

Most IP variants default to 1 if this isn't specified, which is the case
for the amlogic variants (in this case, S905X3).

The stmmac selftests for UC filtering look if we have enough slots in
the filter to store the dev->uc list, but doesn't account for the
device's own MAC address. The dev->uc list's size we get with
netdev_uc_count() also doesn't account for the HW addr.

As the selftest only requires one available slot, in the case of
single-slot platforms, that means we erroneously consider we have enough
room for the test, when we actually don't, and the filtering test fails.

Fixes: 091810dbded9 ("net: stmmac: Introduce selftests support")
Signed-off-by: Maxime Chevallier <maxime.chevallier@bootlin.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Link: https://patch.msgid.link/20260826140500.616466-6-maxime.chevallier@bootlin.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../stmicro/stmmac/stmmac_selftests.c         | 21 ++++++++++++++++---
 1 file changed, 18 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_selftests.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_selftests.c
index 702ba192f803d..5a5002fdbc64d 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_selftests.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_selftests.c
@@ -499,6 +499,21 @@ static int stmmac_filter_check(struct stmmac_priv *priv)
 	return -EOPNOTSUPP;
 }
 
+static int stmmac_uc_filter_check(struct stmmac_priv *priv)
+{
+	/* For tests involving the UC filter, we need at least one empty
+	 * slot in the UC filter. The UC filters contains netdev_uc_count() + 1
+	 * entries: The dev->uc list + one entry for the HW address.
+	 *
+	 * Having an empty slot therefore means netdev_uc_count() + 2 entries
+	 * can fit in the filter
+	 */
+	if (netdev_uc_count(priv->dev) + 2 > priv->hw->unicast_filter_entries)
+		return -EOPNOTSUPP;
+
+	return 0;
+}
+
 static bool stmmac_hash_check(struct stmmac_priv *priv, unsigned char *addr)
 {
 	int mc_offset = 32 - priv->hw->mcast_bits_log2;
@@ -590,7 +605,7 @@ static int stmmac_test_pfilt(struct stmmac_priv *priv)
 
 	if (stmmac_filter_check(priv))
 		return -EOPNOTSUPP;
-	if (netdev_uc_count(priv->dev) >= priv->hw->unicast_filter_entries)
+	if (stmmac_uc_filter_check(priv))
 		return -EOPNOTSUPP;
 
 	while (--tries) {
@@ -634,7 +649,7 @@ static int stmmac_test_mcfilt(struct stmmac_priv *priv)
 
 	if (stmmac_filter_check(priv))
 		return -EOPNOTSUPP;
-	if (netdev_uc_count(priv->dev) >= priv->hw->unicast_filter_entries)
+	if (stmmac_uc_filter_check(priv))
 		return -EOPNOTSUPP;
 	if (netdev_mc_count(priv->dev) >= priv->hw->multicast_filter_bins)
 		return -EOPNOTSUPP;
@@ -680,7 +695,7 @@ static int stmmac_test_ucfilt(struct stmmac_priv *priv)
 
 	if (stmmac_filter_check(priv))
 		return -EOPNOTSUPP;
-	if (netdev_uc_count(priv->dev) >= priv->hw->unicast_filter_entries)
+	if (stmmac_uc_filter_check(priv))
 		return -EOPNOTSUPP;
 	if (netdev_mc_count(priv->dev) >= priv->hw->multicast_filter_bins)
 		return -EOPNOTSUPP;
-- 
2.53.0



