Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BBA41FF61E;
	Mon,  2 Jun 2025 15:03:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748876590; cv=none; b=avnKShARo97lXIDH0jAhDvnk29fjBaAFJDF5cdnGrYfEhcB7LG8DFT7uHxRnDhhKCuF/uZxNmF4J0RHgZXTKN7zqgd60R8+WhrlB9T9y8XhQa6nMpi6wj4zOdPjTtisNesSLoR/P8kmb9BlD0oXcYqGDhboA34e58F676PoZ+no=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748876590; c=relaxed/simple;
	bh=zoUO5CIQrF8SJX93lIVWyb9yE3XcylewTo/1vNJKh10=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tD3rPW/2IdNpvyHwoOVRNOLRoTbjNF+kxHCR0KL692cBhf4kB+no7PRJ1JJaYnVok2wdN3NFgHgJbt9w5g3uSKreAbpMhshxf2YmP7X4Y5MkL27GT8aRRrJGjWdsDDhleo+ghvhmOqZxgSJzckcLEnHEV/HUYf2xMo0WhsECawk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WGYEQlkU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WGYEQlkU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C45E5C4CEEB;
	Mon,  2 Jun 2025 15:03:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748876590;
	bh=zoUO5CIQrF8SJX93lIVWyb9yE3XcylewTo/1vNJKh10=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WGYEQlkUXXViOXpZNmZpqknyZnt7ZRn7poodXu88QvTkMs3wEqriQg7UFfMwTNmfM
	 O1M/mpC8lsbRpD8pz+Qb7eNsa2KMTQVK0l+650m3Fvzq4WoMOOgOCTaj2RBqvUh20J
	 MYzVmlZZxW/PHyqadVTNhXXpxUKEg2I9WMdK1eHI=
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
Subject: [PATCH 6.1 004/325] gpio: pca953x: fix IRQ storm on system wake up
Date: Mon,  2 Jun 2025 15:44:40 +0200
Message-ID: <20250602134319.909153272@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134319.723650984@linuxfoundation.org>
References: <20250602134319.723650984@linuxfoundation.org>
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
index a5be47a916d3a..f81d79a297a5c 100644
--- a/drivers/gpio/gpio-pca953x.c
+++ b/drivers/gpio/gpio-pca953x.c
@@ -1241,6 +1241,8 @@ static int pca953x_restore_context(struct pca953x_chip *chip)
 
 	guard(mutex)(&chip->i2c_lock);
 
+	if (chip->client->irq > 0)
+		enable_irq(chip->client->irq);
 	regcache_cache_only(chip->regmap, false);
 	regcache_mark_dirty(chip->regmap);
 	ret = pca953x_regcache_sync(chip);
@@ -1253,6 +1255,10 @@ static int pca953x_restore_context(struct pca953x_chip *chip)
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



