Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 040F032ABC0;
	Thu, 28 May 2026 20:13:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779999186; cv=none; b=Go6UCO0y1yi2T04lIKDwzpODCi5vgXH3O7cxyKlvJ/kPaWn07RXKWhToPesDY/zriBOPo9tr8ERgyWhd3Cvr7sq3F9bb61AD+PzHSDoEZrijxIxrL7RGP8LLAdaNMtrxxEt8GUMGvs3B12Fz5aMF280QqMkVyFfaqxdc5ou0qB4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779999186; c=relaxed/simple;
	bh=MsjbIXFLFODKvA4O9o6+ZOLSKHar5XGTbEhVrVT34gI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ljJ7F7goy3qCRb05HH9O3k+wQt20bZMLz9wCg9h3GAN4ljdTP/kdWICrRJo33ULiDTh8PB9rXaKZcE+UFdHggApQ/RV+4QmMxMgm/i83csdWkbmgxAqRWoGryBrc5I9l3HXOVEB6JcoavhkNLIV8GDIpoaaGsWTTJRxZ3USEPXU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=l6+HFfKd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="l6+HFfKd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 622E81F000E9;
	Thu, 28 May 2026 20:13:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779999185;
	bh=MjW0U4O9Mz8mFNhPLcTdO2PDO7xKs52GG0YakzL+sBE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=l6+HFfKdYkTmIImfuMAPq5EscYWNGYjOAQ+OvFl9mQqGGEI6nyTbcC9GvTv3Vi8vV
	 cfdmeYpbZsBeKuI1SNIaE8S+ClnQQ/dQitiYpiY9DCXjD0OtzNT7Fj/gA1S6n3VYIY
	 0SEiNEZjTDYYz5oiju+fuNQ/aHMM5SmhYnHS2zlE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 440/461] gpio: aggregator: lock device when calling device_is_bound()
Date: Thu, 28 May 2026 21:49:29 +0200
Message-ID: <20260528194700.266421275@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194646.819809818@linuxfoundation.org>
References: <20260528194646.819809818@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>

[ Upstream commit 598a2b3e2e0e6aa2e9f7843c96c45b5ea11e0411 ]

The kerneldoc for device_is_bound() says it must be called with the
device lock taken. Add missing synchronization to this driver.

Fixes: 3a27f40b4570 ("gpio: aggregator: stop using dev-sync-probe")
Link: https://patch.msgid.link/20260518-gpio-dev-lock-v1-2-cc4736f3ff0b@oss.qualcomm.com
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpio-aggregator.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/gpio/gpio-aggregator.c b/drivers/gpio/gpio-aggregator.c
index a9ad809708fb6..bc6699a821ee7 100644
--- a/drivers/gpio/gpio-aggregator.c
+++ b/drivers/gpio/gpio-aggregator.c
@@ -968,9 +968,12 @@ static int gpio_aggregator_activate(struct gpio_aggregator *aggr)
 	}
 
 	wait_for_device_probe();
-	if (!device_is_bound(&pdev->dev)) {
-		ret = -ENXIO;
-		goto err_unregister_pdev;
+
+	scoped_guard(device, &pdev->dev) {
+		if (!device_is_bound(&pdev->dev)) {
+			ret = -ENXIO;
+			goto err_unregister_pdev;
+		}
 	}
 
 	aggr->pdev = pdev;
-- 
2.53.0



