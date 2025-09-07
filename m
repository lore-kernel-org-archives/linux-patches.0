Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BC3A1F09A5;
	Sun,  7 Sep 2025 20:10:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757275854; cv=none; b=ZqJqetDKBTh2dTvK6HKy/HLXC5U5HA59eCHeFRkowpx7snF8mqinaTGn/xJBcLpd6c3Gjdd6Jf/Lp01VOWMSbCCnmmaisuw6+yw781V10AmFx/3SJ34Uciy2K6kV8AmbEKc6Faub0S8Ep9aPp7kI5zSkHtMB/M3zFNseokDNmfA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757275854; c=relaxed/simple;
	bh=1tnaEUhxiVc0wFzPAX/9tgO9wW7i/R1iJnQie2ZEzfg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Du/SaOR9RaHGqiI6NMHuf8G/QHOYpiIMF1yj8dlYmceITe9Ea8At1DIkol0DyUhrKedXMs+pIfF6psvDmcvqd9dN2Fqt3815CvBqDKrf9DnGc7LtbJx7e5Fq1U0GhQGtdj6gXPMXi9Ph/RK0SFuDd4PHnip5wUBJvGjQ+/UZ6wo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=P/0tzzCo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="P/0tzzCo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C86CDC4CEF0;
	Sun,  7 Sep 2025 20:10:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757275854;
	bh=1tnaEUhxiVc0wFzPAX/9tgO9wW7i/R1iJnQie2ZEzfg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=P/0tzzCo5+TKj2nZz9CmGe0C8RSbSc/X0wfRQvzS7lBLNSGCBLvWMIuwMHKwXC6sw
	 YXb2sYRE6YCbFVg22sqkRxY1ZW/gF3OxjEntilezsobTH9s/2KuqIlzmPA4szEiDA7
	 oT4W6Rojtkjm52xkAA9LzA/8hmohI8kNmpyi1MjI=
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
Subject: [PATCH 5.4 31/45] gpio: pca953x: fix IRQ storm on system wake up
Date: Sun,  7 Sep 2025 21:58:17 +0200
Message-ID: <20250907195601.880352674@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250907195600.953058118@linuxfoundation.org>
References: <20250907195600.953058118@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1199,6 +1199,9 @@ static int pca953x_suspend(struct device
 	struct pca953x_chip *chip = dev_get_drvdata(dev);
 
 	mutex_lock(&chip->i2c_lock);
+	/* Disable IRQ to prevent early triggering while regmap "cache only" is on */
+	if (chip->client->irq > 0)
+		disable_irq(chip->client->irq);
 	regcache_cache_only(chip->regmap, true);
 	mutex_unlock(&chip->i2c_lock);
 
@@ -1224,6 +1227,8 @@ static int pca953x_resume(struct device
 	}
 
 	mutex_lock(&chip->i2c_lock);
+	if (chip->client->irq > 0)
+		enable_irq(chip->client->irq);
 	regcache_cache_only(chip->regmap, false);
 	regcache_mark_dirty(chip->regmap);
 	ret = pca953x_regcache_sync(dev);


