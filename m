Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B53F263C90;
	Tue,  8 Apr 2025 11:22:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744111342; cv=none; b=YLGJ9HzL+wvZSqA0IjFWi5Jp+L2c5j4kZh/+X4DlVsatW+jLhmHsnrOtLKtJybflcL7/7NgI/Hj1vLZxDchGkCLxansc/MW0CAbIxLhZDYDqib0JX48kejI51AZtfLsLjI+mMdnjkm7J2Pm5D3Nqf/DWG3Hoivc5k/Dq3NcVLn4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744111342; c=relaxed/simple;
	bh=s0WV1qXWf7qdgcjGVovJie8BY8ZzZZN+je0BGY06GxM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JLFJQLjLq9Pn6sSt1qVLMSTJfFMop96pM8Sav43t48/P+Eeo4ykUBdfkerZRXfEhfvX9732QRhMLdrCTf/kGXEywSmbUUjEj9angBpdHBqaLHqU9d9ImpFn6fvAfKdYB6GwPkFBSmiSyKJF+uuy939U636ydZoMNcJHvqgmlNKo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=h6EpIqcr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="h6EpIqcr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FB1FC4CEE5;
	Tue,  8 Apr 2025 11:22:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744111342;
	bh=s0WV1qXWf7qdgcjGVovJie8BY8ZzZZN+je0BGY06GxM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=h6EpIqcrWPTU4N26VffM4nAvtv6p06pjafXmQQGyaY0su2UotX3ADvLV1fnuDgYi5
	 P+9QNnCxls1rG6UnAsRpAee/fDeUEdJuJEcaB/WtF3PefE17vlJnFMhjTGHj7rcklx
	 J9u5PV6uh4WwxfR9xamEMu5IG97LOPAurKM4Yuw4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <linux@weissschuh.net>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 398/731] leds: st1202: Check for error code from devm_mutex_init() call
Date: Tue,  8 Apr 2025 12:44:55 +0200
Message-ID: <20250408104923.530698644@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Weißschuh <linux@weissschuh.net>

[ Upstream commit 8168906bbb3ba678583422de29e6349407a94bb5 ]

Even if it's not critical, the avoidance of checking the error code
from devm_mutex_init() call today diminishes the point of using devm
variant of it. Tomorrow it may even leak something. Add the missed
check.

Fixes: 259230378c65 ("leds: Add LED1202 I2C driver")
Signed-off-by: Thomas Weißschuh <linux@weissschuh.net>
Link: https://lore.kernel.org/r/20250204-must_check-devm_mutex_init-v2-1-7b6271c4b7e6@weissschuh.net
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/leds/leds-st1202.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/leds/leds-st1202.c b/drivers/leds/leds-st1202.c
index e894b3f9a0f46..4cebc0203c227 100644
--- a/drivers/leds/leds-st1202.c
+++ b/drivers/leds/leds-st1202.c
@@ -345,7 +345,9 @@ static int st1202_probe(struct i2c_client *client)
 	if (!chip)
 		return -ENOMEM;
 
-	devm_mutex_init(&client->dev, &chip->lock);
+	ret = devm_mutex_init(&client->dev, &chip->lock);
+	if (ret < 0)
+		return ret;
 	chip->client = client;
 
 	ret = st1202_dt_init(chip);
-- 
2.39.5



