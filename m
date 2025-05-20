Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FD962505C7;
	Tue, 20 May 2025 14:17:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747750677; cv=none; b=kcJvVLfSi4OJvfHz5HORDroITm27poChEmm4We136YDc4KA5BLwbm3X6St3lM0ghBOx7157jJHj0wFe7Mv2yUJdBHAF5Wq12FDm2rerxaBkL+0JlqsFW/C1xuHn5qM+kLkJ/Lo1WUu+994OWJ2rfQg81s5MawQwrPycP8/TXxaI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747750677; c=relaxed/simple;
	bh=j7XUk58StIpFkbSUmzNoitBdNHATsNMeZKwZjYfSKvg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dB5XeRHRjXIpd3ItMws+BqIhvaRF8NLP0KVkdLN2jPLPsoXGyAJnQg5EVJfbTsjzBASL0zErEzQwVZRYW3t8GkNkoKZ38fD/xNb1Enlxok2IDq/VagniP8UF+88oouj5ZOOSD3LKrWxCIv7tEUa+P6m1a/6so3j3XxAx3d4Oar0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yA8tc/IH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yA8tc/IH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 187F2C4CEE9;
	Tue, 20 May 2025 14:17:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747750677;
	bh=j7XUk58StIpFkbSUmzNoitBdNHATsNMeZKwZjYfSKvg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yA8tc/IHVHLWK9Gvqi70C74uHGQ0/xlcgJD+3NpZw9+udB9LSOwA/E3ZmrzofX9nl
	 SB84V6ScJzRNVMP+Zlz177r/m8GbbqpIIyngB5f7ALKdgRUMIpevE8gNU2oDNScbGh
	 21OyBKkpbfI973Xwar6shixCNS0lzsp5r4JYDyN0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Emanuele Ghidoli <emanuele.ghidoli@toradex.com>,
	Francesco Dolcini <francesco.dolcini@toradex.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Subject: [PATCH 6.14 086/145] gpio: pca953x: fix IRQ storm on system wake up
Date: Tue, 20 May 2025 15:50:56 +0200
Message-ID: <20250520125813.943800291@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250520125810.535475500@linuxfoundation.org>
References: <20250520125810.535475500@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Emanuele Ghidoli <emanuele.ghidoli@toradex.com>

commit 3e38f946062b4845961ab86b726651b4457b2af8 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpio/gpio-pca953x.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/drivers/gpio/gpio-pca953x.c
+++ b/drivers/gpio/gpio-pca953x.c
@@ -1203,6 +1203,8 @@ static int pca953x_restore_context(struc
 
 	guard(mutex)(&chip->i2c_lock);
 
+	if (chip->client->irq > 0)
+		enable_irq(chip->client->irq);
 	regcache_cache_only(chip->regmap, false);
 	regcache_mark_dirty(chip->regmap);
 	ret = pca953x_regcache_sync(chip);
@@ -1215,6 +1217,10 @@ static int pca953x_restore_context(struc
 static void pca953x_save_context(struct pca953x_chip *chip)
 {
 	guard(mutex)(&chip->i2c_lock);
+
+	/* Disable IRQ to prevent early triggering while regmap "cache only" is on */
+	if (chip->client->irq > 0)
+		disable_irq(chip->client->irq);
 	regcache_cache_only(chip->regmap, true);
 }
 


