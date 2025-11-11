Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D8E133F382;
	Tue, 11 Nov 2025 01:42:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762825343; cv=none; b=mRwf+WhUQrb9ByfVXGvnhFGkqZQ219VeMzrg6AxS7rtK6Kt5lKGZjeip984y1udVgSjGxfy29zQwh5ycfMH0Jv4AA6ZrlSDCfxB8ogKfv2fojaxI63Fk+6oOsuUV2HyA0YQPLoxoXvw5m/liqJRINa86eC4pswfWnkSlongXxu4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762825343; c=relaxed/simple;
	bh=u7SGvKR7+BEG4Hxvsr/EXCKgCD/XY3/n5eAxjI3talg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EDfNCjvhhMXDI+2ISIpFhhBWFEG1KctKRiZEHaFGtASVR4OZsjoMP0MW4ceJhYCGlRbdC0sVjlDyxRI+QyYCtHya8bzPPXn4ZP3fOStRx9HsFst6BK7kJ1X7gqaHKrSQCVsxIjyQ8G3Aeob88gapjlLpilZWrGOjCv/ja1WTuE0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lJrCWJe9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lJrCWJe9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1D79C4CEF5;
	Tue, 11 Nov 2025 01:42:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762825343;
	bh=u7SGvKR7+BEG4Hxvsr/EXCKgCD/XY3/n5eAxjI3talg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lJrCWJe9P03Z4/xvSm4MLFHVRMvBQL4QAqQwsVb83BDVcpIZcBC4mkz9YGBawhO2C
	 aQLQT1/gzgEMkADdUDdfojf0NkKkhVWX35QylNbFT4VCW8EARJuvLwxiTyGnoaOlRe
	 MPqyMdYP7gsw34eyM4//BWlUPmedc3td8bNzr92I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthias Schiffer <matthias.schiffer@tq-group.com>,
	Alexander Stein <alexander.stein@ew.tq-group.com>,
	Kevin Hilman <khilman@baylibre.com>,
	Stephen Boyd <sboyd@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 709/849] clk: ti: am33xx: keep WKUP_DEBUGSS_CLKCTRL enabled
Date: Tue, 11 Nov 2025 09:44:39 +0900
Message-ID: <20251111004553.578622616@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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



