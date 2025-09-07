Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA5EE1CDFAC;
	Sun,  7 Sep 2025 20:08:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757275694; cv=none; b=S8hZl+lOresr+3yLX2G/RspD+jA3YfH+hxpZ+7I1qEy7daPomPBOyamdI/ZvQw2NHhnFVi1V/dDs63p3SBkMhjztNWL8ZseU+Cdszw/hxkwVTflHDiI9XoKMhVAkN3U4Tacfr9+tPmZiB35gOF8vTROla2/0ixYyJwW5METG14s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757275694; c=relaxed/simple;
	bh=mXra9LPHXG5hEv/cwIfa2J0myi6m1H3Sw1jqyKgEDgM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AmfqnV2b2CFZR6A1YQY8Mj2HodcnTiVEKdGzneqf27CAhwpx+YPIYxFUpvuo8BumoLwt6iYwk1P6r66xlZGFt5orbBVF66DNzGHwiTCRXnw89u4EU2ghYtV+j9uzW+lInHDasH6y7STftl9kzeSw/F9RTcXP+eGKnNvTR52YHmA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Z08Jca6b; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Z08Jca6b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B4AEC4CEF0;
	Sun,  7 Sep 2025 20:08:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757275693;
	bh=mXra9LPHXG5hEv/cwIfa2J0myi6m1H3Sw1jqyKgEDgM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Z08Jca6b5gGeSBCT0cPJaG+Al7BgkYHgvdwJiMb9ngpQLPxYTA7QEMvB1vsWv3YDV
	 pWd4XYaGNfxCJ859pRfFerneh5TzgvH1bB5dVP6f1vsWexPYZNaydF0ThKYjG5TeRA
	 rt31f1iuB8xRI6DOeQyH0CEBGhzkZnCiL/BH5NB0=
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
Subject: [PATCH 5.10 33/52] gpio: pca953x: fix IRQ storm on system wake up
Date: Sun,  7 Sep 2025 21:57:53 +0200
Message-ID: <20250907195602.940805326@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250907195601.957051083@linuxfoundation.org>
References: <20250907195601.957051083@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
[ Apply directly to suspend/resume functions ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpio/gpio-pca953x.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/gpio/gpio-pca953x.c
+++ b/drivers/gpio/gpio-pca953x.c
@@ -1144,6 +1144,9 @@ static int pca953x_suspend(struct device
 	struct pca953x_chip *chip = dev_get_drvdata(dev);
 
 	mutex_lock(&chip->i2c_lock);
+	/* Disable IRQ to prevent early triggering while regmap "cache only" is on */
+	if (chip->client->irq > 0)
+		disable_irq(chip->client->irq);
 	regcache_cache_only(chip->regmap, true);
 	mutex_unlock(&chip->i2c_lock);
 
@@ -1169,6 +1172,8 @@ static int pca953x_resume(struct device
 	}
 
 	mutex_lock(&chip->i2c_lock);
+	if (chip->client->irq > 0)
+		enable_irq(chip->client->irq);
 	regcache_cache_only(chip->regmap, false);
 	regcache_mark_dirty(chip->regmap);
 	ret = pca953x_regcache_sync(dev);


