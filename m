Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01A5835AC07
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:18:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302698; cv=none; b=TjRJ7Du7cQNW7TqHD4Z5f3PnwqcNiSCE/neuROCw6dTW/k4KeOFjLYvkGC77ltewDc0lHTAMIqP1l2sAK4FLjzebvl7iihdvDchtkcI7SasYNRu0wBivz68GIYf4A/gtH7DVfigDufop9xgUzzKg7cfGL5aN3Z931SOMmC7dAsA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302698; c=relaxed/simple;
	bh=/pV9NBYeN+st5BDc2PVeDgw89TL5Qb/dmxNo73eOb0U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=oCKIHzzi/w3dRKpGuhQgdmwfSF2d+e/iqIj1BopAhcJ0/tnk7oHn+YOBkoKa+tHWkIaZZr4fGNdXuLzIK08VJhEHMDqoi7/CJOZemx/X4jWLk8spCg4glPgFBp+UpylqS8hpv4xjWpoNerHXaw9esLRwqzGFiu/GhJO2KZU052U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=o/70RL54; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="o/70RL54"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 658C9C19423;
	Sat, 28 Feb 2026 18:18:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302697;
	bh=/pV9NBYeN+st5BDc2PVeDgw89TL5Qb/dmxNo73eOb0U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=o/70RL54MnhGCe2C16nONSb7QtE3jQoPU9lxwL+uFYuO880wN0YoExPqb3zh8vkzc
	 mneFL53d9R0iavpWgV2rJRwoFWAIlBnF1pszcIl+WCSZ09me5STK+KB2EQd7vkAY56
	 JAv1JCou8uWnisqlWIIsnzljtYX2ePHtcxwZBX2d7NoVYAciUamEVr0fu4pPGDgAJY
	 cjZqYixAE3mzF9vfjFC9eCdVcn6f0PVbwcFMbFwpuFJC+kMtDoWorxRhW01wwHTHO+
	 dt5D/Q73i5oiSU/u290ajojMnW1fYjiFozXzZJyp7BeTNLroiT+1KgtPaPMOYs3yBY
	 ZxZuKRMpLBVFw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: =?UTF-8?q?Christian=20Kohlsch=C3=BCtter?= <christian@kohlschutter.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 053/147] regulator: core: Fix off-on-delay-us for always-on/boot-on regulators
Date: Sat, 28 Feb 2026 13:16:01 -0500
Message-ID: <20260228181736.1605592-53-sashal@kernel.org>
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

From: Christian Kohlschütter <christian@kohlschutter.com>

[ Upstream commit 218320fec29430438016f88dd4fbebfa1b95ad8d ]

Regulators marked with "regulator-always-on" or "regulator-boot-on"
as well as an "off-on-delay-us", may run into cycling issues that are
hard to detect.

This is caused by the "last_off" state not being initialized in this
case.

Fix the "last_off" initialization by setting it to the current kernel
time upon initialization, regardless of always_on/boot_on state.

Signed-off-by: Christian Kohlschütter <christian@kohlschutter.com>
Link: https://lore.kernel.org/r/FAFD5B39-E9C4-47C7-ACF1-2A04CD59758D@kohlschutter.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Stable-dep-of: 86a8eeb0e913 ("regulator: core: move supply check earlier in set_machine_constraints()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/regulator/core.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index c7c82e958a7d4..84578a107fef2 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -1509,6 +1509,9 @@ static int set_machine_constraints(struct regulator_dev *rdev)
 			rdev->constraints->always_on = true;
 	}
 
+	if (rdev->desc->off_on_delay)
+		rdev->last_off = ktime_get();
+
 	/* If the constraints say the regulator should be on at this point
 	 * and we have control then make sure it is enabled.
 	 */
@@ -1547,8 +1550,6 @@ static int set_machine_constraints(struct regulator_dev *rdev)
 
 		if (rdev->constraints->always_on)
 			rdev->use_count++;
-	} else if (rdev->desc->off_on_delay) {
-		rdev->last_off = ktime_get();
 	}
 
 	print_constraints(rdev);
-- 
2.51.0

