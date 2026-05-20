Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C94C3F54D1;
	Wed, 20 May 2026 18:01:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779300120; cv=none; b=fZT4qRF08uytFuTlghsmPePaw8F/HnJL49Azx1ElhPZf87Qe/Zjb8lfwRgoNDoQkFCTjhPBYqtoEEIrNr8FX0kV21AlkZRTxdmm8w5gG11OIMRi6HSUBWp3RXqaW7evcCDktdeS05BR61X6+Z9WcCbpAu8bym2/KI941/64pjRo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779300120; c=relaxed/simple;
	bh=yH0njiYOrUdcLOgubW/MXVmUuVhSLd3LeSgs4zAv5q0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=onixbgfgiQmH7mMlGW7/k2zbEQDxZthR6s0kpc7xhG6fMvTXgK7m1jb686AwcpVGfmVV/+euogrpKHiaKAZ3By0E0D+K2KCtBdfrO3m8CJ5otXgMb1ucBaV0aLv5PMQRhdqCImUbT+TrLs5OAw3/0FYT6LHqPBJZafa2fcCToT4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tg2BWFI5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tg2BWFI5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91A411F000E9;
	Wed, 20 May 2026 18:01:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779300119;
	bh=lMo8sR051ou11cDkE+fRSIClB9Sh6xpDydT1CVH5I2o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tg2BWFI52tasOvSOoMsOJoWABH4cfxJxIsXA0FqFsp8hagckZTWRE3uxTeQWWvGvn
	 UvdxvCg67V39ngzl0V/LU/EblW+FwblEr6BFG/8UmgvD6Tq6GI1LtKzlegCCVCdN6O
	 DJy5u+TuGy5iFoFhiyFJu7XNAuX+FljWrYTN7NJQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Lo <michael.lo@mediatek.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 054/666] wifi: mt76: mt7921: fix 6GHz regulatory update on connection
Date: Wed, 20 May 2026 18:14:25 +0200
Message-ID: <20260520162112.408231372@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162111.222830634@linuxfoundation.org>
References: <20260520162111.222830634@linuxfoundation.org>
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
index 6ed2edd054b55..a93ae4e44f16a 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7921/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/main.c
@@ -791,7 +791,8 @@ mt7921_regd_set_6ghz_power_type(struct ieee80211_vif *vif, bool is_add)
 	}
 
 out:
-	mt7921_mcu_set_clc(dev, dev->mt76.alpha2, dev->country_ie_env);
+	if (vif->bss_conf.chanreq.oper.chan->band == NL80211_BAND_6GHZ)
+		mt7921_regd_update(dev);
 }
 
 int mt7921_mac_sta_add(struct mt76_dev *mdev, struct ieee80211_vif *vif,
-- 
2.53.0



