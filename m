Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 266A93A4526;
	Wed, 20 May 2026 17:20:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779297615; cv=none; b=HYCS1hY9ctqYlc+KWctpaAux+0RTi4DGjrSuuVQsYuieVpCxzEVwIBOuGL+CaKTUGna5sgHe1OhsmJs2SdCtSHv83c/5jZgidGUWDJ1xuTjciZ+p9dnIr44H9Vn235PnFG41tFUyDMCHeR+N0VCR0Y0OQVgHfPIams+GYsvD4k0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779297615; c=relaxed/simple;
	bh=vhDM5JIVsghPIZe3p0K6gIIgzRttWwUvCsnDS41dyiU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cgFn3Yi4gmgCkTToZ9WkUvbqttjjojF6sjbwk/+XXQkIYpOByf0E9Mkts8mi8H45yFnMXn9x1lRcalYt1AUtiwizw8at3At5a+93falew6B2joZFeor97/CN1PvatQLDYZ5Pn3IMjlXCGryuWLwZGsu5HKb2Sc+bfwsnZcNFZkk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=prPOSykb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="prPOSykb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 651261F00894;
	Wed, 20 May 2026 17:20:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779297613;
	bh=Yb16QcmcDUt7OzpLjEnvm0keN5Wwu6bok+pgXw3nip0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=prPOSykbyZVvO6nHfMsrgPvg7sUgek3WknaHMEv5L6KIyNwY8etHZ0LDlsVa7GTNT
	 XA/RqdX3wBK2R8728WCSPKm2EvbC2jyergHd7j9e9GnxnPTA6Rab0kUZpbvbuFp3PX
	 fPfaG450HRxH36MsUvLmHm0AvlYkRBvju6KMfGuQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Lo <michael.lo@mediatek.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 099/957] wifi: mt76: mt7921: fix 6GHz regulatory update on connection
Date: Wed, 20 May 2026 18:09:42 +0200
Message-ID: <20260520162136.706779084@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
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

From: Michael Lo <michael.lo@mediatek.com>

[ Upstream commit 3dc0c40d7806c72cfe88cf4e1e2650c1673f9db4 ]

Call mt7921_regd_update() instead of mt7921_mcu_set_clc() when setting
the 6GHz power type after connection, so that regulatory limits and SAR
power are also applied.

Fixes: 51ba0e3a15eb ("wifi: mt76: mt7921: add 6GHz power type support for clc")
Signed-off-by: Michael Lo <michael.lo@mediatek.com>
Link: https://patch.msgid.link/20260211095025.2415624-1-leon.yen@mediatek.com
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7921/main.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7921/main.c b/drivers/net/wireless/mediatek/mt76/mt7921/main.c
index 07495c97f1c12..ce11666a32db9 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7921/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/main.c
@@ -800,7 +800,8 @@ mt7921_regd_set_6ghz_power_type(struct ieee80211_vif *vif, bool is_add)
 	}
 
 out:
-	mt7921_mcu_set_clc(dev, dev->mt76.alpha2, dev->country_ie_env);
+	if (vif->bss_conf.chanreq.oper.chan->band == NL80211_BAND_6GHZ)
+		mt7921_regd_update(dev);
 }
 
 int mt7921_mac_sta_add(struct mt76_dev *mdev, struct ieee80211_vif *vif,
-- 
2.53.0



