Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E68B253951;
	Tue, 11 Nov 2025 01:39:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762825184; cv=none; b=CFTjV8SMs8WHWf0OU254ntIaDTSfP1zenWLrAmPRdtZnBg42IeHjiB5c7FIRPMiBrSTJljGAnliGL60CoinNXBBTd68/TkLoMavCdUi64zqHjCjQKvmRf4B6CCLjPTlwEveWjH7/H1CtWfl1PQ4cuUWrlDj8blKnCdveq0BckDk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762825184; c=relaxed/simple;
	bh=fsFc7w2WnvclryUMnPeqlqLjREDN02NZIB5k1XzTAfY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OetKatJ0UsLXq9LPl7gVdgkkPWfvt1Z/F6H+Ce9SBdeqZdYibYjhsPI8SzEGNC/sEtfLUyiTH5Y2jnQ7Or00IzdrdjEBgFkOJKWK1yJXybkg8cE7RaMMpac3Qql827PXx1TQdlZf0bPI4679gaH5QytJhSusH+DqaKk5LGgulGk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rS1y8o6V; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rS1y8o6V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B08D4C116D0;
	Tue, 11 Nov 2025 01:39:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762825184;
	bh=fsFc7w2WnvclryUMnPeqlqLjREDN02NZIB5k1XzTAfY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rS1y8o6VLn/74qXjP5gdbbDuMLhIEBQBqSFS5DMhesA2jgeyX9u5aXWXroWdXWO/0
	 OX8sEMi0UO5BgatpHDR37ad5+cTIMOiSkGLEnSNC73CO5+pftVKnwxeXWfuEh3F+fq
	 CwW/TXf+4VKjS0ycT5EAJHyLfgetMVSiQ9Sfuqss=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Tommaso Merciai <tommaso.merciai.xr@bp.renesas.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 695/849] clk: renesas: rzv2h: Re-assert reset on deassert timeout
Date: Tue, 11 Nov 2025 09:44:25 +0900
Message-ID: <20251111004553.234369586@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

From: Tommaso Merciai <tommaso.merciai.xr@bp.renesas.com>

[ Upstream commit f8c002165ca27d95d3d15e865dd0a47c0a1b14dd ]

Prevent issues during reset deassertion by re-asserting the reset if a
timeout occurs when trying to deassert. This ensures the reset line is in a
known state and improves reliability for hardware that may not immediately
clear the reset monitor bit.

Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Tommaso Merciai <tommaso.merciai.xr@bp.renesas.com>
Link: https://lore.kernel.org/20250903082757.115778-4-tommaso.merciai.xr@bp.renesas.com
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/renesas/rzv2h-cpg.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/drivers/clk/renesas/rzv2h-cpg.c b/drivers/clk/renesas/rzv2h-cpg.c
index f468afbb54e2d..5dfe660d13422 100644
--- a/drivers/clk/renesas/rzv2h-cpg.c
+++ b/drivers/clk/renesas/rzv2h-cpg.c
@@ -864,6 +864,7 @@ static int __rzv2h_cpg_assert(struct reset_controller_dev *rcdev,
 	u32 mask = BIT(priv->resets[id].reset_bit);
 	u8 monbit = priv->resets[id].mon_bit;
 	u32 value = mask << 16;
+	int ret;
 
 	dev_dbg(rcdev->dev, "%s id:%ld offset:0x%x\n",
 		assert ? "assert" : "deassert", id, reg);
@@ -875,9 +876,15 @@ static int __rzv2h_cpg_assert(struct reset_controller_dev *rcdev,
 	reg = GET_RST_MON_OFFSET(priv->resets[id].mon_index);
 	mask = BIT(monbit);
 
-	return readl_poll_timeout_atomic(priv->base + reg, value,
-					 assert ? (value & mask) : !(value & mask),
-					 10, 200);
+	ret = readl_poll_timeout_atomic(priv->base + reg, value,
+					assert ? (value & mask) : !(value & mask),
+					10, 200);
+	if (ret && !assert) {
+		value = mask << 16;
+		writel(value, priv->base + GET_RST_OFFSET(priv->resets[id].reset_index));
+	}
+
+	return ret;
 }
 
 static int rzv2h_cpg_assert(struct reset_controller_dev *rcdev,
-- 
2.51.0



