Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28D7724502C;
	Tue, 29 Apr 2025 17:11:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745946716; cv=none; b=gVsWuHQNzvezGDMsGTbPSPvI5SKAsZSYfpFExlgTeS/bQSNZpaYncNdWasYD/G5egzMLx3jl741Q1tM1RMZ9AxM68dhojAiYLECsE6XXI3jXthYrltEtbWBUPgXHJantlz7JBNFFHWCbkpNTbPg6rhNg1hZ6kd9MiEvutQdJ8+o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745946716; c=relaxed/simple;
	bh=s0CZHnFGkLTELU6rd/9V5Qnu6h7K/zghiT61kvWdiPE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=OssL9DflFHyFM12WgXESDisqRHu0c+pTBJ4dEiO8776MJUcox0Z0hiF3ZPLImm2J44A/fVbSSwVDulmkbjIMNADTEDMyFddlHBITlwOzQLWERvQFtPJ3C+sLWW5Wi3jU7Dp3rotFsxvx8AaFddS/AqVu47Tq2iZj+7io7D+pXOg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vuSY9pfn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vuSY9pfn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C670C4CEE9;
	Tue, 29 Apr 2025 17:11:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745946715;
	bh=s0CZHnFGkLTELU6rd/9V5Qnu6h7K/zghiT61kvWdiPE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vuSY9pfnXiQawoW1GyKcwOOWdR+HT5utpPcOIKzvGf43gfmkZbRJkBzb4NFasOVDj
	 pdynfusNB5aoHEyVO3ydw/AGHrgYO6VxI5e7jlQ7O2OjMiZVMYyQB7zl4O5Am7jYeV
	 0MXNC6lxxrcUlXdnizpc2Rse+/itNJawQq5b1Wn0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>,
	Thierry Reding <thierry.reding@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 046/286] pwm: rcar: Simplify multiplication/shift logic
Date: Tue, 29 Apr 2025 18:39:10 +0200
Message-ID: <20250429161109.753473411@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161107.848008295@linuxfoundation.org>
References: <20250429161107.848008295@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Geert Uytterhoeven <geert+renesas@glider.be>

[ Upstream commit ed14d36498c8d15be098df4af9ca324f96e9de74 ]

- Remove the superfluous cast; the multiplication will yield a 64-bit
    result due to the "100ULL" anyway,
  - "a * (1 << b)" == "a << b".

Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Reviewed-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Signed-off-by: Thierry Reding <thierry.reding@gmail.com>
Stable-dep-of: e7327c193014 ("pwm: rcar: Improve register calculation")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pwm/pwm-rcar.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pwm/pwm-rcar.c b/drivers/pwm/pwm-rcar.c
index 7ab9eb6616d95..efe11e4e449e1 100644
--- a/drivers/pwm/pwm-rcar.c
+++ b/drivers/pwm/pwm-rcar.c
@@ -110,7 +110,7 @@ static int rcar_pwm_set_counter(struct rcar_pwm_chip *rp, int div, int duty_ns,
 	unsigned long clk_rate = clk_get_rate(rp->clk);
 	u32 cyc, ph;
 
-	one_cycle = (unsigned long long)NSEC_PER_SEC * 100ULL * (1 << div);
+	one_cycle = NSEC_PER_SEC * 100ULL << div;
 	do_div(one_cycle, clk_rate);
 
 	tmp = period_ns * 100ULL;
-- 
2.39.5



