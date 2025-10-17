Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3008F32C940;
	Fri, 17 Oct 2025 15:15:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760714127; cv=none; b=RdaHlVIUJWXJmZZRvnmf0aSNBQa646AbBO6o2vla5N6ueFxv3/UlVSmw3EhK4wLvnZCu5R0AEl8aQAfZik5RN9wELGc18U0Rkfr/NLgAm+6WaXTavu6H361YdooOjV+8RwYmaDMkRxQEa8p2iwMZHPcZIp0c9/sDRQPXUVv/t2s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760714127; c=relaxed/simple;
	bh=lv3BEcdxBzJiKpOQRON2w29mDI4Vz31QpaRa2iJETkc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QfAdG+5P0SPs5eevAPPhIuFNbC6uUlM1AcC2KI9852Okf0zwwe1+uoHPri9VJHVKU6qZrhCZzETbfPxsQxWCngpoZu+hTR927WeD+EqP/VQmI3mYHSy+zrAaVDWL8fAAJFq/+i/vgNZ1+191sDpkuQhG9XfNS4OKJb6hzfaq5RA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=m8FXN8mp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="m8FXN8mp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B36F2C4CEE7;
	Fri, 17 Oct 2025 15:15:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760714127;
	bh=lv3BEcdxBzJiKpOQRON2w29mDI4Vz31QpaRa2iJETkc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=m8FXN8mpk3XKGLB/xyuNlMkOdjMtkX8feSJeQX3W17gmzGbveN07xB+7JS8nUGO/l
	 z9bQK+Mt5GCDZJU7qsioh3dWoYRaiAZH8+n0m8lQpkoDCFOAKKXAq6PQJxtufRqRNf
	 vqJsib3pfzYsJuN7o2GVF+B1tZrp3np5bUIbkWBk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alok Tiwari <alok.a.tiwari@oracle.com>,
	Stephen Boyd <sboyd@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 037/277] clk: nxp: Fix pll0 rate check condition in LPC18xx CGU driver
Date: Fri, 17 Oct 2025 16:50:44 +0200
Message-ID: <20251017145148.503355126@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145147.138822285@linuxfoundation.org>
References: <20251017145147.138822285@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 30e0b283ca608..b9e204d63a972 100644
--- a/drivers/clk/nxp/clk-lpc18xx-cgu.c
+++ b/drivers/clk/nxp/clk-lpc18xx-cgu.c
@@ -381,7 +381,7 @@ static int lpc18xx_pll0_determine_rate(struct clk_hw *hw,
 	}
 
 	m = DIV_ROUND_UP_ULL(req->best_parent_rate, req->rate * 2);
-	if (m <= 0 && m > LPC18XX_PLL0_MSEL_MAX) {
+	if (m == 0 || m > LPC18XX_PLL0_MSEL_MAX) {
 		pr_warn("%s: unable to support rate %lu\n", __func__, req->rate);
 		return -EINVAL;
 	}
@@ -404,7 +404,7 @@ static int lpc18xx_pll0_set_rate(struct clk_hw *hw, unsigned long rate,
 	}
 
 	m = DIV_ROUND_UP_ULL(parent_rate, rate * 2);
-	if (m <= 0 && m > LPC18XX_PLL0_MSEL_MAX) {
+	if (m == 0 || m > LPC18XX_PLL0_MSEL_MAX) {
 		pr_warn("%s: unable to support rate %lu\n", __func__, rate);
 		return -EINVAL;
 	}
-- 
2.51.0



