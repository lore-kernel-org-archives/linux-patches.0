Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1DB8415F15;
	Tue, 21 Jul 2026 19:34:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784662442; cv=none; b=c5Nny2No89vLwP9gjdriJ6SwKcFQV6TaxXJlvbhWd4VKhDpuQc7D8/R1f8Bc616u8LXwdO/ZOi26wbugHGsZC/EkBYkAiUUkgLH7otnUxuT03m7Of81Xwwme73qT1A9kkBq4ZfMxk3AJQq45V8izGbke8AU+Q4d3NggSGJkQElI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784662442; c=relaxed/simple;
	bh=xYeBKGvq9UZv8V3dWeQ39bUvFtfvpBhofGad8cZ9P+M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nrIFKArMrG0m/jFfHW0X5coKfENx7QGmX7TB/1qFvWFbjv+KIs2FtNVQgM1/CuyZgD135UtbRfvENjuyxb/+UMHh6UOea2VPbeaosgZMWnT1JpeRc4w8llRpuNOkaHhhI5LRjmJAf4a0xi3ca+KPlnDo07bCxJZLeUGIM8BH3zw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AsRGAJLe; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AsRGAJLe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCC881F000E9;
	Tue, 21 Jul 2026 19:34:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784662441;
	bh=8ObVu31ydwm3ygA2YxG5r8vY/zzjbnwyQll9rzWqnAY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AsRGAJLeCksKyfEOHsUR3I8dMiQ2leHm2OigbFowYQ1TUNZ5cC9arjQPXiofe2x+y
	 Hmxvo/BmTmVTkE1AypQQ6XPLpRNg4HNlpYcCvSY+O/zpeUWbNYi0UBos/ucc81+JHT
	 1ofI2UAdbiTvDX1AaQCG/KHsML6Bmspkx8Hxsr0A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot <sashiko-bot@kernel.org>,
	Joshua Crofts <joshua.crofts1@gmail.com>,
	Jonathan Cameron <jic23@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0445/1276] iio: light: si1133: prevent race condition on timeout
Date: Tue, 21 Jul 2026 17:14:48 +0200
Message-ID: <20260721152456.060352188@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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



