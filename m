Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE3483469F6;
	Tue, 16 Dec 2025 11:54:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765886098; cv=none; b=CyAHmhFKKIn203WXgeabQQ0DHA4g780A/D5RSXRt6bwtC/Rk/rwAIUier8pMzSBnHruuH4Nn2QM6n1WcpCao4aYfjE0dtZ3sSrddXeNmgNiUNmAFPZ5p+Rnywi/g5Yw069z0aISSjqGURVAYojTRr1P7jGp6oVzTRqaxz3SxeTU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765886098; c=relaxed/simple;
	bh=gL835c/mOLa4sQ76Fv2v9EUSf2BMbAATHZjUQ7M6dlg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cDPSSM+zXJK2aBvADGJd0zJQMwXeLVh8wSZHRywRsIvtiztiTFKIiFLSI+iwHH68pMSUQF7ZHVxxZGR5O+yCaWqcqWKcZZ2bMWAsPoR4IjrU1x4Wx9T+l6d0AAFq4P6OFWROtfAHvRjhlMuDzsuMcA4EOB2Cja6qxBS50v7aqRM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bujSgNGM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bujSgNGM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B143C4CEF1;
	Tue, 16 Dec 2025 11:54:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765886098;
	bh=gL835c/mOLa4sQ76Fv2v9EUSf2BMbAATHZjUQ7M6dlg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bujSgNGMnWi5aLbJ3T9tlh13vfLALHfqafYSpf8/mI67rW9YKuu1WxvYfBtQnUzKd
	 EDJazhRHPZ8kT7hNjc9o02dHCrbGQm0pS95cYSD80veuHD1BthuA9iO0gIpSxHFRYG
	 DCsF8+eMZcHBB4Ndj+WfK9KTbw+JhnvGr3ZbpZqo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zilin Guan <zilin@seu.edu.cn>,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 337/507] mt76: mt7615: Fix memory leak in mt7615_mcu_wtbl_sta_add()
Date: Tue, 16 Dec 2025 12:12:58 +0100
Message-ID: <20251216111357.672228109@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111345.522190956@linuxfoundation.org>
References: <20251216111345.522190956@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zilin Guan <zilin@seu.edu.cn>

[ Upstream commit 53d1548612670aa8b5d89745116cc33d9d172863 ]

In mt7615_mcu_wtbl_sta_add(), an skb sskb is allocated. If the
subsequent call to mt76_connac_mcu_alloc_wtbl_req() fails, the function
returns an error without freeing sskb, leading to a memory leak.

Fix this by calling dev_kfree_skb() on sskb in the error handling path
to ensure it is properly released.

Fixes: 99c457d902cf9 ("mt76: mt7615: move mt7615_mcu_set_bmc to mt7615_mcu_ops")
Signed-off-by: Zilin Guan <zilin@seu.edu.cn>
Acked-by: Lorenzo Bianconi <lorenzo@kernel.org>
Link: https://patch.msgid.link/20251113062415.103611-1-zilin@seu.edu.cn
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7615/mcu.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7615/mcu.c b/drivers/net/wireless/mediatek/mt76/mt7615/mcu.c
index 4064e193d4dec..08ee2e861c4e2 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7615/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7615/mcu.c
@@ -874,8 +874,10 @@ mt7615_mcu_wtbl_sta_add(struct mt7615_phy *phy, struct ieee80211_vif *vif,
 	wtbl_hdr = mt76_connac_mcu_alloc_wtbl_req(&dev->mt76, &msta->wcid,
 						  WTBL_RESET_AND_SET, NULL,
 						  &wskb);
-	if (IS_ERR(wtbl_hdr))
+	if (IS_ERR(wtbl_hdr)) {
+		dev_kfree_skb(sskb);
 		return PTR_ERR(wtbl_hdr);
+	}
 
 	if (enable) {
 		mt76_connac_mcu_wtbl_generic_tlv(&dev->mt76, wskb, vif, sta,
-- 
2.51.0



