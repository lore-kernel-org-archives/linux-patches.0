Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1175D3C1963;
	Thu, 15 Jan 2026 17:59:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768499941; cv=none; b=OxU+Z9KeDQGOah9ipAhJ7UR5PFUXzzVVI5qeFF0oFEWB+DXJZqwLN/kelJ5pdYS0OsT0pufZ4cwDLQ3EZ6+jJdZF+nkzCPC+RXubmk0puk/hgQSVnT+KMEsB0OAYkb83XRHn/3llFhb+7aRQQkPuHcUoEeDw7q7oghFQkjYUNbE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768499941; c=relaxed/simple;
	bh=DKMZxPm9QWQYuWuMs308aFIQUtILyk/tNFIctwfgdzA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C4lfYLcDWVwTiV4lCKoTbhkOzV+aHIAJgIsxHbLlJsqLeOFL7wiuLg6tdks3VUElwnsJP5HzZJgIPZDb6FpjWGoJ6gtm/C2yKiAr0kvXYe3h7afUxbKtRUTiPNAJlfKfU8RyMmKlYhdfpuBM3zRX7yTBlLRNaHQIJL2yM7PF4RI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kMaMkN8m; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kMaMkN8m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 920A0C116D0;
	Thu, 15 Jan 2026 17:59:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768499940;
	bh=DKMZxPm9QWQYuWuMs308aFIQUtILyk/tNFIctwfgdzA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kMaMkN8m9ZPbJlZhwxaO6lOVSgI9nUB5KX3v39zOT6sJKWo0Z4BvrJUJuJxFQGkUb
	 9h+G1A1sdlBQgEBvi6ShxmshCkWyhoF63aUEm6LYVAFQ6zz6FdtvDQ8LwGQjlCxjDb
	 dHytJWcacmMTGkRtyEBqjTesdhpB0ysmVJb8Wn+8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Pavel Machek <pavel@ucw.cz>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 402/451] leds: lp50xx: Get rid of redundant check in lp50xx_enable_disable()
Date: Thu, 15 Jan 2026 17:50:03 +0100
Message-ID: <20260115164245.481384446@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164230.864985076@linuxfoundation.org>
References: <20260115164230.864985076@linuxfoundation.org>
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

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

[ Upstream commit 5d2bfb3fb95b2d448c0fbcaa2c58b215b2fa87fc ]

Since GPIO is optional the API is NULL aware and will check descriptor anyway.
Remove duplicate redundant check in lp50xx_enable_disable().

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Pavel Machek <pavel@ucw.cz>
Stable-dep-of: 434959618c47 ("leds: leds-lp50xx: Enable chip before any communication")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/leds/leds-lp50xx.c |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

--- a/drivers/leds/leds-lp50xx.c
+++ b/drivers/leds/leds-lp50xx.c
@@ -380,11 +380,9 @@ static int lp50xx_enable_disable(struct
 {
 	int ret;
 
-	if (priv->enable_gpio) {
-		ret = gpiod_direction_output(priv->enable_gpio, enable_disable);
-		if (ret)
-			return ret;
-	}
+	ret = gpiod_direction_output(priv->enable_gpio, enable_disable);
+	if (ret)
+		return ret;
 
 	if (enable_disable)
 		return regmap_write(priv->regmap, LP50XX_DEV_CFG0, LP50XX_CHIP_EN);


