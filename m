Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D993F31A7F1;
	Wed,  3 Dec 2025 15:48:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764776882; cv=none; b=QWw4v6QtFf+raacKRJGzBcCAPTmJFuiQKgtlr+L/no0xkmC4Q9JAaluFVhNYbRPHAajdaXYER0vsq+GA2ey8GW/GlvDzjR+hvBj8W83XifuUwSDnrPZL56qGKPU6uv6DtcNVLUTeJA5JtEHko4p5kYv2+n8/9tQkOxs73SyLk6Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764776882; c=relaxed/simple;
	bh=+im/NSWJbXqjOWoZuxoQtgg0f6jdX7rqBgbln+1vUhQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j6bh17tNw/FWNA/S936gb/LNDlpHm/y1kqGrqvicvmNHxjWphrj00AzOn6cbAz91fNxxdowMIX+iS+rCngpvk4Y/IAD45x5d63LyGg9G0q4lm6evRW3peOkDBqtYgR5wO0oAe9jRiOS54PgCMWky3ur9Lh3LqzEk7/9jROHIz8E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cUh9wSw3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cUh9wSw3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BD95C4CEF5;
	Wed,  3 Dec 2025 15:48:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764776882;
	bh=+im/NSWJbXqjOWoZuxoQtgg0f6jdX7rqBgbln+1vUhQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cUh9wSw3SO/lHDThZAzYOMgk2lzdSkaL6K24leOFKUSem4OHg7ksKS5Rcda5EMH2n
	 2LSGldo2xHAid2TZxtSNCcSx/SF2fMAWMP3ey/dcqdsLABU6JIXJ9tXuwPqnRqvSoe
	 ht5xTFYJyGO/LeEs0mld2LSXLZyqCmrXhei4Rz7o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Horatiu Vultur <horatiu.vultur@microchip.com>,
	Simon Horman <horms@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 016/146] net: lan966x: Fix the initialization of taprio
Date: Wed,  3 Dec 2025 16:26:34 +0100
Message-ID: <20251203152347.063488687@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152346.456176474@linuxfoundation.org>
References: <20251203152346.456176474@linuxfoundation.org>
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

From: Horatiu Vultur <horatiu.vultur@microchip.com>

[ Upstream commit 9780f535f8e0f20b4632b5a173ead71aa8f095d2 ]

To initialize the taprio block in lan966x, it is required to configure
the register REVISIT_DLY. The purpose of this register is to set the
delay before revisit the next gate and the value of this register depends
on the system clock. The problem is that the we calculated wrong the value
of the system clock period in picoseconds. The actual system clock is
~165.617754MHZ and this correspond to a period of 6038 pico seconds and
not 15125 as currently set.

Fixes: e462b2717380b4 ("net: lan966x: Add offload support for taprio")
Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20251121061411.810571-1-horatiu.vultur@microchip.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/microchip/lan966x/lan966x_ptp.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_ptp.c b/drivers/net/ethernet/microchip/lan966x/lan966x_ptp.c
index b4377b8613c3a..8c40db90ee8f6 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_ptp.c
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_ptp.c
@@ -1,11 +1,14 @@
 // SPDX-License-Identifier: GPL-2.0+
 
 #include <linux/ptp_classify.h>
+#include <linux/units.h>
 
 #include "lan966x_main.h"
 #include "vcap_api.h"
 #include "vcap_api_client.h"
 
+#define LAN9X66_CLOCK_RATE	165617754
+
 #define LAN966X_MAX_PTP_ID	512
 
 /* Represents 1ppm adjustment in 2^59 format with 6.037735849ns as reference
@@ -1126,5 +1129,5 @@ void lan966x_ptp_rxtstamp(struct lan966x *lan966x, struct sk_buff *skb,
 u32 lan966x_ptp_get_period_ps(void)
 {
 	/* This represents the system clock period in picoseconds */
-	return 15125;
+	return PICO / LAN9X66_CLOCK_RATE;
 }
-- 
2.51.0



