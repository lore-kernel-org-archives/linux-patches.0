Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6A9032D7CC;
	Tue, 11 Nov 2025 01:40:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762825252; cv=none; b=QzUJl8GICKrKD36q433+ejY/TE26AsOpYzYJFTxlkjptufneewa9YPRd/PtNWMGE78pML6llr87PfbBV6GIjc+AEYRpUWZ/OsQUrwDMtf+d/aT23JSnLGci3j6vddsnnqQFTMLK0Bb4w98PuyLVTUUPkzWI5VBdhNokduznSmDA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762825252; c=relaxed/simple;
	bh=HBRHtAcJV5B6H/HhfaHr88F7fIB72vYpaV7Ea0x+4MU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZS41oCcQzNEFKmv5lI6L1xkihbt2vm2zpfsthjcwd6WEmahcmYE7Eu19yRVNwpaGJzfQbC2NqY1Oso//ZMf2rm9AU9pfjzZUJD4fouizNJpXXk/LXaYnSKK8JVfYUXz5vnCfSxz+2DQB955YBYVfKhe16J/My1OxZELC1YOa/VQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2wXekH4s; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2wXekH4s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68456C19425;
	Tue, 11 Nov 2025 01:40:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762825252;
	bh=HBRHtAcJV5B6H/HhfaHr88F7fIB72vYpaV7Ea0x+4MU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2wXekH4s8h2ROFXKqtnhQkdKUXP5yYMY1TqRrRG8qM+sXn1PViAb1b3B6H2FEcRy4
	 6h6d+gTjcKks/0ewBJ94lGRecj3qK2QQry4OINDiB+JZxVCwQDSX8lgkOWeFdiff0e
	 gtrDFjLtBkQzN4D+/CXMDPMmKIuQhAIuSPLlU9FA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bruno Thomsen <bruno.thomsen@gmail.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 726/849] rtc: pcf2127: fix watchdog interrupt mask on pcf2131
Date: Tue, 11 Nov 2025 09:44:56 +0900
Message-ID: <20251111004553.984930642@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bruno Thomsen <bruno.thomsen@gmail.com>

[ Upstream commit 87064da2db7be537a7da20a25c18ba912c4db9e1 ]

When using interrupt pin (INT A) as watchdog output all other
interrupt sources need to be disabled to avoid additional
resets. Resulting INT_A_MASK1 value is 55 (0x37).

Signed-off-by: Bruno Thomsen <bruno.thomsen@gmail.com>
Link: https://lore.kernel.org/r/20250902182235.6825-1-bruno.thomsen@gmail.com
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/rtc/rtc-pcf2127.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/drivers/rtc/rtc-pcf2127.c b/drivers/rtc/rtc-pcf2127.c
index 3ba1de30e89c2..bb4fe81d3d62c 100644
--- a/drivers/rtc/rtc-pcf2127.c
+++ b/drivers/rtc/rtc-pcf2127.c
@@ -608,6 +608,21 @@ static int pcf2127_watchdog_init(struct device *dev, struct pcf2127 *pcf2127)
 			set_bit(WDOG_HW_RUNNING, &pcf2127->wdd.status);
 	}
 
+	/*
+	 * When using interrupt pin (INT A) as watchdog output, only allow
+	 * watchdog interrupt (PCF2131_BIT_INT_WD_CD) and disable (mask) all
+	 * other interrupts.
+	 */
+	if (pcf2127->cfg->type == PCF2131) {
+		ret = regmap_write(pcf2127->regmap,
+				   PCF2131_REG_INT_A_MASK1,
+				   PCF2131_BIT_INT_BLIE |
+				   PCF2131_BIT_INT_BIE |
+				   PCF2131_BIT_INT_AIE |
+				   PCF2131_BIT_INT_SI |
+				   PCF2131_BIT_INT_MI);
+	}
+
 	return devm_watchdog_register_device(dev, &pcf2127->wdd);
 }
 
-- 
2.51.0



