Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83A5C35FF58;
	Tue, 16 Dec 2025 12:08:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765886880; cv=none; b=NfA0r8qJHqymx+mnqoPO2F8IZiKHJPg6PKBvPNr6S8ezU7ypBbT4hU6etPcyWe6tA1h6yIo6nWR/x3ywamvhyT0MpShC/l2QyVLVokq08Y4rH3U0WvPJN2SGhtvMJfT+qpJM2o5LZ7UY9p/YDFAfTwngslzL3ts9ZY+7VpIL1wY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765886880; c=relaxed/simple;
	bh=8JUVcza+tSbSqQiuSsVq+YJcR0KHijgE/6S6GH6Fexo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r/FmqNh4UjAmsz44dxT5OQlFavuO3//XcW/a/9qRYNtCrdMxumLfGdVDzU3pT1duECRWdgWx+NyeCLN9I89e2qrMDnMiiOTsL9Fvio5wHW8yx05ykHnTBtMHLIbsKPdds8UUv6k0gvB3diNYcASasQPzKp4oKN9g1RtVn/qJmOo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jf9ouohI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jf9ouohI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA621C4CEF1;
	Tue, 16 Dec 2025 12:07:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765886880;
	bh=8JUVcza+tSbSqQiuSsVq+YJcR0KHijgE/6S6GH6Fexo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jf9ouohIA/PapTzFYpXv/pdz9I1g64NoKej6CRnQAmEIXp1wglTCqqMNsBc9WU3jS
	 CgZ057w9k4BzIk5JLn1bvsqlAukkUXKXPe5bHPfwwzpLCIokJkYXdJQVd2K5brMrs9
	 zvUQkJxZZcdkYP4qsgTKrMPyBSXhQ93Hqx8Yx6Vk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marek Vasut <marek.vasut+renesas@mailbox.org>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 028/614] clk: renesas: cpg-mssr: Add missing 1ms delay into reset toggle callback
Date: Tue, 16 Dec 2025 12:06:35 +0100
Message-ID: <20251216111402.328852442@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111401.280873349@linuxfoundation.org>
References: <20251216111401.280873349@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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



