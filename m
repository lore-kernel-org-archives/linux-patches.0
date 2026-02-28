Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40479449EBB
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:52:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301148; cv=none; b=SKkqUiG6mb0LfkpRj+glcw391QkbfFII7uiiWPKlNKaR5uqKtNz0/ghCleKNkf/vN4aMKRBLUl0cYXkbnI0zSWds6DfJvil5CnBz36kjjsdVgFVuK3iMSh+a4Yn8He9NLVV3SCAWEQW9Bqg9RHAOH8OYnCw8Fv6qQm0+Z37Lqs4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301148; c=relaxed/simple;
	bh=l7MNXpfxHs18FIzzszA7gfEIQrfQvlOn0TBRcP4V6i4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g0xJYNGSjvjlxUO5g31QhXWWpv24dkFvaUdpdpM2NV2rMHu1zHajjq/GhJIFieX0rM5wVJu5eeeJNSPahDxyxSbzurrHoV3H/8fVyLQ2x3apV5ic5kYDw011LjyMhBmuVKShO+134Llj4+Ksj30hsFklKVZ5NcjH25F0H1zS/vE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iE/3cf5F; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iE/3cf5F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 814DBC19425;
	Sat, 28 Feb 2026 17:52:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301148;
	bh=l7MNXpfxHs18FIzzszA7gfEIQrfQvlOn0TBRcP4V6i4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iE/3cf5FcdHIjTwPCHOS58XjCekmSsFCDeooEL883ueyQkfE5BMrhw6LyyCzVU3Cg
	 mhH8rPzO1KzuJeUShW7JGaCU64UFWuRC4wfj5NWGuZxn52HOJEirqnvnpUC8fvK/Gm
	 5hAtvnLQ+EfFSeQLuEo7RmGGLI021DeVvdYjxdJ47Q27fMxnk6lQy2HcgCeu3FzkLw
	 IbpGaiN5X+E7H4dhrgbQ5aFzfQOJulr8WjxiBn4Prpnci0v4rAgI+APXMvIQm2Abhx
	 F8knR3NRCW26qKQBfKx8rTbCH7Xm1BY9b0Zci0mqO/grjbIomjQWT2wRsicdMAxh15
	 H673wS6+F24Ug==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Valentina Fernandez <valentina.fernandezalanis@microchip.com>,
	Conor Dooley <conor.dooley@microchip.com>,
	Jassi Brar <jassisinghbrar@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 310/752] mailbox: mchp-ipc-sbi: fix out-of-bounds access in mchp_ipc_get_cluster_aggr_irq()
Date: Sat, 28 Feb 2026 12:40:21 -0500
Message-ID: <20260228174750.1542406-310-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Valentina Fernandez <valentina.fernandezalanis@microchip.com>

[ Upstream commit f7c330a8c83c9b0332fd524097eaf3e69148164d ]

The cluster_cfg array is dynamically allocated to hold per-CPU
configuration structures, with its size based on the number of online
CPUs. Previously, this array was indexed using hartid, which may be
non-contiguous or exceed the bounds of the array, leading to
out-of-bounds access.
Switch to using cpuid as the index, as it is guaranteed to be within
the valid range provided by for_each_online_cpu().

Signed-off-by: Valentina Fernandez <valentina.fernandezalanis@microchip.com>
Reviewed-by: Conor Dooley <conor.dooley@microchip.com>
Signed-off-by: Jassi Brar <jassisinghbrar@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mailbox/mailbox-mchp-ipc-sbi.c | 22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/mailbox/mailbox-mchp-ipc-sbi.c b/drivers/mailbox/mailbox-mchp-ipc-sbi.c
index a6e52009a4245..d444491a584e8 100644
--- a/drivers/mailbox/mailbox-mchp-ipc-sbi.c
+++ b/drivers/mailbox/mailbox-mchp-ipc-sbi.c
@@ -180,20 +180,20 @@ static irqreturn_t mchp_ipc_cluster_aggr_isr(int irq, void *data)
 	/* Find out the hart that originated the irq */
 	for_each_online_cpu(i) {
 		hartid = cpuid_to_hartid_map(i);
-		if (irq == ipc->cluster_cfg[hartid].irq)
+		if (irq == ipc->cluster_cfg[i].irq)
 			break;
 	}
 
 	status_msg.cluster = hartid;
-	memcpy(ipc->cluster_cfg[hartid].buf_base, &status_msg, sizeof(struct mchp_ipc_status));
+	memcpy(ipc->cluster_cfg[i].buf_base, &status_msg, sizeof(struct mchp_ipc_status));
 
-	ret = mchp_ipc_sbi_send(SBI_EXT_IPC_STATUS, ipc->cluster_cfg[hartid].buf_base_addr);
+	ret = mchp_ipc_sbi_send(SBI_EXT_IPC_STATUS, ipc->cluster_cfg[i].buf_base_addr);
 	if (ret < 0) {
 		dev_err_ratelimited(ipc->dev, "could not get IHC irq status ret=%d\n", ret);
 		return IRQ_HANDLED;
 	}
 
-	memcpy(&status_msg, ipc->cluster_cfg[hartid].buf_base, sizeof(struct mchp_ipc_status));
+	memcpy(&status_msg, ipc->cluster_cfg[i].buf_base, sizeof(struct mchp_ipc_status));
 
 	/*
 	 * Iterate over each bit set in the IHC interrupt status register (IRQ_STATUS) to identify
@@ -385,21 +385,21 @@ static int mchp_ipc_get_cluster_aggr_irq(struct mchp_ipc_sbi_mbox *ipc)
 		if (ret <= 0)
 			continue;
 
-		ipc->cluster_cfg[hartid].irq = ret;
-		ret = devm_request_irq(ipc->dev, ipc->cluster_cfg[hartid].irq,
+		ipc->cluster_cfg[cpuid].irq = ret;
+		ret = devm_request_irq(ipc->dev, ipc->cluster_cfg[cpuid].irq,
 				       mchp_ipc_cluster_aggr_isr, IRQF_SHARED,
 				       "miv-ihc-irq", ipc);
 		if (ret)
 			return ret;
 
-		ipc->cluster_cfg[hartid].buf_base = devm_kmalloc(ipc->dev,
-								 sizeof(struct mchp_ipc_status),
-								 GFP_KERNEL);
+		ipc->cluster_cfg[cpuid].buf_base = devm_kmalloc(ipc->dev,
+								sizeof(struct mchp_ipc_status),
+								GFP_KERNEL);
 
-		if (!ipc->cluster_cfg[hartid].buf_base)
+		if (!ipc->cluster_cfg[cpuid].buf_base)
 			return -ENOMEM;
 
-		ipc->cluster_cfg[hartid].buf_base_addr = __pa(ipc->cluster_cfg[hartid].buf_base);
+		ipc->cluster_cfg[cpuid].buf_base_addr = __pa(ipc->cluster_cfg[cpuid].buf_base);
 
 		irq_found = true;
 	}
-- 
2.51.0

