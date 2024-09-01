Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85D6644C97;
	Sun,  1 Sep 2024 16:19:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725207599; cv=none; b=KXDSC5OaU1HiEVXBKwik9jcUxjudeyVvGZZYWKkVyqw13kG3X8UHF7g238aavVQ7DhEBvTk8eSgWamDObPm/cn4XlUjREX19BuqK2zkO/4Y+uAwtExNJ9ELVHZPHvkTcoILJRbdXMvXzENI+T2PewoMAWj7HYqmye4tbfv0/Xaw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725207599; c=relaxed/simple;
	bh=tyalicEz71vLNQLXmroOyHpIUo6AMaRbM1uWv4f6qdI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O4lYT1qg5bBuoX7Vr53uodEGMArJHMUWzSC/mcbR/ssMMfMNbMhszEARUxLKCshGcW8e8R1fp7zNz/XFka6XaAZe6GrV7qD3igucTMnNYBkQBoS2jsGpDSQNRkX8rMlhpSHuy7+z2/bIhW9MwFpIkmJ6092X2brMYL3jgRV14/c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LiqGQ8Sq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LiqGQ8Sq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECEF3C4CEC3;
	Sun,  1 Sep 2024 16:19:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725207599;
	bh=tyalicEz71vLNQLXmroOyHpIUo6AMaRbM1uWv4f6qdI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LiqGQ8Sqc8+eDvxbZwz1DRmD0wCy3rbG2sdZqZ7lKIeWTIQUmkqbdvokRbVodH4/o
	 Yrdz0FZfH9HVHsulDBctPnljDvrPeU9aNWCxpVs0xxbUrLzhnY7Y7RNwpsgtvqzmlr
	 sOjRwkhVY84Ww/baA+WNGQODwOiNGhe7SITsJEVw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chengfeng Ye <dg573847474@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 20/98] staging: ks7010: disable bh on tx_dev_lock
Date: Sun,  1 Sep 2024 18:15:50 +0200
Message-ID: <20240901160804.453203874@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160803.673617007@linuxfoundation.org>
References: <20240901160803.673617007@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
index 79d0513bd2828..85c4e27f571b1 100644
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



