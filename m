Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF015449EBB
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:52:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301151; cv=none; b=vBBGTxYutrKDMwiRXXf6wB9y3vhRVnzfHaRqOQbHLp11lixIXJ0TlbcoHAp2bRTQelxqMUIq3j2hW3xuRcdYdgTWf+z58MxBx2kbTiFVrGb2GT14cxHfMfMiDh0U5hwubCBZOSuVcLGyTDzs7aBsEt454OF1gc9OIq4Hho9lnlU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301151; c=relaxed/simple;
	bh=aLpQTaDCsoaCt2G3eAu3tYCXL6/FwZb475hYCkU+bTk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hj3f39XMfoLtoHs27nOut13FwVKfwUe9yzGC9nndEE9erUy5nXd29+IkosEo0rbk371EN19qiBTtY0Aku6YiBI9vtPTOoc4hyJ9WnPYBX/pZg2UFTXfeZ6DANld5UvRK898XA1nIG8lQqVftzPZPvM1NO7Qo7vd8rq5jaETd3nU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZR6ZxDro; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZR6ZxDro"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F6E7C19423;
	Sat, 28 Feb 2026 17:52:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301150;
	bh=aLpQTaDCsoaCt2G3eAu3tYCXL6/FwZb475hYCkU+bTk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZR6ZxDroRIQyiNE5CEc869ecnxnL79FvKb9H7sswx+Tp01MafBa3rpYeyw0wYsUDx
	 HBrBECu51CKFlolBoz9Iwp7wbuIA1Jtk9VcJtoltmmyr6f9DxvVUlTUx4e8Q/zQHvT
	 RQbNJLlx95J0OHoGGYbc6scIu7elomgXVXv08YavAVocyBCPqG2hdULFZVzEuZ8jdf
	 yKZW5ig6byAPjgxuknUKEuWPDLDx5NWfYgB0a8RGscLKKMhsmEeSOrt5NYO3o9ZFbq
	 SV/toA9YjPz/SXfZyRV13ckbHkxXkLbj98CPPkUNUF7DpoyAIGhZFa6VMJWNYWBNJR
	 KDOjQElX+edEA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Valentina Fernandez <valentina.fernandezalanis@microchip.com>,
	kernel test robot <lkp@intel.com>,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Jassi Brar <jassisinghbrar@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 313/752] mailbox: mchp-ipc-sbi: fix uninitialized symbol and other smatch warnings
Date: Sat, 28 Feb 2026 12:40:24 -0500
Message-ID: <20260228174750.1542406-313-sashal@kernel.org>
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

[ Upstream commit bc4d17e495cd3b02bcb2e10f575763a5ff31f80b ]

Fix uninitialized symbol 'hartid' warning in mchp_ipc_cluster_aggr_isr()
by introducing a 'found' flag to track whether the IRQ matches any
online hart. If no match is found, return IRQ_NONE.

Also fix other smatch warnings by removing dead code in
mchp_ipc_startup() and by returning -ENODEV in dev_err_probe() if the
Microchip SBI extension is not found.

Fixes below smatch warnings:
drivers/mailbox/mailbox-mchp-ipc-sbi.c:187 mchp_ipc_cluster_aggr_isr() error: uninitialized symbol 'hartid'.
drivers/mailbox/mailbox-mchp-ipc-sbi.c:324 mchp_ipc_startup() warn: ignoring unreachable code.
drivers/mailbox/mailbox-mchp-ipc-sbi.c:422 mchp_ipc_probe() warn: passing zero to 'dev_err_probe'

Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
Closes: https://lore.kernel.org/r/202512171533.CDLdScMY-lkp@intel.com/
Signed-off-by: Valentina Fernandez <valentina.fernandezalanis@microchip.com>
Signed-off-by: Jassi Brar <jassisinghbrar@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mailbox/mailbox-mchp-ipc-sbi.c | 21 +++++++++------------
 1 file changed, 9 insertions(+), 12 deletions(-)

diff --git a/drivers/mailbox/mailbox-mchp-ipc-sbi.c b/drivers/mailbox/mailbox-mchp-ipc-sbi.c
index d444491a584e8..b87bf2fb4b9b9 100644
--- a/drivers/mailbox/mailbox-mchp-ipc-sbi.c
+++ b/drivers/mailbox/mailbox-mchp-ipc-sbi.c
@@ -174,17 +174,21 @@ static irqreturn_t mchp_ipc_cluster_aggr_isr(int irq, void *data)
 	struct mchp_ipc_msg ipc_msg;
 	struct mchp_ipc_status status_msg;
 	int ret;
-	unsigned long hartid;
 	u32 i, chan_index, chan_id;
+	bool found = false;
 
 	/* Find out the hart that originated the irq */
 	for_each_online_cpu(i) {
-		hartid = cpuid_to_hartid_map(i);
-		if (irq == ipc->cluster_cfg[i].irq)
+		if (irq == ipc->cluster_cfg[i].irq) {
+			found = true;
 			break;
+		}
 	}
 
-	status_msg.cluster = hartid;
+	if (unlikely(!found))
+		return IRQ_NONE;
+
+	status_msg.cluster = cpuid_to_hartid_map(i);
 	memcpy(ipc->cluster_cfg[i].buf_base, &status_msg, sizeof(struct mchp_ipc_status));
 
 	ret = mchp_ipc_sbi_send(SBI_EXT_IPC_STATUS, ipc->cluster_cfg[i].buf_base_addr);
@@ -321,13 +325,6 @@ static int mchp_ipc_startup(struct mbox_chan *chan)
 		goto fail_free_buf_msg_rx;
 	}
 
-	if (ret) {
-		dev_err(ipc->dev, "failed to register interrupt(s)\n");
-		goto fail_free_buf_msg_rx;
-	}
-
-	return ret;
-
 fail_free_buf_msg_rx:
 	kfree(chan_info->msg_buf_rx);
 fail_free_buf_msg_tx:
@@ -419,7 +416,7 @@ static int mchp_ipc_probe(struct platform_device *pdev)
 
 	ret = sbi_probe_extension(SBI_EXT_MICROCHIP_TECHNOLOGY);
 	if (ret <= 0)
-		return dev_err_probe(dev, ret, "Microchip SBI extension not detected\n");
+		return dev_err_probe(dev, -ENODEV, "Microchip SBI extension not detected\n");
 
 	ipc = devm_kzalloc(dev, sizeof(*ipc), GFP_KERNEL);
 	if (!ipc)
-- 
2.51.0

