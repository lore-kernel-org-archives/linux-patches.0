Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB8D91DFDBE;
	Wed, 19 Feb 2025 09:21:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739956860; cv=none; b=oVdjlwDYu5mSA98Jto/aW4Ia65YdXir6NKwzYeGeBFoKgFmcHWKoqyrK0PrhWBEMyXKzB5Mw9pawfkGBRy8wa7bej+odT6Nx/UrpaeWjXSpgmCthSQYgWIhjl3FdCpxi73C3apR+MFGV4/mqX3mes48EUD7hqRoHGBnH+fyVdJU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739956860; c=relaxed/simple;
	bh=93XTu8eQMTcDXBR2T6YS9FZaMCn2itC0Z64BARx4M1Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YNaLCKgmqChPT1brrqTRc3b4T87Oef4m0v3qv0LVRczJd2sUBDZrXiVMjXTLFyJT+FuJEifvS+eyFeM1Ju/fLgJk66JJsMrAK0Gb3F/41/kU48jEcfUF3PpP18lu/J2RXFaQdlrBmaN6wkim6iGMPmD5qFQvbMHl2GZ3Bb8wRRg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XcE1TmBV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XcE1TmBV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CF51C4CEE6;
	Wed, 19 Feb 2025 09:21:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739956860;
	bh=93XTu8eQMTcDXBR2T6YS9FZaMCn2itC0Z64BARx4M1Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XcE1TmBVtkQtc8bMQmjVeylKTDXq2exlMnaYJbCPOHtw/5raHk8wasIPlIAnMTMKZ
	 7tvJ1Aeot92/yvMo03/dBrKPf4ktrY4GeHzla4KA7uoEmjyIig0v7nbBRfpiCwkIHE
	 PLqNm794fozH+zMzmfnwhmGmLLaiJrOsK1Ck9c5Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Tomlinson <mark.tomlinson@alliedtelesis.co.nz>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 326/578] gpio: pca953x: Improve interrupt support
Date: Wed, 19 Feb 2025 09:25:30 +0100
Message-ID: <20250219082705.834104838@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082652.891560343@linuxfoundation.org>
References: <20250219082652.891560343@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mark Tomlinson <mark.tomlinson@alliedtelesis.co.nz>

[ Upstream commit d6179f6c6204f9932aed3a7a2100b4a295dfed9d ]

The GPIO drivers with latch interrupt support (typically types starting
with PCAL) have interrupt status registers to determine which particular
inputs have caused an interrupt. Unfortunately there is no atomic
operation to read these registers and clear the interrupt. Clearing the
interrupt is done by reading the input registers.

The code was reading the interrupt status registers, and then reading
the input registers. If an input changed between these two events it was
lost.

The solution in this patch is to revert to the non-latch version of
code, i.e. remembering the previous input status, and looking for the
changes. This system results in no more I2C transfers, so is no slower.
The latch property of the device still means interrupts will still be
noticed if the input changes back to its initial state.

Fixes: 44896beae605 ("gpio: pca953x: add PCAL9535 interrupt support for Galileo Gen2")
Signed-off-by: Mark Tomlinson <mark.tomlinson@alliedtelesis.co.nz>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Link: https://lore.kernel.org/r/20240606033102.2271916-1-mark.tomlinson@alliedtelesis.co.nz
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpio-pca953x.c | 19 -------------------
 1 file changed, 19 deletions(-)

diff --git a/drivers/gpio/gpio-pca953x.c b/drivers/gpio/gpio-pca953x.c
index 9ce54bf2030d7..262b3d276df78 100644
--- a/drivers/gpio/gpio-pca953x.c
+++ b/drivers/gpio/gpio-pca953x.c
@@ -851,25 +851,6 @@ static bool pca953x_irq_pending(struct pca953x_chip *chip, unsigned long *pendin
 	DECLARE_BITMAP(trigger, MAX_LINE);
 	int ret;
 
-	if (chip->driver_data & PCA_PCAL) {
-		/* Read the current interrupt status from the device */
-		ret = pca953x_read_regs(chip, PCAL953X_INT_STAT, trigger);
-		if (ret)
-			return false;
-
-		/* Check latched inputs and clear interrupt status */
-		ret = pca953x_read_regs(chip, chip->regs->input, cur_stat);
-		if (ret)
-			return false;
-
-		/* Apply filter for rising/falling edge selection */
-		bitmap_replace(new_stat, chip->irq_trig_fall, chip->irq_trig_raise, cur_stat, gc->ngpio);
-
-		bitmap_and(pending, new_stat, trigger, gc->ngpio);
-
-		return !bitmap_empty(pending, gc->ngpio);
-	}
-
 	ret = pca953x_read_regs(chip, chip->regs->input, cur_stat);
 	if (ret)
 		return false;
-- 
2.39.5



