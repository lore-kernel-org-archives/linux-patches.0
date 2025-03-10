Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 007BD2D023;
	Mon, 10 Mar 2025 17:54:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741629299; cv=none; b=FnlJWJjIAYwd6cPlVaHiGWr8R2y8NrHGd//Jk1AEsoniGxU+fEgY6U8EIpQhHYsXE9xZS7Q3ZffVErbPriYP5AsWftmPGuhQw6cMxagpkDZBBlrxjzU0T71Ge6Neb4530RYb/Kz3l10OlnL6Kzf+lhZ5xrbWUvx6LwEvPsR0xoY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741629299; c=relaxed/simple;
	bh=ZZKFPbfmoxkFNoFVvQ3IJHOhl0SLKHCPUWVFPiEewQ0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O9o3bJHUg7ddjEiE2rkKkOVRtPhW97o4eeNn//ESDm5meHfruIZaEmu6hMym9DF+eWCIUJ6i7QowqGFp3oh734I0qe8qqzpAXQ2/e8PskaZ0TS84v2r5v84AT7DjUqSdtTSwI45Tl0ad66lIFfynBQW+9Ro/0AtpZ+fQONsGPkA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yfFI/X0k; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yfFI/X0k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F699C4CEE5;
	Mon, 10 Mar 2025 17:54:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741629298;
	bh=ZZKFPbfmoxkFNoFVvQ3IJHOhl0SLKHCPUWVFPiEewQ0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yfFI/X0k4BVL+o/VDm9QOPAs0tgOjxt1FC8HPP9MnlumoeNmFTqt34xkI2ovyIIKF
	 BR/biZYnfKRrD130w1QT6WnI3/04OaMinQPnQE++fm35TKP3T4M0z+EXZ8RLHDSADJ
	 3YjlywWcatGk4a6sJLTjhshw4q5WUYylwEdy2KEY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Tomlinson <mark.tomlinson@alliedtelesis.co.nz>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 245/620] gpio: pca953x: Improve interrupt support
Date: Mon, 10 Mar 2025 18:01:31 +0100
Message-ID: <20250310170555.302276314@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170545.553361750@linuxfoundation.org>
References: <20250310170545.553361750@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 4860bf3b7e002..45f3836c4f0fa 100644
--- a/drivers/gpio/gpio-pca953x.c
+++ b/drivers/gpio/gpio-pca953x.c
@@ -733,25 +733,6 @@ static bool pca953x_irq_pending(struct pca953x_chip *chip, unsigned long *pendin
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



