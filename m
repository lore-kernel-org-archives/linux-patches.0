Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D0C7310627;
	Mon, 27 Oct 2025 18:42:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761590543; cv=none; b=meJ+kUq36qtr0QRSe9LxXq1hQd9HxcWd0Ytnq4es7OmYqqPtnyXcD8tO0EDiDQHWMP5EDnK2D+t+PsvR/2DW/1CC2sApQTvANUzYwmiWMHyyl5PxP3TZlzvyHi3yHmtPkvF+67/ulB0zI5KucxdSTYz8wO1n/818hLEaZBQcQik=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761590543; c=relaxed/simple;
	bh=EhIyY9mP25t1FBwlmulm/V4/jgF59Chn3X6pTnO1Uzg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cIs6yT+5HiVlr4nsT6wLVhT82KRo8/c8Us8ijOj+qkDdSkvravJ3T/AU1BhqdXXirAywHeZ+oz40ZDpo5O0Vcl3w1npaVbctxCNlhngpdJWIKIuGZD4HHoKliowpzFZHjxEzfih2WDFZ8LndlqJlwoFv76J2W68VXUHmF2ugnSQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jqesFtzX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jqesFtzX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C53A2C4CEF1;
	Mon, 27 Oct 2025 18:42:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761590543;
	bh=EhIyY9mP25t1FBwlmulm/V4/jgF59Chn3X6pTnO1Uzg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jqesFtzXmosTxzPk3xBEFS+8dXfogincPPBb2d+weHR2glMljggxFRSYKqXThH+W3
	 6z6IVoTDHZo0WMUsWFqKcIPU1LGo3Bx5dVPVIlNnOU+3hQXvbnZiIa1psvGLfBO5wE
	 z8XDK+E8lQLa7o+hzQFnI89TdmeD/4uzzIoVXcLI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alok Tiwari <alok.a.tiwari@oracle.com>,
	Stephen Boyd <sboyd@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 084/224] clk: nxp: Fix pll0 rate check condition in LPC18xx CGU driver
Date: Mon, 27 Oct 2025 19:33:50 +0100
Message-ID: <20251027183511.243369466@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183508.963233542@linuxfoundation.org>
References: <20251027183508.963233542@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alok Tiwari <alok.a.tiwari@oracle.com>

[ Upstream commit 1624dead9a4d288a594fdf19735ebfe4bb567cb8 ]

The conditional check for the PLL0 multiplier 'm' used a logical AND
instead of OR, making the range check ineffective. This patch replaces
&& with || to correctly reject invalid values of 'm' that are either
less than or equal to 0 or greater than LPC18XX_PLL0_MSEL_MAX.

This ensures proper bounds checking during clk rate setting and rounding.

Fixes: b04e0b8fd544 ("clk: add lpc18xx cgu clk driver")
Signed-off-by: Alok Tiwari <alok.a.tiwari@oracle.com>
[sboyd@kernel.org: 'm' is unsigned so remove < condition]
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/nxp/clk-lpc18xx-cgu.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/clk/nxp/clk-lpc18xx-cgu.c b/drivers/clk/nxp/clk-lpc18xx-cgu.c
index 44e07a3c253b9..ab8741fe57c99 100644
--- a/drivers/clk/nxp/clk-lpc18xx-cgu.c
+++ b/drivers/clk/nxp/clk-lpc18xx-cgu.c
@@ -385,7 +385,7 @@ static int lpc18xx_pll0_determine_rate(struct clk_hw *hw,
 	}
 
 	m = DIV_ROUND_UP_ULL(req->best_parent_rate, req->rate * 2);
-	if (m <= 0 && m > LPC18XX_PLL0_MSEL_MAX) {
+	if (m == 0 || m > LPC18XX_PLL0_MSEL_MAX) {
 		pr_warn("%s: unable to support rate %lu\n", __func__, req->rate);
 		return -EINVAL;
 	}
@@ -408,7 +408,7 @@ static int lpc18xx_pll0_set_rate(struct clk_hw *hw, unsigned long rate,
 	}
 
 	m = DIV_ROUND_UP_ULL(parent_rate, rate * 2);
-	if (m <= 0 && m > LPC18XX_PLL0_MSEL_MAX) {
+	if (m == 0 || m > LPC18XX_PLL0_MSEL_MAX) {
 		pr_warn("%s: unable to support rate %lu\n", __func__, rate);
 		return -EINVAL;
 	}
-- 
2.51.0



