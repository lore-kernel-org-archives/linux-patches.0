Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC7563749E3;
	Sat, 12 Sep 2026 16:29:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789230592; cv=none; b=bhyguZ3YGmW8myinGv8c2h/KlXuALY5Rz0Zh/fsMxJE1MWP68vNH2RRcA+iRZkDhIzp0rQK7Op5+ASyjGEtZD41gqeQvoVOYCT+AGE4qQqwaAliNZ6cwcM0bIBX1OeZP5u073aelZDivNyoKbNuESL6QgbVqJvGprZiQsFx28II=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789230592; c=relaxed/simple;
	bh=vzinu1p0hKmN8fbbzCdYy1HEviwDSosScOj2pAbgaOI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FmRImOJ3AOLqHU/CZee19IF9pyGtTN/Klyrj/pj7jah8ZyW1bw0SdEKnj/iNnZbyvzmoUsuBDmYxOu3cdEpTTVN2Q4HrHPYbOP77BoxmYssqidoMmJ+i6HyPU/Cxze8jM8hmQkkIncnFalKugbPLarqPwJ9F3l/n79R+VWsraoE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ejao7MO1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ejao7MO1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C61941F000FF;
	Sat, 12 Sep 2026 16:29:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789230590;
	bh=rF5sB7ykVp5Ui1Slo7VjSTqcwP8jhFEONe78NmqrV7I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ejao7MO1nivkCcasLrAC+fc508VU0ez+P1vbz4/I2YlfHFbZ7uxPhCZUc4kNGoigr
	 mezcRLyMsHp8oe03mAkfUaNFZQjD7cXyeAtncFb0kZ2GO1Ga3YTfQ8emRNSiKvhV0d
	 78/CJkMb3r4TYYr2X4ai3LMbRZVaEwyCSaJwMCv8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0823/1191] wifi: mt76: mt7915: fix ext PHY use-after-free on register error path
Date: Sat, 12 Sep 2026 08:59:11 +0200
Message-ID: <20260912065606.752772837@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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
index 725768d22363b..38027699cad07 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/init.c
@@ -1123,14 +1123,19 @@ int mt7915_register_device(struct mt7915_dev *dev)
 
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



