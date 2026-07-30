Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5102646C4B7;
	Thu, 30 Jul 2026 16:05:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785427512; cv=none; b=dcs734z4CknX/+82kBT0iXz0efzw4bSISg96aJ56Gua/QzDshmJof1Ig6QcTDNrdQIsrNKus4u9WmI/72ZBtUqQ+Z8gA5JdLphyLTE97J0qmrHNZn4hW3pQFRNwMSFfdKXG6rr46BiyAARHG+fWBp87Wn+cK3pDiKJccLqSpxYo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785427512; c=relaxed/simple;
	bh=qa/wPv86M6ckg4KPQdse4qse5YFZvskePkfaowgnXjA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NgUffV/sWKtNCxaH6GuZ4ZPo9ujRwceAd7E+KJvChRWffVZZE550wMo91a4kPhOqZ8puGao3DDJP99NablLwfTbkmiW+xv8ngKEuVOJS0QmSrWdaB6FuxqJhrP0n8rDERTJ1rwLoeu2Qfr4tNf00YzUdC/hEBwD2kfCKFVWE9xU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rp39b8So; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rp39b8So"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 681081F00A3A;
	Thu, 30 Jul 2026 16:05:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785427511;
	bh=8I+WmDEEogJWLfBN5rK+t6xGFZ31WJsnI+rJIIxYFNE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rp39b8SoL97vkiQCQJSz5ajaPAmNZzwB5BrjPIHxCBBID30eD92L0gnWcypqSiAEh
	 hd+fkTun0z0Vi91iaU5pJAI8RFH95CB/INfukv5CtgWV8EVGjAfW+aGPnLdKb5KL+8
	 gZIGVP4ZVvl5MfC2Cevwvn5wVepzzgFwLqeQrcnI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chenguang Zhao <zhaochenguang@kylinos.cn>,
	Joe Damato <joe@dama.to>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 197/484] hinic: remove unused ethtool RSS user configuration buffers
Date: Thu, 30 Jul 2026 16:11:34 +0200
Message-ID: <20260730141427.747919350@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141423.392222816@linuxfoundation.org>
References: <20260730141423.392222816@linuxfoundation.org>
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
index f4b68028691194..660ab3edf73939 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_ethtool.c
+++ b/drivers/net/ethernet/huawei/hinic/hinic_ethtool.c
@@ -1061,17 +1061,6 @@ static int __set_rss_rxfh(struct net_device *netdev,
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
@@ -1079,16 +1068,6 @@ static int __set_rss_rxfh(struct net_device *netdev,
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



