Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23FD5223328;
	Thu, 28 May 2026 20:31:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780000272; cv=none; b=bcodSECsA6ToGPHO64VAUNKPNdXaBAeBJTBWHqzlGrNuK8WNm0WX7iKLFlFONWCaww0EFPL9nqGlweUz1l/E4++3I3W/AACDAwYM1qaWcOwX/HJa0qhvr9DOLyZFIVBtV8J3zNXII9d/NN1Egr75Mn7wDQauTLmDBnG/DsjxA/8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780000272; c=relaxed/simple;
	bh=rS8iBk0fESQHbBkRGevtqb4BV0LpFAR6SQBFreztM+g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=js4qG7jId/cWj++W3ax0+SiUPGICNEOhXu7NZdMnJ8ZOy96BoR/r/RBmxrjDvz78LJfHt44JRAyzykbwzu877ahAsIe+l4ImAZde10U6CEoUb4RAXgwg7Uyk/rRhE2/IF25Wpgvoc7o89Mw5iD6qEhV5aeiZ076+Ec9gUE0pOCI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tUWjX6yu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tUWjX6yu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8363D1F000E9;
	Thu, 28 May 2026 20:31:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780000271;
	bh=mjv/NFaEWDyw/WiYV1zrOQNQF8+GAYhfqyTQIuJFdo0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tUWjX6yuqw8yT2F4zXa9FUypSH+wKCJDl2S5WxTqOmgWVV9yg1aW2F3u7hTEPQ3wZ
	 G8RD1o3qO3Weh3x2uNpmJUd/vcFir6QFBuDeyyyS8znJGUA1h7zW2Ygt0uCDdcPv94
	 T4k5VCjE/lE+eQiUqQI09ltVp+r3z49bMHg85oWE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 364/377] gpio: aggregator: remove the software node when deactivating the aggregator
Date: Thu, 28 May 2026 21:50:02 +0200
Message-ID: <20260528194648.968314451@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194638.371537336@linuxfoundation.org>
References: <20260528194638.371537336@linuxfoundation.org>
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

[ Upstream commit 61fef83f239ecace1cce716135762a2d9b7b1fc6 ]

The dynamic software node we create for the aggregator platform device
when using configfs is leaked when the device is deactivated. Destroy it
as the last step in the tear-down path.

Fixes: 86f162e73d2d ("gpio: aggregator: introduce basic configfs interface")
Reported-by: Geert Uytterhoeven <geert@linux-m68k.org>
Closes: https://lore.kernel.org/all/CAMuHMdVZ=XUvJTGdDAjnkxgtw7Uvnn61iOy3XN_5XNZM2anctw@mail.gmail.com/
Link: https://patch.msgid.link/20260520121631.33976-1-bartosz.golaszewski@oss.qualcomm.com
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpio-aggregator.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/gpio/gpio-aggregator.c b/drivers/gpio/gpio-aggregator.c
index 23987c38a2468..8cbebcb4bb1f9 100644
--- a/drivers/gpio/gpio-aggregator.c
+++ b/drivers/gpio/gpio-aggregator.c
@@ -992,11 +992,15 @@ static int gpio_aggregator_activate(struct gpio_aggregator *aggr)
 
 static void gpio_aggregator_deactivate(struct gpio_aggregator *aggr)
 {
+	struct fwnode_handle *swnode;
+
+	swnode = dev_fwnode(&aggr->pdev->dev);
 	platform_device_unregister(aggr->pdev);
 	aggr->pdev = NULL;
 	gpiod_remove_lookup_table(aggr->lookups);
 	kfree(aggr->lookups->dev_id);
 	kfree(aggr->lookups);
+	fwnode_remove_software_node(swnode);
 }
 
 static void gpio_aggregator_lockup_configfs(struct gpio_aggregator *aggr,
-- 
2.53.0



