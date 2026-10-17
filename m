Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3E1D3A2540;
	Sat, 17 Oct 2026 18:09:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792260546; cv=none; b=gp43JJHIHCL5FYsI/vtHiBR7KbIw/UXw9fUyjIYS2odbcRNjrskATxA2mKWPUPcsljanv1MCvMmXDreHOvGIR1IFkbYSHGvdyZ+oCr3tnt/0FSzfvzTvGaL5wppX9q6i4XOfT0PImTYo0RhyamRkCX33p+snA565CZWaTVmjoIQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792260546; c=relaxed/simple;
	bh=3U6chij0kpdMihNe96coCMQG7L0qjA+Pt2JfIiAVh8c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lWYLMmyqt7U5PKN2e9xMXtc8HMwV8QRIxWOor2T7zxsjCJVjp8GhM66BA8Ax2rXawahv6RAF5MxVzHcSLK97PqoN0jxDBf52jNePhDOXGfXJ3M6UuCmorDCzTUezh5soriqXCrPMR5whaz0vLE61w3P4LHbP2X2V1pCxoo6CeYk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=w2NqV+eI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="w2NqV+eI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BC101F000C4;
	Sat, 17 Oct 2026 18:09:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792260544;
	bh=tin2lT5iBHIS6FM9DgDJlx8UclKBD9vfkUyUCbkrFCg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=w2NqV+eIZf8K5o2jd0aCI/OgHjKpk+beqQV3pwqKXqpM9FwiPCr3lctM8O2NcHu2t
	 EvkZEVsD/SDQtJKsduzhEwUri/nm1TYqEuxqn1qD1LJ4tjDNjGDDebKSVLUQPyL+TZ
	 x1I+Wwkv8BBFswDF9sBW/jCX2YA2guJKEIUXljac=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen-Yu Tsai <wenst@chromium.org>,
	Linus Walleij <linusw@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1543/1674] pinctrl: mediatek: paris: bypass pinctrl GPIO layer in set GPIO direction
Date: Sat, 17 Oct 2026 18:03:35 +0200
Message-ID: <20261017160510.716478688@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chen-Yu Tsai <wenst@chromium.org>

[ Upstream commit c87c9046c4e00d599454e033a477176c4d73ac2a ]

pinctrl_gpio_direction_input() / pinctrl_gpio_direction_output() take
the pinctrl mutex. This causes a gpiochip operations to need to sleep.
Worse yet, the .can_sleep field in the gpiochip is not set. This causes
the shared GPIO proxy to trip over, as it uses gpiod_cansleep() to check
whether it can use a spinlock or needs a mutex. In this case, it ends
up taking a spinlock, then calls pinctrl_gpio_direction_output(), which
takes a mutex. This causes a huge warning.

While this class of Mediatek hardware does not have separate clear/set
registers, the pinctrl context has a spinlock that is taken whenever
a register read-modify-write is done. Also, once the GPIO function is
selected / muxed in, further GPIO operations do not involve pinctrl
operations or state. The GPIO direction and level values do not require
toggling the pinmux or any other pin config options.

Switch to directly calling mtk_pinmux_gpio_set_direction() in the GPIO
set direction callbacks to avoid taking the pinctrl mutex. Drop the
.gpio_set_direction field in mtk_pmxops to signal we are no longer using
the pinctrl GPIO layer for setting the direction.

Signed-off-by: Chen-Yu Tsai <wenst@chromium.org>
Signed-off-by: Linus Walleij <linusw@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/mediatek/pinctrl-paris.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/pinctrl/mediatek/pinctrl-paris.c b/drivers/pinctrl/mediatek/pinctrl-paris.c
index 972035ab86237..b2c99f0facf99 100644
--- a/drivers/pinctrl/mediatek/pinctrl-paris.c
+++ b/drivers/pinctrl/mediatek/pinctrl-paris.c
@@ -775,7 +775,6 @@ static const struct pinmux_ops mtk_pmxops = {
 	.get_function_name	= mtk_pmx_get_func_name,
 	.get_function_groups	= mtk_pmx_get_func_groups,
 	.set_mux		= mtk_pmx_set_mux,
-	.gpio_set_direction	= mtk_pinmux_gpio_set_direction,
 	.gpio_request_enable	= mtk_pinmux_gpio_request_enable,
 };
 
@@ -904,7 +903,7 @@ static int mtk_gpio_direction_input(struct gpio_chip *chip, unsigned int gpio)
 	if (gpio >= hw->soc->npins)
 		return -EINVAL;
 
-	return pinctrl_gpio_direction_input(chip, gpio);
+	return mtk_pinmux_gpio_set_direction(hw->pctrl, NULL, gpio, true);
 }
 
 static int mtk_gpio_direction_output(struct gpio_chip *chip, unsigned int gpio,
@@ -917,7 +916,7 @@ static int mtk_gpio_direction_output(struct gpio_chip *chip, unsigned int gpio,
 
 	mtk_gpio_set(chip, gpio, value);
 
-	return pinctrl_gpio_direction_output(chip, gpio);
+	return mtk_pinmux_gpio_set_direction(hw->pctrl, NULL, gpio, false);
 }
 
 static int mtk_gpio_to_irq(struct gpio_chip *chip, unsigned int offset)
-- 
2.53.0



