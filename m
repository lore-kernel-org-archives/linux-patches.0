Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8818C352C4F;
	Tue, 10 Mar 2026 11:13:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773141212; cv=none; b=u+K8YUOKCcvZrjcmu3mwEql0yXQ2LNkHQfNzqZgN13QMnbXeCrTeNvoswnpCmqfA1z/afHx3ZpGGgXeXeTX4k0siWBsRr6dRuOoolZgNHU0e6ENFC6z77P9pZeX44ZTOna4iHoiwKZVMEHbUImJNAovor+RitXGbeM1KvoLSAcw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773141212; c=relaxed/simple;
	bh=bMFQ9Wn3/4vkCtCXjtRmkn5wXiD5GPTTJSQtGrDfthM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VwZLBCgv3Wi+GwZ9DBo4YdnZO1s7GGgkynuU6Tb6Xj0cFObkRoeyfU+CrVCDt24N2V/AuaPuS7Lv1K19ivIgF/6fh/qRO7SWq3aRRp+daOsPfJx3YrF6JdzsNxWzxyBdndrULhS9lpOqj1GgOoUTG5hvAx98kVb+Zh99HUebKrA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dXX+CUMO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dXX+CUMO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3122C19423;
	Tue, 10 Mar 2026 11:13:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773141212;
	bh=bMFQ9Wn3/4vkCtCXjtRmkn5wXiD5GPTTJSQtGrDfthM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dXX+CUMOg3WdyvHU+TQiNo/+anSFfnwoViHLlHXtl8guPHpOyBPzkCvdHBT+dNaq4
	 hdIu+SZeRG+CzliFin349frUJCLNzULkXXLOx2t4OB3Jp/EjuIQrYyw7bfm/1VWdiB
	 +rB+WZPxQSPXcUKHoV+8xt5WxGPlNDoeastsTUdNhE4FV4mviIczL4Vjx3taZz81cw
	 LHDjicKtS6zXfz19qb/n2HMg3dYbUXhaGa8JN8xESCYjh/HoFBPODGDWqKuoqodKvB
	 RVJiIs29cSO0Fp50C27P+oSwp05fMW+ePBppA3LauPiIOdqiXMGAm09M0JzNTiA2yn
	 tHRI4UNAvidaA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Guenter Roeck <linux@roeck-us.net>,
	Junrui Luo <moonafterrain@outlook.com>,
	Ioana Ciornei <ioana.ciornei@nxp.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 213/311] dpaa2-switch: Fix interrupt storm after receiving bad if_id in IRQ handler
Date: Tue, 10 Mar 2026 07:04:20 -0400
Message-ID: <06731c250d9b7b186d1e3052c9944b224e13604e.1773140655.git.sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1773140654.git.sashal@kernel.org>
References: <cover.1773140654.git.sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Guenter Roeck <linux@roeck-us.net>

[ Upstream commit 74badb9c20b1a9c02a95c735c6d3cd6121679c93 ]

Commit 31a7a0bbeb00 ("dpaa2-switch: add bounds check for if_id in IRQ
handler") introduces a range check for if_id to avoid an out-of-bounds
access. If an out-of-bounds if_id is detected, the interrupt status is
not cleared. This may result in an interrupt storm.

Clear the interrupt status after detecting an out-of-bounds if_id to avoid
the problem.

Found by an experimental AI code review agent at Google.

Fixes: 31a7a0bbeb00 ("dpaa2-switch: add bounds check for if_id in IRQ handler")
Cc: Junrui Luo <moonafterrain@outlook.com>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Reviewed-by: Ioana Ciornei <ioana.ciornei@nxp.com>
Link: https://patch.msgid.link/20260227055812.1777915-1-linux@roeck-us.net
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c
index 78e21b46a5ba8..e212a014c8d41 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c
@@ -1533,7 +1533,7 @@ static irqreturn_t dpaa2_switch_irq0_handler_thread(int irq_num, void *arg)
 	if_id = (status & 0xFFFF0000) >> 16;
 	if (if_id >= ethsw->sw_attr.num_ifs) {
 		dev_err(dev, "Invalid if_id %d in IRQ status\n", if_id);
-		goto out;
+		goto out_clear;
 	}
 	port_priv = ethsw->ports[if_id];
 
@@ -1553,6 +1553,7 @@ static irqreturn_t dpaa2_switch_irq0_handler_thread(int irq_num, void *arg)
 			dpaa2_switch_port_connect_mac(port_priv);
 	}
 
+out_clear:
 	err = dpsw_clear_irq_status(ethsw->mc_io, 0, ethsw->dpsw_handle,
 				    DPSW_IRQ_INDEX_IF, status);
 	if (err)
-- 
2.51.0

