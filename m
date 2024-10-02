Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6F431D2F5A;
	Wed,  2 Oct 2024 14:38:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727879908; cv=none; b=OPY7QbmS8KGq/MFoznV963YEhkyt6orIPaOOEHOA/Hf/rXevjeBb0mIl95IeXNDWokUq2rGT3LdWOzjXQDHVHsCTZO5Eb/0/pQ/zT3Bb1uH3/JECvea+FFJddjxHmnow+izeruI42f75P4KjHbyCSFJ/ENlPCUYmLhkzts6yiO0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727879908; c=relaxed/simple;
	bh=nYn0vwjqi3rycosunMplcXJ8VTRYHKUJJ6SEjQg2vLo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V+aR92bSpg4whcIKHnRCzwsejlBkwbcy1jFESelO1YzxPhyHZ9ZMsa2ayY4U+Y4zJZXXzymPEawF70yharbR2BQ1zFdh7zEPwBCC8qzk2pghOv+j4Ki4hDLIBjwatYM+HIIUHccxPMTgb2ucCwbY790Ir1mDNnYwa/y3IoPAEFk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yE4cTCMo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yE4cTCMo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 500C2C4CEC2;
	Wed,  2 Oct 2024 14:38:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727879908;
	bh=nYn0vwjqi3rycosunMplcXJ8VTRYHKUJJ6SEjQg2vLo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yE4cTCMoDPMHto2qe5shBeUcIgcHCjorlO6N9pA5fJuUY+SNbfeuueVBqAQNS0Flw
	 lfErDfHBguIl0df4ILkuNNDRgkY0MISIbXKhSlGiKXGpUhrSfyl2Y96hbeelufA/29
	 Tha8YPp7aIVEMBV/S/qVpcJJCEAag6kkaFe1I+uo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Emanuele Ghidoli <emanuele.ghidoli@toradex.com>,
	Francesco Dolcini <francesco.dolcini@toradex.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 280/538] Input: ilitek_ts_i2c - add report id message validation
Date: Wed,  2 Oct 2024 14:58:39 +0200
Message-ID: <20241002125803.309164330@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125751.964700919@linuxfoundation.org>
References: <20241002125751.964700919@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index f70af5a173b34..e719f5da68bf5 100644
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



