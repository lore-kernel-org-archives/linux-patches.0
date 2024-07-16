Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA10F1DDCE;
	Tue, 16 Jul 2024 16:07:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721146061; cv=none; b=vGLgC5nxEvRZj/iV+izyQgibc0Ld6iFrJTKibDgpPuM6D9ogkMEWRsSjYYVegaH/RbwZKF57OIEWrYbyIePnt+VWKOA/R5CJqumZ3iL4qF16vWgQKD0zaiCsgwYgyEDiZzt1xCXMtHSifOiIAdRi1ajMA+gwO/4Dekn0N/1cYdw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721146061; c=relaxed/simple;
	bh=9cG682PTMYJCRk1NS0GUu/KmJXg+EHcSWR3I1W+NX1U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DJKitCRtckjMrmzQULSh0cfAb7y0+cwnhT7SI4GrQFi0QlztwK2xlT9oqVFaLOLJ5C533tE6zyDJ1/645ydM5wvKcB3cfheEn5a+mRDjrV4+cDwjtvXFueciOAJKEulE+WBccv8m0/UlVgFE+AAhPKcnMg3uDGkOWQbZlBYLClE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GJ0RRqGA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GJ0RRqGA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67865C4AF0D;
	Tue, 16 Jul 2024 16:07:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721146060;
	bh=9cG682PTMYJCRk1NS0GUu/KmJXg+EHcSWR3I1W+NX1U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GJ0RRqGACD3vIZcujXwdTn+kfPsEtbtnWsB+uv/hSHDk/YANWKBOw+GJ+7Cqa2gRn
	 GHLwcBc6hpn4An/Qf4F87IN16CfgminsweNrVwlZOJK038dpaDAEaqwFWZOHHALAoa
	 tRX1MHIpbHTMKX3fjXSQUb19z1lfHZRvT/STEeiw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linus Walleij <linus.walleij@linaro.org>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 044/144] gpiolib: of: add a quirk for reset line polarity for Himax LCDs
Date: Tue, 16 Jul 2024 17:31:53 +0200
Message-ID: <20240716152754.238984688@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240716152752.524497140@linuxfoundation.org>
References: <20240716152752.524497140@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Dmitry Torokhov <dmitry.torokhov@gmail.com>

[ Upstream commit 99d18d42c942854a073191714a311dc2420ec7d3 ]

Existing DTS that use legacy (non-standard) property name for the reset
line "gpios-reset" also specify incorrect polarity (0 which maps to
"active high"). Add a quirk to force polarity to "active low" so that
once driver is converted to gpiod API that pays attention to line
polarity it will work properly.

Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Stable-dep-of: f8d76c2c313c ("gpiolib: of: add polarity quirk for TSC2005")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpiolib-of.c | 36 ++++++++++++++++++++++++++++++++++++
 1 file changed, 36 insertions(+)

diff --git a/drivers/gpio/gpiolib-of.c b/drivers/gpio/gpiolib-of.c
index e9da0d5017c02..7a77d9cd9c774 100644
--- a/drivers/gpio/gpiolib-of.c
+++ b/drivers/gpio/gpiolib-of.c
@@ -152,11 +152,47 @@ static void of_gpio_quirk_polarity(const struct device_node *np,
 	}
 }
 
+/*
+ * This quirk does static polarity overrides in cases where existing
+ * DTS specified incorrect polarity.
+ */
+static void of_gpio_try_fixup_polarity(const struct device_node *np,
+				       const char *propname,
+				       enum of_gpio_flags *flags)
+{
+	static const struct {
+		const char *compatible;
+		const char *propname;
+		bool active_high;
+	} gpios[] = {
+#if !IS_ENABLED(CONFIG_LCD_HX8357)
+		/*
+		 * Himax LCD controllers used incorrectly named
+		 * "gpios-reset" property and also specified wrong
+		 * polarity.
+		 */
+		{ "himax,hx8357",	"gpios-reset",	false },
+		{ "himax,hx8369",	"gpios-reset",	false },
+#endif
+	};
+	unsigned int i;
+
+	for (i = 0; i < ARRAY_SIZE(gpios); i++) {
+		if (of_device_is_compatible(np, gpios[i].compatible) &&
+		    !strcmp(propname, gpios[i].propname)) {
+			of_gpio_quirk_polarity(np, gpios[i].active_high, flags);
+			break;
+		}
+	}
+}
+
 static void of_gpio_flags_quirks(const struct device_node *np,
 				 const char *propname,
 				 enum of_gpio_flags *flags,
 				 int index)
 {
+	of_gpio_try_fixup_polarity(np, propname, flags);
+
 	/*
 	 * Some GPIO fixed regulator quirks.
 	 * Note that active low is the default.
-- 
2.43.0



