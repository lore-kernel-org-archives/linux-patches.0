Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0ED082C324D;
	Mon,  2 Jun 2025 14:03:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748873012; cv=none; b=MU0Hc7dx8G0mKSR+kFN021dul4+Q4Y4+GcgBtv79Qi9mhMixAeuHHgUqwm768rstT7IC9Gpg9CwbnmSLw3HpIxSwrMprDVItZ9wK1oWsD7et3DDTgaj1isMlnXF6CyBHxXnDSX3Aa3fHa4jomRwBB17Yt44JoNT6dBCb+28ko4Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748873012; c=relaxed/simple;
	bh=jIIWssNa7nysdUGmZoDhsOwVfn6o3OWSD7J2IoQ4N+Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CanohjEHNclh6/DaRmHu3FRAX+U5/2/+BbTK9na+WCRZ/qKbzOnq23/WSJe19BqVmJmf7bbV0zoiKL5yxDeTwG32KZE8sH7hn05E7nUAaU/183qHDH94tG0BcE6Hlwq49hVDezxo/wGBqKoDQgADlaAiPGWdKnuRVVnHo/HOOu8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=V1o9xkEy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="V1o9xkEy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CED7C4CEEE;
	Mon,  2 Jun 2025 14:03:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748873011;
	bh=jIIWssNa7nysdUGmZoDhsOwVfn6o3OWSD7J2IoQ4N+Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=V1o9xkEyhw8Vc7wI6lL9ZWasIZM0o0T3ft0Ickc+1LyaUXeUW4H+0VcBNg/69vfR+
	 BuSQwgW1m1ulvkEsNeKq0XaHJ1EuVe+UCqIWnylrMvFBHDr5lpJZtTBWfO0b7iEdAt
	 KFzUIgCcptFxZxZJ7EPtdPKBhVJY5Z1BD+1A8yfM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Emanuele Ghidoli <emanuele.ghidoli@toradex.com>,
	Francesco Dolcini <francesco.dolcini@toradex.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 003/444] gpio: pca953x: fix IRQ storm on system wake up
Date: Mon,  2 Jun 2025 15:41:07 +0200
Message-ID: <20250602134341.048140430@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134340.906731340@linuxfoundation.org>
References: <20250602134340.906731340@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Emanuele Ghidoli <emanuele.ghidoli@toradex.com>

[ Upstream commit 3e38f946062b4845961ab86b726651b4457b2af8 ]

If an input changes state during wake-up and is used as an interrupt
source, the IRQ handler reads the volatile input register to clear the
interrupt mask and deassert the IRQ line. However, the IRQ handler is
triggered before access to the register is granted, causing the read
operation to fail.

As a result, the IRQ handler enters a loop, repeatedly printing the
"failed reading register" message, until `pca953x_resume()` is eventually
called, which restores the driver context and enables access to
registers.

Fix by disabling the IRQ line before entering suspend mode, and
re-enabling it after the driver context is restored in `pca953x_resume()`.

An IRQ can be disabled with disable_irq() and still wake the system as
long as the IRQ has wake enabled, so the wake-up functionality is
preserved.

Fixes: b76574300504 ("gpio: pca953x: Restore registers after suspend/resume cycle")
Cc: stable@vger.kernel.org
Signed-off-by: Emanuele Ghidoli <emanuele.ghidoli@toradex.com>
Signed-off-by: Francesco Dolcini <francesco.dolcini@toradex.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Tested-by: Geert Uytterhoeven <geert+renesas@glider.be>
Link: https://lore.kernel.org/r/20250512095441.31645-1-francesco@dolcini.it
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpio-pca953x.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/gpio/gpio-pca953x.c b/drivers/gpio/gpio-pca953x.c
index a39c8ebd410e4..faadbe66b23e7 100644
--- a/drivers/gpio/gpio-pca953x.c
+++ b/drivers/gpio/gpio-pca953x.c
@@ -1209,6 +1209,8 @@ static int pca953x_restore_context(struct pca953x_chip *chip)
 
 	guard(mutex)(&chip->i2c_lock);
 
+	if (chip->client->irq > 0)
+		enable_irq(chip->client->irq);
 	regcache_cache_only(chip->regmap, false);
 	regcache_mark_dirty(chip->regmap);
 	ret = pca953x_regcache_sync(chip);
@@ -1221,6 +1223,10 @@ static int pca953x_restore_context(struct pca953x_chip *chip)
 static void pca953x_save_context(struct pca953x_chip *chip)
 {
 	guard(mutex)(&chip->i2c_lock);
+
+	/* Disable IRQ to prevent early triggering while regmap "cache only" is on */
+	if (chip->client->irq > 0)
+		disable_irq(chip->client->irq);
 	regcache_cache_only(chip->regmap, true);
 }
 
-- 
2.39.5



