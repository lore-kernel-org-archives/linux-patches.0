Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39F573ACA5C;
	Mon, 23 Mar 2026 13:51:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774273896; cv=none; b=PKNcltX8IVW9v3R3VuRl5UYDVXvKDG0YS+/Kbcc3boGxS50H44BEZUHWi+wpELeAKRXPOPC/xWAmXqRYwhBr+gi13i5JhIoOVBV+j8UIGXydjRdXZJh7gEbm7V8LLTNoxlGP+lzy4Vg4t+zasqtT/FzlWJy3DNA1IcKmTDKmUFw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774273896; c=relaxed/simple;
	bh=Q3D75tZayzY8HIO6kArQwrFA9K9IvgQkLBbIq2gVMb8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q2t7v9Yyi1Sc0J9jW4uObqtWfREzHDu2DBsV2w/HVHwJoRTcPUvWworCAWDLZLyqIdT9r0KGpdPqDNfarAFjVfytmKva34C1Y0nb2pOxRe9geJgo3J/+H8LBMFWVi4jG1XvOK08bi7Fuecw4j7+tS9xRgt7m9fNoIit7KP3Lpng=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pOLZ8Yeq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pOLZ8Yeq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A2B7C2BCB3;
	Mon, 23 Mar 2026 13:51:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774273895;
	bh=Q3D75tZayzY8HIO6kArQwrFA9K9IvgQkLBbIq2gVMb8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pOLZ8YeqPYVcZ1YdRiAcV9ThpsM8tok0AxzYG7yBJStci+aON/diIYnGWG8rujhQl
	 p+A2i2j4kDVWxlU3V8dWusA0yWtod4kZdPfY560iroeKsewBzUhBfy8AH9/XTzkFki
	 F/vyJy3ZerPJG0Bq5uPvugaYM4KkQ5HfHbqApmjI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luke Wang <ziniu.wang_1@nxp.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 6.19 044/220] mmc: sdhci: fix timing selection for 1-bit bus width
Date: Mon, 23 Mar 2026 14:43:41 +0100
Message-ID: <20260323134505.981010360@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134504.575022936@linuxfoundation.org>
References: <20260323134504.575022936@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Luke Wang <ziniu.wang_1@nxp.com>

commit 5e3486e64094c28a526543f1e8aa0d5964b7f02d upstream.

When 1-bit bus width is used with HS200/HS400 capabilities set,
mmc_select_hs200() returns 0 without actually switching. This
causes mmc_select_timing() to skip mmc_select_hs(), leaving eMMC
in legacy mode (26MHz) instead of High Speed SDR (52MHz).

Per JEDEC eMMC spec section 5.3.2, 1-bit mode supports High Speed
SDR. Drop incompatible HS200/HS400/UHS/DDR caps early so timing
selection falls through to mmc_select_hs() correctly.

Fixes: f2119df6b764 ("mmc: sd: add support for signal voltage switch procedure")
Signed-off-by: Luke Wang <ziniu.wang_1@nxp.com>
Acked-by: Adrian Hunter <adrian.hunter@intel.com>
Cc: stable@vger.kernel.org
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mmc/host/sdhci.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

--- a/drivers/mmc/host/sdhci.c
+++ b/drivers/mmc/host/sdhci.c
@@ -4532,8 +4532,15 @@ int sdhci_setup_host(struct sdhci_host *
 	 * their platform code before calling sdhci_add_host(), and we
 	 * won't assume 8-bit width for hosts without that CAP.
 	 */
-	if (!(host->quirks & SDHCI_QUIRK_FORCE_1_BIT_DATA))
+	if (host->quirks & SDHCI_QUIRK_FORCE_1_BIT_DATA) {
+		host->caps1 &= ~(SDHCI_SUPPORT_SDR104 | SDHCI_SUPPORT_SDR50 | SDHCI_SUPPORT_DDR50);
+		if (host->quirks2 & SDHCI_QUIRK2_CAPS_BIT63_FOR_HS400)
+			host->caps1 &= ~SDHCI_SUPPORT_HS400;
+		mmc->caps2 &= ~(MMC_CAP2_HS200 | MMC_CAP2_HS400 | MMC_CAP2_HS400_ES);
+		mmc->caps &= ~(MMC_CAP_DDR | MMC_CAP_UHS);
+	} else {
 		mmc->caps |= MMC_CAP_4_BIT_DATA;
+	}
 
 	if (host->quirks2 & SDHCI_QUIRK2_HOST_NO_CMD23)
 		mmc->caps &= ~MMC_CAP_CMD23;


