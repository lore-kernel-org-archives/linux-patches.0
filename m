Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7FF63C063A;
	Wed, 30 Sep 2026 18:58:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790794686; cv=none; b=m41hNneO/1Quc0sTkgVGEK9ojgAW2RPY1W0sqPcOAv2PAHETCLRUkVP7EHGG5JTU2r81g3VMkN2OV/bw8nKeuur1FFnYu980j7QVsVcUbHLcty9gopTReiX2kPzJ7SvYCEydtPQ33Exa8Zf8f41YcQdBITa7OOhTPCEc6rXbA5A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790794686; c=relaxed/simple;
	bh=ehXpfh9GClxMUNGoIXRFV2sOtWLrMfIV2x7n3iHoMgk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g/qSsVVvA7+H3TlMlVeveMWxLWdmBWbAaA39lkmaGFfhYBdpU4bx+Wn2eXD8j8Pqb3XaIfpfRtPbtGS5CAMVDwoGZ4fYsOPnia7+YWsBkmilC/tuZat9AfqDvtSBEfCOPQlHA1SGh0jYMCvkZiOkXGgRfbAoKRCz1KFdlNbl8Vw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YaI06HQl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YaI06HQl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E47B1F000FF;
	Wed, 30 Sep 2026 18:58:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790794685;
	bh=thGkumMGCKttTd5Q0TClOWs1/9mBtcWFookQyxiCq4o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YaI06HQlJ/UxEv05VWDleMCCkFRvNJnMz2U1KjytZ0+D22n9I0+HNjJVYq8lHnith
	 go2A85zHRUgYMpVyr4A0fjHLTGrn4h15yc34XZwJbRXOxBD020yC1yuih3Q2eJhc89
	 w/L5ZFCWhO9GZVjJjXGr+Ltwka9jO3123f9ddUiA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0298/1193] wifi: rsi: validate beacon length before fixed buffer copy
Date: Wed, 30 Sep 2026 17:16:22 +0200
Message-ID: <20260930152440.777889116@linuxfoundation.org>
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
index 2cebe562a1f4b..5873c0bac520d 100644
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



