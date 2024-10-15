Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7292019B3FF;
	Tue, 15 Oct 2024 11:47:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728992829; cv=none; b=RIymTG+UDEo1MV73wRtISL0MoojxTVPEmYLBYuFzD1VGuA+2U/Xpe9L13I3XT2pprrCOdurhG99fBEt1PcMc1FpZRSkZsbx1ZGQ5cnF7kiL5iuYQovGm4iVV1hYDzZlUMJrotitRI5+AmTzDE3sVNIGu24rvWTxEwq9vsv3fM6Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728992829; c=relaxed/simple;
	bh=GS42nIH3SVvTpSEpY+ZFqseJibswEhl7jaV52h1k+Kw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZwKysQLqThJXtcls1nnO56pL/ALQ1c/GZ/V5xqLJGSp5Zb9GaRAFwzqjY4q1wkn9yZqfHZiryT1I+6qlgl6Towx8NcP8abv8supwe/H0dXQwHUFzUW2/qpEU35xfor9b2Z+tqRJwkCZqeNHcdS7op/ZdiTsCxIJ6jiRzGj0HQQs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0+6DnqO2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0+6DnqO2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8A51C4CEC6;
	Tue, 15 Oct 2024 11:47:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728992829;
	bh=GS42nIH3SVvTpSEpY+ZFqseJibswEhl7jaV52h1k+Kw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0+6DnqO2MH/Q+aldFC32PPdJmj5AMskihCr+2lV8sp9VxQgmeVRzj4Qy+NxAY/3K1
	 Ko2v13c0FO+8kDjJhMh6Hk+dvmYr0jiY+/DL1xuGsNsC3MHZ/LbctPMNhVhTLgUpJ8
	 SWCHD4ZdSayPUiLr1JKUkIFMmkJrHDezfMntgGCE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Emanuele Ghidoli <emanuele.ghidoli@toradex.com>,
	Francesco Dolcini <francesco.dolcini@toradex.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 230/691] Input: ilitek_ts_i2c - add report id message validation
Date: Tue, 15 Oct 2024 13:22:58 +0200
Message-ID: <20241015112449.487078692@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015112440.309539031@linuxfoundation.org>
References: <20241015112440.309539031@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Emanuele Ghidoli <emanuele.ghidoli@toradex.com>

[ Upstream commit 208989744a6f01bed86968473312d4e650e600b3 ]

Ensure that the touchscreen response has correct "report id" byte
before processing the touch data and discard other messages.

Fixes: 42370681bd46 ("Input: Add support for ILITEK Lego Series")
Signed-off-by: Emanuele Ghidoli <emanuele.ghidoli@toradex.com>
Signed-off-by: Francesco Dolcini <francesco.dolcini@toradex.com>
Link: https://lore.kernel.org/r/20240805085511.43955-3-francesco@dolcini.it
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/input/touchscreen/ilitek_ts_i2c.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/input/touchscreen/ilitek_ts_i2c.c b/drivers/input/touchscreen/ilitek_ts_i2c.c
index 43c3e068a8c35..41c928dc9d050 100644
--- a/drivers/input/touchscreen/ilitek_ts_i2c.c
+++ b/drivers/input/touchscreen/ilitek_ts_i2c.c
@@ -37,6 +37,8 @@
 #define ILITEK_TP_CMD_GET_MCU_VER			0x61
 #define ILITEK_TP_CMD_GET_IC_MODE			0xC0
 
+#define ILITEK_TP_I2C_REPORT_ID				0x48
+
 #define REPORT_COUNT_ADDRESS				61
 #define ILITEK_SUPPORT_MAX_POINT			40
 
@@ -163,6 +165,11 @@ static int ilitek_process_and_report_v6(struct ilitek_ts_data *ts)
 		return error;
 	}
 
+	if (buf[0] != ILITEK_TP_I2C_REPORT_ID) {
+		dev_err(dev, "get touch info failed. Wrong id: 0x%02X\n", buf[0]);
+		return -EINVAL;
+	}
+
 	report_max_point = buf[REPORT_COUNT_ADDRESS];
 	if (report_max_point > ts->max_tp) {
 		dev_err(dev, "FW report max point:%d > panel info. max:%d\n",
-- 
2.43.0



