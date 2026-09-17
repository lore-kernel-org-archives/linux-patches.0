Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64BE0547041;
	Thu, 17 Sep 2026 18:41:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789670467; cv=none; b=de33DVGvRSVADVOJHHVI+UnkPERuU210lPHo2sQLsPBAhbBg+FqHbe9BTN+fcXTaiuhgCtbk86GGd5HMwl7ZVsDdnZjfl2qZSBGn/717qMKy4DtKO3SvZhIs9eb0SybghTHjvXuLPuUse6qhbnUq4GwxAtzQeYKKMlgA39iPxjA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789670467; c=relaxed/simple;
	bh=VsxU1GMjoDbRHBSf35cys4LLIjg0AZDYs0txdY6ERzY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tbG+Kedu54GRHJIQPdqHzR3AbEmjF3Fre+5KutdODj2peTkxKs2ypGCjXARWxaE7QbuXwkxIRjVnBGvPZTLDaB0YaIBkCMehlaXvzr7hbJC911an+mgAzou8NpSBoy7Jm8MJ+KJJNFYplXBa1Mrov+2J85YghPyOiwN4X1kRIqQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KHXzI2Dw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KHXzI2Dw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A2091F000FF;
	Thu, 17 Sep 2026 18:41:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789670466;
	bh=B3r0wpeWT8stphVYoo4yyj57pDHxpr+87r0YZl69qng=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KHXzI2DwI9zyreQTDc9RXitRaTXS1TSH0G3u8UkKzxM5DT/dmVygMPOdXMsIimmiw
	 Plcrg8hthpuT6lPHnkdQ21mt5VF0xEYeYZNk83aVCZJz+6raG26ng7tsTcd8mUVt3/
	 0XN/ETcPB++DDqhp5V9u+6osMOVBCSeiB7F6vFV4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0669/1102] net: ethtool: add dedicated callbacks for getting and setting rxfh fields
Date: Thu, 17 Sep 2026 16:10:12 +0100
Message-ID: <20260917151557.012232462@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jakub Kicinski <kuba@kernel.org>

[ Upstream commit 9bb00786fc61e865e121aa20dd12aa4d1311a990 ]

We mux multiple calls to the drivers via the .get_nfc and .set_nfc
callbacks. This is slightly inconvenient to the drivers as they
have to de-mux them back. It will also be awkward for netlink code
to construct struct ethtool_rxnfc when it wants to get info about
RX Flow Hash, from the RSS module.

Add dedicated driver callbacks. Create struct ethtool_rxfh_fields
which contains only data relevant to RXFH. Maintain the names of
the fields to avoid having to heavily modify the drivers.

For now support both callbacks, once all drivers are converted
ethtool_*et_rxfh_fields() will stop using the rxnfc callbacks.

Link: https://patch.msgid.link/20250611145949.2674086-5-kuba@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: f1986bf87b07 ("eth: nfp: bound the ntuple rule dump by the caller's buffer size")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/ethtool.h | 20 +++++++++++++++
 net/ethtool/ioctl.c     | 55 +++++++++++++++++++++++++++++++++--------
 2 files changed, 65 insertions(+), 10 deletions(-)

diff --git a/include/linux/ethtool.h b/include/linux/ethtool.h
index 913286e16a3e0..a47a98d446094 100644
--- a/include/linux/ethtool.h
+++ b/include/linux/ethtool.h
@@ -729,6 +729,19 @@ struct ethtool_rxfh_param {
 	u8	input_xfrm;
 };
 
+/**
+ * struct ethtool_rxfh_fields - Rx Flow Hashing (RXFH) header field config
+ * @data: which header fields are used for hashing, bitmask of RXH_* defines
+ * @flow_type: L2-L4 network traffic flow type
+ * @rss_context: RSS context, will only be used if rxfh_per_ctx_fields is
+ *	set in struct ethtool_ops
+ */
+struct ethtool_rxfh_fields {
+	u32 data;
+	u32 flow_type;
+	u32 rss_context;
+};
+
 /**
  * struct kernel_ethtool_ts_info - kernel copy of struct ethtool_ts_info
  * @cmd: command number = %ETHTOOL_GET_TS_INFO
@@ -867,6 +880,8 @@ struct kernel_ethtool_ts_info {
  *	will remain unchanged.
  *	Returns a negative error code or zero. An error code must be returned
  *	if at least one unsupported change was requested.
+ * @get_rxfh_fields: Get header fields used for flow hashing.
+ * @set_rxfh_fields: Set header fields used for flow hashing.
  * @create_rxfh_context: Create a new RSS context with the specified RX flow
  *	hash indirection table, hash key, and hash function.
  *	The &struct ethtool_rxfh_context for this context is passed in @ctx;
@@ -1051,6 +1066,11 @@ struct ethtool_ops {
 	int	(*get_rxfh)(struct net_device *, struct ethtool_rxfh_param *);
 	int	(*set_rxfh)(struct net_device *, struct ethtool_rxfh_param *,
 			    struct netlink_ext_ack *extack);
+	int	(*get_rxfh_fields)(struct net_device *,
+				   struct ethtool_rxfh_fields *);
+	int	(*set_rxfh_fields)(struct net_device *,
+				   const struct ethtool_rxfh_fields *,
+				   struct netlink_ext_ack *extack);
 	int	(*create_rxfh_context)(struct net_device *,
 				       struct ethtool_rxfh_context *ctx,
 				       const struct ethtool_rxfh_param *rxfh,
diff --git a/net/ethtool/ioctl.c b/net/ethtool/ioctl.c
index f5f2db4b53ca6..c567370d96666 100644
--- a/net/ethtool/ioctl.c
+++ b/net/ethtool/ioctl.c
@@ -1047,9 +1047,20 @@ static int ethtool_check_flow_types(struct net_device *dev, u32 input_xfrm)
 			continue;
 
 		info.flow_type = i;
-		err = ops->get_rxnfc(dev, &info, NULL);
-		if (err)
-			continue;
+
+		if (ops->get_rxfh_fields) {
+			struct ethtool_rxfh_fields fields = {
+				.flow_type	= info.flow_type,
+			};
+
+			if (ops->get_rxfh_fields(dev, &fields))
+				continue;
+
+			info.data = fields.data;
+		} else {
+			if (ops->get_rxnfc(dev, &info, NULL))
+				continue;
+		}
 
 		err = ethtool_check_xfrm_rxfh(input_xfrm, info.data);
 		if (err)
@@ -1063,11 +1074,12 @@ static noinline_for_stack int
 ethtool_set_rxfh_fields(struct net_device *dev, u32 cmd, void __user *useraddr)
 {
 	const struct ethtool_ops *ops = dev->ethtool_ops;
+	struct ethtool_rxfh_fields fields = {};
 	struct ethtool_rxnfc info;
 	size_t info_size = sizeof(info);
 	int rc;
 
-	if (!ops->set_rxnfc)
+	if (!ops->set_rxnfc && !ops->set_rxfh_fields)
 		return -EOPNOTSUPP;
 
 	rc = ethtool_rxnfc_copy_struct(cmd, &info, &info_size, useraddr);
@@ -1090,7 +1102,15 @@ ethtool_set_rxfh_fields(struct net_device *dev, u32 cmd, void __user *useraddr)
 			return rc;
 	}
 
-	return ops->set_rxnfc(dev, &info);
+	if (!ops->set_rxfh_fields)
+		return ops->set_rxnfc(dev, &info);
+
+	fields.data = info.data;
+	fields.flow_type = info.flow_type & ~FLOW_RSS;
+	if (info.flow_type & FLOW_RSS)
+		fields.rss_context = info.rss_context;
+
+	return ops->set_rxfh_fields(dev, &fields, NULL);
 }
 
 static noinline_for_stack int
@@ -1101,7 +1121,7 @@ ethtool_get_rxfh_fields(struct net_device *dev, u32 cmd, void __user *useraddr)
 	const struct ethtool_ops *ops = dev->ethtool_ops;
 	int ret;
 
-	if (!ops->get_rxnfc)
+	if (!ops->get_rxnfc && !ops->get_rxfh_fields)
 		return -EOPNOTSUPP;
 
 	ret = ethtool_rxnfc_copy_struct(cmd, &info, &info_size, useraddr);
@@ -1112,9 +1132,24 @@ ethtool_get_rxfh_fields(struct net_device *dev, u32 cmd, void __user *useraddr)
 	    !ops->rxfh_per_ctx_fields)
 		return -EINVAL;
 
-	ret = ops->get_rxnfc(dev, &info, NULL);
-	if (ret < 0)
-		return ret;
+	if (ops->get_rxfh_fields) {
+		struct ethtool_rxfh_fields fields = {
+			.flow_type	= info.flow_type & ~FLOW_RSS,
+		};
+
+		if (info.flow_type & FLOW_RSS)
+			fields.rss_context = info.rss_context;
+
+		ret = ops->get_rxfh_fields(dev, &fields);
+		if (ret < 0)
+			return ret;
+
+		info.data = fields.data;
+	} else {
+		ret = ops->get_rxnfc(dev, &info, NULL);
+		if (ret < 0)
+			return ret;
+	}
 
 	return ethtool_rxnfc_copy_to_user(useraddr, &info, info_size, NULL);
 }
@@ -1485,7 +1520,7 @@ static noinline_for_stack int ethtool_set_rxfh(struct net_device *dev,
 	u8 *rss_config;
 	int ret;
 
-	if (!ops->get_rxnfc || !ops->set_rxfh)
+	if ((!ops->get_rxnfc && !ops->get_rxfh_fields) || !ops->set_rxfh)
 		return -EOPNOTSUPP;
 
 	if (ops->get_rxfh_indir_size)
-- 
2.53.0



