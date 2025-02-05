Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5512B14A088;
	Wed,  5 Feb 2025 14:24:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738765463; cv=none; b=SscvMmpTKMTeeiNEE1T7VpYg3d1zMLc3P1S08MWaCnfklacHOQprFjSBzZc7wTRj5HI/P0kNsEn8EAT64wJiozpMrkBeZWAm1EhlmtrtTjb2gwOFUpZPC/VDsZMfQntO29f6gEYgK3ef5UfqEdxDlLnmAOFzFIS5ITLBuqXoYGU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738765463; c=relaxed/simple;
	bh=7D4+eenryfWlG3QQ04/ccRhgpPPi7V+dcUi/Ekj8HHo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FOJa6Vfh2mai1d5a1nj8TOUgCr+3a29PbE9WATS4lmuglv4o+8bHSo/70hj11ZN8IsZBLRr8Qc/HmzaJg0DKxhs8J+wj5UXzCWZhSJ4Ob21VcGT2RzsATEyGb+wL+TCPgMBLjNBzpi7rXQZNA9Gww9kR4FWalDptqC0s+fCg2Bg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KdzBWWu3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KdzBWWu3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B54DFC4CED1;
	Wed,  5 Feb 2025 14:24:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738765463;
	bh=7D4+eenryfWlG3QQ04/ccRhgpPPi7V+dcUi/Ekj8HHo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KdzBWWu3ImETw1AE0Fr/t0cNW3I8Fd9mfv3jXJrkT6NNh4tWmzjj385evHFCpiCam
	 89hI1tu1aySJmVlTCatln8dGZQRZanOV3hh4xEC3K/G2+/n9EEaixlI8mM8iziYxJ2
	 E4k6EValz+3j35M3BFG5QCdMGiPhHCU7vP7vhrKU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 180/623] wifi: mt76: mt7915: Fix an error handling path in mt7915_add_interface()
Date: Wed,  5 Feb 2025 14:38:42 +0100
Message-ID: <20250205134503.121516272@linuxfoundation.org>
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

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit 126a516fe30639708e759678bcb10178938cc718 ]

If mt76_wcid_alloc() fails, the "mt76.mutex" mutex needs to be released as
done in the other error handling paths of mt7915_add_interface().

Fixes: f3049b88b2b3 ("wifi: mt76: mt7915: allocate vif wcid in the same range as stations")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Link: https://patch.msgid.link/b9d8fbfc19360bfe60b9cea1cb0f735ab3b4bc26.1727639596.git.christophe.jaillet@wanadoo.fr
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7915/main.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7915/main.c b/drivers/net/wireless/mediatek/mt76/mt7915/main.c
index 8183708a9b355..351285daac99f 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/main.c
@@ -246,8 +246,10 @@ static int mt7915_add_interface(struct ieee80211_hw *hw,
 	phy->omac_mask |= BIT_ULL(mvif->mt76.omac_idx);
 
 	idx = mt76_wcid_alloc(dev->mt76.wcid_mask, mt7915_wtbl_size(dev));
-	if (idx < 0)
-		return -ENOSPC;
+	if (idx < 0) {
+		ret = -ENOSPC;
+		goto out;
+	}
 
 	INIT_LIST_HEAD(&mvif->sta.rc_list);
 	INIT_LIST_HEAD(&mvif->sta.wcid.poll_list);
-- 
2.39.5



