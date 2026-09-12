Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 747EB343889;
	Sat, 12 Sep 2026 10:35:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789209301; cv=none; b=gkzWS9Khv2+F7ySunb56CsOsAbwLpv6LwDnoAsVcC2OPoRLzYed6CaV0BLQkvRyyGmmmFf2EYD35aJ8Nz+a0uQ87pRsVajMPb9FhsocAAS/XstSMXTlLxTnFPrsk1WW3jV6PW+iCe60S2KbrhhnuATTTQ/ojufFeTLnnIZF1G+4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789209301; c=relaxed/simple;
	bh=d9aODhxEL52cKvXpt2VKy4Cv4Ku5aI3pAnh8O98E/Pg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FPsXKjSiDWe3fbwTgNm5p0xwN5iMfSixOgIuNdsjHG1Y8TDsleESBfe/NiEBqRkGTGVeomF7AKLhDu521LoNWuzIGN+yoczzYvyr4EKt8WXTF6S3+bslS0y7srpKKmwtt7zNh1ibPoTLks5aqRE2dgNwMjhoJoYOkDr+ET5CthM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vUa4/MZ7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vUa4/MZ7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78EBD1F000FF;
	Sat, 12 Sep 2026 10:34:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789209300;
	bh=wf3fL4KPyjSnpiEELpJ/IkAsOgx9yo6D/dwcrRN2D2s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vUa4/MZ75aDT4v/e8ZqKMj4GmNHFNVn0Yn0V1uclorys2DNj3Z6tIfx1BiyF/iOca
	 OeIoxZ4MRV3ftFIZq6UcHmqVe0PVlwD+xg7qxxztdQzk4rDcGzHGAhGA2MZNeRpzOi
	 9QwJ16cpfctn40FmcDEMuNf6pg5GWNzDhvFFwePI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0794/1518] wifi: mt76: mt7915: fix ext PHY use-after-free on register error path
Date: Sat, 12 Sep 2026 08:49:23 +0200
Message-ID: <20260912065641.394638264@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

From: Felix Fietkau <nbd@nbd.name>

[ Upstream commit 15b960014f24dce5388d4a2e7274e6490cb3c421 ]

After mt7915_register_ext_phy() succeeded, a failure of the main PHY
mt7915_init_debugfs() or mt7915_coredump_register() unwound through
free_phy2, which called ieee80211_free_hw() on the ext PHY hw while it
was still registered with mac80211, since mt76_unregister_device() only
unregisters the main hw. Unregister the ext PHY (thermal + phy + hw)
first and skip the redundant free.

Fixes: 7b8e1ae886e4 ("mt76: mt7915: rework hardware/phy initialization")
Link: https://patch.msgid.link/20260727150434.1778520-3-nbd@nbd.name
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7915/init.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7915/init.c b/drivers/net/wireless/mediatek/mt76/mt7915/init.c
index d2b163a5fce5b..f247846520138 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/init.c
@@ -1265,14 +1265,19 @@ int mt7915_register_device(struct mt7915_dev *dev)
 
 	ret = mt7915_init_debugfs(&dev->phy);
 	if (ret)
-		goto unreg_thermal;
+		goto unreg_ext_phy;
 
 	ret = mt7915_coredump_register(dev);
 	if (ret)
-		goto unreg_thermal;
+		goto unreg_ext_phy;
 
 	return 0;
 
+unreg_ext_phy:
+	if (phy2) {
+		mt7915_unregister_ext_phy(dev);
+		phy2 = NULL;
+	}
 unreg_thermal:
 	mt7915_unregister_thermal(&dev->phy);
 unreg_dev:
-- 
2.53.0



