Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C196C3D75AD;
	Wed, 23 Sep 2026 14:14:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790172865; cv=none; b=ij3h6iP5Q5HHee3QP/y7dNUfm9Ancr3yEZiDcGYklPXaqIutxdw/d2Yfh0IBYy9ZFLmB4fZrEtxXRwAEpTruVtKVHCno4Rs4x4NRzOohhg+9hn1KQi3g3N+wwmmDBHiD7Tayd4x1P6vpwSbdfN74+b1WPWKRx60MKe5EpTkQ7XM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790172865; c=relaxed/simple;
	bh=50QTlIvz/6iAGrYbGlTYZbIIqdJioBfaq2kL3ZA1yu8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YkOej+kPbfPnPZuuD/D6oc+G6XgMu+2DfZ3JM3fQ49zoljgpModOcA+R2S2x2dObEAeLPNJscI7oe5EtQ4Mgs9H5Nyv2sUnpePIORidpIKtZ+9l4mhnhuVVILPVsw/wiBOEHZcGGmDwGSerknIX/tFryh0sK9cmFmTGu154yoWE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UpEhRROq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UpEhRROq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 248B41F000FF;
	Wed, 23 Sep 2026 14:14:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790172864;
	bh=MvM57HPgwAafrocdAMDWJ4RqH1eenXhBUwJ+vun9uOs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UpEhRROqUbrOIdw2Lsed5UwZfs2bIsLonZ6J5qjg8T5uSlQb8MZ5/mbNiax8onz3S
	 PIqXXCJMi3fysw86bH9J32RYQsrd9WqrihIlhN8mB3T63uuzK+iaEibuqZ+uML1csL
	 h3n8YR7BwGpVtRyVTRGi9lev8CMB7nLQdgn5uEZU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mariano Baragiola <mbaragiola@linux.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 048/438] wifi: virt_wifi: free skb when disconnected
Date: Wed, 23 Sep 2026 16:01:09 +0200
Message-ID: <20260923140646.029636727@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140644.756254324@linuxfoundation.org>
References: <20260923140644.756254324@linuxfoundation.org>
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

From: Mariano Baragiola <mbaragiola@linux.com>

[ Upstream commit f9edf7cf63b96d2b776fca8d258d3c5256e40c8e ]

When the simulated link is disconnected, virt_wifi_start_xmit() returns
NET_XMIT_DROP without freeing the skb. dev_hard_start_xmit() treats this
return value as consumed, so every packet sent while disconnected leaks its
skb.

Free the skb before returning the drop status.

Fixes: c7cdba31ed8b ("mac80211-next: rtnetlink wifi simulation device")
Signed-off-by: Mariano Baragiola <mbaragiola@linux.com>
Link: https://patch.msgid.link/20260809124947.3590270-1-mbaragiola@linux.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/virtual/virt_wifi.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/virtual/virt_wifi.c b/drivers/net/wireless/virtual/virt_wifi.c
index 2335e45db8b85..b69a4650fba85 100644
--- a/drivers/net/wireless/virtual/virt_wifi.c
+++ b/drivers/net/wireless/virtual/virt_wifi.c
@@ -434,6 +434,7 @@ static netdev_tx_t virt_wifi_start_xmit(struct sk_buff *skb,
 	priv->tx_packets++;
 	if (!priv->is_connected) {
 		priv->tx_failed++;
+		dev_kfree_skb_any(skb);
 		return NET_XMIT_DROP;
 	}
 
-- 
2.53.0



