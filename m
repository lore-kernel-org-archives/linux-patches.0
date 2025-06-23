Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C81D0225413;
	Mon, 23 Jun 2025 22:25:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750717543; cv=none; b=GkO17Z5aGTVE/3t3rTGfnzN6KifWEcF/uj1Z1ZXwbqOrjW8lobu9rlZe7pq+4aiHVLbtFF9W3KvF+DYOYlHok21zo3gxGqhuCjaEOrwkKHvin/xM0oardUaUqBmzzNEdvVTRpiL2sc+RKY7oDTJ3Z+1twjf+M990sHcJPQo06DQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750717543; c=relaxed/simple;
	bh=Fuip1V9n033WdY+s9DecuMl7u7nkalfglGtQAitBjVQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FvyWY7LjQRxISwISMhkxj4+ExUdwPP5ZbJmJeXY3yh+V2ailcxWu1jhxnn6o0NqpRzj9WQYzdHlJf3h88xj4GXn8ZSzML9vz8kMOiekh6NwLq3I4UJEQqcnFhnPR6nWPavfwizUxvR/5emH+PpSJxOPH8cRL2EV8F5HL/1L87+A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KBpg/swe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KBpg/swe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECBF9C4CEEA;
	Mon, 23 Jun 2025 22:25:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750717543;
	bh=Fuip1V9n033WdY+s9DecuMl7u7nkalfglGtQAitBjVQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KBpg/swedxY6GqgLRadv5L29vlhqcAUUXgMDdaunF0EM9Y5kGweUbkjiuqPIuYanr
	 T4qP1c9QAQO2JsHg8sPtRSpXWye4pLimv3H6jPInsHgph+oe3YCfIEeqGh5TaFd/BG
	 ST0qiau/7nmR4ppcyiuNqQgHOPBZlRnlcx/h8Vw8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sascha Hauer <s.hauer@pengutronix.de>,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 410/414] gpio: pca953x: fix wrong error probe return value
Date: Mon, 23 Jun 2025 15:09:07 +0200
Message-ID: <20250623130652.199180451@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130642.015559452@linuxfoundation.org>
References: <20250623130642.015559452@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sascha Hauer <s.hauer@pengutronix.de>

[ Upstream commit 0a1db19f66c0960eb00e1f2ccd40708b6747f5b1 ]

The second argument to dev_err_probe() is the error value. Pass the
return value of devm_request_threaded_irq() there instead of the irq
number.

Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
Fixes: c47f7ff0fe61 ("gpio: pca953x: Utilise dev_err_probe() where it makes sense")
Link: https://lore.kernel.org/r/20250616134503.1201138-1-s.hauer@pengutronix.de
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpio-pca953x.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpio/gpio-pca953x.c b/drivers/gpio/gpio-pca953x.c
index ef3aee1cabcfd..bb7c1bf5f856e 100644
--- a/drivers/gpio/gpio-pca953x.c
+++ b/drivers/gpio/gpio-pca953x.c
@@ -951,7 +951,7 @@ static int pca953x_irq_setup(struct pca953x_chip *chip, int irq_base)
 					IRQF_ONESHOT | IRQF_SHARED, dev_name(dev),
 					chip);
 	if (ret)
-		return dev_err_probe(dev, client->irq, "failed to request irq\n");
+		return dev_err_probe(dev, ret, "failed to request irq\n");
 
 	return 0;
 }
-- 
2.39.5



