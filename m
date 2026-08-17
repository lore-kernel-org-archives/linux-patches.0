Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AD2142EEDD;
	Mon, 17 Aug 2026 14:53:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786978394; cv=none; b=D4zAY4NDSg7rHCnvVpuJ5ydIC/Vx2hwa1ZC0ofrp9HuHl19zOVl0QjOT88/E95YtVGcO5TTwuk1OjzYmqVu8JlXiS4T1t2P+46r4AIsXCywzmFb7eEWyXR4f1Rz4ZsEN9WVWvvANaDB10GO1ApRG2y3kqt6SWeuEpdBt1d81RZI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786978394; c=relaxed/simple;
	bh=YwKtMya9OrrAG0c0FvQehCvjsdcEZQos79s1TkgzosY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Rtd/AwhOFZvT+IRgk/LTK47UwHA/lpKLUOl+ONxgjNcC/bVcp67prqBWt+ZQHQOcd2oqEo3GHB8+hb7I/I+7bsEbNAqBLRUVEXjqGuNEKi+sAukj/EodLpbzwPKOxiR1m8HQ/gyllSmxavgFioMac2E99SbE/qTF+fHv/+oNB0c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JjkfQe+s; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JjkfQe+s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B7E11F000E9;
	Mon, 17 Aug 2026 14:53:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786978393;
	bh=CEIC5juLic6J6/x4bjLrkAYAoVE620AlXpMcSs5Rv/E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JjkfQe+snc11YwT1VeUhcA0a7Z7OqI6VBnj3ekpkn+yNEPJHwDaZlYQmZNbYdxoNP
	 1v1TkdAnnLu5OaVtXysOkFGmhqr9I6nHoLc7ARkLAqS3w20SgvbT7M3bLbtbWWYSD7
	 hiF0jMhIzgGNl7g9FfHfTHyE5zpWxzOZKaePylQU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Babanpreet Singh <bbnpreetsingh@gmail.com>,
	Joshua Crofts <joshua.crofts1@gmail.com>,
	William Breathitt Gray <wbg@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 021/156] counter: microchip-tcb-capture: Fix DT channel validation
Date: Mon, 17 Aug 2026 15:32:35 +0200
Message-ID: <20260817132535.461007157@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132534.666299318@linuxfoundation.org>
References: <20260817132534.666299318@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 461f57f66631c..fbd1afe178a36 100644
--- a/drivers/counter/microchip-tcb-capture.c
+++ b/drivers/counter/microchip-tcb-capture.c
@@ -309,7 +309,7 @@ static int mchp_tc_probe(struct platform_device *pdev)
 	char clk_name[7];
 	struct regmap *regmap;
 	struct clk *clk[3];
-	int channel;
+	u32 channel;
 	int ret, i;
 
 	counter = devm_counter_alloc(&pdev->dev, sizeof(*priv));
@@ -343,7 +343,7 @@ static int mchp_tc_probe(struct platform_device *pdev)
 
 		priv->channel[i] = channel;
 
-		snprintf(clk_name, sizeof(clk_name), "t%d_clk", channel);
+		snprintf(clk_name, sizeof(clk_name), "t%u_clk", channel);
 
 		clk[i] = of_clk_get_by_name(np->parent, clk_name);
 		if (IS_ERR(clk[i])) {
-- 
2.53.0



