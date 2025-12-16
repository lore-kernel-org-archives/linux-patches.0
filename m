Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5179734AB1D;
	Tue, 16 Dec 2025 11:48:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765885711; cv=none; b=Alb4E8zV07JPybH0zoaR0TbMdV5OOm9ewd0G8Ze9ZCyn0DSxxVoOaFFKGM9UKNWoWkx5NovCzdj5YPBGzp1YJY+iaNvp5agpZTRqrqsCeozyccm5wNNlVjii7i4e8rOwcE07DTt9Wg6r3/KTGZ16C9NUWlYGnzbUQhE/N0qpk0c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765885711; c=relaxed/simple;
	bh=gvHpRLTdsZvSFo3ZuLuvlyB2bYvhKzAqLqP9+QABCAI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LcX84zTub7oqLQ3pyLuqqcHpb38PALd0AKm2QGXkjwMFvtiLo22Zn9tuJdLPrqjJ24TzbvPkrwQq/XjXXT5NHmOaVkne3LEMSFRGVPXV/GH7ZzHl0aSVnsmsQ1WDDTb+LXn/fVFo4EHXvj/Ia177VWsG+yGZYpxPJ3tVQfG9AWc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Y1DDISU0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Y1DDISU0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC497C4CEF1;
	Tue, 16 Dec 2025 11:48:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765885711;
	bh=gvHpRLTdsZvSFo3ZuLuvlyB2bYvhKzAqLqP9+QABCAI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Y1DDISU0f+QAxHWZY1j7oygWCyUctwzLB+DvGxWKl+ZgZ8GPckerGFnJbOpKm7r2r
	 cXSqnuRZnNlMi1TcVtuwpKTYSlyP/e86CTo2UkxckbqBMQnGOGuFNG0j+awPcwq5KJ
	 mkIFoTGHI8fWt3iHitlO3KMz1lUq8SwqXT8TMA5c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haotian Zhang <vulab@iscas.ac.cn>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 222/507] clk: renesas: r9a06g032: Fix memory leak in error path
Date: Tue, 16 Dec 2025 12:11:03 +0100
Message-ID: <20251216111353.549072223@linuxfoundation.org>
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

From: Haotian Zhang <vulab@iscas.ac.cn>

[ Upstream commit f8def051bbcf8677f64701e9699bf6d11e2780cd ]

The current code uses of_iomap() to map registers but never calls
iounmap() on any error path after the mapping. This causes a memory
leak when probe fails after successful ioremap, for example when
of_clk_add_provider() or r9a06g032_add_clk_domain() fails.

Replace of_iomap() with devm_of_iomap() to automatically unmap the
region on probe failure. Update the error check accordingly to use
IS_ERR() and PTR_ERR() since devm_of_iomap() returns ERR_PTR on error.

Fixes: 4c3d88526eba ("clk: renesas: Renesas R9A06G032 clock driver")
Signed-off-by: Haotian Zhang <vulab@iscas.ac.cn>
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
Link: https://patch.msgid.link/20251030061603.1954-1-vulab@iscas.ac.cn
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/renesas/r9a06g032-clocks.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/clk/renesas/r9a06g032-clocks.c b/drivers/clk/renesas/r9a06g032-clocks.c
index dcda19318b2a9..0f5c91b5dfa99 100644
--- a/drivers/clk/renesas/r9a06g032-clocks.c
+++ b/drivers/clk/renesas/r9a06g032-clocks.c
@@ -1333,9 +1333,9 @@ static int __init r9a06g032_clocks_probe(struct platform_device *pdev)
 	if (IS_ERR(mclk))
 		return PTR_ERR(mclk);
 
-	clocks->reg = of_iomap(np, 0);
-	if (WARN_ON(!clocks->reg))
-		return -ENOMEM;
+	clocks->reg = devm_of_iomap(dev, np, 0, NULL);
+	if (IS_ERR(clocks->reg))
+		return PTR_ERR(clocks->reg);
 
 	r9a06g032_init_h2mode(clocks);
 
-- 
2.51.0



