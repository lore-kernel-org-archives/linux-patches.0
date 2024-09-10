Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21C26224F6;
	Tue, 10 Sep 2024 09:52:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725961958; cv=none; b=ADjt8U6K0+Nm8pvxkEelkPKYmoND6D1r21/25ajQh+EPwncoBKdQqbC3DAMjLovXpOSiF3IuMaIdsW8d5S4gJGpsH51t/8CmxRua/6DJgCQoMZDSjGs/Ze13hxYY8iBr6eiZ7eDhAeg1tgyeWOLkWSnlhJ1x1dkz+Pbf5olsXlI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725961958; c=relaxed/simple;
	bh=KJqvWugf6E8tQUtvc4gJoh/+gM70k5LH8NxHgqRbO+k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a3Kh+oJYV744fL+Bg+3FA5bgc5T+ExV5dvaZ7qNploDws2EI2vGx4Bq3XIXuyii55v3CcRj8+5OrXSfA3DBiANuIrMDoAmwyYzMm/HcBapyXsh7/ZdUQM2Ikb5FpsF9VCPwxkP0Qh1B34MxKzhzvCdMA4grzQMvEbreueRkPeXM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nxdQ1qJC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nxdQ1qJC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FA57C4CEC3;
	Tue, 10 Sep 2024 09:52:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725961958;
	bh=KJqvWugf6E8tQUtvc4gJoh/+gM70k5LH8NxHgqRbO+k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nxdQ1qJCHnn8ODPy71QXJa1g2/ISJjDfnJKANQ/9dCq5wVmuuhsB0YEPvQbJV6QE+
	 bL1baHHL7u8mqzt9alsHRhNWVmInkgDKp4dFAd0QotB1ovhvqZR6LkWgtTpmj8OLsY
	 M1H6ioQB1jStQ/eoD8csndJGVOyMVlCsOzfkA924=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jacob Keller <jacob.e.keller@intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 246/375] ethtool: fail closed if we cant get max channel used in indirection tables
Date: Tue, 10 Sep 2024 11:30:43 +0200
Message-ID: <20240910092630.810973307@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092622.245959861@linuxfoundation.org>
References: <20240910092622.245959861@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jakub Kicinski <kuba@kernel.org>

[ Upstream commit 2899d58462ba868287d6ff3acad3675e7adf934f ]

Commit 0d1b7d6c9274 ("bnxt: fix crashes when reducing ring count with
active RSS contexts") proves that allowing indirection table to contain
channels with out of bounds IDs may lead to crashes. Currently the
max channel check in the core gets skipped if driver can't fetch
the indirection table or when we can't allocate memory.

Both of those conditions should be extremely rare but if they do
happen we should try to be safe and fail the channel change.

Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
Link: https://patch.msgid.link/20240710174043.754664-2-kuba@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ethtool/channels.c |  6 ++----
 net/ethtool/common.c   | 26 +++++++++++++++-----------
 net/ethtool/common.h   |  2 +-
 net/ethtool/ioctl.c    |  4 +---
 4 files changed, 19 insertions(+), 19 deletions(-)

diff --git a/net/ethtool/channels.c b/net/ethtool/channels.c
index 7b4bbd674bae..cee188da54f8 100644
--- a/net/ethtool/channels.c
+++ b/net/ethtool/channels.c
@@ -171,11 +171,9 @@ ethnl_set_channels(struct ethnl_req_info *req_info, struct genl_info *info)
 	 */
 	if (ethtool_get_max_rxnfc_channel(dev, &max_rxnfc_in_use))
 		max_rxnfc_in_use = 0;
-	if (!netif_is_rxfh_configured(dev) ||
-	    ethtool_get_max_rxfh_channel(dev, &max_rxfh_in_use))
-		max_rxfh_in_use = 0;
+	max_rxfh_in_use = ethtool_get_max_rxfh_channel(dev);
 	if (channels.combined_count + channels.rx_count <= max_rxfh_in_use) {
-		GENL_SET_ERR_MSG(info, "requested channel counts are too low for existing indirection table settings");
+		GENL_SET_ERR_MSG_FMT(info, "requested channel counts are too low for existing indirection table (%d)", max_rxfh_in_use);
 		return -EINVAL;
 	}
 	if (channels.combined_count + channels.rx_count <= max_rxnfc_in_use) {
diff --git a/net/ethtool/common.c b/net/ethtool/common.c
index 6b2a360dcdf0..8a62375ebd1f 100644
--- a/net/ethtool/common.c
+++ b/net/ethtool/common.c
@@ -587,35 +587,39 @@ int ethtool_get_max_rxnfc_channel(struct net_device *dev, u64 *max)
 	return err;
 }
 
-int ethtool_get_max_rxfh_channel(struct net_device *dev, u32 *max)
+u32 ethtool_get_max_rxfh_channel(struct net_device *dev)
 {
 	struct ethtool_rxfh_param rxfh = {};
-	u32 dev_size, current_max = 0;
+	u32 dev_size, current_max;
 	int ret;
 
+	if (!netif_is_rxfh_configured(dev))
+		return 0;
+
 	if (!dev->ethtool_ops->get_rxfh_indir_size ||
 	    !dev->ethtool_ops->get_rxfh)
-		return -EOPNOTSUPP;
+		return 0;
 	dev_size = dev->ethtool_ops->get_rxfh_indir_size(dev);
 	if (dev_size == 0)
-		return -EOPNOTSUPP;
+		return 0;
 
 	rxfh.indir = kcalloc(dev_size, sizeof(rxfh.indir[0]), GFP_USER);
 	if (!rxfh.indir)
-		return -ENOMEM;
+		return U32_MAX;
 
 	ret = dev->ethtool_ops->get_rxfh(dev, &rxfh);
-	if (ret)
-		goto out;
+	if (ret) {
+		current_max = U32_MAX;
+		goto out_free;
+	}
 
+	current_max = 0;
 	while (dev_size--)
 		current_max = max(current_max, rxfh.indir[dev_size]);
 
-	*max = current_max;
-
-out:
+out_free:
 	kfree(rxfh.indir);
-	return ret;
+	return current_max;
 }
 
 int ethtool_check_ops(const struct ethtool_ops *ops)
diff --git a/net/ethtool/common.h b/net/ethtool/common.h
index 28b8aaaf9bcb..b55705a9ad5a 100644
--- a/net/ethtool/common.h
+++ b/net/ethtool/common.h
@@ -42,7 +42,7 @@ int __ethtool_get_link(struct net_device *dev);
 bool convert_legacy_settings_to_link_ksettings(
 	struct ethtool_link_ksettings *link_ksettings,
 	const struct ethtool_cmd *legacy_settings);
-int ethtool_get_max_rxfh_channel(struct net_device *dev, u32 *max);
+u32 ethtool_get_max_rxfh_channel(struct net_device *dev);
 int ethtool_get_max_rxnfc_channel(struct net_device *dev, u64 *max);
 int __ethtool_get_ts_info(struct net_device *dev, struct ethtool_ts_info *info);
 
diff --git a/net/ethtool/ioctl.c b/net/ethtool/ioctl.c
index f99fd564d0ee..2f5b69d5d4b0 100644
--- a/net/ethtool/ioctl.c
+++ b/net/ethtool/ioctl.c
@@ -1928,9 +1928,7 @@ static noinline_for_stack int ethtool_set_channels(struct net_device *dev,
 	 * indirection table/rxnfc settings */
 	if (ethtool_get_max_rxnfc_channel(dev, &max_rxnfc_in_use))
 		max_rxnfc_in_use = 0;
-	if (!netif_is_rxfh_configured(dev) ||
-	    ethtool_get_max_rxfh_channel(dev, &max_rxfh_in_use))
-		max_rxfh_in_use = 0;
+	max_rxfh_in_use = ethtool_get_max_rxfh_channel(dev);
 	if (channels.combined_count + channels.rx_count <=
 	    max_t(u64, max_rxnfc_in_use, max_rxfh_in_use))
 		return -EINVAL;
-- 
2.43.0



