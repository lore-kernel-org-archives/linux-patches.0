Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A2F81DFD1;
	Sun,  1 Sep 2024 16:52:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725209531; cv=none; b=u6DxOAued9oZUBlf+I3XYFLzAUz0Cl/w7SN8rBLItaGPJpa0Fb2GBd3h7kCCSuJZosq/SmhNGBeDppeplDraHsrCNHg1GinJHiwL2ddth7T2KGkyllvQktBegqQoPl+5Ln5JJBzEac6y4v3bcH8aa82hB4uUPP2d1ZZFCkCW0vc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725209531; c=relaxed/simple;
	bh=/ttphmw1VhTCySoyiIj7Dcw6u+Ds5uEnVeD3w9E/KjQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T+m8CjJo+uuQBBg/J94/BJgZORaLz4EwO+z0LPCA/7tiQLOecEI97qaS+pCgcjXp/Yc3ynTLkthHRB/x4lZISIKq5Bcp/JZe+AZbwBaPlC15WPdGawGemGeGTBUpf1qgVcKuP7Emuj70PoJMM2VlZGxJfHDX9qi630YG9Nnmxs8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2cNeKM/7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2cNeKM/7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE13EC4CEC3;
	Sun,  1 Sep 2024 16:52:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725209531;
	bh=/ttphmw1VhTCySoyiIj7Dcw6u+Ds5uEnVeD3w9E/KjQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2cNeKM/7zHbOEIHlbgotkoDiLlbSoODsuPmEx+tA0zhNCXoqdvWnGhrVdcLS/bjuC
	 xf3dEGuDZOcIHAOVsr3AAAy5x3VcRG9Q02caQhxQAnuC3R5drHTNRRhEvadZj4c4nd
	 yXLCPNwDivFVyv6XBvUMBZ3ZBHrrH/7IL1gZozj0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wolfram Sang <wsa+renesas@sang-engineering.com>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Wolfram Sang <wsa@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 034/151] i2c: riic: avoid potential division by zero
Date: Sun,  1 Sep 2024 18:16:34 +0200
Message-ID: <20240901160815.383547677@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160814.090297276@linuxfoundation.org>
References: <20240901160814.090297276@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wolfram Sang <wsa+renesas@sang-engineering.com>

[ Upstream commit 7890fce6201aed46d3576e3d641f9ee5c1f0e16f ]

Value comes from DT, so it could be 0. Unlikely, but could be.

Signed-off-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Wolfram Sang <wsa@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/busses/i2c-riic.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/i2c/busses/i2c-riic.c b/drivers/i2c/busses/i2c-riic.c
index 4eccc0f69861f..d8f252c4caf2b 100644
--- a/drivers/i2c/busses/i2c-riic.c
+++ b/drivers/i2c/busses/i2c-riic.c
@@ -312,7 +312,7 @@ static int riic_init_hw(struct riic_dev *riic, struct i2c_timings *t)
 	 * frequency with only 62 clock ticks max (31 high, 31 low).
 	 * Aim for a duty of 60% LOW, 40% HIGH.
 	 */
-	total_ticks = DIV_ROUND_UP(rate, t->bus_freq_hz);
+	total_ticks = DIV_ROUND_UP(rate, t->bus_freq_hz ?: 1);
 
 	for (cks = 0; cks < 7; cks++) {
 		/*
-- 
2.43.0



