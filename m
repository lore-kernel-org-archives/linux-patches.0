Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66AC02FA0DB;
	Tue, 12 Aug 2025 18:13:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755022432; cv=none; b=Oegljb0QGztOPa0caRV6LxuYgd0lt1PJJrw8fb29MzUha0G4QTFpj0QP4oDrlxn+q8wcB9SaUp5rCgRn6N/YxqwuQgwElDvyM4UNQ+KrYslG+OU2xw09+1ZCxLrPa/+V9C9Ih5fs5c9SdX+M37MrUydEA3jfhSwERxoqeC13hag=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755022432; c=relaxed/simple;
	bh=wvyhIixYiMFHZ8yqRPwU0OtKn3FCoatEldOMfgBOQCE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uEFwNZIxh8RdSiiH0svN8oRT+loQc2ZNKxWXS/4ArXOi5ztn96/ilTZJRSqlC1Kv32v92PrG7yOnkIRi23Af3+CH7yQhquDWC9QQTDh32HxgCx/NhgC8TPb+2En0j2NTnMeRtsqwUhuCLQ/U7W56BXeoBP113+z1oiRWNSQVOkg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iK223nog; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iK223nog"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7ABD7C4CEF1;
	Tue, 12 Aug 2025 18:13:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755022432;
	bh=wvyhIixYiMFHZ8yqRPwU0OtKn3FCoatEldOMfgBOQCE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iK223nogrGUXpM5see66d/wthxmZ6NYrMnq8FVsSSdRuorOjQBZFrW2ZE8Z2TMNk3
	 cYpMDVjOG40ZcLBW/8Ai1U+hmYsGnm89YnJ2tigaV/7nH+S6LNUxPsgoDulgEFmyA+
	 whSwe8Ys9ACGwV77dSUer4V7zS5ULYpi9eteKvyM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 154/369] clk: renesas: rzv2h: Fix missing CLK_SET_RATE_PARENT flag for ddiv clocks
Date: Tue, 12 Aug 2025 19:27:31 +0200
Message-ID: <20250812173020.569853552@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173014.736537091@linuxfoundation.org>
References: <20250812173014.736537091@linuxfoundation.org>
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

From: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>

[ Upstream commit 715676d8418062f54d746451294ccce9786c1734 ]

Commit bc4d25fdfadf ("clk: renesas: rzv2h: Add support for dynamic
switching divider clocks") missed setting the `CLK_SET_RATE_PARENT`
flag when registering ddiv clocks.

Without this flag, rate changes to the divider clock do not propagate
to its parent, potentially resulting in incorrect clock configurations.

Fix this by setting `CLK_SET_RATE_PARENT` in the clock init data.

Fixes: bc4d25fdfadfa ("clk: renesas: rzv2h: Add support for dynamic switching divider clocks")
Signed-off-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
Link: https://lore.kernel.org/20250609140341.235919-1-prabhakar.mahadev-lad.rj@bp.renesas.com
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/renesas/rzv2h-cpg.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/clk/renesas/rzv2h-cpg.c b/drivers/clk/renesas/rzv2h-cpg.c
index b524a9d33610..5f8116e39e22 100644
--- a/drivers/clk/renesas/rzv2h-cpg.c
+++ b/drivers/clk/renesas/rzv2h-cpg.c
@@ -312,6 +312,7 @@ rzv2h_cpg_ddiv_clk_register(const struct cpg_core_clk *core,
 	init.ops = &rzv2h_ddiv_clk_divider_ops;
 	init.parent_names = &parent_name;
 	init.num_parents = 1;
+	init.flags = CLK_SET_RATE_PARENT;
 
 	ddiv->priv = priv;
 	ddiv->mon = cfg_ddiv.monbit;
-- 
2.39.5



