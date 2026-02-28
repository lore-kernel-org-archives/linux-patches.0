Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EE5F35AC28
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:18:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302700; cv=none; b=Kr7oVmxVlK3El0N6MxKJtbDPQZPfvNSp01wfhSxzMHe7ZsEUX+wNheJ4whYcy0vTjcVSGuBl4VwrrEGT+yLN7CQunEr7McKYtj9slt7q6zxn40C3RWnULRq/GM28YzPckU+tRRu/h95puWiteAQUGNIZQJyBIDIudxuF94L0qGI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302700; c=relaxed/simple;
	bh=m5rX0Z/XqrbFGLCXtWlu7gjptlHPk8Zfcv72cMnh68w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=cM+//jn7Ve/ymqGqHUZWgx7CltoMC8mpPocUU3YAhjbNfd0rgaY7y+KD4UTrwAwJeI/pFblIEMbIuaKSEWvB7Vy4PGwXBXUav8kjRroFCU22XMriu5/5gOMOLwjDle7uWYNkkDfQZwejUAtB6qLviu6DvtDDHirXrP/r6xib3L8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Bk28WEDH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Bk28WEDH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D418FC19423;
	Sat, 28 Feb 2026 18:18:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302700;
	bh=m5rX0Z/XqrbFGLCXtWlu7gjptlHPk8Zfcv72cMnh68w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Bk28WEDHpOQYtbiFWa+SMEWdUQU/KwSXX/BvWc/ZY8LXNMtgySOwO01hobzxzLbcW
	 Y8oKW993SUoHvov/Ig6a1snjaoIXQGFUpvAUuy8GojwZSj9xRLWNeKVJqAAcFkWECz
	 o4Z6c8ujrVBZP/ru2gp/Un4BGuYJDo5ueP03UKzVeC/VjLK7z/EZaaCNRdigG+9aCw
	 YrmIT/Ff7Dlrwf3QyxqtNd7Td4eJwqJ3DfW3PwNadByXW0W0WJWPGJQr9YA/niE6n4
	 Yfg5GJaJ/kh5raNsmfE94JnV+7VG0vNstO0UktUvq7aj16tYVrX8remcFpoJvNelYX
	 sstpOujYRR3Gw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: =?UTF-8?q?Andr=C3=A9=20Draszik?= <andre.draszik@linaro.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 056/147] regulator: core: move supply check earlier in set_machine_constraints()
Date: Sat, 28 Feb 2026 13:16:04 -0500
Message-ID: <20260228181736.1605592-56-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228181736.1605592-1-sashal@kernel.org>
References: <20260228181736.1605592-1-sashal@kernel.org>
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
index dfc03a2d70959..a04356a644f39 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -1400,6 +1400,33 @@ static int set_machine_constraints(struct regulator_dev *rdev)
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
@@ -1491,37 +1518,15 @@ static int set_machine_constraints(struct regulator_dev *rdev)
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

