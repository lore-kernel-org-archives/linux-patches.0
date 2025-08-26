Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88F9D34165A;
	Tue, 26 Aug 2025 13:21:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756214472; cv=none; b=nSk8vDatE5pLjMmPlX8a5MG7fQU2dRahm5MGFZ4E2Snwb/AXSQmbM7XAm36170mLUKPg9AMug7ud5h/6xSDNwrrGpFFjS9CzgO75CRPKjWc0EGeqxi8DhqQAoLYVCcB2ArbtXMQXgsH76tsWppPzZ/8V2JVZlfwNpe5IAWZj4GQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756214472; c=relaxed/simple;
	bh=vCho1hyMzXiknJikRRvcVqnuqpzYCZ8R/6OW1dUQkg8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=NuLQa3ez4vLKotwWZPoip0dsw+VYEVWGfbncpCCgHptUE9loGwtOXB3STLMXdhVDIKKA9/1qZgQEM0mnQJ5LWk2fqRbj2aysyGZmtI5MvjtFY0CyFRYRkOH/zQSLdKulPyARAtWi4QbN4tu/Yh81l49jPiIhc7sy2NvsHun9Eas=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HvTvye2Y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HvTvye2Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB1CFC4CEF1;
	Tue, 26 Aug 2025 13:21:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756214472;
	bh=vCho1hyMzXiknJikRRvcVqnuqpzYCZ8R/6OW1dUQkg8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HvTvye2YROrV9YM/FuAzAwtMqQXzdIZmcslYDYWh+RPiCorGS1udLB9d9lA3nTXRj
	 Cc3K3Amd1ceEmx9HQwZ5FKhbHSQ5dJYb25MMoojG/B6xTq4231LaAkdpFBe2q828N/
	 nQNTXhaaW8A1XasPsG53tcjGfGn/rFhYgirrf34s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bitterblue Smith <rtl8821cerfe2@gmail.com>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 119/482] wifi: rtw89: Lower the timeout in rtw89_fw_read_c2h_reg() for USB
Date: Tue, 26 Aug 2025 13:06:12 +0200
Message-ID: <20250826110933.764220129@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110930.769259449@linuxfoundation.org>
References: <20250826110930.769259449@linuxfoundation.org>
User-Agent: quilt/0.68
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bitterblue Smith <rtl8821cerfe2@gmail.com>

[ Upstream commit 671be46afd1f03de9dc6e4679c88e1a7a81cdff6 ]

This read_poll_timeout_atomic() with a delay of 1 µs and a timeout of
1000000 µs can take ~250 seconds in the worst case because sending a
USB control message takes ~250 µs.

Lower the timeout to 4000 for USB in order to reduce the maximum polling
time to ~1 second.

This problem was observed with RTL8851BU while suspending to RAM with
WOWLAN enabled. The computer sat for 4 minutes with a black screen
before suspending.

Signed-off-by: Bitterblue Smith <rtl8821cerfe2@gmail.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Link: https://patch.msgid.link/09313da6-c865-4e91-b758-4cb38a878796@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/realtek/rtw89/fw.c | 9 +++++++--
 drivers/net/wireless/realtek/rtw89/fw.h | 2 ++
 2 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw89/fw.c b/drivers/net/wireless/realtek/rtw89/fw.c
index 0f022a5192ac..977aadfdf997 100644
--- a/drivers/net/wireless/realtek/rtw89/fw.c
+++ b/drivers/net/wireless/realtek/rtw89/fw.c
@@ -2397,13 +2397,18 @@ static int rtw89_fw_read_c2h_reg(struct rtw89_dev *rtwdev,
 {
 	const struct rtw89_chip_info *chip = rtwdev->chip;
 	const u32 *c2h_reg = chip->c2h_regs;
-	u32 ret;
+	u32 ret, timeout;
 	u8 i, val;
 
 	info->id = RTW89_FWCMD_C2HREG_FUNC_NULL;
 
+	if (rtwdev->hci.type == RTW89_HCI_TYPE_USB)
+		timeout = RTW89_C2H_TIMEOUT_USB;
+	else
+		timeout = RTW89_C2H_TIMEOUT;
+
 	ret = read_poll_timeout_atomic(rtw89_read8, val, val, 1,
-				       RTW89_C2H_TIMEOUT, false, rtwdev,
+				       timeout, false, rtwdev,
 				       chip->c2h_ctrl_reg);
 	if (ret) {
 		rtw89_warn(rtwdev, "c2h reg timeout\n");
diff --git a/drivers/net/wireless/realtek/rtw89/fw.h b/drivers/net/wireless/realtek/rtw89/fw.h
index 0047d5d0e9b1..d0f2c5b22513 100644
--- a/drivers/net/wireless/realtek/rtw89/fw.h
+++ b/drivers/net/wireless/realtek/rtw89/fw.h
@@ -33,6 +33,8 @@ enum rtw89_fw_dl_status {
 #define RTW89_C2HREG_HDR_LEN 2
 #define RTW89_H2CREG_HDR_LEN 2
 #define RTW89_C2H_TIMEOUT 1000000
+#define RTW89_C2H_TIMEOUT_USB 4000
+
 struct rtw89_mac_c2h_info {
 	u8 id;
 	u8 content_len;
-- 
2.39.5



