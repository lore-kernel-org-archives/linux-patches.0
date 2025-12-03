Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FFFA350285;
	Wed,  3 Dec 2025 16:56:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764780965; cv=none; b=JDB9jPdlXdrvjUqjV00GYkczm4uxXjBbBjbUClrgLTiJEz+s61zGgX51kIdvYmW3lIjBvie+gQ8SbX+iLppkh6sFGj5E42cTf45APTKbZWUdNxlpfjpbMmcsZfV6CpgmpTIK36NeE7armIdki7q0W0hM1pZd2IrFCi0U7EGLtYo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764780965; c=relaxed/simple;
	bh=1WxeUsn5KHfiiGS05As/8pKsHvzMHZ1LkzwG1lcxUJc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tJZe7q1rCeF9cXG7oepd4UQt4s8z6HA2sgsLT15k9rlyO4Junoj9OVeSV2XT7ThmRAwBENwM70H7/2bO7Xjhprs+otnr43uiTNXd9uhMT6MIwxfDCNy7LToJf34K9nsjrEa9CD4sYKymCN2+3Ml97lIq4qKNrUjqDxEgnrMbWFY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Vzke32kq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Vzke32kq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4136FC4CEF5;
	Wed,  3 Dec 2025 16:56:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764780964;
	bh=1WxeUsn5KHfiiGS05As/8pKsHvzMHZ1LkzwG1lcxUJc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Vzke32kqDbPRWAJg/MmGF6l/3qWfzMUFnvSJfL72zw+8JyO3ucFd0jK1LJEh1/4yc
	 A0PqZL3XslKgB0a74GqDwXQCtgtnQi0dhCg98sgATA6A5niE92gqrO34tHY51mqaG/
	 GCZ5oWcxoG50MRNbhB9wnEojTkcg6hBP0iUan0l0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Horatiu Vultur <horatiu.vultur@microchip.com>,
	Simon Horman <horms@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 10/93] net: lan966x: Fix the initialization of taprio
Date: Wed,  3 Dec 2025 16:29:03 +0100
Message-ID: <20251203152336.888262696@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152336.494201426@linuxfoundation.org>
References: <20251203152336.494201426@linuxfoundation.org>
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
index 87e5e81d40dc6..84f5b4410e48e 100644
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
@@ -1132,5 +1135,5 @@ void lan966x_ptp_rxtstamp(struct lan966x *lan966x, struct sk_buff *skb,
 u32 lan966x_ptp_get_period_ps(void)
 {
 	/* This represents the system clock period in picoseconds */
-	return 15125;
+	return PICO / LAN9X66_CLOCK_RATE;
 }
-- 
2.51.0



