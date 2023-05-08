Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E70BA171A1
	for <patches@lists.linux.dev>; Mon,  8 May 2023 11:32:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69AC7C433D2;
	Mon,  8 May 2023 11:32:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683545573;
	bh=eQlu+AAUvvB5MxX9Rv+o6FBnde/Cws4SK9IQDge22Dc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TvUtq2qHmafbFDD3SNAbftvnVRJ+SXS0Dyj22ZVNiEXPdgrewa74pNORhxv3w/KbD
	 7z1d3fsO/dQcBvZY2l1kwAb0IEYk7OH7qVf7iCh2Nx7BbY2OplCHhPbu1oIotM2B7d
	 xDbgROiBP/FqPR6B0+2vPrrQAKK5H1dPXgrhg2/M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Christian=20Kohlsch=C3=BCtter?= <christian@kohlschutter.com>,
	Douglas Anderson <dianders@chromium.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 084/371] regulator: core: Shorten off-on-delay-us for always-on/boot-on by time since booted
Date: Mon,  8 May 2023 11:44:45 +0200
Message-Id: <20230508094815.420248425@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094811.912279944@linuxfoundation.org>
References: <20230508094811.912279944@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Douglas Anderson <dianders@chromium.org>

[ Upstream commit 691c1fcda5351ed98a44610b7dccc0e3ee920020 ]

This is very close to a straight revert of commit 218320fec294
("regulator: core: Fix off-on-delay-us for always-on/boot-on
regulators"). We've identified that patch as causing a boot speed
regression on sc7180-trogdor boards. While boot speed certainly isn't
more important than making sure that power sequencing is correct,
looking closely at the original change it doesn't seem to have been
fully justified. It mentions "cycling issues" without describing
exactly what the issues were. That means it's possible that the
cycling issues were really a problem that should be fixed in a
different way.

Let's take a careful look at how we should handle regulators that have
an off-on-delay and that are boot-on or always-on. Linux currently
doesn't have any way to identify whether a GPIO regulator was already
on when the kernel booted. That means that when the kernel boots we
probe a regulator, see that it wants boot-on / always-on we, and then
turn the regulator on. We could be in one of two cases when we do
this:

a) The regulator might have been left on by the bootloader and we're
   ensuring that it stays on.
b) The regulator might have been left off by the bootloader and we're
   just now turning it on.

For case a) we definitely don't need any sort of delay. For case b) we
_might_ need some delay in case the bootloader turned the regulator
off _right_ before booting the kernel. To get the proper delay for
case b) then we can just assume a `last_off` of 0, which is what it
gets initialized to by default.

As per above, we can't tell whether we're in case a) or case b) so
we'll assume the longer delay (case b). This basically puts the code
to how it was before commit 218320fec294 ("regulator: core: Fix
off-on-delay-us for always-on/boot-on regulators"). However, we add
one important change: we make sure that the delay is actually honored
if `last_off` is 0. Though the original "cycling issues" cited were
vague, I'm hopeful that this important extra change will be enough to
fix the issues that the initial commit mentioned.

With this fix, I've confined that on a sc7180-trogdor board the delay
at boot goes down from 500 ms to ~250 ms. That's not as good as the 0
ms that we had prior to commit 218320fec294 ("regulator: core: Fix
off-on-delay-us for always-on/boot-on regulators"), but it's probably
safer because we don't know if the bootloader turned the regulator off
right before booting.

One note is that it's possible that we could be in a state that's not
a) or b) if there are other issues in the kernel. The only one I can
think of is related to pinctrl. If the pinctrl driver being used on a
board isn't careful about avoiding glitches when setting up a pin then
it's possible that setting up a pin could cause the regulator to "turn
off" briefly immediately before the regulator probes. If this is
indeed causing problems then the pinctrl driver should be fixed,
perhaps in a similar way to what was done in commit d21f4b7ffc22
("pinctrl: qcom: Avoid glitching lines when we first mux to output")

Fixes: 218320fec294 ("regulator: core: Fix off-on-delay-us for always-on/boot-on regulators")
Cc: Christian Kohlschütter <christian@kohlschutter.com>
Signed-off-by: Douglas Anderson <dianders@chromium.org>
Link: https://lore.kernel.org/r/20230313111806.1.I2eaad872be0932a805c239a7c7a102233fb0b03b@changeid
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/regulator/core.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index cd10880378a6d..e876702d6ef36 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -1539,9 +1539,6 @@ static int set_machine_constraints(struct regulator_dev *rdev)
 			rdev->constraints->always_on = true;
 	}
 
-	if (rdev->desc->off_on_delay)
-		rdev->last_off = ktime_get_boottime();
-
 	/* If the constraints say the regulator should be on at this point
 	 * and we have control then make sure it is enabled.
 	 */
@@ -1575,6 +1572,8 @@ static int set_machine_constraints(struct regulator_dev *rdev)
 
 		if (rdev->constraints->always_on)
 			rdev->use_count++;
+	} else if (rdev->desc->off_on_delay) {
+		rdev->last_off = ktime_get();
 	}
 
 	print_constraints(rdev);
@@ -2624,7 +2623,7 @@ static int _regulator_do_enable(struct regulator_dev *rdev)
 
 	trace_regulator_enable(rdev_get_name(rdev));
 
-	if (rdev->desc->off_on_delay && rdev->last_off) {
+	if (rdev->desc->off_on_delay) {
 		/* if needed, keep a distance of off_on_delay from last time
 		 * this regulator was disabled.
 		 */
-- 
2.39.2



