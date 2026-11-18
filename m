Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795020496;
	b=r7Cir1fMWulu3wVWxVOgvBre6T4yxAJNhmQ1hEU36mL2PUuP9vQ7T4Mam80kAfJwaEy4
	 emeCXr5ovI7UChP5EnOswIQ1dKcJlHS4k5G0y/h11YMuD/REPiaRqZ6Jmc6Gg6yn23vvv
	 tp8ldHvsdywR58H9X91Msa1Jg81gwWLTGb2Y5yVwmVQQ7iG4nlAof2v4ie93mtRw7anmR
	 ptc5w3b2SfkXr3muzzbr0ajIogAvzvBCjcGoiZzmpswGnMOOQCIDCGF7cw7YFpdyKPLh4
	 0n1GzUmku8F3tKjiYjUvaBE7kRKTAk0BrLnQmFQLfeGrwrtnrlJUHsGjeWd+gQp7Srw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795020496;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=SK3W3UG6ltOt2PIXcSaFIM54ISQIJmSLR248Phklzqg=;
	b=BKVxXk8Mj/DyyUvanAh6Q0/JUnOvxw8cjofmzWssuDSX2d2YpvNfUB2A6bM4JdYk8pP4
	 BV7j0sigLpFULpLl3pAKjcgXhN32KRF5tTo/4+UTHQsLaFzG20tkFY8KbmA4lznXRy95j
	 oH0P3cbP2Mc9ra3bAAHjaF6FLqgfAZFfGYfPFM8fNXkD6+ec6UGzEWHA44kxbW/dmTrHi
	 GXhIlb7LbvfarPRugR3fyx9Wy/fIryeCeEAQqlVvzr4Fqa9NWisT15Ex0evT63T3BNcei
	 DaHFJsoNMdaqaLOBJpxGgxZlac+6dTAb4bn1Iy8idnPtn6y0jhmpY1+CwdndJ3azmnQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vdo0OGl0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAE3A606A320;
	Wed, 18 Nov 2026 16:48:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vdo0OGl0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 397D61F000C4;
	Wed, 18 Nov 2026 16:48:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795020496;
	bh=SK3W3UG6ltOt2PIXcSaFIM54ISQIJmSLR248Phklzqg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vdo0OGl0XpHpCswg/H/ux4lNX2Ekjv7EnYCKiLE0ke78kWnLiyy61UWBhO2oGVbrI
	 WPp2qvxOAFQB/B96PnE6kVAuun03VSSZgfkq9mkoNQrWFO7v5ToAKgNX1fLDrSnvPC
	 yi7bU4QcumFqHFV8M9XoYT175RiUa1VZ92JOu6cE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Stephen Boyd <sboyd@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1921/2651] spmi: mtk-pmif: Add workaround for FSM lockup/error in read operation
Date: Wed, 18 Nov 2026 15:52:41 +0100
Message-ID: <20261118150355.902216215@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>

[ Upstream commit 84c72fc05f73df3473b3bfac89c0a7eae765513a ]

The SPMI PMIF in some SoCs like MT8196 is affected by a hardware
issue that makes the first read operation on each SID to fail as
the FSM locks up after sending the read command, and this happens
at least in the following conditions:
 - At boot, after bootloader handoff; and
 - At every suspend->resume cycle.

This critical bug may produce unwanted issues in regulator drivers
which may fail to set voltages, making the platform to end up in a
undervoltage or, a bit more critically, an overvoltage condition,
producing instability or ... worse.

In order to work around this issue, add a retry mechanism into the
pmif_spmi_read_cmd() callback which will resend the read command
up to 3 times in the following conditions:
 - Software Interface returns an error; or
 - Software Interface never gets in WFVLDCLR state.

As to avoid uselessly blocking for too much time, only during the
read-retry loop, the maximum SWINF polling time for each trial is
reduced to PMIF_TIMEOUT_US / 2: this was tested on multiple SoCs
and seems to always be enough, as when any read succeeds it will
always take less than 40ms.
In any case, this is still allowing 1.5 times the previous maximum
polling time, reaching a total maximum (for 3 retries) of 150ms.

Worst case testing that I performed saw a third retry only 3 times
out of ~100 reboots.

Fixes: 1f5be2d7f743 ("spmi: mtk-pmif: Add support for MT8196 SPMI Controller")
Signed-off-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spmi/spmi-mtk-pmif.c | 38 +++++++++++++++++++++++++++---------
 1 file changed, 29 insertions(+), 9 deletions(-)

diff --git a/drivers/spmi/spmi-mtk-pmif.c b/drivers/spmi/spmi-mtk-pmif.c
index 1048420b5afb6..61c916edaec4c 100644
--- a/drivers/spmi/spmi-mtk-pmif.c
+++ b/drivers/spmi/spmi-mtk-pmif.c
@@ -21,6 +21,7 @@
 #define SWINF_WFVLDCLR	0x06
 
 #define GET_SWINF(x)	(((x) >> 1) & 0x7)
+#define GET_SWINFERR(x) (((x) >> 18) & 0x1)
 
 #define PMIF_CMD_REG_0		0
 #define PMIF_CMD_REG		1
@@ -349,6 +350,7 @@ static int pmif_spmi_read_cmd(struct spmi_controller *ctrl, u8 opc, u8 sid,
 	struct pmif *arb = to_mtk_pmif(ctrl);
 	struct ch_reg *inf_reg;
 	int ret;
+	u8 retry = 0;
 	u32 data, cmd;
 	unsigned long flags;
 
@@ -385,17 +387,35 @@ static int pmif_spmi_read_cmd(struct spmi_controller *ctrl, u8 opc, u8 sid,
 		return ret;
 	}
 
-	/* Send the command. */
 	cmd = (opc << 30) | (sid << 24) | ((len - 1) << 16) | addr;
-	pmif_writel(arb, pbus, cmd, inf_reg->ch_send);
+	do {
+		/* Send the command. */
+		pmif_writel(arb, pbus, cmd, inf_reg->ch_send);
+
+		/*
+		 * Wait for Software Interface FSM state to be WFVLDCLR or to
+		 * return an error.
+		 *
+		 * If this is WFVLDCLR, read the data and clear the valid flag;
+		 * If error or timeout, retry for a maximum of 3 times as a
+		 * workaround for an hardware issue.
+		 */
+		ret = readl_poll_timeout_atomic(pbus->base + arb->data->regs[inf_reg->ch_sta],
+						data,
+						GET_SWINF(data) == SWINF_WFVLDCLR ||
+						GET_SWINFERR(data),
+						PMIF_DELAY_US, PMIF_TIMEOUT_US / 2);
+		if (ret < 0)
+			continue;
+
+		if (GET_SWINFERR(data)) {
+			ret = -EIO;
+			continue;
+		}
+
+		break;
+	} while (++retry < 3);
 
-	/*
-	 * Wait for Software Interface FSM state to be WFVLDCLR,
-	 * read the data and clear the valid flag.
-	 */
-	ret = readl_poll_timeout_atomic(pbus->base + arb->data->regs[inf_reg->ch_sta],
-					data, GET_SWINF(data) == SWINF_WFVLDCLR,
-					PMIF_DELAY_US, PMIF_TIMEOUT_US);
 	if (ret < 0) {
 		raw_spin_unlock_irqrestore(&pbus->lock, flags);
 		dev_err(&ctrl->dev, "failed to wait for SWINF_WFVLDCLR\n");
-- 
2.53.0



