Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3068650C2A4;
	Wed, 30 Sep 2026 17:10:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790788202; cv=none; b=DvZxafciHpVFnSqolyQD/snbi++xqs2FrugRyEk716/ApSL5O9Uln8cpf0D2SPUoQdznEP7hfZXTL1wfPe+92em71PV8Fws3eJMLFgenmpqynQcEDvmJiEadzzyKr/jXJrynWdbMAzxt7AzXEI5H4wDta6A6ULjLPlzCGWUmWn8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790788202; c=relaxed/simple;
	bh=5qQtcQoGVck4APUdrNrzxl1kYAWRzwwYY1wGMcyCU+Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZIyIM4p+zQUI0AFKUIXEBZ0u+pPtO8NU/j0aFZgp5ssooYBf5m9l5QBihFiEW7zRdXK4txE49lUTp6TTp30WKHfF4Dcg9DFi8II7GXo/D9swe5aIl8sizEzLZzYkRM1phU8Xo26JxP9CNAAo0bABIjWEUQGdRYwpVXqxym2zKmY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Upej3C5c; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Upej3C5c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 014F61F00898;
	Wed, 30 Sep 2026 17:09:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790788200;
	bh=aMKPAnSNs5I4RNr2CCObCAmgrFpGrQ3IvdGsE5tbkCA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Upej3C5cY9WwpJj7yAKUHlwhINq12/IAXW1HpVUpkvUekhxznw9MyZLv/2kRcMGp/
	 /xF2g6DTFigOyLSVzwMO9YUSTWBkrQoFcW7sCWsEA4CPgwDtuNrDf3XRaApzZiovcj
	 sQ3BMGZsKA7Mb3Pz7RUzmuNZKF8nlygIBz/ke9yw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mariano Baragiola <mbaragiola@linux.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 041/877] wifi: virt_wifi: free skb when disconnected
Date: Wed, 30 Sep 2026 17:15:52 +0200
Message-ID: <20260930152415.631640660@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152414.738996857@linuxfoundation.org>
References: <20260930152414.738996857@linuxfoundation.org>
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
index 976edacb689de..056d375e3f41f 100644
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



