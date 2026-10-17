Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA71F392C27;
	Sat, 17 Oct 2026 16:51:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792255882; cv=none; b=oeJHBMwc7yV9rYHQENulpSHSrQWhvN4TGvn5hyLT8KMdXtBmDCyXjix7Vb9L9ZW/UrCOHbUKHbHOxq/RaQkdv1zWfSkrqQv7cWrWgawv/DAoRKaXrd907+Kw4yYjiIXcbaJDaF4lyKIiqkvJyNcBM3hXBVLdlx4IKK8bTrnjkJc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792255882; c=relaxed/simple;
	bh=WjAUwP6cvxQ47R68UmNnhZI33f9UZSH/rgHpmscY1lE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UFki7aeV3+xDM1gDyNTDmKgSXavziWfqBkAIeMBAsWTJq74mdC26pVoChFOCZAXh3qubdoH8r5573uJd7o2Wv/yraPe+6z9xsMuowOcYZnJSsl+r/Tq3qzYwYKzq5mokqJI7rJf3+nu02cFfQWgAFINX5pTsEP8tzPbobCIP45k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vtgBSj7D; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vtgBSj7D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D4971F000C5;
	Sat, 17 Oct 2026 16:51:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792255881;
	bh=W2p8QG7oxs02yht3PtoB3FPUmDh0PGT0L6WeEYAoE6w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vtgBSj7D/AjsTBDyjo+8Hunt40hOnHc4yLr1Bp5olo9xHaKV9M73d3BLdAlEf3jf9
	 CckunliFe4bDb/GWgUuqjErpcSci2WFSN6D05QNqtPgbKx1T1cELqvnFsAv/8wdmFL
	 2gyVycExqro7/eDAD5tTG6A/XRz5ZiJZ/R7eI5Y8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jacob Keller <jacob.e.keller@intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Artem Dinaburg <artem@trailofbits.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0052/1674] ethtool: fail closed if we cant get max channel used in indirection tables
Date: Sat, 17 Oct 2026 17:38:44 +0200
Message-ID: <20261017160432.474643137@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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

[ Backport to 6.6.y: mapped the newer rxfh-parameter callback to the
  older raw indirection-table callback. ]

Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
Link: https://patch.msgid.link/20240710174043.754664-2-kuba@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Assisted-by: LLM
Signed-off-by: Artem Dinaburg <artem@trailofbits.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ethtool/channels.c |  6 ++----
 net/ethtool/common.c   | 22 +++++++++++++---------
 net/ethtool/common.h   |  2 +-
 net/ethtool/ioctl.c    |  4 +---
 4 files changed, 17 insertions(+), 17 deletions(-)

diff --git a/net/ethtool/channels.c b/net/ethtool/channels.c
index 7b4bbd674bae7..cee188da54f85 100644
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
index f5598c5f50de9..30fa329fec05d 100644
--- a/net/ethtool/common.c
+++ b/net/ethtool/common.c
@@ -587,35 +587,39 @@ int ethtool_get_max_rxnfc_channel(struct net_device *dev, u64 *max)
 	return err;
 }
 
-int ethtool_get_max_rxfh_channel(struct net_device *dev, u32 *max)
+u32 ethtool_get_max_rxfh_channel(struct net_device *dev)
 {
-	u32 dev_size, current_max = 0;
+	u32 dev_size, current_max;
 	u32 *indir;
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
 
 	indir = kcalloc(dev_size, sizeof(indir[0]), GFP_USER);
 	if (!indir)
-		return -ENOMEM;
+		return U32_MAX;
 
 	ret = dev->ethtool_ops->get_rxfh(dev, indir, NULL, NULL);
-	if (ret)
+	if (ret) {
+		current_max = U32_MAX;
 		goto out;
+	}
 
+	current_max = 0;
 	while (dev_size--)
 		current_max = max(current_max, indir[dev_size]);
 
-	*max = current_max;
-
 out:
 	kfree(indir);
-	return ret;
+	return current_max;
 }
 
 int ethtool_check_ops(const struct ethtool_ops *ops)
diff --git a/net/ethtool/common.h b/net/ethtool/common.h
index 28b8aaaf9bcb3..b55705a9ad5aa 100644
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
index eaeb514b7e5f6..8eaf786eb0c7f 100644
--- a/net/ethtool/ioctl.c
+++ b/net/ethtool/ioctl.c
@@ -1847,9 +1847,7 @@ static noinline_for_stack int ethtool_set_channels(struct net_device *dev,
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
2.53.0



