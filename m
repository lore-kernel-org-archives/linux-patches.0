Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B211D46D560;
	Tue, 21 Jul 2026 15:46:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784648776; cv=none; b=YsGjtCyqDbIt9X7ALw1/fAGR3l/3V3875g8kVVGNYgP9dnmwOSB8EOTgKbaAzulGQ0+ZwCYrhpUVw2W/wHXaHHl1GInLQ2cKC3/0g8ByW+0Wwe7dnA4iUjLd+GC9SrjNZ8xTSI8sUNfjEbEiVgU+F0tug8CWUv8IrvY3HleRhUM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784648776; c=relaxed/simple;
	bh=NRwA7DssgMAkIjfbZBHOO4TzPRi0namnzkdE40hQw+4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WaJ5br4zSX9dA/IHDeQ18aCsTXDCkqXi/CgVNiMMMaOvK6oysUWvbglmKAU9qVDZ6iD8k7LCNWLDjbj+OIssxf1xsgqe8u8MM5c3EX/bNR9i6lm7kkb2Y4Gw1tII6MX/k6ubBd3QavAdMKdKyoTZQC+aw63vPHGAUpgI+8RwGHM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Qqxvw+9h; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Qqxvw+9h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 230601F00A3A;
	Tue, 21 Jul 2026 15:46:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784648775;
	bh=pqG/TWdsLo2z9j4hbnN8Xx48ptdtnUieS8s3vowfzQ4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Qqxvw+9h0MVWzwyUj8Xk5s7PPWMAyH+8qXA4Bd1jK0dmOmh39dIj8n/rJwlGaOk8T
	 9Nju9orxq2IYrVS7HtNAeFH/Rc2l4mRMKZ09mp+lQpOZxjhoQOCIwXqe03MEB5jWHO
	 zpqtl3roliStO0L2lnr7GfuDr3jF53dXgipOVarc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Charles Keepax <ckeepax@opensource.cirrus.com>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Linus Walleij <linusw@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0328/2077] pinctrl: cs42l43: Fix leaked pm reference on error path
Date: Tue, 21 Jul 2026 17:00:01 +0200
Message-ID: <20260721152600.418101440@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Charles Keepax <ckeepax@opensource.cirrus.com>

[ Upstream commit 1cb73b83ab6dec8159d0280345a46fbb282c378f ]

Returning directly if the regmap_update_bits() fails causes a pm runtime
reference to be leaked, let things run to the end of the function
instead.

Fixes: e52c741907fb ("pinctrl: cirrus: cs42l43: use new GPIO line value setter callbacks")
Signed-off-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Reviewed-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Signed-off-by: Linus Walleij <linusw@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/cirrus/pinctrl-cs42l43.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/pinctrl/cirrus/pinctrl-cs42l43.c b/drivers/pinctrl/cirrus/pinctrl-cs42l43.c
index 227c37c360e19a..3cc18352060770 100644
--- a/drivers/pinctrl/cirrus/pinctrl-cs42l43.c
+++ b/drivers/pinctrl/cirrus/pinctrl-cs42l43.c
@@ -499,12 +499,10 @@ static int cs42l43_gpio_set(struct gpio_chip *chip, unsigned int offset,
 
 	ret = regmap_update_bits(priv->regmap, CS42L43_GPIO_CTRL1,
 				 BIT(shift), value << shift);
-	if (ret)
-		return ret;
 
 	pm_runtime_put(priv->dev);
 
-	return 0;
+	return ret;
 }
 
 static int cs42l43_gpio_direction_out(struct gpio_chip *chip,
-- 
2.53.0



