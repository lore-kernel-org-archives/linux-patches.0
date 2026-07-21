Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 480F2370AFB;
	Tue, 21 Jul 2026 22:03:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784671399; cv=none; b=TbF1lgAoy59oUxPH5QRP5vBI6/Cy4DG/SlIFfSHK7rTIczMSt5wmHlRKwkaPf0GMMfnIkVMcupsxuKV6wObA6albQRdW0XrRe2RHRDhLpAzDXpdqwjk4xCEwgS094BOGev2/56AZQIO/9NcNmTtzsXGv7f/TwpSZHkwL0UGeEMc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784671399; c=relaxed/simple;
	bh=0OP9/hNfTCF6CIzbeMT8RLz1oB/ZMh4EO7cQ6cazrXE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cTaS5yiZ61wHuZtbQrOi4j0VN36kjf58R1EvChtYJNEW45QgeLVRa05MhNcsDIjv5EZXL6QY6HZ4eI3Gil0xGC3DFaV5gcOGDZW/htNTJHZ1vo7l+XM78t6Buxz9ZZb1AtTw9yXKeJ3v+XX6mR7XmJRYIWQzwIU0bch+U8YpvFE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=a9/RYIOa; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="a9/RYIOa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE67E1F000E9;
	Tue, 21 Jul 2026 22:03:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784671398;
	bh=IfqLHSYW67X483v5pfmA2S7EBOWVwet45/rGvd806FU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=a9/RYIOaujUvChzyz5N0PWyz0xb7i8NjoiwkqeKphVlpt1ZiRHIuyJrER1zoxKKSw
	 Ye4mCONSFJybdgoqSJdvlgJITen4SXNOeKquUplOVolp/VT/c0LUD34dHcP4ivjn8i
	 kvo9r8UJd9c2elww95BTHoZLgbCLTBT9Zrk/6G3k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Turquette <mturquette@baylibre.com>,
	Stephen Boyd <sboyd@kernel.org>,
	linux-clk@vger.kernel.org,
	Cristian Marussi <cristian.marussi@arm.com>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Brian Masney <bmasney@redhat.com>,
	Sudeep Holla <sudeep.holla@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 232/843] clk: scmi: Fix clock rate rounding
Date: Tue, 21 Jul 2026 17:17:47 +0200
Message-ID: <20260721152411.236048357@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152405.946368001@linuxfoundation.org>
References: <20260721152405.946368001@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cristian Marussi <cristian.marussi@arm.com>

[ Upstream commit d0c81a38d06d446d341532700b3a4a43d3b00eb1 ]

While the do_div() helper used for rounding expects its divisor argument
to be a 32bits quantity, the currently provided divisor parameter is a
64bit value that, as a consequence, is silently truncated and a possible
source of bugs.

Fix by using the proper div64_ul helper.

Cc: Michael Turquette <mturquette@baylibre.com>
Cc: Stephen Boyd <sboyd@kernel.org>
Cc: linux-clk@vger.kernel.org
Fixes: 7a8655e19bdb ("clk: scmi: Fix the rounding of clock rate")
Signed-off-by: Cristian Marussi <cristian.marussi@arm.com>
Tested-by: Florian Fainelli <florian.fainelli@broadcom.com>
Tested-by: Geert Uytterhoeven <geert+renesas@glider.be>
Link: https://patch.msgid.link/20260508153300.2224715-2-cristian.marussi@arm.com
Reviewed-by: Brian Masney <bmasney@redhat.com>
Signed-off-by: Sudeep Holla <sudeep.holla@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/clk-scmi.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/clk/clk-scmi.c b/drivers/clk/clk-scmi.c
index a26027597a0ac6..3e272a28a6f163 100644
--- a/drivers/clk/clk-scmi.c
+++ b/drivers/clk/clk-scmi.c
@@ -9,9 +9,9 @@
 #include <linux/device.h>
 #include <linux/err.h>
 #include <linux/of.h>
+#include <linux/math64.h>
 #include <linux/module.h>
 #include <linux/scmi_protocol.h>
-#include <asm/div64.h>
 
 static const struct scmi_clk_proto_ops *scmi_proto_clk_ops;
 
@@ -61,7 +61,7 @@ static long scmi_clk_round_rate(struct clk_hw *hw, unsigned long rate,
 
 	ftmp = rate - fmin;
 	ftmp += clk->info->range.step_size - 1; /* to round up */
-	do_div(ftmp, clk->info->range.step_size);
+	ftmp = div64_ul(ftmp, clk->info->range.step_size);
 
 	return ftmp * clk->info->range.step_size + fmin;
 }
-- 
2.53.0



