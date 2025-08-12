Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E5D92FD1C2;
	Tue, 12 Aug 2025 18:39:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755023999; cv=none; b=I38f19CijJ+rGu9ml/o/2nz+aRWrvsKWon+EtatpRhVL7yXqcP4OrV7yJlB1QCS2o30NRxhairPGj2E1Prw6MeXKumDScHGwJUQJlINv8zhre5yfGmXAzBnbWku6/ToQsYXYK7TpMXFJiDOUbp1BP0lE4O0onmc1hV8p+XfI5+A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755023999; c=relaxed/simple;
	bh=ntSV+iBeg2VgZo+Dyti6oMO7KAY6RI+8QO58Z6BiVy4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=GSlpoGf32iu2Qt8XSy/SZ++NZDNqSFNaCrPZ2CkmzB7c9clOXwqcw2gntvS9pPDk3M8NmbXOJT23V4nq8yu4bnOa7DZi9rcRVi9wdHiCh7akqDN0NE8dQ/bZ8aHNe+UUPbhV88mJOoKvfsHebTdcAVJRnv1abT9h5grueweBF1Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=l68D6i0j; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="l68D6i0j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FEBAC4CEF0;
	Tue, 12 Aug 2025 18:39:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755023999;
	bh=ntSV+iBeg2VgZo+Dyti6oMO7KAY6RI+8QO58Z6BiVy4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=l68D6i0jJiSnyjpVQpKjOcnRw4EHIv+u2Q4ctQXaZhfij62WBl3iNEvsEfHF7NBwn
	 q6igy31BELoO/uzlh6GzMvv8kH/hJzBMrAjpWmEer/mSwl+vD6z5dzrmHYWbA9yHCh
	 c25yI/zSPJKD3fnB8LAO/4SpL7D+a3e3Eeh3UkzM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <linux@weissschuh.net>,
	Andrew Davis <afd@ti.com>,
	Lee Jones <lee@kernel.org>,
	Boqun Feng <boqun.feng@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 210/627] leds: lp8860: Check return value of devm_mutex_init()
Date: Tue, 12 Aug 2025 19:28:25 +0200
Message-ID: <20250812173427.270499846@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173419.303046420@linuxfoundation.org>
References: <20250812173419.303046420@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Weißschuh <linux@weissschuh.net>

[ Upstream commit 3b07bb900af7f43f13f9ff398b4c6ca1dee217cd ]

devm_mutex_init() can fail. With CONFIG_DEBUG_MUTEXES=y the mutex will be
marked as unusable and trigger errors on usage.

Add the missed check.

Fixes: 87a59548af95 ("leds: lp8860: Use new mutex guards to cleanup function exits")
Signed-off-by: Thomas Weißschuh <linux@weissschuh.net>
Acked-by: Andrew Davis <afd@ti.com>
Acked-by: Lee Jones <lee@kernel.org>
Signed-off-by: Boqun Feng <boqun.feng@gmail.com>
Link: https://lore.kernel.org/r/20250617-must_check-devm_mutex_init-v7-2-d9e449f4d224@weissschuh.net
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/leds/leds-lp8860.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/leds/leds-lp8860.c b/drivers/leds/leds-lp8860.c
index 52b97c9f2a03..0962c00c215a 100644
--- a/drivers/leds/leds-lp8860.c
+++ b/drivers/leds/leds-lp8860.c
@@ -307,7 +307,9 @@ static int lp8860_probe(struct i2c_client *client)
 	led->client = client;
 	led->led_dev.brightness_set_blocking = lp8860_brightness_set;
 
-	devm_mutex_init(&client->dev, &led->lock);
+	ret = devm_mutex_init(&client->dev, &led->lock);
+	if (ret)
+		return dev_err_probe(&client->dev, ret, "Failed to initialize lock\n");
 
 	led->regmap = devm_regmap_init_i2c(client, &lp8860_regmap_config);
 	if (IS_ERR(led->regmap)) {
-- 
2.39.5



