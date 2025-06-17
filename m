Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1F682DFF02;
	Tue, 17 Jun 2025 16:22:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750177322; cv=none; b=YJMP8ItSRaKSrheZAQUmwqTrmNiNFfh2hsItIHLhgo4lmoV1vLAgDSimgBmTi5oJ5c/CWtyxMOZEpeAuTJoEiaJ6KsvWDxkK6JLHp3ajIIyXvfdqqLbmAp+ShgrAVNWTd1OQX3lD192G2rXmdN/b1cE2wQH7hnysddhhLATl2Ls=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750177322; c=relaxed/simple;
	bh=toxTyOdb9tuATbdb149AwieUQYmZc4+cQ6sVxLTlPlI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UNUHmUenJ6ew7afTnmgHntSn1XWhKhR2KfjYTjqUFQz+Ht64RDGK7YQghEU7pbuZEZ0vl9A3gc+2IS8VodxSvI9CP8643zfKtKv6Afx7ZgKexaq+mPgByl4RCDwna/laBUcdLlSlUbMnwJBs2hCumDIcJYf41XiS9AwD3seBoYU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LxAT5uny; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LxAT5uny"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B3EFC4CEE3;
	Tue, 17 Jun 2025 16:22:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750177321;
	bh=toxTyOdb9tuATbdb149AwieUQYmZc4+cQ6sVxLTlPlI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LxAT5unyrG4JqtTQRqeOEqvhCmO9FZAq7AqSFELp/PqoDyRoMZsdidazhXNmswwPw
	 dDpFOhQ26qeikf1mInKD5Zuik7kDW6e4fFiDHgrqHrlBkVI7kAWJbtKb2PpHnETSLX
	 0UrPaEi+2YkSm9acYacHmai/YWWUJ2WhMHabN6cU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Charles Han <hanchunchao@inspur.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 289/780] wifi: mt76: mt7996: Add NULL check in mt7996_thermal_init
Date: Tue, 17 Jun 2025 17:19:57 +0200
Message-ID: <20250617152503.240025203@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Charles Han <hanchunchao@inspur.com>

[ Upstream commit caf4b347c5dc40fdd125793b5e82ba9fc4de5275 ]

devm_kasprintf() can return a NULL pointer on failure,but this
returned value in mt7996_thermal_init() is not checked.
Add NULL check in mt7996_thermal_init(), to handle kernel NULL
pointer dereference error.

Fixes: 69d54ce7491d ("wifi: mt76: mt7996: switch to single multi-radio wiphy")
Signed-off-by: Charles Han <hanchunchao@inspur.com>
Link: https://patch.msgid.link/20250407095551.32127-1-hanchunchao@inspur.com
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7996/init.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/init.c b/drivers/net/wireless/mediatek/mt76/mt7996/init.c
index 6b660424aedc3..5af52bd1f1f12 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/init.c
@@ -217,6 +217,9 @@ static int mt7996_thermal_init(struct mt7996_phy *phy)
 
 	name = devm_kasprintf(&wiphy->dev, GFP_KERNEL, "mt7996_%s.%d",
 			      wiphy_name(wiphy), phy->mt76->band_idx);
+	if (!name)
+		return -ENOMEM;
+
 	snprintf(cname, sizeof(cname), "cooling_device%d", phy->mt76->band_idx);
 
 	cdev = thermal_cooling_device_register(name, phy, &mt7996_thermal_ops);
-- 
2.39.5



