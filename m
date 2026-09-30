Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 767454E5322;
	Wed, 30 Sep 2026 15:39:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790782764; cv=none; b=QzEGT5oIbseIrOWT0V1D3eu1y7iZMFgkm7z11L2em1orULUmyCFdeO9uCTHlhVRre3furHqW6ua93nNI0VYH1o8NgyFAL6w3wWgld7D1auDMtqQdAwzJIaU/8oqEPfDQc5pcvfC31TTPpiE07/KPz8dadVS8fxepvR6dR13WILw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790782764; c=relaxed/simple;
	bh=uldaRW2ZzNX9rUEJD7bSzdWHR/1/nBz8ukGu/KR53Gk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n62WT3L4svOPKY32Yi/hds3HpmC8Xp/nbQsCO3UbIFyTPaFmlBRoutBfiIOiMVPg6Ff9NnwmijApPCkmxlwELBkMoOB11QfeFm1BTN/6i/rMLP/t4rukJXavwF5m/1MAt9HhE21Nq7m/yEY1OPNZXOtlo67YqZqwp0otVD52NSU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=W4h2RsZN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="W4h2RsZN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2355D1F000FF;
	Wed, 30 Sep 2026 15:39:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790782760;
	bh=+RkI+ZXxEyTKvC8a5r+Doc3+T9KZKNC0b0SHjnU7Ljs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=W4h2RsZNDaIlPilezCi2eNREJ8dZrvXvtk5nGOjkYv7ybIKwtpgV+NooWrOZDG2bL
	 ITrVatF9ay8Se9sDyc6CaR4GyQmaHHJIjV8a8nUcuk30oZM/OUxQoxUKFxcvB2YpZR
	 VX8dXmbMAO+m4QQkmyhbAiihaGYL2Ba6AXSHMec0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 158/595] wifi: libertas: reject short monitor TX frames
Date: Wed, 30 Sep 2026 17:20:51 +0200
Message-ID: <20260930152351.134293529@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152347.700140858@linuxfoundation.org>
References: <20260930152347.700140858@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pengpeng Hou <pengpeng@iscas.ac.cn>

[ Upstream commit 13ff543e0b2c713aedeaadadde686686e949dc78 ]

In monitor mode, lbs_hard_start_xmit() casts skb->data to a
radiotap TX header, skips that header, and then copies the 802.11
destination address from offset 4 in the remaining frame.  The
generic length check only rejects zero-length and oversized skbs, so
a short monitor frame can be read past the end of the skb data.

Require enough bytes for the radiotap TX header and the destination
address field before using the monitor-mode header layout.

Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
Link: https://patch.msgid.link/20260704011140.37639-1-pengpeng@iscas.ac.cn
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/marvell/libertas/tx.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/net/wireless/marvell/libertas/tx.c b/drivers/net/wireless/marvell/libertas/tx.c
index aeb481740df67..d56969920506d 100644
--- a/drivers/net/wireless/marvell/libertas/tx.c
+++ b/drivers/net/wireless/marvell/libertas/tx.c
@@ -116,6 +116,13 @@ netdev_tx_t lbs_hard_start_xmit(struct sk_buff *skb, struct net_device *dev)
 	if (priv->wdev->iftype == NL80211_IFTYPE_MONITOR) {
 		struct tx_radiotap_hdr *rtap_hdr = (void *)skb->data;
 
+		if (skb->len < sizeof(*rtap_hdr) + 4 + ETH_ALEN) {
+			lbs_deb_tx("tx err: short monitor frame %u\n", skb->len);
+			dev->stats.tx_dropped++;
+			dev->stats.tx_errors++;
+			goto free;
+		}
+
 		/* set txpd fields from the radiotap header */
 		txpd->tx_control = cpu_to_le32(convert_radiotap_rate_to_mv(rtap_hdr->rate));
 
-- 
2.53.0



