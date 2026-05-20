Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8C8D3F39D1;
	Wed, 20 May 2026 17:07:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779296866; cv=none; b=jsRhTCUc5OpCqVKEsZq8FTxYJsJQvUMPCj/hC5XLhP5mLh4MKMATXiWI7SB/2yp+J24cS8YdYcvtJZJK2EwTRp0fdDxepmj+Evy0CmxBBqRf79yotLy2a5d7K/5Hyw1jLc0qU5zjBCoFwRUxyh+6MS306tYDdGSViikC9sCIrzY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779296866; c=relaxed/simple;
	bh=V2HYv1y9Mm6Mvt3onBCsqOv+yZsdcvp5/CokPWrbMR0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gdyN7NSbzuvTC2oNt+hr7X74wGKIPXWUKPIVU+3svZq5xFKKDMlK8gUSXuwBCIGUCsIlzBXcTa8u3aK46WZeESj3fnjcQdwoxZdMXfAAFMtj+OiFUHpnF9GtiwtYfzdfttOHcu62Ef6raYSF4ed+HFPNAsjk5GkeIrkJ+LUal4s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lJ4D08cu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lJ4D08cu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 026A11F000E9;
	Wed, 20 May 2026 17:07:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779296864;
	bh=z1ftE5X7/K1no3GTL1okX1D+twUN7j5Y1IWu4uxV8XM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lJ4D08cut6PrLeDdxX010Cu9w0aRyAvjfD7EMc8dQBzD38lqo+59Pfw4TIBPCRUuI
	 1MvoM5woszya+xWVfxv8PmWWdY30ZByP4R6vfsVnbLers+q6+pKSj3g+gGMAV8IQKd
	 phYzWjYOZe8Xvrhjxjobed9XQ29o3Kq4tkFEKB4w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John Madieu <john.madieu.xa@bp.renesas.com>,
	Biju Das <biju.das.jz@bp.renesas.com>,
	Cosmin Tanislav <cosmin-gabriel.tanislav.xa@renesas.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0910/1146] spi: rzv2h-rspi: Fix silent failure in clock setup error path
Date: Wed, 20 May 2026 18:19:20 +0200
Message-ID: <20260520162208.834735543@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: John Madieu <john.madieu.xa@bp.renesas.com>

[ Upstream commit 54900126ae0a2671f8790a7f95706b9ea95fac4e ]

rzv2h_rspi_setup_clock() is declared to return u32 but returns -EINVAL
when no valid clock parameters are found. Cast to u32, -EINVAL becomes
0xffffffea, which is a non-zero value. The caller in
rzv2h_rspi_prepare_message() guards against failure with:

	rspi->freq = rzv2h_rspi_setup_clock(rspi, speed_hz);
	if (!rspi->freq)
		return -EINVAL;

Because 0xffffffea is non-zero, the check is bypassed and the controller
proceeds to program SPBR/SPCMD with stale values, leading to an unknown
bit rate.

Return 0 on the failed-search path, consistent with the existing
clk_set_rate() failure path which already returns 0.

Fixes: 77d931584dd3 ("spi: rzv2h-rspi: make transfer clock rate finding chip-specific")
Signed-off-by: John Madieu <john.madieu.xa@bp.renesas.com>
Reviewed-by: Biju Das <biju.das.jz@bp.renesas.com>
Reviewed-by: Cosmin Tanislav <cosmin-gabriel.tanislav.xa@renesas.com>
Link: https://patch.msgid.link/20260425024725.2393632-1-john.madieu.xa@bp.renesas.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-rzv2h-rspi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/spi/spi-rzv2h-rspi.c b/drivers/spi/spi-rzv2h-rspi.c
index d6b9b558932dd..53c44799fab71 100644
--- a/drivers/spi/spi-rzv2h-rspi.c
+++ b/drivers/spi/spi-rzv2h-rspi.c
@@ -581,7 +581,7 @@ static u32 rzv2h_rspi_setup_clock(struct rzv2h_rspi_priv *rspi, u32 hz)
 					   RSPI_SPBR_SPR_MAX, &best_clock);
 
 	if (!best_clock.clk_rate)
-		return -EINVAL;
+		return 0;
 
 	ret = clk_set_rate(best_clock.clk, best_clock.clk_rate);
 	if (ret)
-- 
2.53.0



