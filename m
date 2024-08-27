Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B3EE1CCEF3;
	Tue, 27 Aug 2024 15:26:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724772399; cv=none; b=gcyn/35WTDly34GgBmGC6qdQl/hhYReORXDX/i0FvRi/4F0CJyA21k3g2UDDrPWcF+lAJH3SzI+Cazee0ExcXBnAUoq6u/dWGYvqjpQRdRf4Sqau4AiKkXYqztK7ZpWaj39Gip5OTfHdIumvmb+HTR8cDR2412lVKf6jokZ2b7w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724772399; c=relaxed/simple;
	bh=rFmk9UnZOTwmx7Ba90nzAAa2KGljqqbzXFEFetNhOYo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=St6mAteKSIiwSqp0Mhq1Vg6KZBQ/lzWpmKaOjIbN9+hb1gWIUDaVjwMX/u6ACNtFEybux4ETs85GCoKn+xa+UmdvfzPZqBdMj8csEjEeh3X/ifSCMGoHef5avxlIaZaN8kzan7JLAMRgE4r1OH1bYjL7Vyd72uBA+yQHq5B0vSg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FVUD6DfP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FVUD6DfP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4369C4DE12;
	Tue, 27 Aug 2024 15:26:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724772399;
	bh=rFmk9UnZOTwmx7Ba90nzAAa2KGljqqbzXFEFetNhOYo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FVUD6DfP+y/iLusQ3wVFFYYOvvvyNDwo6vhf1u1M2Q2RECYKxA5ki5/BOhZmo9Ob6
	 L3c3GfiTgq0HbPWpMVDU1EgjOPqG9Sww/jvNfDKyx/J5KW1G5NVpwAZni+eHUZScZN
	 GAZrJrhq9ez3jI7BJON7J+BYJzTLiPivJ81/kA2k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
	Daniel Lezcano <daniel.lezcano@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 172/321] clocksource/drivers/arm_global_timer: Guard against division by zero
Date: Tue, 27 Aug 2024 16:38:00 +0200
Message-ID: <20240827143844.778997377@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143838.192435816@linuxfoundation.org>
References: <20240827143838.192435816@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Martin Blumenstingl <martin.blumenstingl@googlemail.com>

[ Upstream commit e651f2fae33634175fae956d896277cf916f5d09 ]

The result of the division of new_rate by gt_target_rate can be zero (if
new_rate is smaller than gt_target_rate). Using that result as divisor
without checking can result in a division by zero error. Guard against
this by checking for a zero value earlier.
While here, also change the psv variable to an unsigned long to make
sure we don't overflow the datatype as all other types involved are also
unsiged long.

Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Link: https://lore.kernel.org/r/20240225151336.2728533-3-martin.blumenstingl@googlemail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clocksource/arm_global_timer.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/clocksource/arm_global_timer.c b/drivers/clocksource/arm_global_timer.c
index e1c773bb55359..22a58d35a41fa 100644
--- a/drivers/clocksource/arm_global_timer.c
+++ b/drivers/clocksource/arm_global_timer.c
@@ -290,18 +290,17 @@ static int gt_clk_rate_change_cb(struct notifier_block *nb,
 	switch (event) {
 	case PRE_RATE_CHANGE:
 	{
-		int psv;
+		unsigned long psv;
 
-		psv = DIV_ROUND_CLOSEST(ndata->new_rate,
-					gt_target_rate);
-
-		if (abs(gt_target_rate - (ndata->new_rate / psv)) > MAX_F_ERR)
+		psv = DIV_ROUND_CLOSEST(ndata->new_rate, gt_target_rate);
+		if (!psv ||
+		    abs(gt_target_rate - (ndata->new_rate / psv)) > MAX_F_ERR)
 			return NOTIFY_BAD;
 
 		psv--;
 
 		/* prescaler within legal range? */
-		if (psv < 0 || psv > GT_CONTROL_PRESCALER_MAX)
+		if (psv > GT_CONTROL_PRESCALER_MAX)
 			return NOTIFY_BAD;
 
 		/*
-- 
2.43.0



