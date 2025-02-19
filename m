Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6C751E25E1;
	Wed, 19 Feb 2025 08:53:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739955216; cv=none; b=KQqJKiGqZf20hPgMJnmnWynLXIkOMn0pL2MLhcbeQjicg/COc1rJxg0HUPMVShA1OZjHi5vweDKNFSkpU/SQw7jjPwhTUXm7e+rE5yrKZIE5IvHQj25GxO8qtg8K9sU1YLQVcEf9eXrkQHGpRF30Ml+rVVoHkXrQWZ6FltI1QVs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739955216; c=relaxed/simple;
	bh=qZjPbH3YUZ6ZoUUwHGqsK+nhrng1ksYPipAAwSqv4N0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mDhxQMLESs3FnDHq7hiNuqYfbDn4Li8wNOuUYQ/z3vI2ewx42NngzPQHus84DtR9wIHPqyvZv8vTKOfTknvjMFpEnomb6puRflqdP8//pvjq+0FZia9SctF0NnkCFYCbHtKkoDu7aPWneBvTyRd20/UBcljSimJWC9URelXppf8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZV6V7v7W; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZV6V7v7W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE0E5C4CED1;
	Wed, 19 Feb 2025 08:53:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739955216;
	bh=qZjPbH3YUZ6ZoUUwHGqsK+nhrng1ksYPipAAwSqv4N0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZV6V7v7WctfVIyOz6GldP0a5f7/wF6hcrOi+C0w+ElJOLujMnyKYIiMECkm52dDrl
	 jTyjye4LYmCo7Lu939W9fRGYINSkP7rA+fetJoXgsDyklDk20GXib9+Ve1C/7TeZMN
	 +OTTm6N5LGUpXuC7/vkSre921+DiBuoeC9RfXIQc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aditya Kumar Singh <aditya.kumar.singh@oss.qualcomm.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Subject: [PATCH 6.12 135/230] wifi: ath12k: fix handling of 6 GHz rules
Date: Wed, 19 Feb 2025 09:27:32 +0100
Message-ID: <20250219082606.965865791@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082601.683263930@linuxfoundation.org>
References: <20250219082601.683263930@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aditya Kumar Singh <aditya.kumar.singh@oss.qualcomm.com>

commit 64a1ba4072b34af1b76bf15fca5c2075b8cc4d64 upstream.

In the US country code, to avoid including 6 GHz rules in the 5 GHz rules
list, the number of 5 GHz rules is set to a default constant value of 4
(REG_US_5G_NUM_REG_RULES). However, if there are more than 4 valid 5 GHz
rules, the current logic will bypass the legitimate 6 GHz rules.

For example, if there are 5 valid 5 GHz rules and 1 valid 6 GHz rule, the
current logic will only consider 4 of the 5 GHz rules, treating the last
valid rule as a 6 GHz rule. Consequently, the actual 6 GHz rule is never
processed, leading to the eventual disabling of 6 GHz channels.

To fix this issue, instead of hardcoding the value to 4, use a helper
function to determine the number of 6 GHz rules present in the 5 GHz rules
list and ignore only those rules.

Tested-on: QCN9274 hw2.0 PCI WLAN.WBE.1.3.1-00173-QCAHKSWPL_SILICONZ-1

Cc: stable@vger.kernel.org
Fixes: d889913205cf ("wifi: ath12k: driver for Qualcomm Wi-Fi 7 devices")
Signed-off-by: Aditya Kumar Singh <aditya.kumar.singh@oss.qualcomm.com>
Link: https://patch.msgid.link/20250123-fix_6ghz_rules_handling-v1-1-d734bfa58ff4@oss.qualcomm.com
Signed-off-by: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/ath/ath12k/wmi.c |   61 +++++++++++++++++++++++++---------
 drivers/net/wireless/ath/ath12k/wmi.h |    1 
 2 files changed, 45 insertions(+), 17 deletions(-)

--- a/drivers/net/wireless/ath/ath12k/wmi.c
+++ b/drivers/net/wireless/ath/ath12k/wmi.c
@@ -4681,6 +4681,22 @@ static struct ath12k_reg_rule
 	return reg_rule_ptr;
 }
 
+static u8 ath12k_wmi_ignore_num_extra_rules(struct ath12k_wmi_reg_rule_ext_params *rule,
+					    u32 num_reg_rules)
+{
+	u8 num_invalid_5ghz_rules = 0;
+	u32 count, start_freq;
+
+	for (count = 0; count < num_reg_rules; count++) {
+		start_freq = le32_get_bits(rule[count].freq_info, REG_RULE_START_FREQ);
+
+		if (start_freq >= ATH12K_MIN_6G_FREQ)
+			num_invalid_5ghz_rules++;
+	}
+
+	return num_invalid_5ghz_rules;
+}
+
 static int ath12k_pull_reg_chan_list_ext_update_ev(struct ath12k_base *ab,
 						   struct sk_buff *skb,
 						   struct ath12k_reg_info *reg_info)
@@ -4691,6 +4707,7 @@ static int ath12k_pull_reg_chan_list_ext
 	u32 num_2g_reg_rules, num_5g_reg_rules;
 	u32 num_6g_reg_rules_ap[WMI_REG_CURRENT_MAX_AP_TYPE];
 	u32 num_6g_reg_rules_cl[WMI_REG_CURRENT_MAX_AP_TYPE][WMI_REG_MAX_CLIENT_TYPE];
+	u8 num_invalid_5ghz_ext_rules;
 	u32 total_reg_rules = 0;
 	int ret, i, j;
 
@@ -4784,20 +4801,6 @@ static int ath12k_pull_reg_chan_list_ext
 
 	memcpy(reg_info->alpha2, &ev->alpha2, REG_ALPHA2_LEN);
 
-	/* FIXME: Currently FW includes 6G reg rule also in 5G rule
-	 * list for country US.
-	 * Having same 6G reg rule in 5G and 6G rules list causes
-	 * intersect check to be true, and same rules will be shown
-	 * multiple times in iw cmd. So added hack below to avoid
-	 * parsing 6G rule from 5G reg rule list, and this can be
-	 * removed later, after FW updates to remove 6G reg rule
-	 * from 5G rules list.
-	 */
-	if (memcmp(reg_info->alpha2, "US", 2) == 0) {
-		reg_info->num_5g_reg_rules = REG_US_5G_NUM_REG_RULES;
-		num_5g_reg_rules = reg_info->num_5g_reg_rules;
-	}
-
 	reg_info->dfs_region = le32_to_cpu(ev->dfs_region);
 	reg_info->phybitmap = le32_to_cpu(ev->phybitmap);
 	reg_info->num_phy = le32_to_cpu(ev->num_phy);
@@ -4900,8 +4903,29 @@ static int ath12k_pull_reg_chan_list_ext
 		}
 	}
 
+	ext_wmi_reg_rule += num_2g_reg_rules;
+
+	/* Firmware might include 6 GHz reg rule in 5 GHz rule list
+	 * for few countries along with separate 6 GHz rule.
+	 * Having same 6 GHz reg rule in 5 GHz and 6 GHz rules list
+	 * causes intersect check to be true, and same rules will be
+	 * shown multiple times in iw cmd.
+	 * Hence, avoid parsing 6 GHz rule from 5 GHz reg rule list
+	 */
+	num_invalid_5ghz_ext_rules = ath12k_wmi_ignore_num_extra_rules(ext_wmi_reg_rule,
+								       num_5g_reg_rules);
+
+	if (num_invalid_5ghz_ext_rules) {
+		ath12k_dbg(ab, ATH12K_DBG_WMI,
+			   "CC: %s 5 GHz reg rules number %d from fw, %d number of invalid 5 GHz rules",
+			   reg_info->alpha2, reg_info->num_5g_reg_rules,
+			   num_invalid_5ghz_ext_rules);
+
+		num_5g_reg_rules = num_5g_reg_rules - num_invalid_5ghz_ext_rules;
+		reg_info->num_5g_reg_rules = num_5g_reg_rules;
+	}
+
 	if (num_5g_reg_rules) {
-		ext_wmi_reg_rule += num_2g_reg_rules;
 		reg_info->reg_rules_5g_ptr =
 			create_ext_reg_rules_from_wmi(num_5g_reg_rules,
 						      ext_wmi_reg_rule);
@@ -4913,7 +4937,12 @@ static int ath12k_pull_reg_chan_list_ext
 		}
 	}
 
-	ext_wmi_reg_rule += num_5g_reg_rules;
+	/* We have adjusted the number of 5 GHz reg rules above. But still those
+	 * many rules needs to be adjusted in ext_wmi_reg_rule.
+	 *
+	 * NOTE: num_invalid_5ghz_ext_rules will be 0 for rest other cases.
+	 */
+	ext_wmi_reg_rule += (num_5g_reg_rules + num_invalid_5ghz_ext_rules);
 
 	for (i = 0; i < WMI_REG_CURRENT_MAX_AP_TYPE; i++) {
 		reg_info->reg_rules_6g_ap_ptr[i] =
--- a/drivers/net/wireless/ath/ath12k/wmi.h
+++ b/drivers/net/wireless/ath/ath12k/wmi.h
@@ -3943,7 +3943,6 @@ struct ath12k_wmi_eht_rate_set_params {
 #define MAX_REG_RULES 10
 #define REG_ALPHA2_LEN 2
 #define MAX_6G_REG_RULES 5
-#define REG_US_5G_NUM_REG_RULES 4
 
 enum wmi_start_event_param {
 	WMI_VDEV_START_RESP_EVENT = 0,


