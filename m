Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74EB3569D
	for <patches@lists.linux.dev>; Sun, 28 May 2023 19:29:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0431DC433EF;
	Sun, 28 May 2023 19:29:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1685302198;
	bh=Q8Bmx1+1Uv3JAz4GRXVD97DLqOSUzzsjt9DACLf2FcA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sUtiQ1ZKTA3OJurKyEd+U8wkekngWkpxlwDps44enOUkYgHWXz7ZinLEAFXovKHZp
	 Z7hBsTmaEAsPHLIxNySoTgohHQLBh4tsbhD5wgDGFzA47lkx3WhrNbZt+tyn0nS5R1
	 tEFSSAFPPtwES+QLXnn01pYp6uDyeMvf0SD+BrL4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Kalle Valo <kvalo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 001/127] wifi: rtw89: 8852b: adjust quota to avoid SER L1 caused by access null page
Date: Sun, 28 May 2023 20:09:37 +0100
Message-Id: <20230528190836.216919878@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230528190836.161231414@linuxfoundation.org>
References: <20230528190836.161231414@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Ping-Ke Shih <pkshih@realtek.com>

[ Upstream commit c0426c446d92023d344131d01d929bc25db7a24e ]

Though SER can recover this case, traffic can get stuck for a while. Fix it
by adjusting page quota to avoid hardware access null page of CMAC/DMAC.

Fixes: a1cb097168fa ("wifi: rtw89: 8852b: configure DLE mem")
Fixes: 3e870b481733 ("wifi: rtw89: 8852b: add HFC quota arrays")
Cc: stable@vger.kernel.org
Tested-by: Larry Finger <Larry.Finger@lwfinger.net>
Link: https://github.com/lwfinger/rtw89/issues/226#issuecomment-1520776761
Link: https://github.com/lwfinger/rtw89/issues/240
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Signed-off-by: Kalle Valo <kvalo@kernel.org>
Link: https://lore.kernel.org/r/20230426034737.24870-1-pkshih@realtek.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/realtek/rtw89/mac.c      |  4 ++++
 drivers/net/wireless/realtek/rtw89/mac.h      |  2 ++
 drivers/net/wireless/realtek/rtw89/rtw8852b.c | 22 +++++++++----------
 3 files changed, 17 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw89/mac.c b/drivers/net/wireless/realtek/rtw89/mac.c
index 2e2a2b6eab09d..d0cafe813cdb4 100644
--- a/drivers/net/wireless/realtek/rtw89/mac.c
+++ b/drivers/net/wireless/realtek/rtw89/mac.c
@@ -1425,6 +1425,8 @@ const struct rtw89_mac_size_set rtw89_mac_size = {
 	.wde_size4 = {RTW89_WDE_PG_64, 0, 4096,},
 	/* PCIE 64 */
 	.wde_size6 = {RTW89_WDE_PG_64, 512, 0,},
+	/* 8852B PCIE SCC */
+	.wde_size7 = {RTW89_WDE_PG_64, 510, 2,},
 	/* DLFW */
 	.wde_size9 = {RTW89_WDE_PG_64, 0, 1024,},
 	/* 8852C DLFW */
@@ -1449,6 +1451,8 @@ const struct rtw89_mac_size_set rtw89_mac_size = {
 	.wde_qt4 = {0, 0, 0, 0,},
 	/* PCIE 64 */
 	.wde_qt6 = {448, 48, 0, 16,},
+	/* 8852B PCIE SCC */
+	.wde_qt7 = {446, 48, 0, 16,},
 	/* 8852C DLFW */
 	.wde_qt17 = {0, 0, 0,  0,},
 	/* 8852C PCIE SCC */
diff --git a/drivers/net/wireless/realtek/rtw89/mac.h b/drivers/net/wireless/realtek/rtw89/mac.h
index 8064d3953d7f2..85c02c1f36bd7 100644
--- a/drivers/net/wireless/realtek/rtw89/mac.h
+++ b/drivers/net/wireless/realtek/rtw89/mac.h
@@ -791,6 +791,7 @@ struct rtw89_mac_size_set {
 	const struct rtw89_dle_size wde_size0;
 	const struct rtw89_dle_size wde_size4;
 	const struct rtw89_dle_size wde_size6;
+	const struct rtw89_dle_size wde_size7;
 	const struct rtw89_dle_size wde_size9;
 	const struct rtw89_dle_size wde_size18;
 	const struct rtw89_dle_size wde_size19;
@@ -803,6 +804,7 @@ struct rtw89_mac_size_set {
 	const struct rtw89_wde_quota wde_qt0;
 	const struct rtw89_wde_quota wde_qt4;
 	const struct rtw89_wde_quota wde_qt6;
+	const struct rtw89_wde_quota wde_qt7;
 	const struct rtw89_wde_quota wde_qt17;
 	const struct rtw89_wde_quota wde_qt18;
 	const struct rtw89_ple_quota ple_qt4;
diff --git a/drivers/net/wireless/realtek/rtw89/rtw8852b.c b/drivers/net/wireless/realtek/rtw89/rtw8852b.c
index 45c374d025cbd..355e515364611 100644
--- a/drivers/net/wireless/realtek/rtw89/rtw8852b.c
+++ b/drivers/net/wireless/realtek/rtw89/rtw8852b.c
@@ -13,25 +13,25 @@
 #include "txrx.h"
 
 static const struct rtw89_hfc_ch_cfg rtw8852b_hfc_chcfg_pcie[] = {
-	{5, 343, grp_0}, /* ACH 0 */
-	{5, 343, grp_0}, /* ACH 1 */
-	{5, 343, grp_0}, /* ACH 2 */
-	{5, 343, grp_0}, /* ACH 3 */
+	{5, 341, grp_0}, /* ACH 0 */
+	{5, 341, grp_0}, /* ACH 1 */
+	{4, 342, grp_0}, /* ACH 2 */
+	{4, 342, grp_0}, /* ACH 3 */
 	{0, 0, grp_0}, /* ACH 4 */
 	{0, 0, grp_0}, /* ACH 5 */
 	{0, 0, grp_0}, /* ACH 6 */
 	{0, 0, grp_0}, /* ACH 7 */
-	{4, 344, grp_0}, /* B0MGQ */
-	{4, 344, grp_0}, /* B0HIQ */
+	{4, 342, grp_0}, /* B0MGQ */
+	{4, 342, grp_0}, /* B0HIQ */
 	{0, 0, grp_0}, /* B1MGQ */
 	{0, 0, grp_0}, /* B1HIQ */
 	{40, 0, 0} /* FWCMDQ */
 };
 
 static const struct rtw89_hfc_pub_cfg rtw8852b_hfc_pubcfg_pcie = {
-	448, /* Group 0 */
+	446, /* Group 0 */
 	0, /* Group 1 */
-	448, /* Public Max */
+	446, /* Public Max */
 	0 /* WP threshold */
 };
 
@@ -44,9 +44,9 @@ static const struct rtw89_hfc_param_ini rtw8852b_hfc_param_ini_pcie[] = {
 };
 
 static const struct rtw89_dle_mem rtw8852b_dle_mem_pcie[] = {
-	[RTW89_QTA_SCC] = {RTW89_QTA_SCC, &rtw89_mac_size.wde_size6,
-			   &rtw89_mac_size.ple_size6, &rtw89_mac_size.wde_qt6,
-			   &rtw89_mac_size.wde_qt6, &rtw89_mac_size.ple_qt18,
+	[RTW89_QTA_SCC] = {RTW89_QTA_SCC, &rtw89_mac_size.wde_size7,
+			   &rtw89_mac_size.ple_size6, &rtw89_mac_size.wde_qt7,
+			   &rtw89_mac_size.wde_qt7, &rtw89_mac_size.ple_qt18,
 			   &rtw89_mac_size.ple_qt58},
 	[RTW89_QTA_DLFW] = {RTW89_QTA_DLFW, &rtw89_mac_size.wde_size9,
 			    &rtw89_mac_size.ple_size8, &rtw89_mac_size.wde_qt4,
-- 
2.39.2



