Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 987B035AC25
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:18:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302696; cv=none; b=A8WlX57IXDUJJ33WMpgay+rKTbCTpLLEhWym6OVCr4ODx5b1D6GEcQaQNpQanDoLpa9ow31Fovzg3xeZ+QB7/JVltGMBDY6r4P9HPmy3iCs/LxelPkhdzvt1fHD6eTvXNqkMJJlZp4Prp96iQ+M509NGni5OkgojGUZG4CRiPxY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302696; c=relaxed/simple;
	bh=jPy64S4fzOiBl67nwKOpsKNpFfSZH4gYwNjGm2dXnhs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QrdwyU5a8gibg4Qg9CAu+xi8DVFpY3e4P0a1pQhdQkT0gFYwM5sjrushk/Z6rF3lVJowNapuIGaJJvHLGE0kQ697s8SjR3rxwR3/hrTYrIyHcTTc1oDasj06AyLF9yU8qMo74emKLYNwLH7YjxpbYALwlDmWc1L3vBIRAX6w04U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=M0I3VTnt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="M0I3VTnt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09CEDC19423;
	Sat, 28 Feb 2026 18:18:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302696;
	bh=jPy64S4fzOiBl67nwKOpsKNpFfSZH4gYwNjGm2dXnhs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=M0I3VTntFkaV7ljb+aL0idEuz8UNN6JzHw4/GtLxwNkjwr5JWddGxG1Ubh/vjDYdp
	 gDYPQeiI1nap595jhQA9o06U7bWseZz85oasdlIwm/JkEPlqolIZxYxmMBZVPzG7BV
	 TIIvYKFVT1O3LCqU7L/Lg4aK+ReB66i50+gPHdRB1+Zxf9UenfWIIN6qGBZwlbkwpV
	 JAvkyZZ74jL3jG/ESHHRA1MJBjuimddoycNBMbt/EgSovQaO1Hd2QQA2D2vubh3uxG
	 M+RlmC+VShnd+0WEFDeN7ivURU98rh3Bwt4D/X0h5F+kbsqAse0U9B/U+aM/uY+Nfz
	 HeA1V08dUOnTw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Vincent Whitchurch <vincent.whitchurch@axis.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 051/147] regulator: core: Fix off_on_delay handling
Date: Sat, 28 Feb 2026 13:15:59 -0500
Message-ID: <20260228181736.1605592-51-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228181736.1605592-1-sashal@kernel.org>
References: <20260228181736.1605592-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Vincent Whitchurch <vincent.whitchurch@axis.com>

[ Upstream commit a8ce7bd89689997537dd22dcbced46cf23dc19da ]

The jiffies-based off_on_delay implementation has a couple of problems
that cause it to sometimes not actually delay for the required time:

 (1) If, for example, the off_on_delay time is equivalent to one jiffy,
     and the ->last_off_jiffy is set just before a new jiffy starts,
     then _regulator_do_enable() does not wait at all since it checks
     using time_before().

 (2) When jiffies overflows, the value of "remaining" becomes higher
     than "max_delay" and the code simply proceeds without waiting.

Fix these problems by changing it to use ktime_t instead.

[Note that since jiffies doesn't start at zero but at INITIAL_JIFFIES
 ("-5 minutes"), (2) above also led to the code not delaying if
 the first regulator_enable() is called when the ->last_off_jiffy is not
 initialised, such as for regulators with ->constraints->boot_on set.
 It's not clear to me if this was intended or not, but I've preserved
 this behaviour explicitly with the check for a non-zero ->last_off.]

Signed-off-by: Vincent Whitchurch <vincent.whitchurch@axis.com>
Link: https://lore.kernel.org/r/20210423114524.26414-1-vincent.whitchurch@axis.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Stable-dep-of: 86a8eeb0e913 ("regulator: core: move supply check earlier in set_machine_constraints()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/regulator/core.c         | 33 ++++++++------------------------
 include/linux/regulator/driver.h |  2 +-
 2 files changed, 9 insertions(+), 26 deletions(-)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index 38c01516d2ed0..3147498948373 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -1530,7 +1530,7 @@ static int set_machine_constraints(struct regulator_dev *rdev)
 		if (rdev->constraints->always_on)
 			rdev->use_count++;
 	} else if (rdev->desc->off_on_delay) {
-		rdev->last_off_jiffy = jiffies;
+		rdev->last_off = ktime_get();
 	}
 
 	print_constraints(rdev);
@@ -2604,29 +2604,15 @@ static int _regulator_do_enable(struct regulator_dev *rdev)
 
 	trace_regulator_enable(rdev_get_name(rdev));
 
-	if (rdev->desc->off_on_delay) {
+	if (rdev->desc->off_on_delay && rdev->last_off) {
 		/* if needed, keep a distance of off_on_delay from last time
 		 * this regulator was disabled.
 		 */
-		unsigned long start_jiffy = jiffies;
-		unsigned long intended, max_delay, remaining;
-
-		max_delay = usecs_to_jiffies(rdev->desc->off_on_delay);
-		intended = rdev->last_off_jiffy + max_delay;
-
-		if (time_before(start_jiffy, intended)) {
-			/* calc remaining jiffies to deal with one-time
-			 * timer wrapping.
-			 * in case of multiple timer wrapping, either it can be
-			 * detected by out-of-range remaining, or it cannot be
-			 * detected and we get a penalty of
-			 * _regulator_enable_delay().
-			 */
-			remaining = intended - start_jiffy;
-			if (remaining <= max_delay)
-				_regulator_enable_delay(
-						jiffies_to_usecs(remaining));
-		}
+		ktime_t end = ktime_add_us(rdev->last_off, rdev->desc->off_on_delay);
+		s64 remaining = ktime_us_delta(end, ktime_get());
+
+		if (remaining > 0)
+			_regulator_enable_delay(remaining);
 	}
 
 	if (rdev->ena_pin) {
@@ -2858,11 +2844,8 @@ static int _regulator_do_disable(struct regulator_dev *rdev)
 			return ret;
 	}
 
-	/* cares about last_off_jiffy only if off_on_delay is required by
-	 * device.
-	 */
 	if (rdev->desc->off_on_delay)
-		rdev->last_off_jiffy = jiffies;
+		rdev->last_off = ktime_get();
 
 	trace_regulator_disable_complete(rdev_get_name(rdev));
 
diff --git a/include/linux/regulator/driver.h b/include/linux/regulator/driver.h
index 633e7a2ab01d0..a465350427087 100644
--- a/include/linux/regulator/driver.h
+++ b/include/linux/regulator/driver.h
@@ -473,7 +473,7 @@ struct regulator_dev {
 	unsigned int is_switch:1;
 
 	/* time when this regulator was disabled last time */
-	unsigned long last_off_jiffy;
+	ktime_t last_off;
 };
 
 struct regulator_dev *
-- 
2.51.0

