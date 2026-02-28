Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 420B135AC2F
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:18:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302697; cv=none; b=KcIeoco4xiGXspQ/7ZngGfVWmrgFJVHT8xM8Sggx6mm9Qt+Or4RhEtxbnUztB+D2XwI3KJjLjh8yiYTMuT8WL4O6zdOdzr/gj4J6kVhp3tLlD3Qzx5gYN3Elxu+0ecRjSX63REVlVdmUX23F9+eXbMfm7sXICF8jQ5xfGBjLBJI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302697; c=relaxed/simple;
	bh=FoVwq1DhdqHgBy148b8YjaAduBwbscPF9I7b1YEeJ14=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NVinlF+Uzshc0DusWERbPWfJSvZ2z52uQ8CBXtNrv7s6xuOHC5U0eObneNfaxchGGIv2fwUfIu7VSMkS5mBZ4eILOKU0tyQn9Czn9lSz3VCOzh7F8P2os1vkj1YT8taJ5ymkiTHvOonTS1YmLdY8EJltl2yIr/2RhH9djVfCcxM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=T7aE4/kM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="T7aE4/kM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCBE3C19423;
	Sat, 28 Feb 2026 18:18:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302697;
	bh=FoVwq1DhdqHgBy148b8YjaAduBwbscPF9I7b1YEeJ14=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=T7aE4/kMTOiTxJB9kfUgLpCYWJ15o40ezDr1tc7H+8YNLtcWZVmgAQhMFGqFZTxMM
	 rIK8ALnIXuxW7DfamkKI1IlbWflO5VVkblNpmEPtPhj9mCqlJjNFfoUaGtrtnq68pR
	 TEFQrO40qgspUSrqwXqlDaEgUkqp/O121PiRSNfJG4Ha6CiAW/v86GxO/P4QNDrA+y
	 hKdqHO1ZtQ4XXH5YetZ1DyQRGvjP085FGQpoaRBsZliUaAOMT/tywsNAFBXWUCM2CZ
	 uooiLQQ1izkK/AYMWUoNCSa3RcTsTCpY23m8SUeYDisQ30LONK0ng/b37zQBOpBjHt
	 irVX5ngg42EyQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 052/147] regulator: Flag uncontrollable regulators as always_on
Date: Sat, 28 Feb 2026 13:16:00 -0500
Message-ID: <20260228181736.1605592-52-sashal@kernel.org>
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

From: Mark Brown <broonie@kernel.org>

[ Upstream commit 261f06315cf7c3744731e36bfd8d4434949e3389 ]

While we currently assume that regulators with no control available are
just uncontionally enabled this isn't always as clearly displayed to
users as is desirable, for example the code for disabling unused
regulators will log that it is about to disable them. Clean this up a
bit by setting always_on during constraint evaluation if we have no
available mechanism for controlling the regualtor so things that check
the constraint will do the right thing.

Signed-off-by: Mark Brown <broonie@kernel.org>
Link: https://lore.kernel.org/r/20220325144637.1543496-1-broonie@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Stable-dep-of: 86a8eeb0e913 ("regulator: core: move supply check earlier in set_machine_constraints()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/regulator/core.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index 3147498948373..c7c82e958a7d4 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -1491,6 +1491,24 @@ static int set_machine_constraints(struct regulator_dev *rdev)
 		}
 	}
 
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
 	/* If the constraints say the regulator should be on at this point
 	 * and we have control then make sure it is enabled.
 	 */
-- 
2.51.0

