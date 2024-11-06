Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFC601DED58;
	Wed,  6 Nov 2024 12:27:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730896033; cv=none; b=J7saQ6ehG9BCjnnk1V+M5CKcqhutaRByWwKvVybJ8/jztssZVKUbA1WRCBp6bPrWFitdWeK0aIT4Wm7FJLj0b/Qix5oQqIzh1AhW/XHbQrxTj4enNO1+tQL5Oe6nWUJ20jaaZakLA3MOzcs1OaD9rr6yV55XthhV5UOSor0dXnY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730896033; c=relaxed/simple;
	bh=EiYADMrWp0EBzf+Z5Nocq/ohorrjBqJ5KkCLmJgvZx8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CAm6WH/KVe1G1+l49QjZPfStWe3Y+FltES3ty2/A3hSEs5mYu/VPZQlYw9rsw801hHoHz2Uw/hsiA/+Je3hjgi48xXK0FQBtgcAqKrwhJ2vWYCkD1Ps3JeMpFZ0SltR9q+jwmH78KMXsnz7f4JKXs5ROYNz31tb+1QwUILv+eh8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WzTWFKRy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WzTWFKRy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD894C4CECD;
	Wed,  6 Nov 2024 12:27:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730896033;
	bh=EiYADMrWp0EBzf+Z5Nocq/ohorrjBqJ5KkCLmJgvZx8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WzTWFKRy05T0wYSNVFHwb2fte7qreZwAang1pT6m8btTSniZw0s0CkyQzo4SZQnqR
	 TURbIKHpBh98Kgl3vJAQ5rTj2YHszKRvPqCCIeVouugvsLhVhRY59tLyvte8ikfweF
	 +gLdMHnX+P3FCJOOwfr7AzcfBtJxs6/ZxaEl6LZE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wolfram Sang <wsa+renesas@sang-engineering.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 067/245] gpio: sloppy-logic-analyzer: Check for error code from devm_mutex_init() call
Date: Wed,  6 Nov 2024 13:02:00 +0100
Message-ID: <20241106120320.856680549@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120319.234238499@linuxfoundation.org>
References: <20241106120319.234238499@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

[ Upstream commit 90bad749858cf88d80af7c2b23f86db4f7ad61c2 ]

Even if it's not critical, the avoidance of checking the error code
from devm_mutex_init() call today diminishes the point of using devm
variant of it. Tomorrow it may even leak something. Add the missed
check.

Fixes: 7828b7bbbf20 ("gpio: add sloppy logic analyzer using polling")
Reviewed-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Link: https://lore.kernel.org/r/20241030174132.2113286-3-andriy.shevchenko@linux.intel.com
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpio-sloppy-logic-analyzer.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/gpio/gpio-sloppy-logic-analyzer.c b/drivers/gpio/gpio-sloppy-logic-analyzer.c
index aed6d1f6cfc30..6440d55bf2e1f 100644
--- a/drivers/gpio/gpio-sloppy-logic-analyzer.c
+++ b/drivers/gpio/gpio-sloppy-logic-analyzer.c
@@ -235,7 +235,9 @@ static int gpio_la_poll_probe(struct platform_device *pdev)
 	if (!priv)
 		return -ENOMEM;
 
-	devm_mutex_init(dev, &priv->blob_lock);
+	ret = devm_mutex_init(dev, &priv->blob_lock);
+	if (ret)
+		return ret;
 
 	fops_buf_size_set(priv, GPIO_LA_DEFAULT_BUF_SIZE);
 
-- 
2.43.0



