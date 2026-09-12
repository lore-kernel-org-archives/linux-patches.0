Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45BF6346A08;
	Sat, 12 Sep 2026 07:42:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789198935; cv=none; b=sFiSbcuptTLffcgmXAYUyvoLKfVJWnj+MUOxm+y25dUSyfA7+OAWCfOzMczEx8+fONzw0NvQc2DXTGh2k8kRWu9xLEAG6wfxFOPidrZhsQrwd+VraN8ouGepkG8NSWK6wM5Wi8IKOPW/fUNH/pt/OGF6qvWJNOM5A6qjCVBryiA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789198935; c=relaxed/simple;
	bh=H1rN4rH07R3YEuwi6s+hCBDosEhbcX88NNz3ByHykos=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HLLEExj5V5jPGgr8hMOabgXUVdzexjYFbC0zZqRbxs4oYoAPgXflUTYkLcaUNJqDwHKsM3mO4BEZ5rD+bXI+jvCBYsFdJzijWNJi4HYekb2yky73gS8iyfaQnFBF3znct7pMZ69Q5lSjVe+amh1zs1HIy3lN4qwUMx/muO0IfXE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=11ZyiI5D; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="11ZyiI5D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DBB71F00893;
	Sat, 12 Sep 2026 07:42:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789198933;
	bh=VM370XvRsLX8fVNxt+uDZUdpZZiObPzxIMdXEkZbgKg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=11ZyiI5DxZQhyrEyA09Dj8KyT//BNXAxBjWBQjhgrtsXpGv93tiPRU7QoSLgvCV0R
	 luA9fS/rENkbVjL2/UkDInDmuLrcw4HFX8OrzpHSrfsLy444m0jugqOWz4ozC3Ip0B
	 kZCpfaDeMbP6bAg1JA1zqON4V8S7sf1XPZRpRVik=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bitterblue Smith <rtl8821cerfe2@gmail.com>,
	Chia-Yuan Li <leo.li@realtek.com>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0482/1815] wifi: rtw89: fw: use MAC source for IO offload delay command
Date: Sat, 12 Sep 2026 08:37:12 +0200
Message-ID: <20260912065700.206569783@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chia-Yuan Li <leo.li@realtek.com>

[ Upstream commit 730dbda6dc70d29180eb2a7e9fa36823838bb042 ]

The udelay/mdelay helpers set the command source to
RTW89_FW_CMD_OFLD_SRC_OTHER (4), which does not fit the two-bit field
RTW89_H2C_CMD_OFLD_W0_SRC (GENMASK(1, 0)). The le32_encode_bits() masks
it down to 0 (RTW89_FW_CMD_OFLD_SRC_BB), and compiler throws
__field_overflow() error. Fortunately it still works because firmware
ignores the source field for a delay command.

Use RTW89_FW_CMD_OFLD_SRC_MAC as the vendor driver does, and drop the
unused RTW89_FW_CMD_OFLD_SRC_OTHER enumerator.

Reported-by: Bitterblue Smith <rtl8821cerfe2@gmail.com>
Closes: https://github.com/morrownr/rtw89/issues/111
Fixes: ae3d327515f2 ("wifi: rtw89: add IO offload support via firmware")
Signed-off-by: Chia-Yuan Li <leo.li@realtek.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Link: https://patch.msgid.link/20260714074811.30124-1-pkshih@realtek.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/realtek/rtw89/fw.c | 4 ++--
 drivers/net/wireless/realtek/rtw89/fw.h | 1 -
 2 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw89/fw.c b/drivers/net/wireless/realtek/rtw89/fw.c
index 2824cee964cb2..5edad2d25ae4b 100644
--- a/drivers/net/wireless/realtek/rtw89/fw.c
+++ b/drivers/net/wireless/realtek/rtw89/fw.c
@@ -11780,7 +11780,7 @@ static void rtw89_fw_cmd_ofld_write_rf(struct rtw89_dev *rtwdev,
 static void rtw89_fw_cmd_ofld_udelay(struct rtw89_dev *rtwdev, u32 us)
 {
 	struct rtw89_fw_cmd_ofld_arg cmd = {
-		.src = RTW89_FW_CMD_OFLD_SRC_OTHER,
+		.src = RTW89_FW_CMD_OFLD_SRC_MAC,
 		.type = RTW89_FW_CMD_OFLD_DELAY,
 		.value = us,
 	};
@@ -11794,7 +11794,7 @@ static void rtw89_fw_cmd_ofld_udelay(struct rtw89_dev *rtwdev, u32 us)
 static void rtw89_fw_cmd_ofld_mdelay(struct rtw89_dev *rtwdev, u32 ms)
 {
 	struct rtw89_fw_cmd_ofld_arg cmd = {
-		.src = RTW89_FW_CMD_OFLD_SRC_OTHER,
+		.src = RTW89_FW_CMD_OFLD_SRC_MAC,
 		.type = RTW89_FW_CMD_OFLD_DELAY,
 		.value = ms * 1000,
 	};
diff --git a/drivers/net/wireless/realtek/rtw89/fw.h b/drivers/net/wireless/realtek/rtw89/fw.h
index 5873301fc4729..8c90865dfa3b5 100644
--- a/drivers/net/wireless/realtek/rtw89/fw.h
+++ b/drivers/net/wireless/realtek/rtw89/fw.h
@@ -3144,7 +3144,6 @@ enum rtw89_fw_cmd_ofld_arg_src {
 	RTW89_FW_CMD_OFLD_SRC_RF,
 	RTW89_FW_CMD_OFLD_SRC_MAC,
 	RTW89_FW_CMD_OFLD_SRC_RF_DDIE,
-	RTW89_FW_CMD_OFLD_SRC_OTHER,
 };
 
 enum rtw89_fw_cmd_ofld_arg_type {
-- 
2.53.0



