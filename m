Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CD0A1519BE;
	Wed,  5 Feb 2025 14:18:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738765139; cv=none; b=XmJGlYX54f0DzIM5osRMTwrV22LkaMK6kNW+E+ZBCexWnsoUXYJ8RlU4n7em6lTQc+zKAJWyOpTYB/a94ghFxskXYPOQ2cCTxU8w58zlqLbfDa7MNABWMPAERtXeRo0PfZma/Lni0MMu4bPkC7ctOk8zKMZuKFpobKAG8GqbAFw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738765139; c=relaxed/simple;
	bh=IiAcCYpl8MiGEiZylaRPjdLwyCGNZm7dWbfO5ZlK794=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WupnqjFivdypiQGhzn+yj+5rxfuvGH/GShA3TobcPGur/UdaSL8Qlh3eaMMlp5nJ4Sw0kQg2GpKt2X5EUhd75rHaxa9Uixdo46jAyzA3MRoutDcFzzKav9bqG6kpOkCwdxVAM3tVQUMp6FH3HKQzdjhmI5O9mQNbNb6XZCRTbe8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jKZka/ok; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jKZka/ok"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CDC9C4CED1;
	Wed,  5 Feb 2025 14:18:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738765139;
	bh=IiAcCYpl8MiGEiZylaRPjdLwyCGNZm7dWbfO5ZlK794=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jKZka/okROM+21oQtgytdTBRXFZyhhuWVLSx6adylx3qfyJPwrG3Q8eXd84FN60mf
	 d2imALwxLRf+XSBhJWIIxs2FCt84Mt1tITwr1+wR5gVjAiBuIpv9N/BT6w5Sh2sN2B
	 20gGE04eByXj1asRqJ76eknph57ptwWsQpEb0K5M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 174/590] wifi: mt76: mt7915: Fix an error handling path in mt7915_add_interface()
Date: Wed,  5 Feb 2025 14:38:49 +0100
Message-ID: <20250205134501.938814228@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134455.220373560@linuxfoundation.org>
References: <20250205134455.220373560@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index b7884772e2f40..8c0d63cebf3e1 100644
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



