Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A6884432
	for <patches@lists.linux.dev>; Wed, 15 Mar 2023 12:27:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD487C433A1;
	Wed, 15 Mar 2023 12:27:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678883240;
	bh=H+I7i9XyA716jcMukxZSzJn95vXblwM3o3qrJIJtZso=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xsWn3pX4BGt+FfGj0jR4hva5YG9Z5XZDn16OOapbl0U1MIHoldI0aG3LS4DLagqtp
	 yVa9dzS4mBAeLDDVqkqcXuegi3qsxDlzIHE181stHgLeHpplr55lmczUsPf96oCYdI
	 NaP615a9Ij+k+5fGDeJMuilTF3X7J+35ppkNobVg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthias Kaehlcke <mka@chromium.org>,
	Stephen Boyd <swboyd@chromium.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 041/145] regulator: core: Use ktime_get_boottime() to determine how long a regulator was off
Date: Wed, 15 Mar 2023 13:11:47 +0100
Message-Id: <20230315115740.431945870@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230315115738.951067403@linuxfoundation.org>
References: <20230315115738.951067403@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Matthias Kaehlcke <mka@chromium.org>

[ Upstream commit 80d2c29e09e663761c2778167a625b25ffe01b6f ]

For regulators with 'off-on-delay-us' the regulator framework currently
uses ktime_get() to determine how long the regulator has been off
before re-enabling it (after a delay if needed). A problem with using
ktime_get() is that it doesn't account for the time the system is
suspended. As a result a regulator with a longer 'off-on-delay' (e.g.
500ms) that was switched off during suspend might still incurr in a
delay on resume before it is re-enabled, even though the regulator
might have been off for hours. ktime_get_boottime() accounts for
suspend time, use it instead of ktime_get().

Fixes: a8ce7bd89689 ("regulator: core: Fix off_on_delay handling")
Cc: stable@vger.kernel.org    # 5.13+
Signed-off-by: Matthias Kaehlcke <mka@chromium.org>
Reviewed-by: Stephen Boyd <swboyd@chromium.org>
Link: https://lore.kernel.org/r/20230223003301.v2.1.I9719661b8eb0a73b8c416f9c26cf5bd8c0563f99@changeid
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/regulator/core.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index c7b1e15bf7bb5..cd10880378a6d 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -1540,7 +1540,7 @@ static int set_machine_constraints(struct regulator_dev *rdev)
 	}
 
 	if (rdev->desc->off_on_delay)
-		rdev->last_off = ktime_get();
+		rdev->last_off = ktime_get_boottime();
 
 	/* If the constraints say the regulator should be on at this point
 	 * and we have control then make sure it is enabled.
@@ -2629,7 +2629,7 @@ static int _regulator_do_enable(struct regulator_dev *rdev)
 		 * this regulator was disabled.
 		 */
 		ktime_t end = ktime_add_us(rdev->last_off, rdev->desc->off_on_delay);
-		s64 remaining = ktime_us_delta(end, ktime_get());
+		s64 remaining = ktime_us_delta(end, ktime_get_boottime());
 
 		if (remaining > 0)
 			_regulator_enable_delay(remaining);
@@ -2868,7 +2868,7 @@ static int _regulator_do_disable(struct regulator_dev *rdev)
 	}
 
 	if (rdev->desc->off_on_delay)
-		rdev->last_off = ktime_get();
+		rdev->last_off = ktime_get_boottime();
 
 	trace_regulator_disable_complete(rdev_get_name(rdev));
 
-- 
2.39.2



