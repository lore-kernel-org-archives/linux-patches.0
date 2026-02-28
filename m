Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30F29346E70
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:12:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302354; cv=none; b=fl6D07O2KvkAmR2qavMdYNjSpMUrDS0p6RMqleyO3IS7koWtgAUtMS5RsARFkJehyYCLxQAnhXEUvv488n8plIeap7OO5Ke1YCdMrtY4YTyuMhGxKDfNezoofvJorxinKDfsoGeAOsVR14SUijF2qkl9E58wiBQz12OFc4bJJvE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302354; c=relaxed/simple;
	bh=oYB2/jXgN3wTgj5zHbwpw5tY3gm+U6o1Fi8Qxvl7dME=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lu6QIhDQLJbVDOAuOI2uHZ79L2nFhFz+GLGkpK48gYiqUwJdGiduAHu+BQWAKPT6tdzpEiRf4Jx1UUI2Hx7n2Czvyd4dsz2DOrWguILo3cUPJtExRGqIXb5UNDnL9E828L6VUdFeMmPYjkrlWJEimb5HaZfRgIkS0leo/IbpJkg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oLKXUoRt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oLKXUoRt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93ED0C19423;
	Sat, 28 Feb 2026 18:12:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302354;
	bh=oYB2/jXgN3wTgj5zHbwpw5tY3gm+U6o1Fi8Qxvl7dME=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oLKXUoRtigRc0SsmJXbrOLQ6nTkQ1QFpjatWDGXKDNL6GLMLQEDKR7RfACr5McgxI
	 qbDU9EnaDVIWAbKayHSXbrenuqFlM62A/tpIBeXAqt8fpj+7RLlD/+MsTfEyr00Lbi
	 KucPPg95kd6ECC4KvkYJWceAORjjlPb8Ylk5ttIYqGvXRrHFnJZx3Ji3RQOSByruGi
	 pvUyQSwCCNGSlPnFaLRG7F374/0TfzI/mB6keEOn2fhMzuafGOcxs1rzlR4BiVE+9j
	 vxl94aXAGw2K4jr9YDUDYD233DD0fh26hJ2W80I6YZUJawLN5PvXXQ1lXZDDtWcRXi
	 58cv798+ztZcQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: =?UTF-8?q?Andr=C3=A9=20Draszik?= <andre.draszik@linaro.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 079/232] regulator: core: move supply check earlier in set_machine_constraints()
Date: Sat, 28 Feb 2026 13:08:52 -0500
Message-ID: <20260228181127.1592657-79-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228181127.1592657-1-sashal@kernel.org>
References: <20260228181127.1592657-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: André Draszik <andre.draszik@linaro.org>

[ Upstream commit 86a8eeb0e913f4b6a55dabba5122098d4e805e55 ]

Since commit 98e48cd9283d ("regulator: core: resolve supply for
boot-on/always-on regulators"), set_machine_constraints() can return
-EPROBE_DEFER very late, after it has done a lot of work and
configuration of the regulator.

This means that configuration will happen multiple times for no
benefit in that case. Furthermore, this can lead to timing-dependent
voltage glitches as mentioned e.g. in commit 8a866d527ac0 ("regulator:
core: Resolve supply name earlier to prevent double-init").

We can know that it's going to fail very early, in particular before
going through the complete regulator configuration by moving some code
around a little.

Do so to avoid re-configuring the regulator multiple times, also
avoiding the voltage glitches if we can.

Fixes: 98e48cd9283d ("regulator: core: resolve supply for boot-on/always-on regulators")
Signed-off-by: André Draszik <andre.draszik@linaro.org>
Link: https://patch.msgid.link/20260109-regulators-defer-v2-3-1a25dc968e60@linaro.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/regulator/core.c | 55 ++++++++++++++++++++++------------------
 1 file changed, 30 insertions(+), 25 deletions(-)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index 7b1d60628a001..454e19d87e35a 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -1473,6 +1473,33 @@ static int set_machine_constraints(struct regulator_dev *rdev)
 	int ret = 0;
 	const struct regulator_ops *ops = rdev->desc->ops;
 
+	/*
+	 * If there is no mechanism for controlling the regulator then
+	 * flag it as always_on so we don't end up duplicating checks
+	 * for this so much.  Note that we could control the state of
+	 * a supply to control the output on a regulator that has no
+	 * direct control.
+	 */
+	if (!rdev->ena_pin && !ops->enable) {
+		if (rdev->supply_name && !rdev->supply)
+			return -EPROBE_DEFER;
+
+		if (rdev->supply)
+			rdev->constraints->always_on =
+				rdev->supply->rdev->constraints->always_on;
+		else
+			rdev->constraints->always_on = true;
+	}
+
+	/*
+	 * If we want to enable this regulator, make sure that we know the
+	 * supplying regulator.
+	 */
+	if (rdev->constraints->always_on || rdev->constraints->boot_on) {
+		if (rdev->supply_name && !rdev->supply)
+			return -EPROBE_DEFER;
+	}
+
 	ret = machine_constraints_voltage(rdev, rdev->constraints);
 	if (ret != 0)
 		return ret;
@@ -1638,37 +1665,15 @@ static int set_machine_constraints(struct regulator_dev *rdev)
 		}
 	}
 
-	/*
-	 * If there is no mechanism for controlling the regulator then
-	 * flag it as always_on so we don't end up duplicating checks
-	 * for this so much.  Note that we could control the state of
-	 * a supply to control the output on a regulator that has no
-	 * direct control.
-	 */
-	if (!rdev->ena_pin && !ops->enable) {
-		if (rdev->supply_name && !rdev->supply)
-			return -EPROBE_DEFER;
-
-		if (rdev->supply)
-			rdev->constraints->always_on =
-				rdev->supply->rdev->constraints->always_on;
-		else
-			rdev->constraints->always_on = true;
-	}
-
 	/* If the constraints say the regulator should be on at this point
 	 * and we have control then make sure it is enabled.
 	 */
 	if (rdev->constraints->always_on || rdev->constraints->boot_on) {
 		bool supply_enabled = false;
 
-		/* If we want to enable this regulator, make sure that we know
-		 * the supplying regulator.
-		 */
-		if (rdev->supply_name && !rdev->supply)
-			return -EPROBE_DEFER;
-
-		/* If supplying regulator has already been enabled,
+		/* We have ensured a potential supply has been resolved above.
+		 *
+		 * If supplying regulator has already been enabled,
 		 * it's not intended to have use_count increment
 		 * when rdev is only boot-on.
 		 */
-- 
2.51.0

