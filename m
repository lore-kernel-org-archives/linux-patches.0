Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B20843E071;
	Tue, 21 Jul 2026 22:28:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784672907; cv=none; b=jfrSA3c4DWKwmdjX1fHsn5u5WKdg3cDQAPHggIMgNFPIactLqPzxvzGLESEMtLSp28tdkr+eV/6dqWTwYlXF8v9KUTIB/Nj02UuCA/DqudkMy6TiVBRhlpOohlIQ8VHawZe2LXYusrk2fszLTMas6HTHDkgvqnHo1DoHDFuDsAA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784672907; c=relaxed/simple;
	bh=SnGm9kK4KD07znpIDns024YXt7x2EGiog01KwalBJBw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ds9+ccbc7fOOtsxUPORr0WgsFONBqCiVWgbTBj3sQJDdZdgK5UHik3IHOzMpaEFtuOkzMyJGipZEw54CAPJckxTxj3md83JR2SSqoNpnNTQc3IMe0ok2NZiio4GvfUVlFscGiJIETQf8WpPf/4TsguzbcC0aMDoMoTzXKc312kg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EswWUQdm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EswWUQdm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8600A1F000E9;
	Tue, 21 Jul 2026 22:28:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784672899;
	bh=28iGLy4Htpb7HsXZMjM+KR3NDsiTsfvVAKUJnOU6YpM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EswWUQdmkTzRySkAiSwcFxH08n2J2tdQhYXpCB5rAlWGuJuQjOFJSMaznhUM2/r4g
	 mHij9y/6biVOCVDk+qJCs7XugA5Ipha7GR2aPmHC4d4Hrddi28utgw2xi5hpceTC2/
	 ielsDAyaM24vHueu6ZvTTSFOIHAcN9UpuqEc8u5Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 772/843] gpio: sch: use new GPIO line value setter callbacks
Date: Tue, 21 Jul 2026 17:26:47 +0200
Message-ID: <20260721152423.420940424@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152405.946368001@linuxfoundation.org>
References: <20260721152405.946368001@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>

[ Upstream commit 883c7eb2c4a9e143b2662ba754f9c16fb31adced ]

struct gpio_chip now has callbacks for setting line values that return
an integer, allowing to indicate failures. Convert the driver to using
them.

Acked-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Link: https://lore.kernel.org/r/20250625-gpiochip-set-rv-gpio-round2-v1-3-bc110a3b52ff@linaro.org
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Stable-dep-of: 286533cb14a3 ("gpio: sch: use raw_spinlock_t in the irq startup path")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpio/gpio-sch.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

--- a/drivers/gpio/gpio-sch.c
+++ b/drivers/gpio/gpio-sch.c
@@ -116,7 +116,7 @@ static int sch_gpio_get(struct gpio_chip
 	return sch_gpio_reg_get(sch, gpio_num, GLV);
 }
 
-static void sch_gpio_set(struct gpio_chip *gc, unsigned int gpio_num, int val)
+static int sch_gpio_set(struct gpio_chip *gc, unsigned int gpio_num, int val)
 {
 	struct sch_gpio *sch = gpiochip_get_data(gc);
 	unsigned long flags;
@@ -124,6 +124,8 @@ static void sch_gpio_set(struct gpio_chi
 	spin_lock_irqsave(&sch->lock, flags);
 	sch_gpio_reg_set(sch, gpio_num, GLV, val);
 	spin_unlock_irqrestore(&sch->lock, flags);
+
+	return 0;
 }
 
 static int sch_gpio_direction_out(struct gpio_chip *gc, unsigned int gpio_num,
@@ -145,8 +147,7 @@ static int sch_gpio_direction_out(struct
 	 * But we cannot prevent a short low pulse if direction is set to high
 	 * and an external pull-up is connected.
 	 */
-	sch_gpio_set(gc, gpio_num, val);
-	return 0;
+	return sch_gpio_set(gc, gpio_num, val);
 }
 
 static int sch_gpio_get_direction(struct gpio_chip *gc, unsigned int gpio_num)
@@ -165,7 +166,7 @@ static const struct gpio_chip sch_gpio_c
 	.direction_input	= sch_gpio_direction_in,
 	.get			= sch_gpio_get,
 	.direction_output	= sch_gpio_direction_out,
-	.set			= sch_gpio_set,
+	.set_rv			= sch_gpio_set,
 	.get_direction		= sch_gpio_get_direction,
 };
 


