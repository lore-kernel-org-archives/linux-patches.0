Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60C341D049A;
	Wed,  2 Oct 2024 13:36:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727876203; cv=none; b=Az1jbMILB9Joa+1+QH36bWvoSLCoL7zVR9bqHG176deXdB0erwyre/03WpIpVOw+QE6QhTKSJc827VaxGcUxdrePk0DaLL2GUTI1rpDSerhYX2mNIzJ6NmhvaL5IJn9147KdAtqfbRSB235cGzZkQpr+vIsoxclWfIYY3+EQmpw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727876203; c=relaxed/simple;
	bh=Gle0nDVjKxmlLJZ+UElsMs6xhLfzPVGh0ojgCZ/oNno=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U4RonIxkj6rVL/ievcS1s1P3z9VP3SgG6iEKlnq5DxU64zbK0tO2MN+4Mi7QeOi2juKb8whTJcAOjuJleBXXkII7pD5E/jodjL41cnEz8/YB56JLbxG85lylkXv0n5hH6ZjuUYr+R9iPqxmh1rhhjltIeyIRK0vQbZwo1PDfKIA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Vk1y46+H; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Vk1y46+H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D2B5C4CECF;
	Wed,  2 Oct 2024 13:36:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727876202;
	bh=Gle0nDVjKxmlLJZ+UElsMs6xhLfzPVGh0ojgCZ/oNno=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Vk1y46+H3SNGbedIgJPaMyF+ZdDA+h4kcuN81YgVhCZ3/eR6UsMS/GctS3fZWmusc
	 d2r7vuPwOV7+AiaBLenTcv0c7kTDit7GcYFGvFTj70TF+SGoI4OAC8GBYz43L75vya
	 c8AKQ0NWYNZtXPHlBMtREIpIuIVqdj/tOAoRdVU0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Emanuele Ghidoli <emanuele.ghidoli@toradex.com>,
	Francesco Dolcini <francesco.dolcini@toradex.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 364/695] Input: ilitek_ts_i2c - add report id message validation
Date: Wed,  2 Oct 2024 14:56:02 +0200
Message-ID: <20241002125836.974465594@linuxfoundation.org>
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



