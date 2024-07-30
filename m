Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D9C31A76DD;
	Tue, 30 Jul 2024 17:16:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722359772; cv=none; b=sBYZy+EA3A1eZIaU7tVuez2/xvgFHQzBRET3YhslRVzTStTBfVCi3DuEbLw3A7JWy3v7Cgj+/+Q/13KT/nDSlBGk5wIqid6iQ2fi8GVO9NNR5YjMxmhSP303XH6WCMzqk4M3GFgynSB9LtVLQLgzzj9CPNTjXUcL8cjYSNnw7ZE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722359772; c=relaxed/simple;
	bh=81szZ3UV/5mexYSd7R5/pA/mLpbun2SyIQyFgXfCM3w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IB643txzQsDms4bvBAPGWD0HIcaXrSB1+XxAAmFHMxUVBCz+CBdgvdm66ujIl6swjOj/n2EPGG+kUSfjIrDjN9s2vb66PZN5qINRMxhvdgaqJrjr4i7qK1mnHLDMtngjCFzCgvjwSBN85A9gjbEoDr5h0ISqddC7m316Fz9xuyw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=l0f9BLqR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="l0f9BLqR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7AF7C32782;
	Tue, 30 Jul 2024 17:16:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722359772;
	bh=81szZ3UV/5mexYSd7R5/pA/mLpbun2SyIQyFgXfCM3w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=l0f9BLqR9bfRKaSkdZTIYq3MS9SzWeUCrNFVyRZbl8cGdNdNGZ8Yj95ipksjq6qlg
	 0xPRfuFMM1QDbEDHUcZRMhwG1gBP+tT9D1XJoYc6L5nDIfdCXAd0AIbIpOdqd94yOV
	 Gzrg6WpZceBxv3tyStpgzg6LlB+tElBsTIxR4ogI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ranjani Vaidyanathan <ranjani.vaidyanathan@nxp.com>,
	Peng Fan <peng.fan@nxp.com>,
	Jassi Brar <jassisinghbrar@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 530/809] mailbox: imx: fix TXDB_V2 channel race condition
Date: Tue, 30 Jul 2024 17:46:46 +0200
Message-ID: <20240730151745.671591204@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peng Fan <peng.fan@nxp.com>

[ Upstream commit b5ef17917f3a797a7b12d1edd51f676554e44a07 ]

Two TXDB_V2 channels are used between Linux and System Manager(SM).
Channel0 for normal TX, Channel 1 for notification completion.
The TXDB_V2 trigger logic is using imx_mu_xcr_rmw which uses
read/modify/update logic.

Note: clear MUB GSR BITs, the MUA side GCR BITs will also got cleared per
hardware design.
Channel0 Linux
read GCR->modify GCR->write GCR->M33 SM->read GSR----->clear GSR
                                                |-(1)-|
Channel1 Linux start in time slot(1)
read GCR->modify GCR->write GCR->M33 SM->read GSR->clear GSR
So Channel1 read GCR will read back the GCR that Channel0 wrote, because
M33 has not finish clear GSR, this means Channel1 GCR writing will
trigger Channel1 and Channel0 interrupt both which is wrong.

Channel0 will be freed(SCMI channel status set to FREE) in M33 SM when
processing the 1st Channel0 interrupt. So when 2nd interrupt trigger
(channel 0/1 trigger together), SM will see a freed Channel0, and report
protocol error.

To address the issue, not using read/modify/update logic, just use
write, because write 0 to GCR will be ignored. And after write MUA GCR,
wait the SM to clear MUB GSR by looping MUA GCR value.

Fixes: 5bfe4067d350 ("mailbox: imx: support channel type tx doorbell v2")
Reviewed-by: Ranjani Vaidyanathan <ranjani.vaidyanathan@nxp.com>
Signed-off-by: Peng Fan <peng.fan@nxp.com>
Signed-off-by: Jassi Brar <jassisinghbrar@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mailbox/imx-mailbox.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/mailbox/imx-mailbox.c b/drivers/mailbox/imx-mailbox.c
index 933727f89431d..d17efb1dd0cb1 100644
--- a/drivers/mailbox/imx-mailbox.c
+++ b/drivers/mailbox/imx-mailbox.c
@@ -225,6 +225,8 @@ static int imx_mu_generic_tx(struct imx_mu_priv *priv,
 			     void *data)
 {
 	u32 *arg = data;
+	u32 val;
+	int ret;
 
 	switch (cp->type) {
 	case IMX_MU_TYPE_TX:
@@ -236,7 +238,13 @@ static int imx_mu_generic_tx(struct imx_mu_priv *priv,
 		queue_work(system_bh_wq, &cp->txdb_work);
 		break;
 	case IMX_MU_TYPE_TXDB_V2:
-		imx_mu_xcr_rmw(priv, IMX_MU_GCR, IMX_MU_xCR_GIRn(priv->dcfg->type, cp->idx), 0);
+		imx_mu_write(priv, IMX_MU_xCR_GIRn(priv->dcfg->type, cp->idx),
+			     priv->dcfg->xCR[IMX_MU_GCR]);
+		ret = readl_poll_timeout(priv->base + priv->dcfg->xCR[IMX_MU_GCR], val,
+					 !(val & IMX_MU_xCR_GIRn(priv->dcfg->type, cp->idx)),
+					 0, 1000);
+		if (ret)
+			dev_warn_ratelimited(priv->dev, "channel type: %d failure\n", cp->type);
 		break;
 	default:
 		dev_warn_ratelimited(priv->dev, "Send data on wrong channel type: %d\n", cp->type);
-- 
2.43.0



