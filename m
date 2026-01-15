Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFD093B52ED;
	Thu, 15 Jan 2026 16:57:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768496256; cv=none; b=iNobKRrAfLuz+0AmgykEDmiibzRaeGYYST1ZcDTbCdadcXeH6Giipv8n2JE6Y7bzOZ+ml/ANPlUQT2957rNAnwwFwf5DdQQeoGZCYsbBOTSDP6JPwqqX4Dz1S+lySMJ49rT04ZuBcayPAwJ1euwhC+YYFPk+u7wwpYYjKDVFXN0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768496256; c=relaxed/simple;
	bh=UE6f05RQ/CCPVF7dbFJRNza5hMsMeo+LLJYhnH5qhDQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XFNYjh6TfYugsFFozI+EL1PEOCzrpY6y/3hGP165AMCqdkDLor3G/FxSoKo+II262lpTtmN3h//3EEI3XLpqxuhfZRnqF5/R2z4ZXHmYr5sBFB6OA1Bg2IVaRnV/94AzkrMhKmPFJTYaeRnrgwChztjqbtn7MDW5oD5P00SBBE4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bHtABJPx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bHtABJPx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6985EC116D0;
	Thu, 15 Jan 2026 16:57:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768496256;
	bh=UE6f05RQ/CCPVF7dbFJRNza5hMsMeo+LLJYhnH5qhDQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bHtABJPxVH5xqm42tGGavkfLL3f051G8FbuDC5cn804gZsTWfUTYym0f2XuqRbAkG
	 47Yv2zEIhCpWzZVq/6zQtgw5LgPOsQuqOYVMhj8Cc2W8e3RUGVUcDgtUlNNV+V9ttT
	 5xN5EP3SWiy4Vn16g/KMqB1Oh5l/SZ2L4/KDAaUU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sreedevi Joshi <sreedevi.joshi@intel.com>,
	Aleksandr Loktionov <aleksandr.loktionov@intel.com>,
	Sridhar Samudrala <sridhar.samudrala@intel.com>,
	Emil Tantilov <emil.s.tantilov@intel.com>,
	Samuel Salin <Samuel.salin@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 132/181] idpf: Fix RSS LUT configuration on down interfaces
Date: Thu, 15 Jan 2026 17:47:49 +0100
Message-ID: <20260115164207.087304829@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164202.305475649@linuxfoundation.org>
References: <20260115164202.305475649@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sreedevi Joshi <sreedevi.joshi@intel.com>

[ Upstream commit 445b49d13787da2fe8d51891ee196e5077feef44 ]

RSS LUT provisioning and queries on a down interface currently return
silently without effect. Users should be able to configure RSS settings
even when the interface is down.

Fix by maintaining RSS configuration changes in the driver's soft copy and
deferring HW programming until the interface comes up.

Fixes: 02cbfba1add5 ("idpf: add ethtool callbacks")
Signed-off-by: Sreedevi Joshi <sreedevi.joshi@intel.com>
Reviewed-by: Aleksandr Loktionov <aleksandr.loktionov@intel.com>
Reviewed-by: Sridhar Samudrala <sridhar.samudrala@intel.com>
Reviewed-by: Emil Tantilov <emil.s.tantilov@intel.com>
Tested-by: Samuel Salin <Samuel.salin@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/idpf/idpf_ethtool.c | 18 +++++++++++-------
 1 file changed, 11 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/intel/idpf/idpf_ethtool.c b/drivers/net/ethernet/intel/idpf/idpf_ethtool.c
index 8e9a93125b4aa..3e191cf528b69 100644
--- a/drivers/net/ethernet/intel/idpf/idpf_ethtool.c
+++ b/drivers/net/ethernet/intel/idpf/idpf_ethtool.c
@@ -395,7 +395,10 @@ static u32 idpf_get_rxfh_indir_size(struct net_device *netdev)
  * @netdev: network interface device structure
  * @rxfh: pointer to param struct (indir, key, hfunc)
  *
- * Reads the indirection table directly from the hardware. Always returns 0.
+ * RSS LUT and Key information are read from driver's cached
+ * copy. When rxhash is off, rss lut will be displayed as zeros.
+ *
+ * Return: 0 on success, -errno otherwise.
  */
 static int idpf_get_rxfh(struct net_device *netdev,
 			 struct ethtool_rxfh_param *rxfh)
@@ -403,10 +406,13 @@ static int idpf_get_rxfh(struct net_device *netdev,
 	struct idpf_netdev_priv *np = netdev_priv(netdev);
 	struct idpf_rss_data *rss_data;
 	struct idpf_adapter *adapter;
+	struct idpf_vport *vport;
+	bool rxhash_ena;
 	int err = 0;
 	u16 i;
 
 	idpf_vport_ctrl_lock(netdev);
+	vport = idpf_netdev_to_vport(netdev);
 
 	adapter = np->adapter;
 
@@ -416,9 +422,8 @@ static int idpf_get_rxfh(struct net_device *netdev,
 	}
 
 	rss_data = &adapter->vport_config[np->vport_idx]->user_config.rss_data;
-	if (!test_bit(IDPF_VPORT_UP, np->state))
-		goto unlock_mutex;
 
+	rxhash_ena = idpf_is_feature_ena(vport, NETIF_F_RXHASH);
 	rxfh->hfunc = ETH_RSS_HASH_TOP;
 
 	if (rxfh->key)
@@ -426,7 +431,7 @@ static int idpf_get_rxfh(struct net_device *netdev,
 
 	if (rxfh->indir) {
 		for (i = 0; i < rss_data->rss_lut_size; i++)
-			rxfh->indir[i] = rss_data->rss_lut[i];
+			rxfh->indir[i] = rxhash_ena ? rss_data->rss_lut[i] : 0;
 	}
 
 unlock_mutex:
@@ -466,8 +471,6 @@ static int idpf_set_rxfh(struct net_device *netdev,
 	}
 
 	rss_data = &adapter->vport_config[vport->idx]->user_config.rss_data;
-	if (!test_bit(IDPF_VPORT_UP, np->state))
-		goto unlock_mutex;
 
 	if (rxfh->hfunc != ETH_RSS_HASH_NO_CHANGE &&
 	    rxfh->hfunc != ETH_RSS_HASH_TOP) {
@@ -483,7 +486,8 @@ static int idpf_set_rxfh(struct net_device *netdev,
 			rss_data->rss_lut[lut] = rxfh->indir[lut];
 	}
 
-	err = idpf_config_rss(vport);
+	if (test_bit(IDPF_VPORT_UP, np->state))
+		err = idpf_config_rss(vport);
 
 unlock_mutex:
 	idpf_vport_ctrl_unlock(netdev);
-- 
2.51.0



