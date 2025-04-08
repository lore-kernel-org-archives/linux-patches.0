Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 684B726A08F;
	Tue,  8 Apr 2025 12:15:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744114533; cv=none; b=EE7wKO6tgBWg7MBe/Ze4p0pNk3i/VGY7vS3DxH3cVVrhXQI1YlIY47u8uWyIx5l+iJwP78DzuYJdblq2VYxZllwgfLsFiRHapm6/GpqLaj6thvUiYQ3yaeBgVG9GR4rDPL9WdV7GHvqkJBS+/0lm6roMSl6I13GoKNKxdCEPpmU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744114533; c=relaxed/simple;
	bh=fzqdE+PYgISeJqq5FKWji1uAj24op+ahM6TTudPBfwU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ichrPSaIexxcY5l2ym3MI3Nf4NIZOx35a3nsMgzAqPce9ZgwDxuVEVERWU/1F35F1CM3nocXmRl8XXl7z/FojApctDv/5KOhukCzLm3VWm47nPXnp/G8+kEiwYD7E/kTMPFFmZCSQkptRLneShBnVReIiO+Ykoijal1Uv2jjcqI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vt1i3C0Q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vt1i3C0Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F092CC4CEE5;
	Tue,  8 Apr 2025 12:15:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744114533;
	bh=fzqdE+PYgISeJqq5FKWji1uAj24op+ahM6TTudPBfwU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vt1i3C0QgwLgCmTvtl1qhUPzj6gZTrtssLOZh7IheNFcEoJHiQFzWMcrNwBY2g7g3
	 bC7FbR8LxWtlNA+vd+k042G2Tn4wFgPwt94BW+UvdvQQ4Y5JOD11XhU5fD1QmBKMxd
	 DEi1TeAjHL1lsK/qDxoMIvs/TnuncE2UIkRACr+w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Will McVicker <willmcvicker@google.com>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 143/499] clk: samsung: Fix UBSAN panic in samsung_clk_init()
Date: Tue,  8 Apr 2025 12:45:55 +0200
Message-ID: <20250408104854.755291598@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104851.256868745@linuxfoundation.org>
References: <20250408104851.256868745@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Will McVicker <willmcvicker@google.com>

[ Upstream commit d19d7345a7bcdb083b65568a11b11adffe0687af ]

With UBSAN_ARRAY_BOUNDS=y, I'm hitting the below panic due to
dereferencing `ctx->clk_data.hws` before setting
`ctx->clk_data.num = nr_clks`. Move that up to fix the crash.

  UBSAN: array index out of bounds: 00000000f2005512 [#1] PREEMPT SMP
  <snip>
  Call trace:
   samsung_clk_init+0x110/0x124 (P)
   samsung_clk_init+0x48/0x124 (L)
   samsung_cmu_register_one+0x3c/0xa0
   exynos_arm64_register_cmu+0x54/0x64
   __gs101_cmu_top_of_clk_init_declare+0x28/0x60
   ...

Fixes: e620a1e061c4 ("drivers/clk: convert VL struct to struct_size")
Signed-off-by: Will McVicker <willmcvicker@google.com>
Link: https://lore.kernel.org/r/20250212183253.509771-1-willmcvicker@google.com
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/samsung/clk.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/clk/samsung/clk.c b/drivers/clk/samsung/clk.c
index 283c523763e6b..8d440cf56bd45 100644
--- a/drivers/clk/samsung/clk.c
+++ b/drivers/clk/samsung/clk.c
@@ -74,12 +74,12 @@ struct samsung_clk_provider * __init samsung_clk_init(struct device *dev,
 	if (!ctx)
 		panic("could not allocate clock provider context.\n");
 
+	ctx->clk_data.num = nr_clks;
 	for (i = 0; i < nr_clks; ++i)
 		ctx->clk_data.hws[i] = ERR_PTR(-ENOENT);
 
 	ctx->dev = dev;
 	ctx->reg_base = base;
-	ctx->clk_data.num = nr_clks;
 	spin_lock_init(&ctx->lock);
 
 	return ctx;
-- 
2.39.5



