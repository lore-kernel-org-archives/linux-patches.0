Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC3EA368941;
	Wed, 20 May 2026 16:31:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779294706; cv=none; b=hETvM9cSRkaB7nyIBP2l27TzNl17+WYTjBov3AsMFbLSQciM6FviJ8iLx48lhZ3V+LEsyBAeGSTRTb6qH6MV7+ES7TKicPjrHaX6v/Rdr/O4HWoNUm+kQGuWZZkQ0XWnnJwaft594vHIy8bEOiqnQNmP83CdgVfDqNBPy+6NjRA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779294706; c=relaxed/simple;
	bh=VccHE1WkymadYA5nz/r/ZGT3ZGwlPF9uCfytkHeAxOM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RtJdTjjNyLCFcuw6KbGeeFw0TALD6w6IkvaYxC6weSCL8Pyv3nPtEOwxxEr8zkxVUf8ShEvDo6esxtIUWH0+ahRW9b/2Md/Y440wT+Wa6CplwNi1bgxXDga8WEzpSZjW3KTmbt6Cqjd6R38MUXDKyNLsz1JnmdKrbJGRjOmwI7s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bJ6qQAn1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bJ6qQAn1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E83D1F00893;
	Wed, 20 May 2026 16:31:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779294705;
	bh=ha8j/vXsGKps9CwQa6UHFecP/weT1z6OMTX/qK1+s3c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bJ6qQAn130io2rZ9NroEanaPjQJD8Mm4efolPWeCeZUp5CZORQ31QNfpy7SVEvFC6
	 R2phQwo4uWpH/e3hccZM8ljinaURJYAshjisTqFwowBVckoUJjvq9VYRa2WTpEVDgn
	 iWq+v3ztXJOuA+2jRV6E+HLghvQ5zOppkWxWmDNc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Lo <michael.lo@mediatek.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0124/1146] wifi: mt76: mt7921: fix 6GHz regulatory update on connection
Date: Wed, 20 May 2026 18:06:14 +0200
Message-ID: <20260520162151.135540305@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

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
index 42b9514e04e71..3d74fabe74085 100644
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



