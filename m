Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 490FB338939
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:02:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301751; cv=none; b=Y4n6B8JOy69Ql1nUxQmqpzhNmDZjE0R7nqWj9qevZvbDIMwyNqQmQaF2miNV3YACtTSfdDjqct/YBz2Goj4UP1fAtN3mHaPf8X8tDpEEfsABVJbXEALsJCzgyTfmNtNFxs7EppmZ38Xeg5GX8G1uum5m/2uuhsaZpTQHewOO91M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301751; c=relaxed/simple;
	bh=3y49546T6d/tPdaYEn1VK5fBQi2CdmUuv79nk7KIQVk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=aJqN2gWZU0kFjljjOoxwx9Bb7bzDpfiTDB9oLDh7a8/jyr5ebq22Nj0CurBqzBxa9xNJ0awUCagTBI6OAYsHru2Vj7PPyZRkawZS2iP8AxB6BpcA/Sj/NRzDuFnG0WxAwLbrxroTSuezEbAMMDPszExHEYN/262SPG1AxgiRtJs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=tSngfoYZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="tSngfoYZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A52FAC2BC87;
	Sat, 28 Feb 2026 18:02:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301751;
	bh=3y49546T6d/tPdaYEn1VK5fBQi2CdmUuv79nk7KIQVk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tSngfoYZmKxFRSAObjdZ9aFaXbMV2DwjEREC9mgu7i/JI+CusyZ0kUOWnzHzeppL/
	 HHqEcgF++7qKfGHDIDjWihel/zSVzyROGVaFTgykZFQS4sdsbw9qLDkjtowtYa5O/r
	 29tSdxiQYTsrBmjP4SCXa+ZKPOTfcxfa9BZ7MsMoZvSNAVU+zBHPqhOdXn3PaGOckr
	 XOsgDHsX7sS4pfKclplEziofo6c6Hg8kOoQlxW6stc0A+C87F33nrxLp9UXimH8God
	 EVHL5Z6s3y8CceTEwHhQWYUvvtGDVjA7MGCukRxeAPI/knKWh04aT3Y/SZ6IuKzrK1
	 web46/sw03MLQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: =?UTF-8?q?Andr=C3=A9=20Draszik?= <andre.draszik@linaro.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 154/385] regulator: core: move supply check earlier in set_machine_constraints()
Date: Sat, 28 Feb 2026 12:56:16 -0500
Message-ID: <20260228180011.1568201-154-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180011.1568201-1-sashal@kernel.org>
References: <20260228180011.1568201-1-sashal@kernel.org>
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
index 1c0748fee6846..078d3dc50aa3f 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -1406,6 +1406,33 @@ static int set_machine_constraints(struct regulator_dev *rdev)
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
@@ -1571,37 +1598,15 @@ static int set_machine_constraints(struct regulator_dev *rdev)
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

