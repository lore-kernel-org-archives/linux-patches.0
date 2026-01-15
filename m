Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B12325228D;
	Thu, 15 Jan 2026 16:56:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768496165; cv=none; b=Ty3GLIJq8jYIC37PhUDyd3HgtP6mvprAbQd3PzHfhPYM+PZoTFy04lhg6BoyxHgMTM13HYBMLACtAZv5NL9bEbDU1GRr8taELT+Y7DKzt6lHLhRRrg6rVv3GrwTH7oeJD10JngXlXa0IcAFXFLEsUHZyctqet6Q9tm8V2m56M/A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768496165; c=relaxed/simple;
	bh=sjq8KJ4oENh2JYLAmw04qFNVg0QdgAgDpCnIJSJrhkM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RAC7l+ovC6PJWxJ94F3pz/r2lL8fZT73zLq1KT36JkOYBkQrCGbIsUp3SSZ41Ah53Zth6toOnN1j582UpxvhMOw3LKytxZGbl5vDqw6G9d4Kr6/zICUAfxP7yQtc7TYhJisoHNUsyP3fCvfAJdjSBS9ASjXcLSYPgfOUi4+C3LE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=h6cN1SV2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="h6cN1SV2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0254C116D0;
	Thu, 15 Jan 2026 16:56:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768496165;
	bh=sjq8KJ4oENh2JYLAmw04qFNVg0QdgAgDpCnIJSJrhkM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=h6cN1SV20QNxITOvRpPyzt9cT1I26O69m5eMKJ1pXStugYTsIC+Apza73oah1dew7
	 GqGrSq6Zpt/W8kzP8emHvRyw4liPu/NLaFZCY5Eox0OxfPNcgR0lH/d+4/8zpBpTtm
	 5EsxHcVX3C29HP48Xt00g4awzDxzMt1vT0y3IkwY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Gibson <daniel@gibson.sh>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 073/181] gpio: it87: balance superio enter/exit calls in error path
Date: Thu, 15 Jan 2026 17:46:50 +0100
Message-ID: <20260115164204.959139064@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164202.305475649@linuxfoundation.org>
References: <20260115164202.305475649@linuxfoundation.org>
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

From: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>

[ Upstream commit a05543d6b05ba998fdbb4b383319ae5121bb7407 ]

We always call superio_enter() in it87_gpio_direction_out() but only
call superio_exit() if the call to it87_gpio_set() succeeds. Move the
label to balance the calls in error path as well.

Fixes: ef877a159072 ("gpio: it87: use new line value setter callbacks")
Reported-by: Daniel Gibson <daniel@gibson.sh>
Closes: https://lore.kernel.org/all/bd0a00e3-9b8c-43e8-8772-e67b91f4c71e@gibson.sh/
Link: https://lore.kernel.org/r/20251210055026.23146-1-bartosz.golaszewski@oss.qualcomm.com
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpio-it87.c | 11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

diff --git a/drivers/gpio/gpio-it87.c b/drivers/gpio/gpio-it87.c
index 5d677bcfccf26..2ad3c239367bc 100644
--- a/drivers/gpio/gpio-it87.c
+++ b/drivers/gpio/gpio-it87.c
@@ -12,6 +12,7 @@
 
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
+#include <linux/cleanup.h>
 #include <linux/init.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
@@ -241,23 +242,17 @@ static int it87_gpio_direction_out(struct gpio_chip *chip,
 	mask = 1 << (gpio_num % 8);
 	group = (gpio_num / 8);
 
-	spin_lock(&it87_gpio->lock);
+	guard(spinlock)(&it87_gpio->lock);
 
 	rc = superio_enter();
 	if (rc)
-		goto exit;
+		return rc;
 
 	/* set the output enable bit */
 	superio_set_mask(mask, group + it87_gpio->output_base);
 
 	rc = it87_gpio_set(chip, gpio_num, val);
-	if (rc)
-		goto exit;
-
 	superio_exit();
-
-exit:
-	spin_unlock(&it87_gpio->lock);
 	return rc;
 }
 
-- 
2.51.0



