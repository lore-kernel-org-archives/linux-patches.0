Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 915AF471254;
	Tue, 21 Jul 2026 18:04:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784657056; cv=none; b=tax/qe1KL/FkHUI7dPoJpQpJ3jn0EXrneqwp90pKlXKdwfCNYa9y8Pq1VXis9WxFWiESgL2lea2BXy0jLeamGeO3EfVNlwrjIsnT9gliSbvETyCZ9MtFRUBk+U0ULVASml9VqHa5oZ/GjbDt8HmPrN7Gxl+kJEh3KBPJyuOrOXI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784657056; c=relaxed/simple;
	bh=DqSKP3H5uyt8qZ53XYaHyB72Nur9ukYzJwK1c7mN3nk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QVSeS0q7jBFGsCoqzwX9OK3zFBbx3CZQbIxjjtpD8WDDekhLdXjZTZVb4N5MUUP04867pXz6Kt0AkIuRR5yy9N3U3f6glgspYLlkPHMGaUd3ziyOPmeLh1eHpouaDFXa2Ks+eC8F8uFzNT7OdWk+UE4ZksMJRYwEKd4HaQ/PlAU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hYrJSyrI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hYrJSyrI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5F601F000E9;
	Tue, 21 Jul 2026 18:04:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784657055;
	bh=mnZb9DZlIa53eMgETdR7W7ZR0DOO8kFraFz8ZulRzrI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hYrJSyrI/ephNZYWhivWbnlMOsxu2Q3W4i+TqpN31RkN+hp1gOellTBtgzRA0ydvb
	 KZsuU6VvZttJyN7mK5ljIx6Kes7W92qqHUn9XvxNPoT3p9ePYZMgHtRnpYs0ynr9E6
	 s5KF6AlOay4ANihk780cnsbh58UAihFbOz1mvMz0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot <sashiko-bot@kernel.org>,
	Joshua Crofts <joshua.crofts1@gmail.com>,
	Jonathan Cameron <jic23@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0621/1611] iio: light: si1133: prevent race condition on timeout
Date: Tue, 21 Jul 2026 17:12:17 +0200
Message-ID: <20260721152529.356420741@linuxfoundation.org>
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

From: Joshua Crofts <joshua.crofts1@gmail.com>

[ Upstream commit 8c50a95ceb230d17801758a9e41ffbbbe46f8b4d ]

Sashiko reported a bug where the si1133_command exits on timeout
without halting the sensor or masking the interrupt. If the sensor
completes the command later, any subsequent command to the sensor
will cause the IRQ handler to complete immediately, returning stale
data to the driver all while the command hasn't finished yet, shifting
all potential reads in the future.

Fix this by masking the IRQ if wait_for_completion_timeout() fails.
When initiating a new command, do a dummy read of the IRQ_STATUS
register and turn the IRQ back on.

Fixes: e01e7eaf37d8 ("iio: light: introduce si1133")
Reported-by: sashiko-bot <sashiko-bot@kernel.org>
Closes: https://sashiko.dev/#/message/20260428-si1133-checkup-v2-5-70ad14bfefe2%40gmail.com
Assisted-by: gemini:gemini-3.1-pro-preview
Signed-off-by: Joshua Crofts <joshua.crofts1@gmail.com>
Signed-off-by: Jonathan Cameron <jic23@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/light/si1133.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/iio/light/si1133.c b/drivers/iio/light/si1133.c
index c88c79202be2e2..bf7bf0f1631d49 100644
--- a/drivers/iio/light/si1133.c
+++ b/drivers/iio/light/si1133.c
@@ -395,8 +395,14 @@ static int si1133_command(struct si1133_data *data, u8 cmd)
 
 	expected_seq = (data->rsp_seq + 1) & SI1133_MAX_CMD_CTR;
 
-	if (cmd == SI1133_CMD_FORCE)
+	if (cmd == SI1133_CMD_FORCE) {
+		/* Flush pending IRQs from a previous timeout. */
+		regmap_read(data->regmap, SI1133_REG_IRQ_STATUS, &resp);
+		regmap_write(data->regmap, SI1133_REG_IRQ_ENABLE,
+			     SI1133_IRQ_CHANNEL_ENABLE);
+
 		reinit_completion(&data->completion);
+	}
 
 	err = regmap_write(data->regmap, SI1133_REG_COMMAND, cmd);
 	if (err) {
@@ -409,6 +415,7 @@ static int si1133_command(struct si1133_data *data, u8 cmd)
 		/* wait for irq */
 		if (!wait_for_completion_timeout(&data->completion,
 			msecs_to_jiffies(SI1133_COMPLETION_TIMEOUT_MS))) {
+			regmap_write(data->regmap, SI1133_REG_IRQ_ENABLE, 0);
 			err = -ETIMEDOUT;
 			goto out;
 		}
-- 
2.53.0



