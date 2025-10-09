Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DDFD2F49E0;
	Thu,  9 Oct 2025 16:00:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760025633; cv=none; b=GGfBtGJE5O/9CScARrZ4qLc25CMoiULnPq5S6Wai7nr/JCaYjxvXb5rl4pmyk6CV2GIi2GTfYidz8uLKznIYUT8xcf3wkYpr9rWplCAoh8Jyf1aPi4Sy8lvsiMG184iWkTpmD9hZNBHNUmz+ut5S5ogpidtDnMAynwOZadglt5k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760025633; c=relaxed/simple;
	bh=yxRS0gKNBTbFJ6hM5audxgolRkFAftUgg65f7Wb+Qo8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=F+v0EKO8Tf+rdFplBhG4Kn61/pCyLLd6T6g48rDadnqvxnt3jT447OfWhp86PpTkgknwBMpQ6i9b7QTOef6ijE1cysItO2VJI6pjJl5VshkZWeOMZiDcBISCUtRVAF72eRp2aRV9BwLFu3iIBhaWaV/QHQSTaCx+xbO/Qp31Lqs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZdORUXiP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZdORUXiP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10B38C4CEF8;
	Thu,  9 Oct 2025 16:00:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760025633;
	bh=yxRS0gKNBTbFJ6hM5audxgolRkFAftUgg65f7Wb+Qo8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZdORUXiPjvcoINvMp3Ehx0e2AzQuABwDLS1gFfoBkyFnG74CFpYJx8MdUAZo4IAK+
	 zrNbyA9xqfc9VuledOSKijxywUh/TWs23v6xs29rUbHvzwkDk3BnzPVu6ziZrt1de1
	 qSmI9G68PkFOa0PrZ6quoa098fzGUVRH8NwGsq0QJkAb7Oqw50t+3Cn+TIGrvCn8CK
	 Au6ycyCjqhiCXbcy36M0J2420jePjPIzhOJ2vINYwQR6kL9re3aZOvL1WlKcT9QZvc
	 /sVMjFMmcksA9rqv1V2RANUjpuKlDSoMWGGywoX6aM8he6FxzYO9Pl0lCXt2N+tMo7
	 j8SuDia0YJYLA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Charles Keepax <ckeepax@opensource.cirrus.com>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	david.rhodes@cirrus.com,
	rf@opensource.cirrus.com,
	linux-sound@vger.kernel.org,
	patches@opensource.cirrus.com
Subject: [PATCH AUTOSEL 6.17-6.16] mfd: cs42l43: Move IRQ enable/disable to encompass force suspend
Date: Thu,  9 Oct 2025 11:55:52 -0400
Message-ID: <20251009155752.773732-86-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251009155752.773732-1-sashal@kernel.org>
References: <20251009155752.773732-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.17.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Charles Keepax <ckeepax@opensource.cirrus.com>

[ Upstream commit 62aec8a0a5b61f149bbe518c636e38e484812499 ]

As pm_runtime_force_suspend() will force the device state to suspend,
the driver needs to ensure no IRQ handlers are currently running. If not
those handlers may find they are now running on suspended hardware
despite holding a PM runtime reference. disable_irq() will sync any
currently running handlers, so move the IRQ disabling to cover the whole
of the forced suspend state to avoid such race conditions.

Signed-off-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Link: https://lore.kernel.org/r/20250903094549.271068-6-ckeepax@opensource.cirrus.com
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

YES

- What it fixes: The change prevents a race where an IRQ handler can
  still be running (or be scheduled) while
  `pm_runtime_force_suspend(dev)` forcibly suspends the device, causing
  the handler to operate on suspended hardware despite holding a PM-
  runtime reference. Moving `disable_irq()` earlier synchronizes with
  any in-flight handler and prevents new ones from running until the
  device is safely resumed.

- Precise code movement (suspend): In `cs42l43_suspend()`,
  `disable_irq(cs42l43->irq)` is moved to precede
  `pm_runtime_force_suspend(dev)`, guaranteeing that all IRQ handling is
  quiesced before the forced suspend runs. See
  `drivers/mfd/cs42l43.c:1128` (disable) and
  `drivers/mfd/cs42l43.c:1130` (force suspend). Previously, the disable
  was after the power-down path, which left a window for the race.

- Precise code movement (resume): In `cs42l43_resume()`,
  `enable_irq(cs42l43->irq)` is moved to after
  `pm_runtime_force_resume(dev)`, ensuring the device is fully resumed
  (including regcache sync and device state restoration) before IRQ
  handlers can run. See `drivers/mfd/cs42l43.c:1173` (force resume) and
  `drivers/mfd/cs42l43.c:1179` (enable).

- Noirq stage unchanged and still consistent: The noirq callbacks
  continue to flip the line as before to align with system-wide
  interrupt state during suspend/resume:
  - `cs42l43_suspend_noirq()` enables the IRQ line just before the noirq
    phase begins to preserve wake semantics;
    `drivers/mfd/cs42l43.c:1146` and `drivers/mfd/cs42l43.c:1150`.
  - `cs42l43_resume_noirq()` disables it during noirq resume, deferring
    final enabling until the device is fully resumed;
    `drivers/mfd/cs42l43.c:1155` and `drivers/mfd/cs42l43.c:1159`.

- Why the ordering matters: `pm_runtime_force_suspend()` explicitly
  ignores usage counts and can suspend while other code holds PM-runtime
  references. `disable_irq()` is synchronous and waits for any running
  threaded IRQ handler to complete, closing the race window.
  Symmetrically, deferring `enable_irq()` until after
  `pm_runtime_force_resume()` ensures the device is configured and
  regcache-synced before any handler runs.

- Scope and risk: The change is tiny (4 insertions, 4 deletions) and
  fully contained to `drivers/mfd/cs42l43.c`. It does not alter
  interfaces or introduce new features. It only adjusts IRQ mask timing
  around force suspend/resume, reducing the risk of handlers touching
  suspended hardware. This is precisely the kind of correctness fix that
  the stable tree seeks.

- Subsystem impact: It touches only the cs42l43 MFD driver, not core PM
  or IRQ subsystems. The driver uses regmap-IRQ and SoundWire; the fix
  is local and does not change those frameworks’ behavior.

- Historical context: The driver began disabling IRQs around system
  suspend in an earlier change (“mfd: cs42l43: Disable IRQs during
  suspend”, 2bb0106db90f8, v6.13-rc1 era). This commit corrects the
  exact placement to cover the `pm_runtime_force_suspend()` window. A
  later cleanup (“mfd: cs42l43: Remove IRQ masking in suspend”,
  afe0f94992dbe) only removes device-level register masking and is
  independent of this ordering fix; it’s not needed to realize this bug
  fix.

- Dependencies and backport nuances: This patch relies on the driver
  already managing the IRQ line in system suspend/resume paths (present
  since 2bb0106db90f8). For stable series that include cs42l43 with MFD-
  level IRQ handling (e.g., 6.13+), this applies cleanly and fixes a
  real race. Older series where IRQ masking lived in the CODEC driver
  may not need this exact change or may require backport coordination
  with the earlier IRQ-management shift.

- Security and regression risk assessment:
  - Security: Prevents potential misbehavior on suspended hardware
    (timeouts, bus errors), but not a direct memory corruption or
    privilege escalation. Low security impact, but improves robustness.
  - Regression risk: Very low. Using `disable_irq()` before suspend and
    `enable_irq()` after resume is a common, safe pattern to serialize
    handlers around device power transitions.

- Stable tree criteria:
  - Fixes a real user-visible race condition with IRQ handling during
    suspend.
  - Small and contained; no architectural changes.
  - No side effects beyond making suspend/resume sequencing correct.
  - No new features.
  - Clear rationale in commit message; aligns with stable policy.

Conclusion: This is a solid, minimal bug fix with low risk and clear
correctness benefits for cs42l43 users. It should be backported to
stable trees that contain the cs42l43 MFD IRQ-management suspend/resume
logic.

 drivers/mfd/cs42l43.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/mfd/cs42l43.c b/drivers/mfd/cs42l43.c
index 07c8f1b8183ee..959298c8232f4 100644
--- a/drivers/mfd/cs42l43.c
+++ b/drivers/mfd/cs42l43.c
@@ -1151,6 +1151,8 @@ static int cs42l43_suspend(struct device *dev)
 		return ret;
 	}
 
+	disable_irq(cs42l43->irq);
+
 	ret = pm_runtime_force_suspend(dev);
 	if (ret) {
 		dev_err(cs42l43->dev, "Failed to force suspend: %d\n", ret);
@@ -1164,8 +1166,6 @@ static int cs42l43_suspend(struct device *dev)
 	if (ret)
 		return ret;
 
-	disable_irq(cs42l43->irq);
-
 	return 0;
 }
 
@@ -1196,14 +1196,14 @@ static int cs42l43_resume(struct device *dev)
 	if (ret)
 		return ret;
 
-	enable_irq(cs42l43->irq);
-
 	ret = pm_runtime_force_resume(dev);
 	if (ret) {
 		dev_err(cs42l43->dev, "Failed to force resume: %d\n", ret);
 		return ret;
 	}
 
+	enable_irq(cs42l43->irq);
+
 	return 0;
 }
 
-- 
2.51.0

