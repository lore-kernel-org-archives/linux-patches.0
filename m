Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BD863AE198;
	Wed, 23 Sep 2026 14:36:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790174211; cv=none; b=QuuxP9t0toUW5X8sUYrskuWQBKNft3fkPJetO6kI4lRDnqLVUOOe5m6P9Yvr4tanZG5sxhjdTVT4lQddOesqoafNjiDZZMAujLB0DCevguPk6MolAMx9own07FK5aE42MWk8AAjMJE9vNIyqhTf7YhilJA85jPNT3Q06qS5lx7k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790174211; c=relaxed/simple;
	bh=KFX5bJ3Im3+XNrq8zdZZRlipAUibqrnYHAc8zGZdplU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kdYo9AEcarImTdy2RE6BL2NIFU4kkekLUf8vDIcDqi4n0llK8XsgzvXorFH756cTDX59lp8bvOtVJbQWerUqcnUHm57tz45Yi6esdzSSCBIAcm7HZ8mDOdiLtrCgSNc/jNLhcVnA58ztV6dtPcXAX50SE+++PrMYel7Rc9qaOLo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LNeClfMF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LNeClfMF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A26A01F0089A;
	Wed, 23 Sep 2026 14:36:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790174210;
	bh=PuK1rXUJPRJGWilHjl9R+KH6+PXZsQBbm21I8qk7E1M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LNeClfMFZPiogxQtML0ic+Dy36bFx2J5nwCyJp3aVs+fdBws0h5f738bjKEpfspfs
	 sroVBIYM/bJgyVl0kGpx9Hg8hAQFboJygZTwC6u9MemUbjBKudOOc/+eKVSXQbPmWj
	 +vNoCj9Viu4GOujFBOkoC4tWC053c67B+7ZsQAq4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mariano Baragiola <mbaragiola@linux.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 045/398] wifi: virt_wifi: free skb when disconnected
Date: Wed, 23 Sep 2026 16:01:59 +0200
Message-ID: <20260923140644.592853540@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140643.441954610@linuxfoundation.org>
References: <20260923140643.441954610@linuxfoundation.org>
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
index cd6b66242bff2..b976b90c1c2d2 100644
--- a/drivers/net/wireless/virtual/virt_wifi.c
+++ b/drivers/net/wireless/virtual/virt_wifi.c
@@ -432,6 +432,7 @@ static netdev_tx_t virt_wifi_start_xmit(struct sk_buff *skb,
 	priv->tx_packets++;
 	if (!priv->is_connected) {
 		priv->tx_failed++;
+		dev_kfree_skb_any(skb);
 		return NET_XMIT_DROP;
 	}
 
-- 
2.53.0



