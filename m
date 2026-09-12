Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1D87360EF5;
	Sat, 12 Sep 2026 08:04:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789200274; cv=none; b=XuWRQPlqwAbv3U3KwGSc4YdCrEpLtJWuvTRqpBKH/ZIXsGI65X5M1ZHYq/LMuVZeXCB2SbCA9q0kGr4OHDE9I2nkyV5Wbv9mlXhXSeQLAPc7JJQN6DhAjPNHMPPovxG/PyXFfCIC593NaU/GD1nR6kJzaaWuV4qrtLx3TeBIUaM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789200274; c=relaxed/simple;
	bh=ndD7IyVkg3aoiC0fcSzfh6n1UxV9tqnhnGYaHbw7uNw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ILR6ano7DS+sEe6EqSKAQxkP5cr9mlxbliGGBVGUTSHypLPcMrIv8dHK+SBZu8cqahm49zuc0TUj/eJoUhxcemNsq6XHgxiyO/z6H2M1fzbsw6QKpW190bjM0QsQM3gpEHwgoFu2mkhdG+UzKAIQo7RXOOACM0/rrQgb7W+S0zk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wzk8hF40; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wzk8hF40"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7C381F000FF;
	Sat, 12 Sep 2026 08:04:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789200272;
	bh=a1qNE9fQXW/0C8q3tVvx+PQ66ZDRuI9z3cAbDFcesIc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wzk8hF40YsfBOtSNOd5vytVQZpQVIi5jZkQeoXnMXEk5YCB9GvmS8QbHLEfOwHpoY
	 pnJ2IdwsAxlR//dC6GfUm2N5ooMs++hv3FlF2hjWamgOJTR4416MCg5Pn6e1fjCzEM
	 3WSsnY6UAky7chMsfnlW7n+9WgKKTgOPSPP1e92A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Surendra Singh Chouhan <kr494167@gmail.com>,
	Andreas Kemnade <andreas@kemnade.info>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0756/1815] regulator: tps65185: handle gpiod_get_value_cansleep() error returns
Date: Sat, 12 Sep 2026 08:41:46 +0200
Message-ID: <20260912065706.655103518@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Surendra Singh Chouhan <kr494167@gmail.com>

[ Upstream commit 623d9a55685c52b10b995d8dbde9da6283170220 ]

tps65185_vposneg_enable() evaluated:
  if (gpiod_get_value_cansleep(data->pgood_gpio) != 1)
      return -ETIMEDOUT;

gpiod_get_value_cansleep() returns 1 if active, 0 if inactive, and a
negative error code (e.g. -EIO or -EINVAL) on failure. Evaluating != 1
treats a negative error code as non-equal, swallowing GPIO read errors and
masking them as -ETIMEDOUT.

Fix this by capturing the return value of gpiod_get_value_cansleep(). If
it returns a negative error code, propagate that error immediately; if
it returns 0 (inactive), return -ETIMEDOUT.

Fixes: b0fc1e770194 ("regulator: Add TPS65185 driver")
Signed-off-by: Surendra Singh Chouhan <kr494167@gmail.com>
Reviewed-by: Andreas Kemnade <andreas@kemnade.info>
Link: https://patch.msgid.link/20260724125858.75635-1-kr494167@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/regulator/tps65185.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/regulator/tps65185.c b/drivers/regulator/tps65185.c
index 786622d8d5980..1f13e4156cab1 100644
--- a/drivers/regulator/tps65185.c
+++ b/drivers/regulator/tps65185.c
@@ -183,7 +183,10 @@ static int tps65185_vposneg_enable(struct regulator_dev *rdev)
 	wait_for_completion_timeout(&data->pgood_completion,
 				    msecs_to_jiffies(PGOOD_TIMEOUT_MSECS));
 	dev_dbg(data->dev, "turned on");
-	if (gpiod_get_value_cansleep(data->pgood_gpio) != 1)
+	ret = gpiod_get_value_cansleep(data->pgood_gpio);
+	if (ret < 0)
+		return ret;
+	if (!ret)
 		return -ETIMEDOUT;
 
 	return 0;
-- 
2.53.0



