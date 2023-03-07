Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D645BA49
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 18:40:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8DEDC4339B;
	Tue,  7 Mar 2023 18:40:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678214438;
	bh=EvoJwXMHnUZUJHQOXHrAX9QKKcvmvLYb6Sj/YgUHLdU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rxNmmnOEYexgix+tSYFdRmQY5yfnwj17yU5VoBvvO8THFHpHBBR1q0YQ4KITVJWyk
	 8Ok7jvQSx7VfClVJ8UV/FLuTzMtZtDL/IEm2mvniL181flMoVtXe9wpeLi3QsHO4XY
	 I16OIqoVd4pNQZqR8qXjsjQG6Jl3FIv6d7H977vk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthias Kaehlcke <mka@chromium.org>,
	Stephen Boyd <swboyd@chromium.org>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.1 822/885] regulator: core: Use ktime_get_boottime() to determine how long a regulator was off
Date: Tue,  7 Mar 2023 18:02:36 +0100
Message-Id: <20230307170037.570126571@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170001.594919529@linuxfoundation.org>
References: <20230307170001.594919529@linuxfoundation.org>
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

commit 80d2c29e09e663761c2778167a625b25ffe01b6f upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/regulator/core.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -1584,7 +1584,7 @@ static int set_machine_constraints(struc
 	}
 
 	if (rdev->desc->off_on_delay)
-		rdev->last_off = ktime_get();
+		rdev->last_off = ktime_get_boottime();
 
 	/* If the constraints say the regulator should be on at this point
 	 * and we have control then make sure it is enabled.
@@ -2673,7 +2673,7 @@ static int _regulator_do_enable(struct r
 		 * this regulator was disabled.
 		 */
 		ktime_t end = ktime_add_us(rdev->last_off, rdev->desc->off_on_delay);
-		s64 remaining = ktime_us_delta(end, ktime_get());
+		s64 remaining = ktime_us_delta(end, ktime_get_boottime());
 
 		if (remaining > 0)
 			_regulator_delay_helper(remaining);
@@ -2912,7 +2912,7 @@ static int _regulator_do_disable(struct
 	}
 
 	if (rdev->desc->off_on_delay)
-		rdev->last_off = ktime_get();
+		rdev->last_off = ktime_get_boottime();
 
 	trace_regulator_disable_complete(rdev_get_name(rdev));
 


