Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5467F1D1E71;
	Wed,  2 Oct 2024 14:09:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727878193; cv=none; b=gp7fP3vdhg0f2MfEP8yQv2HjOovTEpgYvKXuX0UIhOaAiCjS6s12nWzg/i8tqyPR5KMsEegcbOc/nNxCDpxo0n07QPgaL0dMfNrnPF5F9SRqySzwAvxktMb05WiMtPGbul9EwpH+WGt33F28zxt3EINq7E5sMkubxdui2K6MXmY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727878193; c=relaxed/simple;
	bh=BA4DRMB9tdZQgpx8DL7QFIt1dfZ3oVDoCbSaIXOmeLc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VjEGwI0R4qbsIKMYSEVaZ93gs8hEJl+8u9X0TNecvKd8R/iQQK+9eAU394z2/JCLgaVeHNDDnMoTGgviQQvm97j3Ijfvf2NLCtKssB53uDAq26b8i7EEZl4sUAgcgMxHExc0HJcmgWbEng6D8prIqIIYsE27e+L8/4i1MIXu4Ww=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TdkqNlHM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TdkqNlHM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D177BC4CEC5;
	Wed,  2 Oct 2024 14:09:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727878193;
	bh=BA4DRMB9tdZQgpx8DL7QFIt1dfZ3oVDoCbSaIXOmeLc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TdkqNlHMS2sb3Cj+Nzu5LOrxMjodFh9yVkCSi9uwiFvRopbU6YVSrQz9Azq/N9Ys2
	 RLdWP0msiAqniad1GhETY9STlYVsXbEXZq7jjQwu4kgZExEoOTHltHcNhLEZqsYzbJ
	 JLRseLjKuYT2e54U/rI9uh3i6llPE2iXK40yv0b8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Emanuele Ghidoli <emanuele.ghidoli@toradex.com>,
	Francesco Dolcini <francesco.dolcini@toradex.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 330/634] Input: ilitek_ts_i2c - add report id message validation
Date: Wed,  2 Oct 2024 14:57:10 +0200
Message-ID: <20241002125824.130777551@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125811.070689334@linuxfoundation.org>
References: <20241002125811.070689334@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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
index e1849185e18c7..5a807ad723190 100644
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



