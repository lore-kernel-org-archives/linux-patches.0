Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A53725F7A9;
	Wed, 30 Sep 2026 16:28:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790785731; cv=none; b=Nm9L8xab6AtEVodjJeF2EgszSUYmJajXa9vcS9zN/YkCSAPzj7/y9EVCilAxaUkLSvkXZpxMDFyoUzWBL+IwEwltTkPqBMBBayEoH24W+4IWxbv4N51pieimJdHXd51WueAZ/JJd64lqfLw0QUec5swQsAgt1it9fX7nTcwxmd8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790785731; c=relaxed/simple;
	bh=1wvCZPDohDaL9mfMD+uX/93R5/qAIV/gKxt/BoOyn2o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f6FlFZuO7Xnn8VFmRKoVh+FV5+5AaiqvEGFHBEdeH77RaQfTGqHF/aA0FyTVL+A96fh/yk08P5vTjG3iqaqmD0oRgzo1x1T0VCJvdj0MsFpFWGt7nXKrUrkFrnjyR1zTn7IT7o5kugNjuywFR6qWXCKENmrG5JX46kum1Wabeko=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UrHgE+rC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UrHgE+rC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C593E1F00893;
	Wed, 30 Sep 2026 16:28:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790785730;
	bh=I8YB+sKZS9RpfCuBFUSt+H6sbMBdyOPDFFtBHh95+W8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UrHgE+rCVGmVr9h5TAZ4pqsAdrBA6y9/HdPRwj8UphTC6EgNDh2PvOtxWlRYKZhhp
	 kx01ZNzxU811DJ3CYXymIokxfjL3PAN967GXhB6+2SbY0KraavuyXXw0+iqV66lmyJ
	 nJPhyvGpfFnGQep+0lEbTUeQbQFnh05KvO+RhWvo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mariano Baragiola <mbaragiola@linux.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 612/982] wifi: virt_wifi: free skb when disconnected
Date: Wed, 30 Sep 2026 17:22:28 +0200
Message-ID: <20260930152429.921670472@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
 drivers/net/wireless/virt_wifi.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/virt_wifi.c b/drivers/net/wireless/virt_wifi.c
index eac4838807c74..474451e8b5e16 100644
--- a/drivers/net/wireless/virt_wifi.c
+++ b/drivers/net/wireless/virt_wifi.c
@@ -430,6 +430,7 @@ static netdev_tx_t virt_wifi_start_xmit(struct sk_buff *skb,
 	priv->tx_packets++;
 	if (!priv->is_connected) {
 		priv->tx_failed++;
+		dev_kfree_skb_any(skb);
 		return NET_XMIT_DROP;
 	}
 
-- 
2.53.0



