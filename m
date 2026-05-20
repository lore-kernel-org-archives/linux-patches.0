Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D97B63AE6E6;
	Wed, 20 May 2026 16:59:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779296381; cv=none; b=UZlVL0Xv8GoVO+iWSDk2vt+gJLXPZUQ9+n9jQsFta1kza/J+wUZzY2elpxvK02Mw85qY6BIkqtRZ5E3wh8vPrIDZf0Ow7ma9Sf7Esx4GOK7t/KLuLpSKSMu5EWlFZUyXgDy8dxK9RNqwy7TyYZq2FWh5KLCSJaFLZAe45OgGYc0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779296381; c=relaxed/simple;
	bh=Lm3HIleCLI08b4JH5bdEIOdCUiPvrmlgz6gxgIvHYeE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JK8bEx4AL9niqhqa1Sh1C32RYNomizsNVKoHZQQ+iAPS4pJStve7UjB2StjHxPO75gQ6Fk6vTpvlMDMjJfo8iqeWbixGKQ2U/z1Oafh0ocfbiFMCXrUcA0EnWxO7U/5VS0rx9UdTLVtHtHlSEvm8KbiYrFmUUyjZ312PpWv9Gv0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ax/72dJi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ax/72dJi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7F011F00893;
	Wed, 20 May 2026 16:59:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779296379;
	bh=AHTA9DX+mkqgBzb1pKbEpoguMLjuHXkDWCTcAFsAavM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ax/72dJiq1/9EYyu1Y3rWMT8iDrWJjQKIS1yKBMysgIjRZL92FDlR7clPk2WTc2uX
	 k1B6yn2cV60/XBVAb8DFkQ9rHqcRjdvhvn6S+r/bjtmOlmxKKHdxURepn2YYg70VZD
	 tmfeF/N7NUew6vG/VYOugrp+UjKD6ahQf5WnXMtg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wei Fang <wei.fang@nxp.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0775/1146] net: enetc: correct the command BD ring consumer index
Date: Wed, 20 May 2026 18:17:05 +0200
Message-ID: <20260520162205.754910257@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wei Fang <wei.fang@nxp.com>

[ Upstream commit 759a32900b6f3db3d0f34a3b61123742723b50b4 ]

The command BD ring cousumer index register has the consumer index as
the lower 10 bits, and the bit 31 is SBE, which indicates whether a
system bus error occurred during execution of the CBD command. So if a
system bus error occurs, reading the register will get the SBE bit set.

However, the current implementation directly uses the register value as
the consumer index without masking it. Therefore, if a system bus error
occurs, an incorrect consumer index will be obtained, causing errors in
the processing of the command BD ring. Thus, we need to mask out the
other bits to obtain the correct consumer index.

In addition, this patch adds a check for the SBE bit after the polling
loop and returns an error if the bit is set.

Fixes: 4701073c3deb ("net: enetc: add initial netc-lib driver to support NTMP")
Signed-off-by: Wei Fang <wei.fang@nxp.com>
Link: https://patch.msgid.link/20260415060833.2303846-2-wei.fang@nxp.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/freescale/enetc/ntmp.c         | 13 ++++++++++---
 drivers/net/ethernet/freescale/enetc/ntmp_private.h |  2 ++
 2 files changed, 12 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/freescale/enetc/ntmp.c b/drivers/net/ethernet/freescale/enetc/ntmp.c
index 0c1d343253bfb..b188eb2d40c0d 100644
--- a/drivers/net/ethernet/freescale/enetc/ntmp.c
+++ b/drivers/net/ethernet/freescale/enetc/ntmp.c
@@ -55,7 +55,7 @@ int ntmp_init_cbdr(struct netc_cbdr *cbdr, struct device *dev,
 	spin_lock_init(&cbdr->ring_lock);
 
 	cbdr->next_to_use = netc_read(cbdr->regs.pir);
-	cbdr->next_to_clean = netc_read(cbdr->regs.cir);
+	cbdr->next_to_clean = netc_read(cbdr->regs.cir) & NETC_CBDRCIR_INDEX;
 
 	/* Step 1: Configure the base address of the Control BD Ring */
 	netc_write(cbdr->regs.bar0, lower_32_bits(cbdr->dma_base_align));
@@ -98,7 +98,7 @@ static void ntmp_clean_cbdr(struct netc_cbdr *cbdr)
 	int i;
 
 	i = cbdr->next_to_clean;
-	while (netc_read(cbdr->regs.cir) != i) {
+	while ((netc_read(cbdr->regs.cir) & NETC_CBDRCIR_INDEX) != i) {
 		cbd = ntmp_get_cbd(cbdr, i);
 		memset(cbd, 0, sizeof(*cbd));
 		i = (i + 1) % cbdr->bd_num;
@@ -135,12 +135,19 @@ static int netc_xmit_ntmp_cmd(struct ntmp_user *user, union netc_cbd *cbd)
 	cbdr->next_to_use = i;
 	netc_write(cbdr->regs.pir, i);
 
-	err = read_poll_timeout_atomic(netc_read, val, val == i,
+	err = read_poll_timeout_atomic(netc_read, val,
+				       (val & NETC_CBDRCIR_INDEX) == i,
 				       NETC_CBDR_DELAY_US, NETC_CBDR_TIMEOUT,
 				       true, cbdr->regs.cir);
 	if (unlikely(err))
 		goto cbdr_unlock;
 
+	if (unlikely(val & NETC_CBDRCIR_SBE)) {
+		dev_err(user->dev, "Command BD system bus error\n");
+		err = -EIO;
+		goto cbdr_unlock;
+	}
+
 	dma_rmb();
 	/* Get the writeback command BD, because the caller may need
 	 * to check some other fields of the response header.
diff --git a/drivers/net/ethernet/freescale/enetc/ntmp_private.h b/drivers/net/ethernet/freescale/enetc/ntmp_private.h
index 34394e40fddd4..3459cc45b6103 100644
--- a/drivers/net/ethernet/freescale/enetc/ntmp_private.h
+++ b/drivers/net/ethernet/freescale/enetc/ntmp_private.h
@@ -12,6 +12,8 @@
 
 #define NTMP_EID_REQ_LEN	8
 #define NETC_CBDR_BD_NUM	256
+#define NETC_CBDRCIR_INDEX	GENMASK(9, 0)
+#define NETC_CBDRCIR_SBE	BIT(31)
 
 union netc_cbd {
 	struct {
-- 
2.53.0



