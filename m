Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3980619E7F7;
	Sat, 12 Sep 2026 08:20:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789201212; cv=none; b=Vfj8MWa0kps+3235LKK5O3tuZSMtcnYjh1tnZ4N4Np26X+7GSqBK5wONjP0I0WNDVESRbP7f05NbhOFG+4bMZ+tc9xaRSf3tvJlB+b9fAjotFFnWFqIB6Xen6ZiKLX+8O2h0reWRdepfn43F1u//mkvZ8VVimwEDD2mUx4oaZAo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789201212; c=relaxed/simple;
	bh=ZDnPgZ8OB6ECIDgRQECderbDCr4a0/bIF0PVyYJSs0w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RwheSt/WcKrqgV3YUl4IIEpxAwBgyhShgL0kv9K+7sGOcnHPdYvZqQLEebLeNECexFsSqvrpzv1pu0CODQBHug8cMnkKw5R3m3r+wIWg8G/HmZp0NyVBfpMfhErFnb/iYa3czYWnaBi5Ajxpq//CwBGIrDV4qftRxdq6w3SLtLg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WMvnSKza; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WMvnSKza"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E1E31F000FF;
	Sat, 12 Sep 2026 08:20:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789201211;
	bh=qskGDxzUqNuntbxMAeN62zqwcJ52V7neZ2dkH+OL/XA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WMvnSKzaIplolL/+aUP0WJ2fcMJMOxVD2I4j4y03wQgXd6uE73PzMKK8JtFzCYxf/
	 KFFded2hwYkfUerjA2bbynwUXJiJOl4f8URPN3CDNvuAqKP3nfpC4qTlqawT618YL9
	 DvgRyIEq/aOT7xykO+d6mi9BUNMaNfjXtiQAKMio=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Chiu <chui-hao.chiu@mediatek.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0949/1815] wifi: mt76: fix queue assignment for disassoc packets
Date: Sat, 12 Sep 2026 08:44:59 +0200
Message-ID: <20260912065711.237691898@linuxfoundation.org>
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

From: Peter Chiu <chui-hao.chiu@mediatek.com>

[ Upstream commit 3999d15cfcc72a946ec419c4059b0e0cd7860053 ]

Like deauth, a disassoc frame sent to a client in powersave mode can get
stuck in a tx queue along with other buffered frames, filling up hardware
queues with frames that are only released after the WTBL slot is reused
for another client.

Move disassoc packets to the ALTX queue, matching the existing deauth
handling.

Fixes: dedf2ec30fe4 ("wifi: mt76: fix queue assignment for deauth packets")
Signed-off-by: Peter Chiu <chui-hao.chiu@mediatek.com>
Link: https://patch.msgid.link/20260727150434.1778520-11-nbd@nbd.name
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/tx.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/mediatek/mt76/tx.c b/drivers/net/wireless/mediatek/mt76/tx.c
index dc8407be28913..b03be0eb47128 100644
--- a/drivers/net/wireless/mediatek/mt76/tx.c
+++ b/drivers/net/wireless/mediatek/mt76/tx.c
@@ -631,6 +631,7 @@ mt76_txq_schedule_pending_wcid(struct mt76_phy *phy, struct mt76_wcid *wcid,
 		    !ieee80211_is_data_present(hdr->frame_control) &&
 		    (!ieee80211_is_bufferable_mmpdu(skb) ||
 		     ieee80211_is_deauth(hdr->frame_control) ||
+		     ieee80211_is_disassoc(hdr->frame_control) ||
 		     head == &wcid->tx_offchannel))
 			qid = MT_TXQ_PSD;
 
-- 
2.53.0



