Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2C5523BD06;
	Sat, 12 Sep 2026 14:51:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789224716; cv=none; b=f2kiHVluZM9ufWnjHotzN+FzayxiVrw2qwO+DFOLehIwZMGRjiOZuvdXOMIrbGEBaYo7rcjG1jxWmabYsGjhAETlR6odyDAP4W7o9eOhf2+ui6bgArPZpIGIjwPCFjXhb9LiRktwzmV0ghp2LEuXssyotLO9VRTtweeIrkltg3Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789224716; c=relaxed/simple;
	bh=e/ExZzNDhFv3HyLbnk/8eESTY2nlO6pxN2WG9CGe2r4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IFMcvSknoqDTgRmtddRAs9Q0YZYUpcY4l7wblmMBFZkfJuLKcjdTkBp5bmWY18QjnYLrnv/yII78d5SXGBQPc7/aY05bRDz77TgaRK3K9Kp2r6ECUNA6WFBorh8yq5XFB1esJwfufc9J5GdkI5lDmdLIdgWvV9zQOCAfN4vTLKQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PfVEPMzz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PfVEPMzz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6F641F000FF;
	Sat, 12 Sep 2026 14:51:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789224715;
	bh=UjkdKB9QjJTjqU30ljhtdLzA/kojpNo+MW2ZwpBm/Is=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PfVEPMzzXqeAH+qhYIVJjZuIbXHrYmVfq5sBZ06FfsjIlN9VWp3FMIwZIg5fYK4xz
	 BbrbJKG9z+6LzREG6GlMtFRNotS+jbrV5r+fUtUNkz5+uNWqu3hpwIvybAOMgmEXhj
	 0gjSTPU8GqYWjF8qN6PxDxxw2o/iveEIH0aUmhwk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0997/1424] wifi: mt76: mt7915: fix ext PHY use-after-free on register error path
Date: Sat, 12 Sep 2026 08:57:09 +0200
Message-ID: <20260912065629.644009807@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 529a3640944b5..ba8da7e2e7e6f 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/init.c
@@ -1232,14 +1232,19 @@ int mt7915_register_device(struct mt7915_dev *dev)
 
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



