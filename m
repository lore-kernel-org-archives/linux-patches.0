Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 137E8611E;
	Mon, 14 Oct 2024 15:01:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728918113; cv=none; b=hueEvkSFDdeOjxVJXymWW/am5YDLIOf/OrKw9OOdyfqq66t0WVBZQi/Od9U7kBiASTE255YI3jwODiLLqs4cwtcysTObWUR2DWfdV5P9qieeRj47dY2afXilMof2b8gCHf1IJple/adO7jyrq+S709hFXj989Z7Mk9tK/tX3UZE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728918113; c=relaxed/simple;
	bh=nffaAadqWBXuSU8P1NfalRBAhAZ1oaavMQJnpXqzlWc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sIOcYAQxLXTsrLVVG8AcbaRn4heGDElyseqPRmi70d/f34JYkriw1d/3cmgN6z9docrI1RXHL7AOnMCvlGOOqDxhaCIyKzp5E1BvxTJk7GoN6bbTIIWqx0yGzsIrgugfbPQAIFt4s71C0AqJYca4NhcVRNJ6rzf8zo/3WlIA/I8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Qpa7sgzp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Qpa7sgzp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C3ABC4CEC3;
	Mon, 14 Oct 2024 15:01:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728918112;
	bh=nffaAadqWBXuSU8P1NfalRBAhAZ1oaavMQJnpXqzlWc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Qpa7sgzpvs2Z1rmdAvY4TaOxxpMKIuIyZaX5vikkZBd38ID032QXjZz3TQOnThOW2
	 LZqK8NRw3yAXoRrNpEKCj9LlKljtCAj0fXnfrVF+o/v3I2UZhk4eHGcWE8JEbjh1xG
	 vzIt2AMnjI72xku6vKg2BbjdBYTRiSq/ZZkB8Vew=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Emanuele Ghidoli <emanuele.ghidoli@toradex.com>,
	Francesco Dolcini <francesco.dolcini@toradex.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 195/798] Input: ilitek_ts_i2c - add report id message validation
Date: Mon, 14 Oct 2024 16:12:29 +0200
Message-ID: <20241014141225.588789784@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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



