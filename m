Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 018B82C3268;
	Thu, 15 Jan 2026 17:20:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768497636; cv=none; b=WonlxJP6+7sd63z3Sd4NuLzJDTiZc8hzH7EquUw9gPcu0rfgup8DEdJPj9G4zuyBWoIj91qilIkIfzSGexuFjgCoOpx/7HJJp7oZgbxJrjcqMAVGWsQ7NCks7yIU7CceuknMEcz628kJ9Ta4Lpvx+3RAhqNgrkNkK2PbDwPCuhU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768497636; c=relaxed/simple;
	bh=N/I4+OL9DXIgT7/gOzEq+B2heW33m6rUPd3pCy8Xtac=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=khyOdEln/jVU0FqiwdQ31nO7B+iVCxApBLbidpmel+f3WhlAvQA8IzyC/kHbvm9tBelK2c6x7PGzcM+7f9RcMFOkG/lcZFvXSapSVIXdjZvYgBO3jn2mamA/x1nejV3xsEG1dp2AA8iPt+uY7+s3SCyvFyw8pnbt4yrBRCcz0rk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MmlPqDqc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MmlPqDqc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 407B5C116D0;
	Thu, 15 Jan 2026 17:20:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768497635;
	bh=N/I4+OL9DXIgT7/gOzEq+B2heW33m6rUPd3pCy8Xtac=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MmlPqDqcipMpxOFuJ2DA4h127cIjOQKAKeNHphkw2iJCPDUtsaFYVV02UnCqYvsjX
	 jM6ECbH1nyui74HUnjc8CzpVlLjmp9RHCyxn4NOQQhv67T57PHc9atw9AFuPtwXtw7
	 ao6jHrdQO7o1T9AossDn6vFQCoezfDVJIUDOspMI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zilin Guan <zilin@seu.edu.cn>,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 133/554] mt76: mt7615: Fix memory leak in mt7615_mcu_wtbl_sta_add()
Date: Thu, 15 Jan 2026 17:43:19 +0100
Message-ID: <20260115164251.065317407@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164246.225995385@linuxfoundation.org>
References: <20260115164246.225995385@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index bde65af72feda..0776af7f74d94 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7615/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7615/mcu.c
@@ -1045,8 +1045,10 @@ mt7615_mcu_wtbl_sta_add(struct mt7615_phy *phy, struct ieee80211_vif *vif,
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



