Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F029527A900;
	Tue, 27 May 2025 16:59:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748365196; cv=none; b=iCd+5sdhqeVThua1cDJfAyntAlX6DIoUjDWugIMauA4FKklLqqS9VAkRkagJegTO90I01Z6kuspuWRq7QAP+CqFUmULOQCjqdACvDUBXfjCpj3dfZnqkN5fke8yS62mY8lzmG/my3GtJQyGf/lunw0LeR9VRgm7TX+ZoJG65z+w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748365196; c=relaxed/simple;
	bh=nHzzgRTioIicmeTifCzjLXoxGITvzt4XiVvEZC3mdYI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EmNnQjKUSOo3gRNVbQCKc1mmoSaI6mK3I00/KXpH0CHv5D9xLY3SQ7wrxytz5q2sV+9N9jjqugNQOB3AZchYD+DpaGUuhU4LGO2QYn1PKBNuK/TP+WBxaSpPGWu/0bzWrgKlQvN3nLPK3M57v6VADxq5bFYh3hMvpMcIOZQbejQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CDnzNQRJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CDnzNQRJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 232F3C4CEEF;
	Tue, 27 May 2025 16:59:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748365195;
	bh=nHzzgRTioIicmeTifCzjLXoxGITvzt4XiVvEZC3mdYI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CDnzNQRJFeluNAf1BT17LEs33EPmvfZxYUXo35pqVp7R7oI/wasnnzUPv8p7dKx7N
	 3e7wsuZRvRPPumbBnliWYFVXW1GyBuc7+w++eKwintUWyANkTLJUSLWMhCG08E4vLW
	 fA+yZTEun7ymkMxcez7EWCeSmhwGKM/dd6bmG5cU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthias Fend <matthias.fend@emfend.at>,
	Marco Felsch <m.felsch@pengutronix.de>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 297/626] media: tc358746: improve calculation of the D-PHY timing registers
Date: Tue, 27 May 2025 18:23:10 +0200
Message-ID: <20250527162457.099217631@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162445.028718347@linuxfoundation.org>
References: <20250527162445.028718347@linuxfoundation.org>
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

From: Matthias Fend <matthias.fend@emfend.at>

[ Upstream commit 78d7265e2e1ce349e7f3c6a085f2b66d7b73f4ca ]

When calculating D-PHY registers, using data rates that are not multiples
of 16 can lead to precision loss in division operations. This can result in
register values that produce timing violations against the MIPI standard.

An example:
cfg->hs_clk_rate = 294MHz
hf_clk = 18

If the desired value in cfg->init is 100us, which is the minimum allowed
value, then the LINEINITCNT register is calculated as 1799. But since the
actual clock is 18.375MHz instead of 18MHz, this setting results in a time
that is shorter than 100us and thus violates the standard. The correct
value for LINEINITCNT would be 1837.

Improve the precision of calculations by using Hz instead of MHz as unit.

Signed-off-by: Matthias Fend <matthias.fend@emfend.at>
Reviewed-by: Marco Felsch <m.felsch@pengutronix.de>
Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/i2c/tc358746.c | 19 +++++++------------
 1 file changed, 7 insertions(+), 12 deletions(-)

diff --git a/drivers/media/i2c/tc358746.c b/drivers/media/i2c/tc358746.c
index 389582420ba78..048a1a381b333 100644
--- a/drivers/media/i2c/tc358746.c
+++ b/drivers/media/i2c/tc358746.c
@@ -460,24 +460,20 @@ static int tc358746_apply_misc_config(struct tc358746 *tc358746)
 	return err;
 }
 
-/* Use MHz as base so the div needs no u64 */
-static u32 tc358746_cfg_to_cnt(unsigned int cfg_val,
-			       unsigned int clk_mhz,
-			       unsigned int time_base)
+static u32 tc358746_cfg_to_cnt(unsigned long cfg_val, unsigned long clk_hz,
+			       unsigned long long time_base)
 {
-	return DIV_ROUND_UP(cfg_val * clk_mhz, time_base);
+	return div64_u64((u64)cfg_val * clk_hz + time_base - 1, time_base);
 }
 
-static u32 tc358746_ps_to_cnt(unsigned int cfg_val,
-			      unsigned int clk_mhz)
+static u32 tc358746_ps_to_cnt(unsigned long cfg_val, unsigned long clk_hz)
 {
-	return tc358746_cfg_to_cnt(cfg_val, clk_mhz, USEC_PER_SEC);
+	return tc358746_cfg_to_cnt(cfg_val, clk_hz, PSEC_PER_SEC);
 }
 
-static u32 tc358746_us_to_cnt(unsigned int cfg_val,
-			      unsigned int clk_mhz)
+static u32 tc358746_us_to_cnt(unsigned long cfg_val, unsigned long clk_hz)
 {
-	return tc358746_cfg_to_cnt(cfg_val, clk_mhz, 1);
+	return tc358746_cfg_to_cnt(cfg_val, clk_hz, USEC_PER_SEC);
 }
 
 static int tc358746_apply_dphy_config(struct tc358746 *tc358746)
@@ -492,7 +488,6 @@ static int tc358746_apply_dphy_config(struct tc358746 *tc358746)
 
 	/* The hs_byte_clk is also called SYSCLK in the excel sheet */
 	hs_byte_clk = cfg->hs_clk_rate / 8;
-	hs_byte_clk /= HZ_PER_MHZ;
 	hf_clk = hs_byte_clk / 2;
 
 	val = tc358746_us_to_cnt(cfg->init, hf_clk) - 1;
-- 
2.39.5



