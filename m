Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5C651CFEBA;
	Wed,  2 Oct 2024 13:21:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727875315; cv=none; b=EKsu4XdHZ+k9EbDPtOIUn42CF5/Fo1NfZLap2WtGUZHbYsUbQyEy8qzT4TqmzgMeJIhjGOAKLqWI5LfzH3CD4w0/lLJhOx0+wUUtkWcliOb7bJ1Jvs9dgulxtyXp66LZmuUBaHdRSFBUOS0B9itebTXbU/Elu0BEURPqQ9OZFB8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727875315; c=relaxed/simple;
	bh=R5h01oQb5mkK1faO9l7udhmkIPY7O0lvbcFLh/dc6Yo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GEL036qHqXShA2277DsD91m5Sp32P7yvabrLnLAnyXfhLM+8XxzDVSh3M820oGMo5REo6YNSAwhxa/nqqDuNLfdd7qtaJf+1HswTmAFjRdz5EoFF8YIxKyoN4ZFa7ufcuFvyNi/43tg15rtUgfiO/dwYJqBuOT1WoRxhUqWrnb8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=T9le1Wc8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="T9le1Wc8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6FB6C4CEC5;
	Wed,  2 Oct 2024 13:21:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727875315;
	bh=R5h01oQb5mkK1faO9l7udhmkIPY7O0lvbcFLh/dc6Yo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=T9le1Wc8I6+SZlsXPp9EEY3NohJOu8lVwXDfwofdcUgWI3VDzr3e8GzgS9VMWzZSq
	 4WZxFKtc3YWVD1xmO404FYzYy5ngwtqfwLxKPdpjb6YL/l8DyyQ8vLNZ2joW6YahO7
	 45UWmHcfGLCgvLlFsDlA+padTo6zQUiSm/Qye9Cc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zong-Zhe Yang <kevin_yang@realtek.com>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 061/695] wifi: rtw89: wow: fix wait condition for AOAC report request
Date: Wed,  2 Oct 2024 14:50:59 +0200
Message-ID: <20241002125824.921173956@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125822.467776898@linuxfoundation.org>
References: <20241002125822.467776898@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zong-Zhe Yang <kevin_yang@realtek.com>

[ Upstream commit d9dd3ac77cf7cabd35732893f3aefba1daa1c2e1 ]

Each condition binding to the same wait should be unique. AOAC code misused
the wait of FW offload series and broke the above rule. It added another
macro to generate wait condition of WoWLAN/AOAC, but the results conflict
to the ones of FW offload series. It means that we might be completed
wrongly in logic. We don't want things work/read like this and should
have avoided this.

Fix this by adding another wait which aims for WoWLAN functions.

Fixes: ff53fce5c78b ("wifi: rtw89: wow: update latest PTK GTK info to mac80211 after resume")
Signed-off-by: Zong-Zhe Yang <kevin_yang@realtek.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Link: https://patch.msgid.link/20240826090439.17242-2-pkshih@realtek.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/realtek/rtw89/core.c | 1 +
 drivers/net/wireless/realtek/rtw89/core.h | 3 +++
 drivers/net/wireless/realtek/rtw89/fw.c   | 6 ++----
 drivers/net/wireless/realtek/rtw89/fw.h   | 7 +++++--
 drivers/net/wireless/realtek/rtw89/mac.c  | 6 ++----
 5 files changed, 13 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw89/core.c b/drivers/net/wireless/realtek/rtw89/core.c
index 7019f7d482a88..fc172964349bd 100644
--- a/drivers/net/wireless/realtek/rtw89/core.c
+++ b/drivers/net/wireless/realtek/rtw89/core.c
@@ -4278,6 +4278,7 @@ int rtw89_core_init(struct rtw89_dev *rtwdev)
 
 	rtw89_init_wait(&rtwdev->mcc.wait);
 	rtw89_init_wait(&rtwdev->mac.fw_ofld_wait);
+	rtw89_init_wait(&rtwdev->wow.wait);
 
 	INIT_WORK(&rtwdev->c2h_work, rtw89_fw_c2h_work);
 	INIT_WORK(&rtwdev->ips_work, rtw89_ips_work);
diff --git a/drivers/net/wireless/realtek/rtw89/core.h b/drivers/net/wireless/realtek/rtw89/core.h
index 11fa003a9788c..9c282d84743b9 100644
--- a/drivers/net/wireless/realtek/rtw89/core.h
+++ b/drivers/net/wireless/realtek/rtw89/core.h
@@ -5293,6 +5293,9 @@ struct rtw89_wow_param {
 	u8 gtk_alg;
 	u8 ptk_keyidx;
 	u8 akm;
+
+	/* see RTW89_WOW_WAIT_COND series for wait condition */
+	struct rtw89_wait_info wait;
 };
 
 struct rtw89_mcc_limit {
diff --git a/drivers/net/wireless/realtek/rtw89/fw.c b/drivers/net/wireless/realtek/rtw89/fw.c
index fbe08c162b93d..c322148d6daf5 100644
--- a/drivers/net/wireless/realtek/rtw89/fw.c
+++ b/drivers/net/wireless/realtek/rtw89/fw.c
@@ -6825,11 +6825,10 @@ int rtw89_fw_h2c_wow_gtk_ofld(struct rtw89_dev *rtwdev,
 
 int rtw89_fw_h2c_wow_request_aoac(struct rtw89_dev *rtwdev)
 {
-	struct rtw89_wait_info *wait = &rtwdev->mac.fw_ofld_wait;
+	struct rtw89_wait_info *wait = &rtwdev->wow.wait;
 	struct rtw89_h2c_wow_aoac *h2c;
 	u32 len = sizeof(*h2c);
 	struct sk_buff *skb;
-	unsigned int cond;
 
 	skb = rtw89_fw_h2c_alloc_skb_with_hdr(rtwdev, len);
 	if (!skb) {
@@ -6848,8 +6847,7 @@ int rtw89_fw_h2c_wow_request_aoac(struct rtw89_dev *rtwdev)
 			      H2C_FUNC_AOAC_REPORT_REQ, 1, 0,
 			      len);
 
-	cond = RTW89_WOW_WAIT_COND(H2C_FUNC_AOAC_REPORT_REQ);
-	return rtw89_h2c_tx_and_wait(rtwdev, skb, wait, cond);
+	return rtw89_h2c_tx_and_wait(rtwdev, skb, wait, RTW89_WOW_WAIT_COND_AOAC);
 }
 
 /* Return < 0, if failures happen during waiting for the condition.
diff --git a/drivers/net/wireless/realtek/rtw89/fw.h b/drivers/net/wireless/realtek/rtw89/fw.h
index c3b4324c621c1..df6f2424fa911 100644
--- a/drivers/net/wireless/realtek/rtw89/fw.h
+++ b/drivers/net/wireless/realtek/rtw89/fw.h
@@ -3942,8 +3942,11 @@ enum rtw89_wow_h2c_func {
 	NUM_OF_RTW89_WOW_H2C_FUNC,
 };
 
-#define RTW89_WOW_WAIT_COND(func) \
-	(NUM_OF_RTW89_WOW_H2C_FUNC + (func))
+#define RTW89_WOW_WAIT_COND(tag, func) \
+	((tag) * NUM_OF_RTW89_WOW_H2C_FUNC + (func))
+
+#define RTW89_WOW_WAIT_COND_AOAC \
+	RTW89_WOW_WAIT_COND(0 /* don't care */, H2C_FUNC_AOAC_REPORT_REQ)
 
 /* CLASS 2 - PS */
 #define H2C_CL_MAC_PS			0x2
diff --git a/drivers/net/wireless/realtek/rtw89/mac.c b/drivers/net/wireless/realtek/rtw89/mac.c
index facd32de37bce..9a4f23d83bf2a 100644
--- a/drivers/net/wireless/realtek/rtw89/mac.c
+++ b/drivers/net/wireless/realtek/rtw89/mac.c
@@ -5151,11 +5151,10 @@ rtw89_mac_c2h_wow_aoac_rpt(struct rtw89_dev *rtwdev, struct sk_buff *skb, u32 le
 {
 	struct rtw89_wow_param *rtw_wow = &rtwdev->wow;
 	struct rtw89_wow_aoac_report *aoac_rpt = &rtw_wow->aoac_rpt;
-	struct rtw89_wait_info *wait = &rtwdev->mac.fw_ofld_wait;
+	struct rtw89_wait_info *wait = &rtw_wow->wait;
 	const struct rtw89_c2h_wow_aoac_report *c2h =
 		(const struct rtw89_c2h_wow_aoac_report *)skb->data;
 	struct rtw89_completion_data data = {};
-	unsigned int cond;
 
 	aoac_rpt->rpt_ver = c2h->rpt_ver;
 	aoac_rpt->sec_type = c2h->sec_type;
@@ -5173,8 +5172,7 @@ rtw89_mac_c2h_wow_aoac_rpt(struct rtw89_dev *rtwdev, struct sk_buff *skb, u32 le
 	aoac_rpt->igtk_ipn = le64_to_cpu(c2h->igtk_ipn);
 	memcpy(aoac_rpt->igtk, c2h->igtk, sizeof(aoac_rpt->igtk));
 
-	cond = RTW89_WOW_WAIT_COND(H2C_FUNC_AOAC_REPORT_REQ);
-	rtw89_complete_cond(wait, cond, &data);
+	rtw89_complete_cond(wait, RTW89_WOW_WAIT_COND_AOAC, &data);
 }
 
 static void
-- 
2.43.0



