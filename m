Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3E5C18E025;
	Tue, 17 Jun 2025 16:18:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750177084; cv=none; b=eWcYIEWZd1bcyRUPGutgAUpAQVgt+p35qIbgxPg3jhB0GqBZeCyro2ne3ovs6VNQi7RwhRlItqIRHkJwvQJQiVJPXKmat6G9J0AqnhcXEZuzG+MD9yBep6GWy9OoxEQP1JUNwSoWsevc+HP4TC0+1jjIGC48d8GO/Yu+1JBZvAE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750177084; c=relaxed/simple;
	bh=nat7DGFeRNyPGVQNYniapC+khKVdZTphAyUBP+JGyOg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gBLGBP0xWv4Zpa1fhboWbKgQpTmZmUQhmAQHkZ0jcLPDelDshG7YGW1dGll5wdsV4tjYSblQoUVnhiIh25ra2LNJTrAqdRmpukkxXZkoZJNXIf03y9T76e50EL9DQkae8Ml7qzvfKX+UlpBnszs2BvakaWwYCqhagl6SUR1nKqI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nhLEZMHC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nhLEZMHC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BADEAC4CEE3;
	Tue, 17 Jun 2025 16:18:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750177084;
	bh=nat7DGFeRNyPGVQNYniapC+khKVdZTphAyUBP+JGyOg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nhLEZMHCDW+SvSVH/2gVGgqWPPMhTe9kKWK75Mvv/3FbA8PbCM2BsWmk59xSWiyGZ
	 lJLp3buuLNKXg+OqaBTi0hHrUPu+q+QgesPVFZCWo0r4Y5XLwNJ2APtlNo+UdhJKkt
	 F6jcBOPezWZINpL7g4+jyHQC4Cq2ZaX1f4IzItCo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peng Fan <peng.fan@nxp.com>,
	Jassi Brar <jassisinghbrar@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 295/512] mailbox: imx: Fix TXDB_V2 sending
Date: Tue, 17 Jun 2025 17:24:21 +0200
Message-ID: <20250617152431.551512419@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152419.512865572@linuxfoundation.org>
References: <20250617152419.512865572@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peng Fan <peng.fan@nxp.com>

[ Upstream commit f5cb07ec6aabd1bb56adbdeb5f0d70cb524db2cd ]

i.MX95 features several processing domains, Cortex-M7, Cortex-A55
secure, Cortex-A55 non-secure. Each domain could communicate with
SCMI firmware with a dedicated MU. But the current NXP SCMI firmware
is not a RTOS, all processing logic codes are in interrupt context.
So if high priority Cortex-M7 is communicating with SCMI firmware and
requires a bit more time to handle the SCMI call, Linux MU TXDB_V2
will be timeout with high possiblity in 1000us(the current value in
imx-mailbox.c). Per NXP SCMI firmware design, if timeout, there is
no recover logic, so SCMI agents should never timeout and always
wait until the check condition met.

Based on the upper reason, enlarge the timeout value to 10ms which
is less chance to timeout, and retry if timeout really happends.

Fixes: 5bfe4067d350 ("mailbox: imx: support channel type tx doorbell v2")
Signed-off-by: Peng Fan <peng.fan@nxp.com>
Signed-off-by: Jassi Brar <jassisinghbrar@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mailbox/imx-mailbox.c | 21 +++++++++++++++------
 1 file changed, 15 insertions(+), 6 deletions(-)

diff --git a/drivers/mailbox/imx-mailbox.c b/drivers/mailbox/imx-mailbox.c
index f815dab3be50c..0657bd3d8f97b 100644
--- a/drivers/mailbox/imx-mailbox.c
+++ b/drivers/mailbox/imx-mailbox.c
@@ -226,7 +226,7 @@ static int imx_mu_generic_tx(struct imx_mu_priv *priv,
 {
 	u32 *arg = data;
 	u32 val;
-	int ret;
+	int ret, count;
 
 	switch (cp->type) {
 	case IMX_MU_TYPE_TX:
@@ -240,11 +240,20 @@ static int imx_mu_generic_tx(struct imx_mu_priv *priv,
 	case IMX_MU_TYPE_TXDB_V2:
 		imx_mu_write(priv, IMX_MU_xCR_GIRn(priv->dcfg->type, cp->idx),
 			     priv->dcfg->xCR[IMX_MU_GCR]);
-		ret = readl_poll_timeout(priv->base + priv->dcfg->xCR[IMX_MU_GCR], val,
-					 !(val & IMX_MU_xCR_GIRn(priv->dcfg->type, cp->idx)),
-					 0, 1000);
-		if (ret)
-			dev_warn_ratelimited(priv->dev, "channel type: %d failure\n", cp->type);
+		ret = -ETIMEDOUT;
+		count = 0;
+		while (ret && (count < 10)) {
+			ret =
+			readl_poll_timeout(priv->base + priv->dcfg->xCR[IMX_MU_GCR], val,
+					   !(val & IMX_MU_xCR_GIRn(priv->dcfg->type, cp->idx)),
+					   0, 10000);
+
+			if (ret) {
+				dev_warn_ratelimited(priv->dev,
+						     "channel type: %d timeout, %d times, retry\n",
+						     cp->type, ++count);
+			}
+		}
 		break;
 	default:
 		dev_warn_ratelimited(priv->dev, "Send data on wrong channel type: %d\n", cp->type);
-- 
2.39.5



