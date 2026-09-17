Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7571653E2FB;
	Thu, 17 Sep 2026 17:06:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789664812; cv=none; b=JLM+T171L27glccW3PTIQPlyLcRdCbD856I3f25HfuWbsceuqv6s1IP4qo9Oj7Anahwr1QLG3H7tkum9r/o/SSU6tB0MSM/n50ac7Q30neOZk39mv5rKvdUo76hVRjTSpB9W9rhOlp098x8Qvki0PXh1hpB/Z4py2t3eheZhHNw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789664812; c=relaxed/simple;
	bh=5HTz1lvK8rgjUiAnrjnvBblB1AISjaE/1wQF6MM5qTw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mI13cvkj7QcGiotxmgWDwfogjNeROHt3MQCLzOwS8A0DdqjhhVb3hqOtLvKj7A7Dzl2/8BzUZbGi0vR2iTyhevVYMj1kfO0THdX+dv7vvly3lRrR4GOZJtpYTDIg1UVYh52sawff++zy8f02wN5Lx/Fwwx1pCPy7QhBqvjKeHd8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aePrLMkC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aePrLMkC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 807D11F00893;
	Thu, 17 Sep 2026 17:06:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789664811;
	bh=YPC7W1+zDd/u2ZfBM/zzjAyrmQpzqUgw3PjQDKMbeiE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aePrLMkCQmD9qkxTjvEkZtDCzqq4kj4OCRGlOWIs+UZkDRtL9T7CQRV6wsDi4egBf
	 xyWLlQwSpszTLGbMj+QPU3/rMyUNqWcwZ+x/GMEpiVIpShKz/ATccIgIm7HSuztcgg
	 BCl6Luc/cDi7I1o7/Oc08TkeLAlXbFxChTnbcARg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhao Li <enderaoelyther@gmail.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0496/1250] wifi: cfg80211: validate assoc response length before status and IE access
Date: Thu, 17 Sep 2026 16:04:51 +0100
Message-ID: <20260917151605.407531097@linuxfoundation.org>
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

From: Zhao Li <enderaoelyther@gmail.com>

[ Upstream commit b760113aeca2e9362d56bf9e9263373ffe6c8eb3 ]

cfg80211_rx_assoc_resp() initialises the status and response-IE fields
of cfg80211_connect_resp_params from the management frame before
proving that the frame is long enough for those offsets. S1G and
regular association responses also have different IE offsets, but the
S1G path only patched resp_ie after the unsafe initialiser had already
run.

Defer resp_ie, resp_ie_len, and status to after the link-iteration
loop. Use a bool to remember whether the frame is S1G, then validate
the appropriate minimum length and set all three fields in a single
if/else block. Funnel short-frame and SME-reject cleanup through a
shared free_bss label for the abandon paths.

Assisted-by: Codex:gpt-5.5
Assisted-by: Claude:claude-opus-4.8
Signed-off-by: Zhao Li <enderaoelyther@gmail.com>
Link: https://patch.msgid.link/20260707025336.22557-2-enderaoelyther@gmail.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/wireless/mlme.c | 56 ++++++++++++++++++++++++++++-----------------
 1 file changed, 35 insertions(+), 21 deletions(-)

diff --git a/net/wireless/mlme.c b/net/wireless/mlme.c
index 3fc175f9f8686..bf2c0d26e11c6 100644
--- a/net/wireless/mlme.c
+++ b/net/wireless/mlme.c
@@ -32,14 +32,10 @@ void cfg80211_rx_assoc_resp(struct net_device *dev,
 		.timeout_reason = NL80211_TIMEOUT_UNSPECIFIED,
 		.req_ie = data->req_ies,
 		.req_ie_len = data->req_ies_len,
-		.resp_ie = mgmt->u.assoc_resp.variable,
-		.resp_ie_len = data->len -
-			       offsetof(struct ieee80211_mgmt,
-					u.assoc_resp.variable),
-		.status = le16_to_cpu(mgmt->u.assoc_resp.status_code),
 		.ap_mld_addr = data->ap_mld_addr,
 	};
 	unsigned int link_id;
+	bool is_s1g = false;
 
 	for (link_id = 0; link_id < ARRAY_SIZE(data->links); link_id++) {
 		cr.links[link_id].status = data->links[link_id].status;
@@ -60,16 +56,32 @@ void cfg80211_rx_assoc_resp(struct net_device *dev,
 
 		if (cr.links[link_id].bss->channel->band == NL80211_BAND_S1GHZ) {
 			WARN_ON(link_id);
-			cr.resp_ie = (u8 *)&mgmt->u.s1g_assoc_resp.variable;
-			cr.resp_ie_len = data->len -
-					 offsetof(struct ieee80211_mgmt,
-						  u.s1g_assoc_resp.variable);
+			is_s1g = true;
 		}
 
 		if (cr.ap_mld_addr)
 			cr.valid_links |= BIT(link_id);
 	}
 
+	if (is_s1g) {
+		if (data->len < offsetof(struct ieee80211_mgmt,
+					 u.s1g_assoc_resp.variable))
+			goto free_bss;
+		cr.resp_ie = (u8 *)&mgmt->u.s1g_assoc_resp.variable;
+		cr.resp_ie_len = data->len -
+				 offsetof(struct ieee80211_mgmt,
+					  u.s1g_assoc_resp.variable);
+	} else {
+		if (data->len < offsetof(struct ieee80211_mgmt,
+					 u.assoc_resp.variable))
+			goto free_bss;
+		cr.resp_ie = mgmt->u.assoc_resp.variable;
+		cr.resp_ie_len = data->len -
+				 offsetof(struct ieee80211_mgmt,
+					  u.assoc_resp.variable);
+	}
+	cr.status = le16_to_cpu(mgmt->u.assoc_resp.status_code);
+
 	trace_cfg80211_send_rx_assoc(dev, data);
 
 	/*
@@ -78,22 +90,24 @@ void cfg80211_rx_assoc_resp(struct net_device *dev,
 	 * and got a reject -- we only try again with an assoc
 	 * frame instead of reassoc.
 	 */
-	if (cfg80211_sme_rx_assoc_resp(wdev, cr.status)) {
-		for (link_id = 0; link_id < ARRAY_SIZE(data->links); link_id++) {
-			struct cfg80211_bss *bss = data->links[link_id].bss;
-
-			if (!bss)
-				continue;
-
-			cfg80211_unhold_bss(bss_from_pub(bss));
-			cfg80211_put_bss(wiphy, bss);
-		}
-		return;
-	}
+	if (cfg80211_sme_rx_assoc_resp(wdev, cr.status))
+		goto free_bss;
 
 	nl80211_send_rx_assoc(rdev, dev, data);
 	/* update current_bss etc., consumes the bss reference */
 	__cfg80211_connect_result(dev, &cr, cr.status == WLAN_STATUS_SUCCESS);
+	return;
+
+free_bss:
+	for (link_id = 0; link_id < ARRAY_SIZE(data->links); link_id++) {
+		struct cfg80211_bss *bss = data->links[link_id].bss;
+
+		if (!bss)
+			continue;
+
+		cfg80211_unhold_bss(bss_from_pub(bss));
+		cfg80211_put_bss(wiphy, bss);
+	}
 }
 EXPORT_SYMBOL(cfg80211_rx_assoc_resp);
 
-- 
2.53.0



