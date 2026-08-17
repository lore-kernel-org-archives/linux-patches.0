Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DAFD3AAF76;
	Mon, 17 Aug 2026 14:07:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786975631; cv=none; b=acArV4aVNq6nwdbNDAsJNAWxicvhxXHfpMQEmyXyfJv4jRrxom53Rasi+rrS2MvWOuPN1ETU7FAuxQF9YlcXNvc/pVJXYpsviCL7ID8ztdRZWcLFyKWccIZE1anF+dMCCify575iuSxdoFoRM42rVHdRlvvAiJoE3qMPOYyONj0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786975631; c=relaxed/simple;
	bh=6RTEJ27GFD90kmoNqrcg4NWT0XEz2Aon5fNVXByk+PY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n422AhOUglMNNrwLMXhmup7KSDqEPGY1FOAhte2FGRbwX1KgnLcVGvFc8OrCfEOOtkpGF6mWgYLGpvn8Vr2jiyqILpxB22eG3c7tMxsw+iiYIHo/o1P1MBFFo/T2LILUv6jf7u++E0EUvGrGT2eJY5IAZ2laeDPNmas000IIQaY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cHwrFFKs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cHwrFFKs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4F251F000E9;
	Mon, 17 Aug 2026 14:07:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786975630;
	bh=uw1erNw0dn+RphjTm+We3LZZaK14+PY35GC2y1yiv6s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cHwrFFKs/Kl33hLaVgnZiaDboK90UlYTfAMfc3j+iv9eAsz6s0ZN4wFTgnLye1D29
	 bN9teVF8Aym+7x587mIRWurSA65b/gQKkjWk2EyBucZcc5y4lX2eYr6kH+7IIOfCdG
	 eRGk6XFMYgbUGjsZBgY1as0v4GGrRauPWK0ITXYQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chenguang Zhao <zhaochenguang@kylinos.cn>,
	Joe Damato <joe@dama.to>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 094/389] hinic: remove unused ethtool RSS user configuration buffers
Date: Mon, 17 Aug 2026 15:28:53 +0200
Message-ID: <20260817132542.779245891@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132538.796021292@linuxfoundation.org>
References: <20260817132538.796021292@linuxfoundation.org>
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
index a4fbf44f944cd3..46b24f3c5e168d 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_dev.h
+++ b/drivers/net/ethernet/huawei/hinic/hinic_dev.h
@@ -100,8 +100,6 @@ struct hinic_dev {
 	u16				num_rss;
 	u16				rss_limit;
 	struct hinic_rss_type		rss_type;
-	u8				*rss_hkey_user;
-	s32				*rss_indir_user;
 	struct hinic_intr_coal_info	*rx_intr_coalesce;
 	struct hinic_intr_coal_info	*tx_intr_coalesce;
 	struct hinic_sriov_info sriov_info;
diff --git a/drivers/net/ethernet/huawei/hinic/hinic_ethtool.c b/drivers/net/ethernet/huawei/hinic/hinic_ethtool.c
index c340d9acba803f..4a1693c70582a8 100644
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



