Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B5191C07
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 16:24:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23E76C433D2;
	Wed, 28 Dec 2022 16:24:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672244641;
	bh=qCQ80+QQo12orqyGZ6uPIYTEipujiuUJsbMwyPWVve8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ooNOA05d4TAPzXcZabP7sKmPiJrf6lHQcWx66/MV8QpqwyJQ9ylk9ED3C1Yn4ox5i
	 q1cRRLRQQA62KCruBcCwkUm7fHvZ9VjH427DlQoXDm7fmtdJ8fKPpva4/Hp63K+Ff7
	 RFvznDG7nml4qwDDK0k382cp08ayoVUlWEHtKTnw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhang Qilong <zhangqilong3@huawei.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0746/1073] power: supply: z2_battery: Fix possible memleak in z2_batt_probe()
Date: Wed, 28 Dec 2022 15:38:54 +0100
Message-Id: <20221228144348.286080052@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Zhang Qilong <zhangqilong3@huawei.com>

[ Upstream commit 955bee204f3dd307642c101b75e370662987e735 ]

If devm_gpiod_get_optional() returns error, the charger should be
freed before z2_batt_probe returns according to the context. We
fix it by just gotoing to 'err' branch.

Fixes: a3b4388ea19b ("power: supply: z2_battery: Convert to GPIO descriptors")
Signed-off-by: Zhang Qilong <zhangqilong3@huawei.com>
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/power/supply/z2_battery.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/power/supply/z2_battery.c b/drivers/power/supply/z2_battery.c
index 7ed4e4bb26ec..fd33cdf9cf12 100644
--- a/drivers/power/supply/z2_battery.c
+++ b/drivers/power/supply/z2_battery.c
@@ -206,10 +206,12 @@ static int z2_batt_probe(struct i2c_client *client,
 
 	charger->charge_gpiod = devm_gpiod_get_optional(&client->dev,
 							NULL, GPIOD_IN);
-	if (IS_ERR(charger->charge_gpiod))
-		return dev_err_probe(&client->dev,
+	if (IS_ERR(charger->charge_gpiod)) {
+		ret = dev_err_probe(&client->dev,
 				     PTR_ERR(charger->charge_gpiod),
 				     "failed to get charge GPIO\n");
+		goto err;
+	}
 
 	if (charger->charge_gpiod) {
 		gpiod_set_consumer_name(charger->charge_gpiod, "BATT CHRG");
-- 
2.35.1



