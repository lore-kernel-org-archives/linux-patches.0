Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38B4046D086;
	Tue, 21 Jul 2026 17:47:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784656038; cv=none; b=SP52gJuStCWkN8EucuAv/aFnMVNZK05tb8GhIlEKH6CQ98pxEmYGBtWuX9a8szuAfRzfKHCAEJKqBpH1GKLkbKPdnuiiNJdRjt4lerB5ezHUyjOWKjZyj8Ok/2X9MIZyaXtcWVTGN87WIZ0/uiKEW/FjCeF3O7KT0IGUyNnsHt0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784656038; c=relaxed/simple;
	bh=ciwKutJCksdLTeveVnun7IJ1p4dhT46xjc3bznKRfiM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pgjv/MubwF1pKkZJMh4TzITp+ew9z4P5lQpPUejBzJjVTGcYTSDN+4ApatK23l+BjOMDqGblJ3VrVP+VBjY+Itz4tWKxsLg8VnG4tbHEysyBA5Cfp3R3SQ7SGiDWMN903UYgj6YBIFmxrUr6Q2mt3BMYOCPp+IbWfmfA4Mw1iKQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MswJDmMx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MswJDmMx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F2C01F00A3A;
	Tue, 21 Jul 2026 17:47:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784656036;
	bh=Yp0zHYgypyW3aB7IgUlpCyiYGZKNc7Fu3lOq6IsJjO0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MswJDmMxK1p7gAgTb2+HEKiJ7ofpKKVaTh6PxcYvgaf5tmUWW4jz5+f5xHScygYHB
	 muM43pMKtFsWEAqKlRk+CwrfgS3StC8NU8RXgavbLwOr1wc3FEINAa00Hb9N3t52yH
	 lfN1K2aGvAXGY5DvY4coD/4X890+ZpTxIU3fZZP4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Charles Keepax <ckeepax@opensource.cirrus.com>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Linus Walleij <linusw@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0233/1611] pinctrl: cs42l43: Fix leaked pm reference on error path
Date: Tue, 21 Jul 2026 17:05:49 +0200
Message-ID: <20260721152520.250784710@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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



