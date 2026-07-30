Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6829143C7D7;
	Thu, 30 Jul 2026 14:35:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785422117; cv=none; b=nKDRlAcRdqj72w5FRXVETlftr8PgqzzbTjZNNoVpcdYRzVwNOUO/ZceUpd5eibnSPwxXQGqFwm7IIvJpyyAQ0uHfOmcZ7lUz2U45DNNM940oBnMo4eONw36nSw4mA8TVmEwuaBznA3zsxeDeQr1YCphzCXFgDcnRHhb+aaozW0s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785422117; c=relaxed/simple;
	bh=khVYHIOaoDV17+yMkjEuZF9pUWb9AdnYmt+5gke8T8g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H4sX/iYPfwNb6jt2h6RuycAoT8et2ZM2xmU1xCzkpqWghIHZowRhFz1zSJ1oIqJGqqSDfTHR40xhe8yTlmSiiKjUtywbJRAxzCTcMKlohjAnc2pMcp1AixxZjg4ClMEBgocBxvcDnwq1BTzrqHY2gpkha96o0Kg4w9xVF0TPDl0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LSUESttK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LSUESttK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C07DE1F000E9;
	Thu, 30 Jul 2026 14:35:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785422116;
	bh=oec+cSFLf1QVDeVQeA1lFopuU7dSlcJ99xGqlTdu2h8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LSUESttK3gjnXJ1fgREQf+4u8ucpXChCsysHIn7D0ygOMf2RtQq0LWFjuIF8vy7X4
	 marRDJxPa+2m5LacxfKSaGY2ostdEMToK5fAZ2bclOmENsWQWaPIghpacVlAhSxiRq
	 zvF8fh7SVF9vCKGam2Gxc1AUfUlliIxhTlHHFQZQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chenguang Zhao <zhaochenguang@kylinos.cn>,
	Joe Damato <joe@dama.to>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 331/744] hinic: remove unused ethtool RSS user configuration buffers
Date: Thu, 30 Jul 2026 16:10:04 +0200
Message-ID: <20260730141451.319630665@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
References: <20260730141444.267951807@linuxfoundation.org>
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

From: Chenguang Zhao <zhaochenguang@kylinos.cn>

[ Upstream commit fe0c002928c6749b7f4a726f6f600f6dd70280ea ]

rss_indir_user and rss_hkey_user are allocated and filled in
__set_rss_rxfh() when the user configures RSS via ethtool, but
nothing ever reads them. hinic_get_rxfh() fetches the state from
the device, and the hardware is programmed from the original
indir/key arguments. These buffers only leaked on driver unload.

Drop the unused allocations, memcpys, and struct fields.

Fixes: 4fdc51bb4e92 ("hinic: add support for rss parameters with ethtool")
Signed-off-by: Chenguang Zhao <zhaochenguang@kylinos.cn>
Reviewed-by: Joe Damato <joe@dama.to>
Link: https://patch.msgid.link/20260722025353.328179-1-chenguang.zhao@linux.dev
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/huawei/hinic/hinic_dev.h |  2 --
 .../net/ethernet/huawei/hinic/hinic_ethtool.c | 21 -------------------
 2 files changed, 23 deletions(-)

diff --git a/drivers/net/ethernet/huawei/hinic/hinic_dev.h b/drivers/net/ethernet/huawei/hinic/hinic_dev.h
index 52ea97c818b8ec..d9ab94910a2a79 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_dev.h
+++ b/drivers/net/ethernet/huawei/hinic/hinic_dev.h
@@ -104,8 +104,6 @@ struct hinic_dev {
 	u16				num_rss;
 	u16				rss_limit;
 	struct hinic_rss_type		rss_type;
-	u8				*rss_hkey_user;
-	s32				*rss_indir_user;
 	struct hinic_intr_coal_info	*rx_intr_coalesce;
 	struct hinic_intr_coal_info	*tx_intr_coalesce;
 	struct hinic_sriov_info sriov_info;
diff --git a/drivers/net/ethernet/huawei/hinic/hinic_ethtool.c b/drivers/net/ethernet/huawei/hinic/hinic_ethtool.c
index a8b129ce1b7e9f..f75e8563f23aee 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_ethtool.c
+++ b/drivers/net/ethernet/huawei/hinic/hinic_ethtool.c
@@ -1064,17 +1064,6 @@ static int __set_rss_rxfh(struct net_device *netdev,
 	int err;
 
 	if (indir) {
-		if (!nic_dev->rss_indir_user) {
-			nic_dev->rss_indir_user =
-				kzalloc(sizeof(u32) * HINIC_RSS_INDIR_SIZE,
-					GFP_KERNEL);
-			if (!nic_dev->rss_indir_user)
-				return -ENOMEM;
-		}
-
-		memcpy(nic_dev->rss_indir_user, indir,
-		       sizeof(u32) * HINIC_RSS_INDIR_SIZE);
-
 		err = hinic_rss_set_indir_tbl(nic_dev,
 					      nic_dev->rss_tmpl_idx, indir);
 		if (err)
@@ -1082,16 +1071,6 @@ static int __set_rss_rxfh(struct net_device *netdev,
 	}
 
 	if (key) {
-		if (!nic_dev->rss_hkey_user) {
-			nic_dev->rss_hkey_user =
-				kzalloc(HINIC_RSS_KEY_SIZE * 2, GFP_KERNEL);
-
-			if (!nic_dev->rss_hkey_user)
-				return -ENOMEM;
-		}
-
-		memcpy(nic_dev->rss_hkey_user, key, HINIC_RSS_KEY_SIZE);
-
 		err = hinic_rss_set_template_tbl(nic_dev,
 						 nic_dev->rss_tmpl_idx, key);
 		if (err)
-- 
2.53.0



