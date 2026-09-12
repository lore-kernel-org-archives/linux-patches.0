Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD736221FD4;
	Sat, 12 Sep 2026 16:55:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789232116; cv=none; b=Dt6TECbmgFqEeCibv0ua3EF2IRtaUOpJjDZnMngLbuZbNaOdpET0nlFBwAqPpuUCH/vt+EovO7zfB86i0MlzFlYKf7UheIZxFd+KSEXMC5oJnLxCen2mAR0WvRPPPratNa8OMG/xvOm4++zAsmLv2ApPrCYQmxByvj2A0vCRx6w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789232116; c=relaxed/simple;
	bh=SP/XmxrTD3ss+swPpQW2u9uapsB8DVyFGXlwWu0TsaA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HMtqaS4mJXTno3MLoDZlhIFSMB0bzwmoTFcuYeKEjFusEGCJn+qE/X+3jHJT1I71vYq9xK4r85YrzCYFkXnYGg35UGu23gBW7WMLsR+ODcw6CPuSutWLqu+8sdmMXSX6daMQS7qHH1/RqMaUHoyC1PWbB6zMmgwUJJoc4ttaIrw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NWv0zhPI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NWv0zhPI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CADEE1F000FF;
	Sat, 12 Sep 2026 16:55:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789232114;
	bh=l2pVhWlzGoRforiOYSFFY+dSmFttL989FO4Hv65ym8g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NWv0zhPIcHiJmDRHtMdeyWeWd9S5qFBANNsKsCTdAwPN6Hj/mZJjM7nrJAlienH/U
	 UDH6c6qhFqba/MOheTnGMolzOrPAwZyNtkIFGAZm2cdDuHprpv2AVgZ5nHPOTc9CAe
	 ggyIPj3Zu7YtM5EX32Jw355Z8eB0ENXj+Y/j4Qdc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maxime Chevallier <maxime.chevallier@bootlin.com>,
	Andrew Lunn <andrew@lunn.ch>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1135/1191] net: stmmac: selftests: Account for the UC filter list for filtering tests
Date: Sat, 12 Sep 2026 09:04:23 +0200
Message-ID: <20260912065613.643854695@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 124e5a78abc26..c0821d95f8e8c 100644
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



