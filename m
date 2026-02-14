Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F25B61E1E12;
	Sat, 14 Feb 2026 01:03:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771030987; cv=none; b=WZoYaYtQsxZgSrFiugwbXGJE4fWVsAvnGLeSRZ9X5351+/rod58THvJHDV/yrjhFIDYtxWbt18dDOwVBjrEaH6nwu45OJfvinmRBUsKgs75iyK3BT/V+aBL2FOW8htWHi6GxYrSyLkHGn+hXLvzCiwKk/5Ub8hFGXi3o4kSyCPQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771030987; c=relaxed/simple;
	bh=ZfejrtQksITQTSmObej8g8NSFF1QgqkmRIETHoIRC1k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=SENeL3XKofJvJUs8cPUqY2cAPAIyklvEoSyex8AbEkPxcwMjlwm4cy+tO1NMh1/Ah0ZjAF6wKrZzEIz8getTRgXiHUtgxDM90ajYLPc3N2mipLcLww4Z2Y7kLyP7mGWZnJUdM1l1NMV82mLVC2JqKPoV4VwhNTp7LWwNUDYjlUc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=prTrF2vv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="prTrF2vv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B89B8C19424;
	Sat, 14 Feb 2026 01:03:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771030986;
	bh=ZfejrtQksITQTSmObej8g8NSFF1QgqkmRIETHoIRC1k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=prTrF2vvUcNWn+D8qSDjnY27/GjKiWw46Suxiqe10vykiXPutmJWYn5TKXhOCat8m
	 MSpyxawS6mSM+zufkBeYPsrsMHH+UO7/dVMLGOchR6DZ22N1Dar/DOBIQHdeiF/TWk
	 43x3L3pzxDqS3vw3kjC4zmyB7sj22YoKf1W8LaJvvQYbvcT8tlYspyhJTEOkh2Ob2e
	 yCLSGAbUa3vrkDFilNBUSTkWazy/A1ZZdbhXovNuvO7fgTCPMacHkzay+0tlJ6FmUS
	 97nPimiyVgKDh44tcewF9NpFbspd9JI1BcNGgH12HxjF65GWwXKCVP1VxYIkJ61dde
	 sUo7pTV1YL6lA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: "Miquel Raynal (Schneider Electric)" <miquel.raynal@bootlin.com>,
	Wolfram Sang <wsa+renesas@sang-engineering.com>,
	Santhosh Kumar K <s-k6@ti.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	linux-spi@vger.kernel.org
Subject: [PATCH AUTOSEL 6.19-6.18] spi: cadence-qspi: Try hard to disable the clocks
Date: Fri, 13 Feb 2026 19:58:12 -0500
Message-ID: <20260214010245.3671907-12-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260214010245.3671907-1-sashal@kernel.org>
References: <20260214010245.3671907-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.19
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: "Miquel Raynal (Schneider Electric)" <miquel.raynal@bootlin.com>

[ Upstream commit 612227b392eed94a3398dc03334a84a699a82276 ]

In the remove path, we should try hard to perform all steps as we simply
cannot fail.

The "no runtime PM" quirk must only alter the state of the RPM core, but
the clocks should still be disabled if that is possible. Move the
disable call outside of the RPM quirk.

Tested-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
Signed-off-by: Miquel Raynal (Schneider Electric) <miquel.raynal@bootlin.com>
Tested-by: Santhosh Kumar K <s-k6@ti.com>
Link: https://patch.msgid.link/20260122-schneider-6-19-rc1-qspi-v4-9-f9c21419a3e6@bootlin.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

So the `CQSPI_DISABLE_RUNTIME_PM` quirk is used by `socfpga_qspi` (Intel
SoCFPGA platforms). These are real, deployed embedded systems.

### Stability Indicators

- **Tested-by:** Two testers: Wolfram Sang and Santhosh Kumar K — both
  are known kernel contributors
- **Reviewed through proper channels:** Has a Link: to the mailing list
  patch series
- **Part of a series:** The commit is "v4-9" suggesting it's patch 9 in
  a series. This is a concern for dependency.

Let me check if this patch is self-contained or requires other patches
from the series.

The change itself is self-contained — it only modifies the logic of the
`cqspi_remove()` function. The `ret` variable is newly added and
initialized in this function. No new functions, types, or macros are
introduced. The change doesn't depend on other patches.

### Assessment

**What it fixes:** Clock resource leak on driver removal for platforms
with the `CQSPI_DISABLE_RUNTIME_PM` quirk (specifically SoCFPGA).
Without this fix, the QSPI clock remains enabled after driver removal,
which wastes power and can prevent proper power state transitions.

**Meets stable rules:**
- Obviously correct: Yes — the logic change is clear and straightforward
- Fixes a real bug: Yes — resource leak (clock not disabled on remove)
- Small and contained: Yes — ~6 lines in one file
- No new features: Correct — this is purely a bug fix

**Risk:** Very low. The change is minimal, the logic is straightforward,
and it has been tested by two people.

**Concern:** This is part of a larger series (patch 9 of N), but the
change itself appears self-contained. The only question is whether the
code it modifies exists in stable trees — the cadence-qspi driver and
the `CQSPI_DISABLE_RUNTIME_PM` quirk have been around for a while, so
this should apply.

This is a clear resource leak fix in the driver removal path, it's
small, tested, and low risk.

**YES**

 drivers/spi/spi-cadence-quadspi.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/spi/spi-cadence-quadspi.c b/drivers/spi/spi-cadence-quadspi.c
index b1c95b1c343fc..1ce433a8d64a5 100644
--- a/drivers/spi/spi-cadence-quadspi.c
+++ b/drivers/spi/spi-cadence-quadspi.c
@@ -2042,6 +2042,7 @@ static void cqspi_remove(struct platform_device *pdev)
 	const struct cqspi_driver_platdata *ddata;
 	struct cqspi_st *cqspi = platform_get_drvdata(pdev);
 	struct device *dev = &pdev->dev;
+	int ret = 0;
 
 	ddata = of_device_get_match_data(dev);
 
@@ -2061,8 +2062,10 @@ static void cqspi_remove(struct platform_device *pdev)
 		cqspi_jh7110_disable_clk(pdev, cqspi);
 
 	if (!(ddata && (ddata->quirks & CQSPI_DISABLE_RUNTIME_PM)))
-		if (pm_runtime_get_sync(&pdev->dev) >= 0)
-			clk_disable(cqspi->clk);
+		ret = pm_runtime_get_sync(&pdev->dev);
+
+	if (ret >= 0)
+		clk_disable(cqspi->clk);
 
 	if (!(ddata && (ddata->quirks & CQSPI_DISABLE_RUNTIME_PM))) {
 		pm_runtime_put_sync(&pdev->dev);
-- 
2.51.0

