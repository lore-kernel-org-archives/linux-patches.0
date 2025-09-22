Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C9D62F28FA;
	Mon, 22 Sep 2025 19:41:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758570089; cv=none; b=ptqnWRGGeVwFspa6pLuFIp04AgJtzX21y+UHlXappegny2gQHXknezq2ofJuMuR7SiUa59ZaneIvLKlcjGWOxEPgzOHiI3/IpBgLOewJ0AOSxIymeCppwauuikpI2mc/u+hdOcx7E9nWnDEdkVDrl6O8hAErdmtikpVy3X1jWtQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758570089; c=relaxed/simple;
	bh=KzAqsHCx8RvnurN3+wVCsnXgmBHgMi/rLO956G7BqxQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RnPKuK1naVb5Z1w4ogyt7OP4xhWCyq3o1+d2gs9gZormxXO4FJj/e7BlwO/5bds//ui5kGPlx3r++5a7xo1OlSBp8QksqFwQKO6hYHoc0LL+M92HmYGfSTtNOJ3vMOde/C/2tKez1grxnRvW5wufGRSewBSuMe19AnpG3f0sWbw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JV1+P/Py; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JV1+P/Py"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7E08C4CEF0;
	Mon, 22 Sep 2025 19:41:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758570089;
	bh=KzAqsHCx8RvnurN3+wVCsnXgmBHgMi/rLO956G7BqxQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JV1+P/Pybk4UdYVtc0ctFYTrhn1MJnFERPpkU5K3hfRtHmzymrk+laJSbj5L7Qts2
	 FdznTFIfUgX6x3rLpq70s4SDDzBTGqNHYPFGu9Cnnim+mS5dljIptK/y7/1TMGvn0d
	 tLbWqP8JNFESIOAO19oBCYVhQ208BTxnqKKz0Ufk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Ajay Singh <ajay.kathat@microchip.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 005/149] wifi: wilc1000: avoid buffer overflow in WID string configuration
Date: Mon, 22 Sep 2025 21:28:25 +0200
Message-ID: <20250922192413.027723759@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250922192412.885919229@linuxfoundation.org>
References: <20250922192412.885919229@linuxfoundation.org>
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

From: Ajay.Kathat@microchip.com <Ajay.Kathat@microchip.com>

[ Upstream commit fe9e4d0c39311d0f97b024147a0d155333f388b5 ]

Fix the following copy overflow warning identified by Smatch checker.

 drivers/net/wireless/microchip/wilc1000/wlan_cfg.c:184 wilc_wlan_parse_response_frame()
        error: '__memcpy()' 'cfg->s[i]->str' copy overflow (512 vs 65537)

This patch introduces size check before accessing the memory buffer.
The checks are base on the WID type of received data from the firmware.
For WID string configuration, the size limit is determined by individual
element size in 'struct wilc_cfg_str_vals' that is maintained in 'len' field
of 'struct wilc_cfg_str'.

Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
Closes: https://lore.kernel.org/linux-wireless/aLFbr9Yu9j_TQTey@stanley.mountain
Suggested-by: Dan Carpenter <dan.carpenter@linaro.org>
Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
Link: https://patch.msgid.link/20250829225829.5423-1-ajay.kathat@microchip.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../wireless/microchip/wilc1000/wlan_cfg.c    | 37 ++++++++++++++-----
 .../wireless/microchip/wilc1000/wlan_cfg.h    |  5 ++-
 2 files changed, 30 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wireless/microchip/wilc1000/wlan_cfg.c b/drivers/net/wireless/microchip/wilc1000/wlan_cfg.c
index 131388886acbf..cfabd5aebb540 100644
--- a/drivers/net/wireless/microchip/wilc1000/wlan_cfg.c
+++ b/drivers/net/wireless/microchip/wilc1000/wlan_cfg.c
@@ -41,10 +41,10 @@ static const struct wilc_cfg_word g_cfg_word[] = {
 };
 
 static const struct wilc_cfg_str g_cfg_str[] = {
-	{WID_FIRMWARE_VERSION, NULL},
-	{WID_MAC_ADDR, NULL},
-	{WID_ASSOC_RES_INFO, NULL},
-	{WID_NIL, NULL}
+	{WID_FIRMWARE_VERSION, 0, NULL},
+	{WID_MAC_ADDR, 0, NULL},
+	{WID_ASSOC_RES_INFO, 0, NULL},
+	{WID_NIL, 0, NULL}
 };
 
 #define WILC_RESP_MSG_TYPE_CONFIG_REPLY		'R'
@@ -147,44 +147,58 @@ static void wilc_wlan_parse_response_frame(struct wilc *wl, u8 *info, int size)
 
 		switch (FIELD_GET(WILC_WID_TYPE, wid)) {
 		case WID_CHAR:
+			len = 3;
+			if (len + 2  > size)
+				return;
+
 			while (cfg->b[i].id != WID_NIL && cfg->b[i].id != wid)
 				i++;
 
 			if (cfg->b[i].id == wid)
 				cfg->b[i].val = info[4];
 
-			len = 3;
 			break;
 
 		case WID_SHORT:
+			len = 4;
+			if (len + 2  > size)
+				return;
+
 			while (cfg->hw[i].id != WID_NIL && cfg->hw[i].id != wid)
 				i++;
 
 			if (cfg->hw[i].id == wid)
 				cfg->hw[i].val = get_unaligned_le16(&info[4]);
 
-			len = 4;
 			break;
 
 		case WID_INT:
+			len = 6;
+			if (len + 2  > size)
+				return;
+
 			while (cfg->w[i].id != WID_NIL && cfg->w[i].id != wid)
 				i++;
 
 			if (cfg->w[i].id == wid)
 				cfg->w[i].val = get_unaligned_le32(&info[4]);
 
-			len = 6;
 			break;
 
 		case WID_STR:
+			len = 2 + get_unaligned_le16(&info[2]);
+
 			while (cfg->s[i].id != WID_NIL && cfg->s[i].id != wid)
 				i++;
 
-			if (cfg->s[i].id == wid)
+			if (cfg->s[i].id == wid) {
+				if (len > cfg->s[i].len || (len + 2  > size))
+					return;
+
 				memcpy(cfg->s[i].str, &info[2],
-				       get_unaligned_le16(&info[2]) + 2);
+				       len);
+			}
 
-			len = 2 + get_unaligned_le16(&info[2]);
 			break;
 
 		default:
@@ -384,12 +398,15 @@ int wilc_wlan_cfg_init(struct wilc *wl)
 	/* store the string cfg parameters */
 	wl->cfg.s[i].id = WID_FIRMWARE_VERSION;
 	wl->cfg.s[i].str = str_vals->firmware_version;
+	wl->cfg.s[i].len = sizeof(str_vals->firmware_version);
 	i++;
 	wl->cfg.s[i].id = WID_MAC_ADDR;
 	wl->cfg.s[i].str = str_vals->mac_address;
+	wl->cfg.s[i].len = sizeof(str_vals->mac_address);
 	i++;
 	wl->cfg.s[i].id = WID_ASSOC_RES_INFO;
 	wl->cfg.s[i].str = str_vals->assoc_rsp;
+	wl->cfg.s[i].len = sizeof(str_vals->assoc_rsp);
 	i++;
 	wl->cfg.s[i].id = WID_NIL;
 	wl->cfg.s[i].str = NULL;
diff --git a/drivers/net/wireless/microchip/wilc1000/wlan_cfg.h b/drivers/net/wireless/microchip/wilc1000/wlan_cfg.h
index 7038b74f8e8ff..5ae74bced7d74 100644
--- a/drivers/net/wireless/microchip/wilc1000/wlan_cfg.h
+++ b/drivers/net/wireless/microchip/wilc1000/wlan_cfg.h
@@ -24,12 +24,13 @@ struct wilc_cfg_word {
 
 struct wilc_cfg_str {
 	u16 id;
+	u16 len;
 	u8 *str;
 };
 
 struct wilc_cfg_str_vals {
-	u8 mac_address[7];
-	u8 firmware_version[129];
+	u8 mac_address[8];
+	u8 firmware_version[130];
 	u8 assoc_rsp[WILC_MAX_ASSOC_RESP_FRAME_SIZE];
 };
 
-- 
2.51.0



