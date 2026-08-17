Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82CE63EDAB8;
	Mon, 17 Aug 2026 13:40:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786974022; cv=none; b=UWQFVfnTya8qouhtIQTt3+N9iZI6DdtNTyJnJvEdFsagqDOvInPNTi2eisF9FXawOe4q6ty1KdrpQc63PSfYwDxOboAF0r+E5eZn5Leb0QQsrIZndcmwlOqcgkaqsee0D5an9eux7wxCeOm4gm5Si9ikSHTjAjJOy0xYlu/MxNM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786974022; c=relaxed/simple;
	bh=PhXZlyzaWuZ373VjolGptz1V1t/Ghwect2Px/eciTqo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nrcHFLHr4aS6omxwWTn5fftbjbgMYS6mgfgPjjiI1vsbuneuz4oZuyLtV5yuTm/sH3lVRh5yhfKPe2B/oO3YTjTbCV/mlxKqPPL3/fv1DH7h+N5ZLMCtu2oA9lZnjmLLSAC3a4LLwU/WNWMGAkMFfaxe7A2vt33/7yoxN7FYsYg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XMzj6n0p; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XMzj6n0p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D75F1F00A3A;
	Mon, 17 Aug 2026 13:40:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786974020;
	bh=9GnYvIaZ5CdhG+Q/hexAfWN97+DN11LyIWHZJwuh3Mk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XMzj6n0pc73v99KewODVCqZXZoRJboQFtFOqFOrGiMXSveyhtHvmXFBgIxSg/vYhj
	 /HUqCCVFxyA2vCSs9wc8zPgqItmgNopOOhkoorycN/WBw5WUyhoAfO8Yy3/gn8k8ch
	 US7yuGOCRlNOCODpsGUqXx0KDXomZ3SpoB7cQx7U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Babanpreet Singh <bbnpreetsingh@gmail.com>,
	Joshua Crofts <joshua.crofts1@gmail.com>,
	William Breathitt Gray <wbg@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 061/271] counter: microchip-tcb-capture: Fix DT channel validation
Date: Mon, 17 Aug 2026 15:29:46 +0200
Message-ID: <20260817132539.255551955@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132536.752504388@linuxfoundation.org>
References: <20260817132536.752504388@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Babanpreet Singh <bbnpreetsingh@gmail.com>

[ Upstream commit f1a3a9946aab611dd2200c01ff122f64b033dad2 ]

mchp_tc_probe() reads the devicetree "reg" cell - a u32, per the API
contract of of_property_read_u32_index() - into a signed int, so the
bounds check "channel > 2" fails to reject cell values at or above
0x80000000: reinterpreted as a negative int, they compare below 2 and
pass validation.

A malformed devicetree can therefore drive a negative channel into the
ATMEL_TC_REG() offset arithmetic, making the driver access syscon
regmap offsets outside the TC block's register window, and into the
"t%d_clk" clock-name formatting, where it truncates clk_name (sized
for "t0_clk".."t2_clk").

Declare channel as u32, matching the API contract; the unsigned
comparison then rejects everything except channels 0..2. Adjust the
format specifier to %u accordingly, which also resolves the W=1
warning that exposed the gap:

  microchip-tcb-capture.c:520:56: warning: '%d' directive output may
    be truncated writing between 1 and 11 bytes into a region of size
    6 [-Wformat-truncation=]
  note: directive argument in the range [-2147483648, 2]

No behavior change for well-formed devicetrees: channels 0..2 take
identical paths before and after.

Fixes: 106b104137fd ("counter: Add microchip TCB capture counter")
Assisted-by: Claude:claude-fable-5 [gcc W=1]
Signed-off-by: Babanpreet Singh <bbnpreetsingh@gmail.com>
Reviewed-by: Joshua Crofts <joshua.crofts1@gmail.com>
Link: https://lore.kernel.org/r/20260714042910.7-1-bbnpreetsingh@gmail.com
Signed-off-by: William Breathitt Gray <wbg@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/counter/microchip-tcb-capture.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/counter/microchip-tcb-capture.c b/drivers/counter/microchip-tcb-capture.c
index 19d457ae4c3bb..e53a8390756b7 100644
--- a/drivers/counter/microchip-tcb-capture.c
+++ b/drivers/counter/microchip-tcb-capture.c
@@ -483,7 +483,7 @@ static int mchp_tc_probe(struct platform_device *pdev)
 	char clk_name[7];
 	struct regmap *regmap;
 	struct clk *clk[3];
-	int channel;
+	u32 channel;
 	int ret, i;
 
 	counter = devm_counter_alloc(&pdev->dev, sizeof(*priv));
@@ -517,7 +517,7 @@ static int mchp_tc_probe(struct platform_device *pdev)
 
 		priv->channel[i] = channel;
 
-		snprintf(clk_name, sizeof(clk_name), "t%d_clk", channel);
+		snprintf(clk_name, sizeof(clk_name), "t%u_clk", channel);
 
 		clk[i] = of_clk_get_by_name(np->parent, clk_name);
 		if (IS_ERR(clk[i])) {
-- 
2.53.0



