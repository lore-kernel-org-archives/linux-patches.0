Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 959343D75C7;
	Wed, 20 May 2026 18:01:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779300096; cv=none; b=KxiUm4JjteptdUf4mB0oJXJwQxEF3DayvpwoT7Z5GUHDaj3mowa0E25iYUsLSqJPbpsOwtBIgOvtadrETc+Ow8XIL2DO4Z/DqRD3TprnHZNXxq+VBW2KD++4fex1nFcY+VedcZwnj5T3/GuS9kWcKFLwb8E5IiYYpWE2wNNnQwg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779300096; c=relaxed/simple;
	bh=lxOkBBzq+6W5Qp4KysrWiwwjDRqvzhgJMJArOysUv7M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bbtvhZWW+V8Hy/gvf/hqui5uOmgmgBGbT5EXOO+qTfVVi1ajHoYnuOJR674cF0YGtiOXSsIkKYrY8cJbmNEn1MYweuc1w0nfj0n1jkgMQnL1g9G9A0lefc5WeqsKFJBY27WteGqxlewXDGgHHIKmqFPt+fUrgexIRbCprgDP0PY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ECBAZTTW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ECBAZTTW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 089421F000E9;
	Wed, 20 May 2026 18:01:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779300095;
	bh=u5A1dZNxOLPxPY3UvvmS6bwD4mu8z3gGjVBekdHAcCw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ECBAZTTWD8naOOwTtNsCXW5w27Qj2zMEQw8LiBHAoV10w+t/mm6nFaaFykkqhPARl
	 G1S+GMc2GfPrZSqOfudIuWo1ShgzcAZJS5iCvfT31/X80S/kG921f5mPbYOX9UnX4e
	 +m7u7TTildZOqilCdqnud8VjhR6JgauCHALB1+c8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ming Yen Hsieh <mingyen.hsieh@mediatek.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 046/666] wifi: mt76: mt7925: prevent NULL pointer dereference in mt7925_tx_check_aggr()
Date: Wed, 20 May 2026 18:14:17 +0200
Message-ID: <20260520162112.239313428@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162111.222830634@linuxfoundation.org>
References: <20260520162111.222830634@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ming Yen Hsieh <mingyen.hsieh@mediatek.com>

[ Upstream commit 83ae3a18ba957257b4c406273d2da2caeea2b439 ]

Move the NULL check for 'sta' before dereferencing it to prevent a
possible crash.

Fixes: 44eb173bdd4f ("wifi: mt76: mt7925: add link handling in mt7925_txwi_free")
Signed-off-by: Ming Yen Hsieh <mingyen.hsieh@mediatek.com>
Link: https://patch.msgid.link/20250904030649.655436-4-mingyen.hsieh@mediatek.com
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7925/mac.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7925/mac.c b/drivers/net/wireless/mediatek/mt76/mt7925/mac.c
index 18b7479cee799..e308c97b574b8 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7925/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/mac.c
@@ -849,11 +849,14 @@ static void mt7925_tx_check_aggr(struct ieee80211_sta *sta, struct sk_buff *skb,
 	bool is_8023;
 	u16 fc, tid;
 
+	if (!sta)
+		return;
+
 	link_sta = rcu_dereference(sta->link[wcid->link_id]);
 	if (!link_sta)
 		return;
 
-	if (!sta || !(link_sta->ht_cap.ht_supported || link_sta->he_cap.has_he))
+	if (!(link_sta->ht_cap.ht_supported || link_sta->he_cap.has_he))
 		return;
 
 	tid = skb->priority & IEEE80211_QOS_CTL_TID_MASK;
-- 
2.53.0



