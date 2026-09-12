Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 851F538D6A2;
	Sat, 12 Sep 2026 08:19:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789201179; cv=none; b=hB1+vXzgRja9sla15MH3iep7Dg/Q8usAQrcSi+mjHhaU+SaYaw+kTV3h/TKBxRvaQQ6tbZvNuZfKMiAtKtnEVU/09eqg1qL/PDG5mlDX2DhUnr97Cw+8evcAGtNPmWETkgfWJzAcC5Aosu31yrOnJMYlVByg5XjHJ7Ti2iwY22U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789201179; c=relaxed/simple;
	bh=OGtb15QPOnm7K4NslL3VG0rPpul9jHybGRU9dR5DMaQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GAghR6Rsz+10LstsMFZHdYvUC0EgRuRPAatg91e4nVZVgkg0Vka1dGefEIzgHxt5CTbaHy7wQjPr1q0GbjJv+TZkw1rSFVpb3ojYFlG1CKZ0grA2xzPexpAxJ47rCYy2XjNbAvviDCW2IOTEgOw2vd3iizni4bzSekqNeTq35xY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vu4c5JXP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vu4c5JXP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E6F61F000FF;
	Sat, 12 Sep 2026 08:19:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789201178;
	bh=bt25qfc9uQjmUxFsLx9Ev8E9pHQuhuAMpjprZR6PP/o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vu4c5JXPy92M1YXjR/OmvtXCXJ3g4ncW76Djn1FYfUtl9hPiqG5FxOYSLv4j8M3s6
	 7W1LHcBiu976X6bdB3+eCuFPm8pR2W99r3c6ztEzwsKTGzm0E2/zat1+aaqXhtvAbc
	 wm1Qs6rYV0gn9XdE75ihtfg/weIgcB7eCH+DHf6o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0942/1815] wifi: mt76: mt7915: fix ext PHY use-after-free on register error path
Date: Sat, 12 Sep 2026 08:44:52 +0200
Message-ID: <20260912065711.071466920@linuxfoundation.org>
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
index a4ca8a46b73d5..2ab38f9e52581 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/init.c
@@ -1272,14 +1272,19 @@ int mt7915_register_device(struct mt7915_dev *dev)
 
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



