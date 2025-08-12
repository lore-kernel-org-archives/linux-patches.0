Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5E602FF14E;
	Tue, 12 Aug 2025 18:40:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755024033; cv=none; b=pqaJPx5M/K6+MyEp023O16DYYXKwQFqug6xyvR4gtHjdaFUmp102ycB2mgX+QMy5jvskNm0Mx0Lxs8RhX1bgrclQfV1r9T3aeG21m8KV+eL6OyKLVfvZ7b6V12fJWktf0F3eY14U2nu/VfNbzV9Wwl15seAlYH+5j2JwZp1SZjQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755024033; c=relaxed/simple;
	bh=/2dZPHv47RN0ZeAaPsm5QSq4dF6sTaRykZZ42aIOfRY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ycxwm0CWTonyVLz60pqYAVTKmlwUxSwK4zO+TQHiP7IdChDiCz56RcS/zhxl4Luv2zVvZNMihw2sRgxdTqI105yyESjaJOrspzCYfl9s9JfgF+iMZ/a/Cql/1niRpVjIQgmjiWP/bPZugvCJF6yHPNm34l7Rf8TLeIDR18L+TEY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vZ9/JX6/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vZ9/JX6/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5B74C4CEF1;
	Tue, 12 Aug 2025 18:40:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755024033;
	bh=/2dZPHv47RN0ZeAaPsm5QSq4dF6sTaRykZZ42aIOfRY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vZ9/JX6/5VtO9Vh5xeG3EMxlD3W3IfQwA2GzedE1GoL6LgAmwUj3O9DiTqS4FZDnJ
	 7wUlwWLH+akrXVgne2sjSkFkLEAlqMdaqcVwPaiUPOaiNtPO0OlSEJFIrR6Bhw4Gql
	 cme1fwR7vkxiyllViegZSmk0qIFgyOFcOcdYH6VM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ting-Ying Li <tingying.li@cypress.com>,
	Gokul Sivakumar <gokulkumar.sivakumar@infineon.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	Arend van Spriel <arend.vanspriel@broadcom.com>
Subject: [PATCH 6.16 254/627] wifi: brcmfmac: fix EXTSAE WPA3 connection failure due to AUTH TX failure
Date: Tue, 12 Aug 2025 19:29:09 +0200
Message-ID: <20250812173428.981831643@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173419.303046420@linuxfoundation.org>
References: <20250812173419.303046420@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ting-Ying Li <tingying.li@cypress.com>

[ Upstream commit f2d7c3c380bf0c38c395d50de3a7c1a6275983cb ]

For WPA3-SAE Connection in EXTSAE mode, the userspace daemon is allowed to
generate the SAE Auth frames. The driver uses the "mgmt_frame" FW IOVAR to
transmit this MGMT frame.

Before sending the IOVAR, the Driver is incorrectly treating the channel
number read from the FW as a frequency value and again attempts to convert
this into a channel number using ieee80211_frequency_to_channel().

This added an invalid channel number as part of the IOVAR request to the FW
And some FW which strictly expects a valid channel would return BAD_CHAN
error, while failing to transmit the driver requested SAE Auth MGMT frame.

Fix this in the CYW vendor specific MGMT TX cfg80211 ops handler, by not
treating the channel number read from the FW as frequency value and skip
the attempt to convert it again into a channel number.

Also fix this in the generic MGMT TX cfg80211 ops handler.

Fixes: c2ff8cad6423 ("brcm80211: make mgmt_tx in brcmfmac accept a NULL channel")
Fixes: 66f909308a7c ("wifi: brcmfmac: cyw: support external SAE authentication in station mode")
Signed-off-by: Ting-Ying Li <tingying.li@cypress.com>
Signed-off-by: Gokul Sivakumar <gokulkumar.sivakumar@infineon.com>
Acked-by: Arend van Spriel <arend.vanspriel@broadcom.com>>
Link: https://patch.msgid.link/20250723105918.5229-1-gokulkumar.sivakumar@infineon.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../broadcom/brcm80211/brcmfmac/cfg80211.c    | 30 ++++++++++++-------
 .../broadcom/brcm80211/brcmfmac/cyw/core.c    | 26 +++++++++-------
 2 files changed, 35 insertions(+), 21 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
index 086b9157292a..70e8ddd3851f 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
@@ -5527,8 +5527,7 @@ brcmf_cfg80211_mgmt_tx(struct wiphy *wiphy, struct wireless_dev *wdev,
 	struct brcmf_fil_action_frame_le *action_frame;
 	struct brcmf_fil_af_params_le *af_params;
 	bool ack;
-	s32 chan_nr;
-	u32 freq;
+	__le32 hw_ch;
 
 	brcmf_dbg(TRACE, "Enter\n");
 
@@ -5589,25 +5588,34 @@ brcmf_cfg80211_mgmt_tx(struct wiphy *wiphy, struct wireless_dev *wdev,
 		/* Add the channel. Use the one specified as parameter if any or
 		 * the current one (got from the firmware) otherwise
 		 */
-		if (chan)
-			freq = chan->center_freq;
-		else
-			brcmf_fil_cmd_int_get(vif->ifp, BRCMF_C_GET_CHANNEL,
-					      &freq);
-		chan_nr = ieee80211_frequency_to_channel(freq);
-		af_params->channel = cpu_to_le32(chan_nr);
+		if (chan) {
+			hw_ch = cpu_to_le32(chan->hw_value);
+		} else {
+			err = brcmf_fil_cmd_data_get(vif->ifp,
+						     BRCMF_C_GET_CHANNEL,
+						     &hw_ch, sizeof(hw_ch));
+			if (err) {
+				bphy_err(drvr,
+					 "unable to get current hw channel\n");
+				goto free;
+			}
+		}
+		af_params->channel = hw_ch;
+
 		af_params->dwell_time = cpu_to_le32(params->wait);
 		memcpy(action_frame->data, &buf[DOT11_MGMT_HDR_LEN],
 		       le16_to_cpu(action_frame->len));
 
-		brcmf_dbg(TRACE, "Action frame, cookie=%lld, len=%d, freq=%d\n",
-			  *cookie, le16_to_cpu(action_frame->len), freq);
+		brcmf_dbg(TRACE, "Action frame, cookie=%lld, len=%d, channel=%d\n",
+			  *cookie, le16_to_cpu(action_frame->len),
+			  le32_to_cpu(af_params->channel));
 
 		ack = brcmf_p2p_send_action_frame(cfg, cfg_to_ndev(cfg),
 						  af_params);
 
 		cfg80211_mgmt_tx_status(wdev, *cookie, buf, len, ack,
 					GFP_KERNEL);
+free:
 		kfree(af_params);
 	} else {
 		brcmf_dbg(TRACE, "Unhandled, fc=%04x!!\n", mgmt->frame_control);
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cyw/core.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cyw/core.c
index c9537fb597ce..4f0ea4347840 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cyw/core.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cyw/core.c
@@ -112,8 +112,7 @@ int brcmf_cyw_mgmt_tx(struct wiphy *wiphy, struct wireless_dev *wdev,
 	struct brcmf_cfg80211_vif *vif;
 	s32 err = 0;
 	bool ack = false;
-	s32 chan_nr;
-	u32 freq;
+	__le16 hw_ch;
 	struct brcmf_mf_params_le *mf_params;
 	u32 mf_params_len;
 	s32 ready;
@@ -143,13 +142,18 @@ int brcmf_cyw_mgmt_tx(struct wiphy *wiphy, struct wireless_dev *wdev,
 	mf_params->len = cpu_to_le16(len - DOT11_MGMT_HDR_LEN);
 	mf_params->frame_control = mgmt->frame_control;
 
-	if (chan)
-		freq = chan->center_freq;
-	else
-		brcmf_fil_cmd_int_get(vif->ifp, BRCMF_C_GET_CHANNEL,
-				      &freq);
-	chan_nr = ieee80211_frequency_to_channel(freq);
-	mf_params->channel = cpu_to_le16(chan_nr);
+	if (chan) {
+		hw_ch = cpu_to_le16(chan->hw_value);
+	} else {
+		err = brcmf_fil_cmd_data_get(vif->ifp, BRCMF_C_GET_CHANNEL,
+					     &hw_ch, sizeof(hw_ch));
+		if (err) {
+			bphy_err(drvr, "unable to get current hw channel\n");
+			goto free;
+		}
+	}
+	mf_params->channel = hw_ch;
+
 	memcpy(&mf_params->da[0], &mgmt->da[0], ETH_ALEN);
 	memcpy(&mf_params->bssid[0], &mgmt->bssid[0], ETH_ALEN);
 	mf_params->packet_id = cpu_to_le32(*cookie);
@@ -159,7 +163,8 @@ int brcmf_cyw_mgmt_tx(struct wiphy *wiphy, struct wireless_dev *wdev,
 	brcmf_dbg(TRACE, "Auth frame, cookie=%d, fc=%04x, len=%d, channel=%d\n",
 		  le32_to_cpu(mf_params->packet_id),
 		  le16_to_cpu(mf_params->frame_control),
-		  le16_to_cpu(mf_params->len), chan_nr);
+		  le16_to_cpu(mf_params->len),
+		  le16_to_cpu(mf_params->channel));
 
 	vif->mgmt_tx_id = le32_to_cpu(mf_params->packet_id);
 	set_bit(BRCMF_MGMT_TX_SEND_FRAME, &vif->mgmt_tx_status);
@@ -185,6 +190,7 @@ int brcmf_cyw_mgmt_tx(struct wiphy *wiphy, struct wireless_dev *wdev,
 tx_status:
 	cfg80211_mgmt_tx_status(wdev, *cookie, buf, len, ack,
 				GFP_KERNEL);
+free:
 	kfree(mf_params);
 	return err;
 }
-- 
2.39.5



