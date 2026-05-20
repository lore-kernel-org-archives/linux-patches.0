Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 990B237754D;
	Wed, 20 May 2026 17:26:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779297981; cv=none; b=eoZyydl25XQI87TlaQZQ+fXIQ4r7PPpEOpQOwYv9dYtnTYY0Tj/YSdCe47pyNxTo7SPHCZ8lbnx3oea2CL3l7ejmQoWeNgvOuAlAb7ecu9YlSeV0h+axGE3ZF82oiNFjiNHZo5UCitU1tPR030Uh2yESghjH+/B6vFrXwpyqi74=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779297981; c=relaxed/simple;
	bh=E8YMW/OhzBPlw19vQ9Hx2zDHrvznFEjdJfHfRysFRcY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pP1bgNeIPrPDQLHty9LMaBOQmM7qXM2CjNbQ5crDgyMT5t8pM38I8TZf5y88iwkmlyocUI9DsnVLE7+/nR6TFNCuDVsUEWPtinhWo+uqUuKM7YrMCrDAgzX82Z7hV0qRxx/ozjH3vUu20ZFDUL6jOeaYppIh3kuNDzbDjGDxrdY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=beyeVNb7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="beyeVNb7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C4DF1F000E9;
	Wed, 20 May 2026 17:26:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779297980;
	bh=0k0a5B8oKqQ/dOC1Ama8Dmk+GS6um9wafbj7v0Ot4vg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=beyeVNb7CK8WwdiXuuseMoNOcFL58SZpSrSMH0fhtsnu4okFvs1A7Ims3cgVZMvCG
	 7OiWngJAZ7Y/69/jM7Wp53VfTADHAJAwC6pWfG8fglLt9ov/n2OZ4t279T8FLJnys3
	 1Hz+a5Gk3BuXPpKpAj3rwJ/Xu35+sWe3rctVJu8c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pei Xiao <xiaopei01@kylinos.cn>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 237/957] spi: hisi-kunpeng: prevent infinite while() loop in hisi_spi_flush_fifo
Date: Wed, 20 May 2026 18:12:00 +0200
Message-ID: <20260520162139.681509851@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pei Xiao <xiaopei01@kylinos.cn>

[ Upstream commit 9f61daf2c2debe9f5cf4e1a4471e56a89a6fe45a ]

The hisi_spi_flush_fifo()'s inner while loop that lacks any timeout
mechanism. Maybe the hardware never becomes empty, the loop will spin
forever, causing the CPU to hang.

Fix this by adding a inner_limit based on loops_per_jiffy. The inner loop
now exits after approximately one jiffy if the FIFO remains non-empty, logs
a ratelimited warning, and breaks out of the outer loop. Additionally, add
a cpu_relax() inside the busy loop to improve power efficiency.

Fixes: c770d8631e18 ("spi: Add HiSilicon SPI Controller Driver for Kunpeng SoCs")
Signed-off-by: Pei Xiao <xiaopei01@kylinos.cn>
Link: https://patch.msgid.link/d834ce28172886bfaeb9c8ca00cfd9bf1c65d5a1.1773889292.git.xiaopei01@kylinos.cn
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-hisi-kunpeng.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/drivers/spi/spi-hisi-kunpeng.c b/drivers/spi/spi-hisi-kunpeng.c
index 80a1a15de0bc3..a38dcae6271ff 100644
--- a/drivers/spi/spi-hisi-kunpeng.c
+++ b/drivers/spi/spi-hisi-kunpeng.c
@@ -196,8 +196,18 @@ static void hisi_spi_flush_fifo(struct hisi_spi *hs)
 	unsigned long limit = loops_per_jiffy << 1;
 
 	do {
-		while (hisi_spi_rx_not_empty(hs))
+		unsigned long inner_limit = loops_per_jiffy;
+
+		while (hisi_spi_rx_not_empty(hs) && --inner_limit) {
 			readl(hs->regs + HISI_SPI_DOUT);
+			cpu_relax();
+		}
+
+		if (!inner_limit) {
+			dev_warn_ratelimited(hs->dev, "RX FIFO flush timeout\n");
+			break;
+		}
+
 	} while (hisi_spi_busy(hs) && limit--);
 }
 
-- 
2.53.0



