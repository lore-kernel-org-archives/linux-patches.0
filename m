Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B01A92FD1D7;
	Wed,  3 Dec 2025 16:34:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764779654; cv=none; b=LCHDx/CPQUi+IagkkLXk1hWzCBneqz61GL8Q/rsYT1Lqa5X16kuvKNxfOePxbJEd8huT8TQPWBkbzcs3vGfk6AV5HQHdhzGBgDepUv9U3WmwCJ18Fti5VS5u5pOtWgK8I/llOPcbmRAUgEEubpEJHgrfoK7ilVNqI8UcSzNpRTw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764779654; c=relaxed/simple;
	bh=PMlCkI4BVoXQ7adJhRwZ902Ap1pDfqzRTgU3OOGX+Cw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bjxaF1xpJPbqRVMNUHkJzuGmjzlowQz5L6F0w5qOFrJAkVPOp00nZ0NWmj8M0o98ACgttX7yCiinDv8BiuIJ9g+cv5/pH0JaH0LKkH/iMfAN1g9mEvFuBxlQgbFq8ImnZMcmCO+Mboh2mz+gqfS+dDAns7dQ+yOudRFxFdVGN1U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ikwZ0bx6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ikwZ0bx6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6C6DC4CEF5;
	Wed,  3 Dec 2025 16:34:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764779654;
	bh=PMlCkI4BVoXQ7adJhRwZ902Ap1pDfqzRTgU3OOGX+Cw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ikwZ0bx6cv6N9ZgsSgSoY28oHFDsc8ban2NJuvQJv0EeuMtD4YntlkwOo1frdTtpi
	 50r5hgg4F9Vqtmrb8BNgVt8t8gBF7s+t/ofIJ1yXXRURuWPgWougAsG/pUTHLBWAtN
	 50S9iRzNTaFEHNTNSLyGw1XCXEZ4pPP7ihGeAEOU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthias Schiffer <matthias.schiffer@tq-group.com>,
	Alexander Stein <alexander.stein@ew.tq-group.com>,
	Kevin Hilman <khilman@baylibre.com>,
	Stephen Boyd <sboyd@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 288/568] clk: ti: am33xx: keep WKUP_DEBUGSS_CLKCTRL enabled
Date: Wed,  3 Dec 2025 16:24:50 +0100
Message-ID: <20251203152451.252812129@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152440.645416925@linuxfoundation.org>
References: <20251203152440.645416925@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matthias Schiffer <matthias.schiffer@tq-group.com>

[ Upstream commit 1e0d75258bd09323cb452655549e03975992b29e ]

As described in AM335x Errata Advisory 1.0.42, WKUP_DEBUGSS_CLKCTRL
can't be disabled - the clock module will just be stuck in transitioning
state forever, resulting in the following warning message after the wait
loop times out:

    l3-aon-clkctrl:0000:0: failed to disable

Just add the clock to enable_init_clks, so no attempt is made to disable
it.

Signed-off-by: Matthias Schiffer <matthias.schiffer@tq-group.com>
Signed-off-by: Alexander Stein <alexander.stein@ew.tq-group.com>
Acked-by: Kevin Hilman <khilman@baylibre.com>
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/ti/clk-33xx.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/clk/ti/clk-33xx.c b/drivers/clk/ti/clk-33xx.c
index 85c50ea39e6da..9269e6a0db6a4 100644
--- a/drivers/clk/ti/clk-33xx.c
+++ b/drivers/clk/ti/clk-33xx.c
@@ -258,6 +258,8 @@ static const char *enable_init_clks[] = {
 	"dpll_ddr_m2_ck",
 	"dpll_mpu_m2_ck",
 	"l3_gclk",
+	/* WKUP_DEBUGSS_CLKCTRL - disable fails, AM335x Errata Advisory 1.0.42 */
+	"l3-aon-clkctrl:0000:0",
 	/* AM3_L3_L3_MAIN_CLKCTRL, needed during suspend */
 	"l3-clkctrl:00bc:0",
 	"l4hs_gclk",
-- 
2.51.0



