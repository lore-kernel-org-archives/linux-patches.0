Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF3E11E87B;
	Sun,  1 Sep 2024 16:59:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725209994; cv=none; b=Wc4hMQjvicUh81ZxKb6t0pLGqkIWm+rGBt31XhTPhVEfirKijdZD7OCEsK8MTl3K5vdphTuac/HA4zcqbl4bQ6PmhfdMk2sFNktSP+oQ6dLe1Szt20zhdD1H0GH0+Zg9m7kDNbRQehszwAeYUQuKgC0QAZp/olP3MlhlsblT9ck=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725209994; c=relaxed/simple;
	bh=JmNI3uT4zD3levVc1oVplZBusl7vZ9+Z1sCm4SsYRf8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VJO6PKQJ/rvYNSIC2tZOxPrmKowyYWAb/0gtysvnL8wcjDSseRdLAlkAD6McbQRKtlydi/JNMRWJPQ7EiGrDQ4y8zVy1+xnKDgnl/2Vo4H+9QN+UNoSXjpjkPHmTcedMtNt0Wvzb+emNKJxOctkQviEFlbpjGqtdEtfv0r0tC1Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uI09mrqk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uI09mrqk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D7CEC4CEC3;
	Sun,  1 Sep 2024 16:59:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725209993;
	bh=JmNI3uT4zD3levVc1oVplZBusl7vZ9+Z1sCm4SsYRf8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uI09mrqkSyndVZUk76MdfzoXp9cr+O4CStKrbBCV6MPjDrMdWlNRx9mAzLbbCbU8O
	 tvGwQQkmEq+UHJuCLgKRRB8iP1JGZq06l9Mx/LoA0Gi9Zrvi0tZhZ23ZjMo7VghxsG
	 H7XHleJBGdF+/jv3WN3KSErpLMoF8I5uyOmbbIHU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chengfeng Ye <dg573847474@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 055/215] staging: ks7010: disable bh on tx_dev_lock
Date: Sun,  1 Sep 2024 18:16:07 +0200
Message-ID: <20240901160825.430707051@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160823.230213148@linuxfoundation.org>
References: <20240901160823.230213148@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chengfeng Ye <dg573847474@gmail.com>

[ Upstream commit 058cbee52ccd7be77e373d31a4f14670cfd32018 ]

As &priv->tx_dev.tx_dev_lock is also acquired by xmit callback which
could be call from timer under softirq context, use spin_lock_bh()
on it to prevent potential deadlock.

hostif_sme_work()
--> hostif_sme_set_pmksa()
--> hostif_mib_set_request()
--> ks_wlan_hw_tx()
--> spin_lock(&priv->tx_dev.tx_dev_lock)

ks_wlan_start_xmit()
--> hostif_data_request()
--> ks_wlan_hw_tx()
--> spin_lock(&priv->tx_dev.tx_dev_lock)

Signed-off-by: Chengfeng Ye <dg573847474@gmail.com>
Link: https://lore.kernel.org/r/20230926161323.41928-1-dg573847474@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/ks7010/ks7010_sdio.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/ks7010/ks7010_sdio.c b/drivers/staging/ks7010/ks7010_sdio.c
index 98d759e7cc957..a4f3a7a79422b 100644
--- a/drivers/staging/ks7010/ks7010_sdio.c
+++ b/drivers/staging/ks7010/ks7010_sdio.c
@@ -395,9 +395,9 @@ int ks_wlan_hw_tx(struct ks_wlan_private *priv, void *p, unsigned long size,
 	priv->hostt.buff[priv->hostt.qtail] = le16_to_cpu(hdr->event);
 	priv->hostt.qtail = (priv->hostt.qtail + 1) % SME_EVENT_BUFF_SIZE;
 
-	spin_lock(&priv->tx_dev.tx_dev_lock);
+	spin_lock_bh(&priv->tx_dev.tx_dev_lock);
 	result = enqueue_txdev(priv, p, size, complete_handler, skb);
-	spin_unlock(&priv->tx_dev.tx_dev_lock);
+	spin_unlock_bh(&priv->tx_dev.tx_dev_lock);
 
 	if (txq_has_space(priv))
 		queue_delayed_work(priv->wq, &priv->rw_dwork, 0);
-- 
2.43.0



