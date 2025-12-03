Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE96636BCC5;
	Wed,  3 Dec 2025 16:45:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764780357; cv=none; b=Ogw8saxVN/yTg4JJW2HO9sxCKJHi6GPeyhGZLZRd/Z4YpHUwLGPysJT8H/JGiz4Jw+IJOUV274XQ/zsXhSm+9/watOBQGOVSQmV9u6WPwQwErS/Xis1v8BjElBZT1ij3kmriNrypaGBC7kC7CEOnqdgSJW58yIMUGuiNlFBai88=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764780357; c=relaxed/simple;
	bh=5YEkV8dPDa4AE4N2zNMoqLgcqFkOMJgPK0FkQaOiOXo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sJ3nsMJf/Kc3Cd9cnKwkP6yv/haKSEE871G3bwGd9oZenr4abHZEOgs/oquJtBIId+cx95YljIfhWPLo4g09XjSQfB9iKMr7jj1YNy6aEOgn+DZcK/pS+RpKa8U8zz8h5nGG5vharIWk3FSqbnI4J4cpLLasjspXYGg6mVWI+xo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QlfAXOPQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QlfAXOPQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BA56C116B1;
	Wed,  3 Dec 2025 16:45:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764780356;
	bh=5YEkV8dPDa4AE4N2zNMoqLgcqFkOMJgPK0FkQaOiOXo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QlfAXOPQNb6qgRjI8vx6/GOmo/U7ISvNrALf27tG7ntg2tZEa5OfLEPWHJ3C8t2Os
	 4Y0HF/m5S7MRY24PyGnlh8YdJnRR4QsVDnazI/Lgg5lztwW3HFbWOM8drZVGGQe/G3
	 qhDwz9FJYTohyG66pZMn2qm1xKQwzMuhn9xfHP2s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Horatiu Vultur <horatiu.vultur@microchip.com>,
	Simon Horman <horms@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 499/568] net: lan966x: Fix the initialization of taprio
Date: Wed,  3 Dec 2025 16:28:21 +0100
Message-ID: <20251203152458.990976031@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152440.645416925@linuxfoundation.org>
References: <20251203152440.645416925@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 0a0e233f36ab0..667f2651ee309 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_ptp.c
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_ptp.c
@@ -1,9 +1,12 @@
 // SPDX-License-Identifier: GPL-2.0+
 
 #include <linux/ptp_classify.h>
+#include <linux/units.h>
 
 #include "lan966x_main.h"
 
+#define LAN9X66_CLOCK_RATE	165617754
+
 #define LAN966X_MAX_PTP_ID	512
 
 /* Represents 1ppm adjustment in 2^59 format with 6.037735849ns as reference
@@ -896,5 +899,5 @@ void lan966x_ptp_rxtstamp(struct lan966x *lan966x, struct sk_buff *skb,
 u32 lan966x_ptp_get_period_ps(void)
 {
 	/* This represents the system clock period in picoseconds */
-	return 15125;
+	return PICO / LAN9X66_CLOCK_RATE;
 }
-- 
2.51.0



