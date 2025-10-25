Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2769D26E6F6;
	Sat, 25 Oct 2025 16:15:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761408920; cv=none; b=ukI7DdCTNatRGAudNf+gPrcjTegXYbtK7sIAY2CiR2NL+8J1TXFA/XUAEPyoGMofwMRYMh4C9xefX+3BMHwrWX1zF/sZ+Kv7CGVdQbNQjhnMgtBLLi9L+x0dyWNo+k2XB3x3sv/Ynp3/j9lxdNHoNgQN41fEO9pI/3BXigHNBig=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761408920; c=relaxed/simple;
	bh=X2WA58Bzf5AHWeoYLMgaK1A19yba3RlyVYXlxKbZ/t4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=u9BOuAFc4mHQIPYZ35faw9f5BbroMb6FKXBoMYxbsFg0M/EMV0sLzhq+L/21TlEpobWAMAtbGNMWwzRsfTyr/lcZo73Vhn73soo+2uSFKAirskYm9EBEnu03/PZkOW1EMYQtfzO9VoYa5EFb6kBDicFyqnWU7SHmFH3y8/5UtIQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fQYd8PfA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fQYd8PfA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C651C4CEFB;
	Sat, 25 Oct 2025 16:15:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761408920;
	bh=X2WA58Bzf5AHWeoYLMgaK1A19yba3RlyVYXlxKbZ/t4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fQYd8PfAT9FEx2UkxNaqdBZ2UY0r0rK81oHrxJ2GeSF3SXEiPyPct/BAm2ti0KpGs
	 m476O/13z3/UiUSG07JHCmvT/GHvvHc09V1GOD0VqEVmehrwqMCL9BmuEY5upQabxp
	 HAxcOun3cMwB487zA5UoPWtValXx/5psVPYq8/yjmt/3J/ntbZXz1noHnIKF+qVGyC
	 kCsf9dedkA6kMX+VB4k8GrVT63k6IpLVokPn/TVxFuM8aVj04OhtI72cmC8MSYLGE6
	 6Hc/9xIRqvoz1KWMys1EA5yWVOy4KeEAfBEKhrCi9UNC9rb1gN3sf0xClzn2ds1nzj
	 I6O9xqEL1WjRQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>,
	robh@kernel.org,
	linux-serial@vger.kernel.org
Subject: [PATCH AUTOSEL 6.17] serdev: Drop dev_pm_domain_detach() call
Date: Sat, 25 Oct 2025 11:56:03 -0400
Message-ID: <20251025160905.3857885-132-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251025160905.3857885-1-sashal@kernel.org>
References: <20251025160905.3857885-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.17.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>

[ Upstream commit e3fa89f3a768a9c61cf1bfe86b939ab5f36a9744 ]

Starting with commit f99508074e78 ("PM: domains: Detach on
device_unbind_cleanup()"), there is no longer a need to call
dev_pm_domain_detach() in the bus remove function. The
device_unbind_cleanup() function now handles this to avoid
invoking devres cleanup handlers while the PM domain is
powered off, which could otherwise lead to failures as
described in the above-mentioned commit.

Drop the explicit dev_pm_domain_detach() call and rely instead
on the flags passed to dev_pm_domain_attach() to power off the
domain.

Signed-off-by: Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>
Reviewed-by: Ulf Hansson <ulf.hansson@linaro.org>
Link: https://lore.kernel.org/r/20250827101747.928265-1-claudiu.beznea.uj@bp.renesas.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

YES

**Why This Fix Matters**
- Prevents wrong unbind ordering after PM core change: The PM core now
  detaches PM domains in `device_unbind_cleanup()` after devres cleanup
  to avoid running devres handlers while the PM domain is powered off.
  See `drivers/base/dd.c:548-561` where `device_unbind_cleanup()` calls
  `dev_pm_domain_detach(dev, dev->power.detach_power_off)` only after
  `devres_release_all(dev)`.
- If serdev keeps explicitly detaching in its bus `remove` path, the PM
  domain may be powered off before devres cleanup runs, reintroducing
  the failure scenario described in the PM core change.

**What The Patch Changes**
- Adds `PD_FLAG_DETACH_POWER_OFF` to `dev_pm_domain_attach()`:
  - `drivers/tty/serdev/core.c:402-407` changes to:
    - `ret = dev_pm_domain_attach(dev, PD_FLAG_ATTACH_POWER_ON |
      PD_FLAG_DETACH_POWER_OFF);`
    - On success, it directly returns `sdrv->probe(...)` without local
      detach on probe failure. The unbind path handles detach (see
      below).
  - This flag sets `dev->power.detach_power_off` so the core knows to
    power off the domain on detach; see
    `drivers/base/power/common.c:103-119`.
- Removes the explicit `dev_pm_domain_detach()` calls:
  - `drivers/tty/serdev/core.c:410-415` no longer detaches in
    `serdev_drv_remove()`.
  - On probe failure or driver removal, the device core’s
    `really_probe()` calls `device_unbind_cleanup(dev);` which detaches
    at the right time:
    - Probe error and cleanup path: `drivers/base/dd.c:714-727` (note
      `device_unbind_cleanup(dev)` at `drivers/base/dd.c:725`).
    - Test-remove path: `drivers/base/dd.c:692-701` (note
      `device_unbind_cleanup(dev)` at `drivers/base/dd.c:699`).

**Dependencies That Gate Safe Backporting**
- Requires the PM core change that introduced detach in
  `device_unbind_cleanup()` and the `PD_FLAG_DETACH_POWER_OFF` flag:
  - `device_unbind_cleanup()` performs `dev_pm_domain_detach()` late:
    `drivers/base/dd.c:548-561`.
  - `dev_pm_domain_attach()` sets `dev->power.detach_power_off` from
    flags: `drivers/base/power/common.c:103-119`.
  - `PD_FLAG_DETACH_POWER_OFF` is defined in
    `include/linux/pm_domain.h:48`.
- The commit message cites the dependency commit “PM: domains: Detach on
  device_unbind_cleanup()” (f99508074e78). This serdev change is a
  follow-on fix to align bus behavior with the new core semantics.

**Risk and Stable Criteria**
- Small, localized change confined to serdev bus init/unbind.
- No new features or API changes; aligns with existing patterns already
  used by other buses (e.g., platform and auxiliary use
  `PD_FLAG_DETACH_POWER_OFF`).
- Fixes real failure potential when the PM core change is present
  (avoids devres running with the PM domain powered off).
- Regression risk is low provided the PM core dependency (detach in
  `device_unbind_cleanup()` and `PD_FLAG_DETACH_POWER_OFF`) is present;
  without that dependency, removing explicit detach would be incorrect.

In summary: This is a targeted follow-on fix that should be backported
to any stable tree that already contains the PM core change
(device_unbind_cleanup() performing detach and
`PD_FLAG_DETACH_POWER_OFF`). It prevents ordering-related failures with
minimal risk and scope.

 drivers/tty/serdev/core.c | 11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

diff --git a/drivers/tty/serdev/core.c b/drivers/tty/serdev/core.c
index d16c207a1a9b2..b33e708cb2455 100644
--- a/drivers/tty/serdev/core.c
+++ b/drivers/tty/serdev/core.c
@@ -399,15 +399,12 @@ static int serdev_drv_probe(struct device *dev)
 	const struct serdev_device_driver *sdrv = to_serdev_device_driver(dev->driver);
 	int ret;
 
-	ret = dev_pm_domain_attach(dev, PD_FLAG_ATTACH_POWER_ON);
+	ret = dev_pm_domain_attach(dev, PD_FLAG_ATTACH_POWER_ON |
+					PD_FLAG_DETACH_POWER_OFF);
 	if (ret)
 		return ret;
 
-	ret = sdrv->probe(to_serdev_device(dev));
-	if (ret)
-		dev_pm_domain_detach(dev, true);
-
-	return ret;
+	return sdrv->probe(to_serdev_device(dev));
 }
 
 static void serdev_drv_remove(struct device *dev)
@@ -415,8 +412,6 @@ static void serdev_drv_remove(struct device *dev)
 	const struct serdev_device_driver *sdrv = to_serdev_device_driver(dev->driver);
 	if (sdrv->remove)
 		sdrv->remove(to_serdev_device(dev));
-
-	dev_pm_domain_detach(dev, true);
 }
 
 static const struct bus_type serdev_bus_type = {
-- 
2.51.0

