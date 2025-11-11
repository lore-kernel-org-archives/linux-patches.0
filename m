Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDFD02FFF94;
	Tue, 11 Nov 2025 01:33:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762824790; cv=none; b=fYWYlqv/M2Mi312CVHkZl8waQraucBEHfZNct00zwMCOxBpu3G/xyJg2UHUxU93ni/mORluMPM+J0xoYlRx3L9qwedG6IgZEA3H9vZ77nYxixLhL52OIs1UEvb8FHR/0e0PbIZXIMC+rxjO1T+GHO0rBz1vjPKBzO23VKjVf490=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762824790; c=relaxed/simple;
	bh=MvytS1IcXzQ0YjfC0EsJVPjsF6GNwkYGgUDXiL3AboQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N20U4c8gxd5V2WKTKtrT8c6+m/dG9YqDI3tLWHFPdZb2qhhQBkZjts+YKbyJr3ZKhNogHgLoF8oLTQyRMlGxuwS66YOv0iSPWFtnsQ0geHV9/QrFYW/OB+3kU+/dq0qMVD97NAf5648Hvdy75wKcooxNQVEYGXvJsMPHRtolBMU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JtB6I3sy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JtB6I3sy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 493EBC4CEFB;
	Tue, 11 Nov 2025 01:33:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762824790;
	bh=MvytS1IcXzQ0YjfC0EsJVPjsF6GNwkYGgUDXiL3AboQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JtB6I3sye99R+5TEja3GGXRIHVKPkML4YtdrjTWzMK8jaCrq33Hv0GG8q8Ff9wff6
	 E6n1LV9XphI6mJM+hd8RK4A/C8awE5vjOUtkvifFTUZG2A1UG/eb2QVYvGAOMr8g1N
	 p7J+acatfkqLCmHH8TTwGfDRFsy0UxRxZnzW3+VI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bruno Thomsen <bruno.thomsen@gmail.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 487/565] rtc: pcf2127: fix watchdog interrupt mask on pcf2131
Date: Tue, 11 Nov 2025 09:45:43 +0900
Message-ID: <20251111004537.884743771@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004526.816196597@linuxfoundation.org>
References: <20251111004526.816196597@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index e793c019fb9d7..05a54f4d4d9a6 100644
--- a/drivers/rtc/rtc-pcf2127.c
+++ b/drivers/rtc/rtc-pcf2127.c
@@ -528,6 +528,21 @@ static int pcf2127_watchdog_init(struct device *dev, struct pcf2127 *pcf2127)
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



