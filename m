Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E66203B47D5;
	Sat, 12 Sep 2026 09:29:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789205354; cv=none; b=pXUHWVs0Rf8LZl4qM6uSgbR7FWTAiT43S6LrsfVu46l9sq6gQl/BlqK307xPTA0bOMr5hocVFZWwwjjHeEJ3/TypXbrSx22mRUwyPRjA6VwEqPQO9ua03CG0pbpKdl9aOB+w842WfEMmy68Rx20CXefMRvk1yGKVTZxaud175aQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789205354; c=relaxed/simple;
	bh=J4HmOV3Wcf5QWIQUxbpLK5prdjhXOqWpSo+KkApYw9I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n8laq3gzxDfaYqaihSnnFg6Rvup9HWKBu4Kc4Ygaa18LU+y5nWLekFj1lCGC4QJAe3MCkrZ2MPdN2KmoCGpT5qxqYgWuQLdrDlfzth8ZdeS27aBY5ExVwhvnSWMVtArVZOu3RNKLrtCy8aUrnS+nPYrC7xUfFfldblF7zLTi8mI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FA1W1b/K; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FA1W1b/K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7A5A1F000FF;
	Sat, 12 Sep 2026 09:29:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789205352;
	bh=KGnEwOEgJY/XxsufeT15DQW4B4+Klz29VsJhOfZZAcs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FA1W1b/KVpIEHCIFg8DoLR9BkedQo/aWZTJvu8lWrG6hzqMqDKoaUSFdC8sF7VnII
	 K4aDCtwg0KqGbStSMAAeg6Th8/dIQvwvU26jT/LA7kBQww9YAFShlvNf6H2TuveNdW
	 hHPRKFz1RvWqFLcmdCsXRSK6l87QgbB+42XKxwK4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maxime Chevallier <maxime.chevallier@bootlin.com>,
	Andrew Lunn <andrew@lunn.ch>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1801/1815] net: stmmac: selftests: Account for the UC filter list for filtering tests
Date: Sat, 12 Sep 2026 08:59:11 +0200
Message-ID: <20260912065731.317663648@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
index d9d95f5352cf8..5e99d8ca773d8 100644
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



