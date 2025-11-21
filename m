Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9424F3242B0;
	Fri, 21 Nov 2025 13:50:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763733021; cv=none; b=i62kFubWysDO7dQCs9Qy0PJ1BLPa/MTUp0uo5fpiH8MWVyI9I9ew0e4EWw1zC418l0JnpB/fWw+KBEphGQSzRdltd04ZGRXHs6Vsi9ouLE46tF6Yv91F1xvxCX3C/Um9NGDqpFhDo2hU0VrFrhjzeTg0qvabHyMaouUGhnfcMnQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763733021; c=relaxed/simple;
	bh=ia5XKxi/+WbiU+Dt2Nh3OpCpVhqwL97vY+N6t0uWenw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=odDtF6iWhFPusUrvmBDcijvrK0HCzUI5fZcCpaEHZUZjOp7CXvVCkDa7XtBWQWKwHn4djppqdbjxKO0kDCazg9JKf9p/5DWd0r0Wti7MMJnITexG/hDJ3zLknFGJP0o1yqZ+/Ymz0GRhiDlSJ5vw0FRO4weH+kzQQxndIpHrnEk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NA75lcxB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NA75lcxB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C6D7C4CEF1;
	Fri, 21 Nov 2025 13:50:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763733021;
	bh=ia5XKxi/+WbiU+Dt2Nh3OpCpVhqwL97vY+N6t0uWenw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NA75lcxBWf6OQ/ByBCzUvBM0qdoJLWLLxk3DJ+GH+aSnkTTyL0zcLJG+A2VwKgxJj
	 uEF3iGBzG7WkEpo2jX1+P+oO/FNxS9uu684XVMS6/lSy2Ib7ILRe5fgLjiVCgRkuay
	 GzDimUbxhLaemuafBEolJ5006sxjS1RtYgpjpM0s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bruno Thomsen <bruno.thomsen@gmail.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 324/529] rtc: pcf2127: fix watchdog interrupt mask on pcf2131
Date: Fri, 21 Nov 2025 14:10:23 +0100
Message-ID: <20251121130242.553453836@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130230.985163914@linuxfoundation.org>
References: <20251121130230.985163914@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



