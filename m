Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E07EE26982C;
	Sat, 12 Sep 2026 08:16:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789200996; cv=none; b=kV2X8tKzWfgtO58XQCNuOmiIlXxiU8RpTUKEOtajcspWX54/rEzAZoy2j+tbTCcrjTUduSQzmALg+sdQA5a2dPwPV5M0/7gJvW8biCQO8eJVBfRA69CFUJfZClTMwNfLHR7Bzg1LGSI+c9ildaxTL5sPfd8onRscZp7nqRkjQTA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789200996; c=relaxed/simple;
	bh=Kgzfl683e1+JNpfV9jyHBE9Uddjpfp9W8jRZ/cAkVK0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ka3vp9FlFldIoVMXY/1w3YFQZDsouCy325Kf4UBWuMjVbnNEZBWRgewaYo7AVyxGBbiYOwS2LkFkRyVub1Z+pe0/Lt69BrrhbacFJVdVarS+eMgalMLHBSjYiuaqULobNgVMqIUqH9Jv531jMOr0i9//hLnJw/YJ2petVImDplY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CWhT78Xk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CWhT78Xk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A54511F000FF;
	Sat, 12 Sep 2026 08:16:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789200994;
	bh=mwpww5M1WCT0ANGBBoU3HrA7qA1V2TYIcNZlCOHLvU0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CWhT78XkWch6T6kKYih/tLR5a/jkeHp98fcW6iKtqMqSTtcy+kjX/9ulQ59pIFEni
	 vszb5QEeyGad5MFmgldkcxNEXmN0Lj+zR0bLzhR5fTKIwqmeFHXLAyF6POAxFgn+tR
	 OWnqA09I3Pv4MIqG5vPWKNs02TEyDj3Sw+47KYyk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	StanleyYP Wang <StanleyYP.Wang@mediatek.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0904/1815] wifi: mt76: mt7996: add missing rdd_idx check when enabling background radar
Date: Sat, 12 Sep 2026 08:44:14 +0200
Message-ID: <20260912065710.145957341@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

From: StanleyYP Wang <StanleyYP.Wang@mediatek.com>

[ Upstream commit dbca5c4d29826cecd3185fb1ae2746205ab55127 ]

Add the missing rdd idx check (< 0) in
mt7996_mcu_rdd_background_enable(). mt7996_get_rdd_idx() returns -1
for phys without 5 GHz support, and the negative index was passed to
the RDD MCU command unchecked.

Fixes: 1529e335f93d ("wifi: mt76: mt7996: rework radar HWRDD idx")
Signed-off-by: StanleyYP Wang <StanleyYP.Wang@mediatek.com>
Link: https://patch.msgid.link/20260724124813.3961474-13-nbd@nbd.name
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7996/mcu.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/mcu.c b/drivers/net/wireless/mediatek/mt76/mt7996/mcu.c
index 289c8390b5fa9..645a8b480871e 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/mcu.c
@@ -4023,6 +4023,9 @@ int mt7996_mcu_rdd_background_enable(struct mt7996_phy *phy,
 	struct mt7996_dev *dev = phy->dev;
 	int err, region, rdd_idx = mt7996_get_rdd_idx(phy, true);
 
+	if (rdd_idx < 0)
+		return -EINVAL;
+
 	if (!chandef) { /* disable offchain */
 		err = mt7996_mcu_rdd_cmd(dev, RDD_STOP, rdd_idx, 0);
 		if (err)
-- 
2.53.0



