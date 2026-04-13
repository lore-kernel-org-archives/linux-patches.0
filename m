Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 366933016EE;
	Mon, 13 Apr 2026 17:03:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776099788; cv=none; b=dASXC6DVnXLVen7SXYMe7QQMPp5Ib+zN+sYnx4WIu+kJKt2gdV9Fvoy35CUR7W4qhEiIkrbx3iYVoeTIculK9VQRxC/BY4KSJjRQLXZmdXFRnec6SUmuwc3n4D1+Ltp478tb5S6czDcc2JaOBMOAYBPz+rJmmo9RUz0OratYDdE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776099788; c=relaxed/simple;
	bh=e8BlvPo/y4gqPY9b3SdlVV96Y83LFDrmthz26/hv92s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PWcbv9uMHo/9ZtY+oyY8sGq3MY7V2ucZ+n0KHs1kP6+nMjLYqnVZGn2uyvbugj7Tw1KpMsGiO3pICnVaB4KSoVrBYTTrN6tFzxEGNpHgM5OQdE7mLzWBhAg+e+FcfjDMRMrTFC9wEDUKe+Dq9EVoV244s3vG3THjwu/LK981Y/A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wZRb52Ce; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wZRb52Ce"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFCCFC2BCAF;
	Mon, 13 Apr 2026 17:03:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776099788;
	bh=e8BlvPo/y4gqPY9b3SdlVV96Y83LFDrmthz26/hv92s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wZRb52Cev8pdtcphMSyaB9LbuVeawOZWw86DiD2WTVpaIomZhvsGCr7UY49siidPN
	 UaESCxRGj0HfTxLgHZIn5x8M/Aa0Bn8QmaeZuzkeZLGrpC+ya+1oMfm+lfIYsyFXmP
	 X/Z087A5JxvenHaHAaip6OSaaghlcNWo0M+Wu6tU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 474/491] mmc: core: Drop superfluous validations in mmc_hw|sw_reset()
Date: Mon, 13 Apr 2026 18:01:59 +0200
Message-ID: <20260413155836.794775290@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155819.042779211@linuxfoundation.org>
References: <20260413155819.042779211@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ulf Hansson <ulf.hansson@linaro.org>

[ Upstream commit fefdd3c91e0a7b3cbb3f25925d93a57c45cb0f31 ]

The mmc_hw|sw_reset() APIs are designed to be called solely from upper
layers, which means drivers that operates on top of the struct mmc_card,
like the mmc block device driver and an SDIO functional driver.

Additionally, as long as the struct mmc_host has a valid pointer to a
struct mmc_card, the corresponding host->bus_ops pointer stays valid and
assigned.

For these reasons, let's drop the superfluous reference counting and the
redundant validations in mmc_hw|sw_reset().

Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Reviewed-by: Adrian Hunter <adrian.hunter@intel.com>
Link: https://lore.kernel.org/r/20210212131532.236775-1-ulf.hansson@linaro.org
Stable-dep-of: 901084c51a0a ("mmc: core: Avoid bitfield RMW for claim/retune flags")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mmc/core/block.c |    2 +-
 drivers/mmc/core/core.c  |   21 +--------------------
 2 files changed, 2 insertions(+), 21 deletions(-)

--- a/drivers/mmc/core/block.c
+++ b/drivers/mmc/core/block.c
@@ -987,7 +987,7 @@ static int mmc_blk_reset(struct mmc_blk_
 	md->reset_done |= type;
 	err = mmc_hw_reset(host);
 	/* Ensure we switch back to the correct partition */
-	if (err != -EOPNOTSUPP) {
+	if (err) {
 		struct mmc_blk_data *main_md =
 			dev_get_drvdata(&host->card->dev);
 		int part_err;
--- a/drivers/mmc/core/core.c
+++ b/drivers/mmc/core/core.c
@@ -2096,18 +2096,7 @@ int mmc_hw_reset(struct mmc_host *host)
 {
 	int ret;
 
-	if (!host->card)
-		return -EINVAL;
-
-	mmc_bus_get(host);
-	if (!host->bus_ops || host->bus_dead || !host->bus_ops->hw_reset) {
-		mmc_bus_put(host);
-		return -EOPNOTSUPP;
-	}
-
 	ret = host->bus_ops->hw_reset(host);
-	mmc_bus_put(host);
-
 	if (ret < 0)
 		pr_warn("%s: tried to HW reset card, got error %d\n",
 			mmc_hostname(host), ret);
@@ -2120,18 +2109,10 @@ int mmc_sw_reset(struct mmc_host *host)
 {
 	int ret;
 
-	if (!host->card)
-		return -EINVAL;
-
-	mmc_bus_get(host);
-	if (!host->bus_ops || host->bus_dead || !host->bus_ops->sw_reset) {
-		mmc_bus_put(host);
+	if (!host->bus_ops->sw_reset)
 		return -EOPNOTSUPP;
-	}
 
 	ret = host->bus_ops->sw_reset(host);
-	mmc_bus_put(host);
-
 	if (ret)
 		pr_warn("%s: tried to SW reset card, got error %d\n",
 			mmc_hostname(host), ret);


