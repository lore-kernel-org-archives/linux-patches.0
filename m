Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5443039B94B
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:15:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302550; cv=none; b=JAhlws0Ijin02zHArN2gCSRAPugugQzrCioYW99adfWZbcvSECHVDkXkknIVmka+K9/P4bKHPeoBQMrsZayw9S3wO4sjIQr8VCKJxc2POo9LudFktFlmuGAgHAoozA13yLMOlB+1/or+jc9giiOz6VfKVhrysP60qvq/G01lAw0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302550; c=relaxed/simple;
	bh=rPUevnrMVxIgpMZvBzSZcPuzcUiIQE49BRm9rVibSpw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lV2F4eXMLcc59YQqrfc5xiiFBVUHnj6NiUT0ApbWSmMQI6RJCXy2LD8wF+I6YlYAcEgMYIKu4I2at7dYVao4Wy6NT5aixbNcEMFNNSIHR5edXHzVhhpGrSL9rvUFXIuHA8LhGWISEMtdLkfAi9ApOL+o1BLUhTIRB+4vfRvVzsM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=q7hihrB4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="q7hihrB4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFE68C116D0;
	Sat, 28 Feb 2026 18:15:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302550;
	bh=rPUevnrMVxIgpMZvBzSZcPuzcUiIQE49BRm9rVibSpw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=q7hihrB4D3ivJ6D8gSZ43RFeheL7LXUfLA3JKIJ4OZz6FlwmeNFAyesRRLAxmcI6s
	 MgqZUltWGK2lXIjY7Kwx2q/5CW7lRfafJqXgiW9PNe52wZXlyyL2ojVcQuG/HQ+WDb
	 Bb40YUP9ZjOvfyYuF8sj8d7JxcGmf99IpM0atQLERguEBapXT6vZ87Xay+SGgvh7V6
	 J/gkQuVYfU5yepBAn4xleDfELBa+zXjgacpZhjd66AqmunSriUjC2nnseMnHtSyLid
	 FIHZZHt4d1P7+Bq3wU3+bAbiJ1vmGJVVyHAkm7mBhitOcsmdBle2UNScMFcF3R4zlL
	 97JWfPHZ1b+vQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: =?UTF-8?q?Andr=C3=A9=20Draszik?= <andre.draszik@linaro.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 053/164] regulator: core: move supply check earlier in set_machine_constraints()
Date: Sat, 28 Feb 2026 13:13:12 -0500
Message-ID: <20260228181505.1600663-53-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228181505.1600663-1-sashal@kernel.org>
References: <20260228181505.1600663-1-sashal@kernel.org>
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
index af0218227a8c7..fdb5e1a1f246f 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -1429,6 +1429,33 @@ static int set_machine_constraints(struct regulator_dev *rdev)
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
@@ -1594,37 +1621,15 @@ static int set_machine_constraints(struct regulator_dev *rdev)
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

