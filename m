Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF78D435532;
	Tue, 21 Jul 2026 22:10:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784671810; cv=none; b=ga0qZ7lfoVZKQXTOWvUg7VNvvWwpWiiO/TjIQ963EHf6BSaaddLmG2uMMwFqujR3hXDzNWQsP5qqFfTpKH1dKQ3ekWSQOoZWYVDAjIOUo9uQ/3XNCCOyxbzY/eCOFvVGDjIX7jlr4pKSZvf07/sX0F6HxyDpjf992i84NnKBk1A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784671810; c=relaxed/simple;
	bh=Y/olvngm4JGAqbvsgvn0jOR6m3Vr0LKEqxPdGq7T+4U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tD6CT5l9AY9BYUXvqs9Ck2EmL8Ng5V9lZOtppRSX940IKzzSJq1g5kj+eV2U5G5K5YtKdQ6f/cKWE6mwsHnSX4fbK96MED5gRTSmzxea/ahZ27fU6Ccrv3CqBmsyKNN7Dm50ByeFm8X3kex38HOTROQJzpy5vaW9kba9/+8UOTs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WIkP8pna; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WIkP8pna"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FBCB1F000E9;
	Tue, 21 Jul 2026 22:10:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784671809;
	bh=QkW5brTpHFytfVt07NvKjQx8G0g0jJBKWoC3y12ORSs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WIkP8pnaX4CsKVRRDFM6S244J/i3DPXkqkaXK7HcftiBqKXruW0t0XDFAlawQVf88
	 1t9dILmhVYz+BHJluRAiENrJJ77V/u8YOomfySH1rvJ8q7v+OaxV4UQSBbg9Czc8mA
	 3nnGqJKcKDNsyj9Kiz5UNs/Y6Q0KJ/aLHrsq0Kdc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot <sashiko-bot@kernel.org>,
	Joshua Crofts <joshua.crofts1@gmail.com>,
	Jonathan Cameron <jic23@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 386/843] iio: light: si1133: prevent race condition on timeout
Date: Tue, 21 Jul 2026 17:20:21 +0200
Message-ID: <20260721152414.720753996@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152405.946368001@linuxfoundation.org>
References: <20260721152405.946368001@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 17ee203d16a274..d207a928b1f823 100644
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



