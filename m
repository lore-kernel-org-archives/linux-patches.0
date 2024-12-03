Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 554421F892A;
	Tue,  3 Dec 2024 15:12:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733238728; cv=none; b=u31o2eV1/HN26QKLzdsoYmegpMpo8V5oP1Y58pu0LwX+Kaw4LblZB172LyQke+7FTl8iBM06Acl5PtHaVvEpPQrCy4C1pgF18JGGo0fzcLEk+x31ZtF8HBCdGBXilYBiIk8nLSQdUaNRdrs/7xyOpUYUxlVOjr7FlQ32XRAD8M0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733238728; c=relaxed/simple;
	bh=TPKs/hqV8Q3NgxhG5/mxTI7+Y6mNYhX1LZZP44Z8aiM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TQVGgMp8YYJo9WFUc91M6UEcqmy03WXhEHxBWfyJpe3BJL0hrYEIu6reiIA+1t1hdg55dh8HlTeFcNEx5qh9BEPk40YDFmp9XfhMWoXEy9CAIZZ0OTKseF1DfTxQQtcR1ynrEWnc6i9XCJDgOoqLXcKRpdS9c1NN3uPUbTceGeo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sxssyUBZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sxssyUBZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F8C2C4CECF;
	Tue,  3 Dec 2024 15:12:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733238727;
	bh=TPKs/hqV8Q3NgxhG5/mxTI7+Y6mNYhX1LZZP44Z8aiM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sxssyUBZd3VAAtEwnwgKf+iylSReMkt3F+x0twYJ4b4AA492h4m1GjqzfIgA1GXDp
	 cNc+NRUElvKSpQMDbwh4Z1i/5sIQqq0Cq9StH4Go+RODT238+vZVTBMD49haSaiSPK
	 +ePR27wMJp7uCMjal1mpSHwwT7Jt4fUTpvA8T3MI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mingwei Zheng <zmw12306@gmail.com>,
	Jiasheng Jiang <jiashengjiangcool@gmail.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 346/817] net: rfkill: gpio: Add check for clk_enable()
Date: Tue,  3 Dec 2024 15:38:38 +0100
Message-ID: <20241203144009.332342265@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
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

From: Mingwei Zheng <zmw12306@gmail.com>

[ Upstream commit 8251e7621b25ccdb689f1dd9553b8789e3745ea1 ]

Add check for the return value of clk_enable() to catch the potential
error.

Fixes: 7176ba23f8b5 ("net: rfkill: add generic gpio rfkill driver")
Signed-off-by: Mingwei Zheng <zmw12306@gmail.com>
Signed-off-by: Jiasheng Jiang <jiashengjiangcool@gmail.com>
Link: https://patch.msgid.link/20241108195341.1853080-1-zmw12306@gmail.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/rfkill/rfkill-gpio.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/net/rfkill/rfkill-gpio.c b/net/rfkill/rfkill-gpio.c
index 84529886c2e66..bfd5ff967e903 100644
--- a/net/rfkill/rfkill-gpio.c
+++ b/net/rfkill/rfkill-gpio.c
@@ -31,8 +31,12 @@ static int rfkill_gpio_set_power(void *data, bool blocked)
 {
 	struct rfkill_gpio_data *rfkill = data;
 
-	if (!blocked && !IS_ERR(rfkill->clk) && !rfkill->clk_enabled)
-		clk_enable(rfkill->clk);
+	if (!blocked && !IS_ERR(rfkill->clk) && !rfkill->clk_enabled) {
+		int ret = clk_enable(rfkill->clk);
+
+		if (ret)
+			return ret;
+	}
 
 	gpiod_set_value_cansleep(rfkill->shutdown_gpio, !blocked);
 	gpiod_set_value_cansleep(rfkill->reset_gpio, !blocked);
-- 
2.43.0



