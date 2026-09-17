Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41DA153E319;
	Thu, 17 Sep 2026 17:07:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789664842; cv=none; b=maHpRNqRqRaP1/vPI3OgpY1GwNx5uP+3c4h25tGd/CTX5lESPwqUDagtvznyYZ+m+aox16NipB8yGgCnl48SWLfbk0naf7BMerQZR7XTLUPQvUm29FiHDlMdbvOtGJlANB76aqsRlrNK+yA5lDKBXpR0vOSUL3cwYBmb12OMn0s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789664842; c=relaxed/simple;
	bh=zoZksgqIrUPUc0iLwkYFrB7VWF27baV6/7TzH62ghak=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ob1SMAV80ceSNsB554GR1LgTXsbfGwaB0+ucbl1Qi294fxmfFK/75QymJ5NtMzdnVoogHjLIA6FQa9AIzsua78AXmgghwPDQ0sXsTcYj9F/G+eP7DZrxCQ6teVVdak6OWzHsjiGPQxhjW4KkO6A9lXBE5Dr5yLZC20m6vc/nWDc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SKiRuVmq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SKiRuVmq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65BE11F00893;
	Thu, 17 Sep 2026 17:07:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789664841;
	bh=mMi3YdljJxNPUIFzuQVY9RemY8MKxutCfQlWKeXzpKQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SKiRuVmqDloKX/gqIE0y/ZkX37cSR51jibfeuzmlZ+0E3BjEDowS1i2Qg03aqZgqW
	 TU54zQDz5iVUyQM3S41G8EKohtHdlCZryMLWIkfX7Zi6DnC8OztR5fpUkDlASu/g1c
	 S9ckfl09rtq6zUZKvuF0/eYNgPVKCB48Pcjn29pQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0505/1250] wifi: rsi: validate beacon length before fixed buffer copy
Date: Thu, 17 Sep 2026 16:05:00 +0100
Message-ID: <20260917151605.647420688@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pengpeng Hou <pengpeng@iscas.ac.cn>

[ Upstream commit 8ecdeb8b8a33b22c597299043c0dcfce50beb9ea ]

rsi_prepare_beacon() copies the mac80211 beacon frame after
FRAME_DESC_SZ into a management skb whose usable tailroom may be smaller
than MAX_MGMT_PKT_SIZE after alignment.

Validate the beacon length against the actual tailroom before the copy
and skb_put(). Leave ownership of the management skb with the caller on
error, matching the existing rsi_send_beacon() cleanup path.

Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
Link: https://patch.msgid.link/20260705084824.68105-1-pengpeng@iscas.ac.cn
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/rsi/rsi_91x_hal.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/net/wireless/rsi/rsi_91x_hal.c b/drivers/net/wireless/rsi/rsi_91x_hal.c
index 7d26314a3e76a..50f77f3eee92c 100644
--- a/drivers/net/wireless/rsi/rsi_91x_hal.c
+++ b/drivers/net/wireless/rsi/rsi_91x_hal.c
@@ -431,6 +431,7 @@ int rsi_prepare_beacon(struct rsi_common *common, struct sk_buff *skb)
 	struct ieee80211_vif *vif;
 	struct sk_buff *mac_bcn;
 	u8 vap_id = 0, i;
+	unsigned int tailroom;
 	u16 tim_offset = 0;
 
 	for (i = 0; i < RSI_MAX_VIFS; i++) {
@@ -480,6 +481,13 @@ int rsi_prepare_beacon(struct rsi_common *common, struct sk_buff *skb)
 	if (mac_bcn->data[tim_offset + 2] == 0)
 		bcn_frm->frame_info |= cpu_to_le16(RSI_DATA_DESC_DTIM_BEACON);
 
+	tailroom = skb_tailroom(skb);
+	if (tailroom < FRAME_DESC_SZ ||
+	    mac_bcn->len > tailroom - FRAME_DESC_SZ) {
+		dev_kfree_skb(mac_bcn);
+		return -EMSGSIZE;
+	}
+
 	memcpy(&skb->data[FRAME_DESC_SZ], mac_bcn->data, mac_bcn->len);
 	skb_put(skb, mac_bcn->len + FRAME_DESC_SZ);
 
-- 
2.53.0



