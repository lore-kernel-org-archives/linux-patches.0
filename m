Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26D51345730;
	Tue, 16 Dec 2025 11:37:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765885051; cv=none; b=d2ap0dhpj72HmRrjZiyzxKn8X22HHOOSa9qbRqn1V1LLRAIp/rkIPLuG9LzSeBOT2N9doMqzga2JRTo79IBe3fqUG+J7tDVfcIv5k77dEMLUb/mHFHpgYyBuCbpaaU0U7fJhPwoEq0M0CDJscJYU4Jo382o4aQCew6B5peyCIvE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765885051; c=relaxed/simple;
	bh=1NV5hE/ySdBMODaenz83xie4dpmGuyULzsm6+kG7FKE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UZnKSHiMcoKOdxE0GWq5Xoxdnp7TQTWHaMJpqnPV6Xc9KFaMZXiJ0LHjirwE2OYqB5Zjdr1rBvRR7YNMVlSqb2RbhlXMOF/5M6qLMt9aWvJNUzUq/fn1He9vG2bSKG/MdwZPmuFneKqkppfkqw3fUJe4C6JnXh7Ed3ZwWzl82OE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xcP4C6wR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xcP4C6wR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DEF3C4CEF1;
	Tue, 16 Dec 2025 11:37:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765885051;
	bh=1NV5hE/ySdBMODaenz83xie4dpmGuyULzsm6+kG7FKE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xcP4C6wRzHJ4JaFXfNPdTOpmW3QRkKbBm0qX/8DVRLd7vCVB0u1wzpcC+cIhxkv+k
	 Ae7NiB1HInkmPWqf5lSdHicZPXbqh1HuOyR300T6MZxhBVfcfVFtE9boBJNxCzydcz
	 KGdChb9WpCJoRJ5Xd6qghE+03289LidodNQB+5fk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marek Vasut <marek.vasut+renesas@mailbox.org>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 023/507] clk: renesas: cpg-mssr: Add missing 1ms delay into reset toggle callback
Date: Tue, 16 Dec 2025 12:07:44 +0100
Message-ID: <20251216111346.377230158@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111345.522190956@linuxfoundation.org>
References: <20251216111345.522190956@linuxfoundation.org>
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

From: Marek Vasut <marek.vasut+renesas@mailbox.org>

[ Upstream commit 62abfd7bedc2b3d86d4209a4146f9d2b5ae21fab ]

R-Car V4H Reference Manual R19UH0186EJ0130 Rev.1.30 Apr. 21, 2025 page
583 Figure 9.3.1(a) Software Reset flow (A) as well as flow (B) / (C)
indicate after reset has been asserted by writing a matching reset bit
into register SRCR, it is mandatory to wait 1ms.

This 1ms delay is documented on R-Car V4H and V4M, it is currently
unclear whether S4 is affected as well.  This patch does apply the extra
delay on R-Car S4 as well.

Fix the reset driver to respect the additional delay when toggling
resets.  Drivers which use separate reset_control_(de)assert() must
assure matching delay in their driver code.

Fixes: 0ab55cf18341 ("clk: renesas: cpg-mssr: Add support for R-Car V4H")
Signed-off-by: Marek Vasut <marek.vasut+renesas@mailbox.org>
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
Link: https://patch.msgid.link/20250918030552.331389-1-marek.vasut+renesas@mailbox.org
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/renesas/renesas-cpg-mssr.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/clk/renesas/renesas-cpg-mssr.c b/drivers/clk/renesas/renesas-cpg-mssr.c
index de1cf7ba45b78..7063d896249ea 100644
--- a/drivers/clk/renesas/renesas-cpg-mssr.c
+++ b/drivers/clk/renesas/renesas-cpg-mssr.c
@@ -689,8 +689,15 @@ static int cpg_mssr_reset(struct reset_controller_dev *rcdev,
 	/* Reset module */
 	writel(bitmask, priv->pub.base0 + priv->reset_regs[reg]);
 
-	/* Wait for at least one cycle of the RCLK clock (@ ca. 32 kHz) */
-	udelay(35);
+	/*
+	 * On R-Car Gen4, delay after SRCR has been written is 1ms.
+	 * On older SoCs, delay after SRCR has been written is 35us
+	 * (one cycle of the RCLK clock @ ca. 32 kHz).
+	 */
+	if (priv->reg_layout == CLK_REG_LAYOUT_RCAR_GEN4)
+		usleep_range(1000, 2000);
+	else
+		usleep_range(35, 1000);
 
 	/* Release module from reset state */
 	writel(bitmask, priv->pub.base0 + priv->reset_clear_regs[reg]);
-- 
2.51.0



