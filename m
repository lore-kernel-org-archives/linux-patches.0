Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B8705187EB;
	Wed, 30 Sep 2026 17:59:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790791152; cv=none; b=VQCIXktOaWGeNRD8lgi+nvzpi4D52qp3JmpnaoHH4mVQfk+0uU3XfNTWV73qQnB9S+dyGBiy8rbs1Ytked9wPf3ahdaKbDLMS+s7WNL3+uWQyvLnoGxFfiO4cOQJ7ylQ+pfLGshWR3Vcvx4AEtuadhUdYAok7I4b7MUjhyV/vVc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790791152; c=relaxed/simple;
	bh=ItTMARSCe0La3ZZRoOrzH/zdyu2/X3T7wIYj4M+DFNc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fOJs7KYH+LZbuVxPBWwAdGvDEpjX15J7DOSuMH1hJt0VYCw5Y0V+NKv+/MCY8CekmD846FKyjsbP2TZvJel8a4rb8GI2olXRxrKDIYGo/kNda2iTF81WFV5O6KQz9X8IYWAWMHNSBlo9ACFuNut3HHfqFzzlfCUgHn9xpqUvZpA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Xa6jfQXj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Xa6jfQXj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34EC81F000FF;
	Wed, 30 Sep 2026 17:59:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790791150;
	bh=YzvAziAlsswo/W9EZAGEsXzvyRA6kWfe8Hz8HVh8ImU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Xa6jfQXjjH1WQ4gnU3x38jlGGXPRJ3OStcp8z4j+NTq2iPdmZlJrpGT0EZtpgUfSC
	 X8LjQ+2sSZjAnBGTIATLLEhmcUxEC8VUFKkgzfVEp4cNpIumxNxn6wXe3yIx/ATitg
	 7QrhOPasduCg8WU8hud1BNr5pI3NjLbcmIqyW1xE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 202/752] wifi: rsi: validate beacon length before fixed buffer copy
Date: Wed, 30 Sep 2026 17:21:12 +0200
Message-ID: <20260930152402.594231821@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152358.131179731@linuxfoundation.org>
References: <20260930152358.131179731@linuxfoundation.org>
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
index 30d2eccbcadd5..62e36bbfecc48 100644
--- a/drivers/net/wireless/rsi/rsi_91x_hal.c
+++ b/drivers/net/wireless/rsi/rsi_91x_hal.c
@@ -434,6 +434,7 @@ int rsi_prepare_beacon(struct rsi_common *common, struct sk_buff *skb)
 	struct ieee80211_vif *vif;
 	struct sk_buff *mac_bcn;
 	u8 vap_id = 0, i;
+	unsigned int tailroom;
 	u16 tim_offset = 0;
 
 	for (i = 0; i < RSI_MAX_VIFS; i++) {
@@ -483,6 +484,13 @@ int rsi_prepare_beacon(struct rsi_common *common, struct sk_buff *skb)
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



