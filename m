Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C33D1155CB3;
	Wed,  5 Feb 2025 14:24:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738765473; cv=none; b=YCu74hFDXGgiXefN7mehiC9JcWKakdYfXQC44MlvuCz16fUuPilI7DJcmKnhrRDRMKEEeyOyu8THlpVRGwr36LIH88wDstOLn2PrS0v73C5llHoMrzmsRtkzAqVelDJY/nBUrzYcq+HN0Ak/EHl68vd4CVEHdOcbwJDNLSt7ClQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738765473; c=relaxed/simple;
	bh=9ShpvCY4fitGzvqgUhOYynzA/ZuylWGafabvyCgKs2U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A1xgRPvIQ+dXJEVamFHq2fihLFBXYOj7wHrX6+NWb8G98MvaNRf+lPP0QAakibglhMq/+edvRCqCaphaEufszyA/8RiXz4DkkkcxsjHcePHt8I08MmREfOUqOTZhrQ+IoImE1dZg5zXKfFK6MO7PReTin8hgvRgSD06UX6LvVNU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DElwBAgn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DElwBAgn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF33DC4CED1;
	Wed,  5 Feb 2025 14:24:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738765473;
	bh=9ShpvCY4fitGzvqgUhOYynzA/ZuylWGafabvyCgKs2U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DElwBAgnKQ6IgxyETrVWGwkcFAHI/2TLXqcNjBV3MOj7fBv8SuEEBwgzsjB1I5b2V
	 HJwSE3ECZ2Ki4yuACc6902svcmukzGvrrD/yt3aGUsP7l9tfDao6GBr0d+TsUHnRp5
	 5Z20Xh1ZE8+EHbdE3uIn1PpvByinzvM6GSyW3zDE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Charles Han <hanchunchao@inspur.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 181/623] wifi: mt76: mt7925: fix NULL deref check in mt7925_change_vif_links
Date: Wed,  5 Feb 2025 14:38:43 +0100
Message-ID: <20250205134503.160095502@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134456.221272033@linuxfoundation.org>
References: <20250205134456.221272033@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Charles Han <hanchunchao@inspur.com>

[ Upstream commit 5cd0bd815c8a48862a296df9b30e0ea0da14acd3 ]

In mt7925_change_vif_links() devm_kzalloc() may return NULL but this
returned value is not checked.

Fixes: 69acd6d910b0 ("wifi: mt76: mt7925: add mt7925_change_vif_links")
Signed-off-by: Charles Han <hanchunchao@inspur.com>
Link: https://patch.msgid.link/20241025075554.181572-1-hanchunchao@inspur.com
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7925/main.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7925/main.c b/drivers/net/wireless/mediatek/mt76/mt7925/main.c
index 791c8b00e1126..a5110f8485e52 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7925/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/main.c
@@ -1946,6 +1946,8 @@ mt7925_change_vif_links(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 					     GFP_KERNEL);
 			mlink = devm_kzalloc(dev->mt76.dev, sizeof(*mlink),
 					     GFP_KERNEL);
+			if (!mconf || !mlink)
+				return -ENOMEM;
 		}
 
 		mconfs[link_id] = mconf;
-- 
2.39.5



