Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D78E27CB02;
	Wed, 25 Feb 2026 01:45:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983930; cv=none; b=LCUMzBD8zkzg4cqb/SZckFYtowTsuh8zZ44wVD71mzbVgtYrFVt0en7W2BKffEL+blAxssSGuOQrODiGlDccLFNncZTtqnSgu09xnUeoEVHON08OtNysAGhpoG6p1E/6c46ROOsEsRU8R1hw/30hD+pFblMw/4KWh25hqMtq/Pg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983930; c=relaxed/simple;
	bh=Wm4uMaBKYzooYVFHrPuR5n3TL6MSrD2p+j/yu9u/5dY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=sKEs3jhbXEfal/UTr8pca5Ew2W/z4/OUzzDGoo704NYQtzyz2VfXySjInO20CgMY/3JLBQoO9zgPKBzOt1NDMxLV06jibOezXkN/uWy0WqzeGH6r6WeKZOGLgKUwsHCW7pNKqIgBv8fixR42tAZPZ3rGZsaVSBqJfJonVHjH578=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OsB9plGO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OsB9plGO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9B27C116D0;
	Wed, 25 Feb 2026 01:45:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983930;
	bh=Wm4uMaBKYzooYVFHrPuR5n3TL6MSrD2p+j/yu9u/5dY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OsB9plGO9YHfoJqPJ6GpsPsk2YWlp19sazUIq9k4zu0FnSwGNK4knYWm946nsCb4l
	 v4Pp+TQ7qKOBz4yGkjTmwsfKBUz3+qI4HBzeO1yPIB/qfvWWHy7a6GRnUtaW/rWBza
	 Zy+I0FlpHjaB4QkvK+DaLpJ3+e5LbkiuhTXq3bh4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Andr=C3=A9=20Draszik?= <andre.draszik@linaro.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 196/641] regulator: core: move supply check earlier in set_machine_constraints()
Date: Tue, 24 Feb 2026 17:18:42 -0800
Message-ID: <20260225012353.736989407@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012348.915798704@linuxfoundation.org>
References: <20260225012348.915798704@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

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
index b38b087eccfd7..17c60d9547dc5 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -1431,6 +1431,33 @@ static int set_machine_constraints(struct regulator_dev *rdev)
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
@@ -1596,37 +1623,15 @@ static int set_machine_constraints(struct regulator_dev *rdev)
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



