Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C0213AF674;
	Wed, 30 Sep 2026 18:57:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790794658; cv=none; b=Kee2lpXtGQdrd+BAWwIiMzr6BLrz38go0joi2mpJB/monbYm6T8clf2Ac+hVwmQ6wa6KH1HA3dQZcddyMN85SMhVeHLG0hNLLliAKXOqnCL57TLM3eH1rUAtTRYEyHqmx74PXG7fPEhxYR2hdq7XR2kytlJ0+Xd21rWGYw2M//0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790794658; c=relaxed/simple;
	bh=VelkpAIZ8U60XOBn4TlCJoFhMBGA8gW84GBV0T0XfUA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hxf3dlsDpX1s8Diu0wtmIkhAixWqhhvBE1H/6sklbFDq62KSmNpZLddOgircCTgHjdhgod9lL3TFveEUYtsPneTXbPL9745+b0RafHmYTpIE8o7KLF8uZvBQr6iCMy4gzolrA7J25W8UZCUmG6GplZVJihWLvcTZ1yhdDK3ZYRo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fYHC2yYX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fYHC2yYX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 906D71F000FF;
	Wed, 30 Sep 2026 18:57:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790794657;
	bh=WOQSjqN6Gix090TxV6PgNlWWLz0L/5VTJoasm4CaVb4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fYHC2yYXsHIUHpN2Z+HjIemAvl8JO1w5RdeUbj2M8jiiNZ81tqEgf/+BhXazwBkmh
	 2F+Kcl5/idKQkEUert5kYG5QqJ/cat7YBX9mF8dr011ysuVO6QDrF+q3g9mTwolKGw
	 opYlu+FqIkTT5mFa2BY0L8I531VlCOig/pX8c2EI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0289/1193] wifi: libertas: reject short monitor TX frames
Date: Wed, 30 Sep 2026 17:16:13 +0200
Message-ID: <20260930152440.584832977@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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
index 27304a98787d6..13d08022e4141 100644
--- a/drivers/net/wireless/marvell/libertas/tx.c
+++ b/drivers/net/wireless/marvell/libertas/tx.c
@@ -117,6 +117,13 @@ netdev_tx_t lbs_hard_start_xmit(struct sk_buff *skb, struct net_device *dev)
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



