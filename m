Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5ED5A25A341;
	Mon,  9 Jun 2025 13:47:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749476829; cv=none; b=iLFt/KBGrn5rJ3opH2DNNFAOHgRMTfknbo94YqJaiFGM2zuhWGclxa7Ef7Fuh+etUaUg1mDxQySurOZYyD+SqRSoZD2BzK773565FOCXqYVAH55cEBp1fpQYbw5UZg9OIDCXtQ6XiP+ANY/Oi7K0/pxdSNO08PIeoqrCGiKV920=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749476829; c=relaxed/simple;
	bh=oVx0F96kMJ0ahtvTUJKIKVM4G6Bsm+6hvjQrGC0jZcc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=tdd6GeE2AuSb/cZwmSDU+LvDzFebwkDEPORX2eyQHuQDdsYmIMOUbRWXsjJDZuPC+5RS8FT/B31tSMoDNT137zQ/5huoDYEVrywy7NwfXrL/1c2GrxiobSA8hyofaCerXLDDi3Pex+A5nzgRLF8drMQ+Mw0cwnxAGJ2VCv962qo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LSoUAgk5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LSoUAgk5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63ED7C4CEEB;
	Mon,  9 Jun 2025 13:47:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1749476829;
	bh=oVx0F96kMJ0ahtvTUJKIKVM4G6Bsm+6hvjQrGC0jZcc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LSoUAgk5XfOQfHQataHsYf/rYjxq8vPJCLHdTTAn7yT7huz/3Z1JNhEvc19xpaD/S
	 /VtvuQtpqj7evDdcVMJiADPia1CegjLewNDNvvaSscZjYkkEKDqaUhGNcI/UWqIRE1
	 GqaLwBjbjIQrQ65eEzUKEpSu8ZQ7kNAkfqWrQWxjGqTiKF+r72jsAVz6i1KxTE9TpN
	 JoQDcBJlFG/SJD9iHL0e/7+1CHymnynyIlZEv/JFRmeYZqO1zaKRMxwEwiBpUA+5XT
	 TLEWdYnlkcrSg68jPaD6y6br3dCTeqdu7r7xuNWcJkjfsMM34BT6Qa9LvzoYOflc/4
	 7atScgu6ptw7Q==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Michael Grzeschik <m.grzeschik@pengutronix.de>,
	Minas Harutyunyan <hminas@synopsys.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>,
	linux-usb@vger.kernel.org
Subject: [PATCH AUTOSEL 6.6 09/18] usb: dwc2: also exit clock_gating when stopping udc while suspended
Date: Mon,  9 Jun 2025 09:46:43 -0400
Message-Id: <20250609134652.1344323-9-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250609134652.1344323-1-sashal@kernel.org>
References: <20250609134652.1344323-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.6.93
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Michael Grzeschik <m.grzeschik@pengutronix.de>

[ Upstream commit af076a41f8a28faf9ceb9dd2d88aef2c202ef39a ]

It is possible that the gadget will be disabled, while the udc is
suspended. When enabling the udc in that case, the clock gating
will not be enabled again. Leaving the phy unclocked. Even when the
udc is not enabled, connecting this powered but not clocked phy leads
to enumeration errors on the host side.

To ensure that the clock gating will be in an valid state, we ensure
that the clock gating will be enabled before stopping the udc.

Signed-off-by: Michael Grzeschik <m.grzeschik@pengutronix.de>
Acked-by: Minas Harutyunyan <hminas@synopsys.com>
Link: https://lore.kernel.org/r/20250417-dwc2_clock_gating-v1-1-8ea7c4d53d73@pengutronix.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

Based on my analysis of the code, similar commits, and the context, here
is my assessment:

**YES**

This commit should be backported to stable kernel trees. Here's my
extensive analysis:

## Code Analysis

The commit adds clock gating exit logic to the `dwc2_hsotg_udc_stop()`
function in drivers/usb/dwc2/gadget.c. Specifically, it adds these lines
before shutting down endpoints:

```c
/* Exit clock gating when driver is stopped. */
if (hsotg->params.power_down == DWC2_POWER_DOWN_PARAM_NONE &&
    hsotg->bus_suspended && !hsotg->params.no_clock_gating) {
    dwc2_gadget_exit_clock_gating(hsotg, 0);
}
```

## Rationale for Backporting

1. **Follows Established Pattern**: The code change exactly matches the
   pattern used throughout the dwc2 driver in other similar contexts. I
   found identical condition checks and dwc2_gadget_exit_clock_gating()
   calls in:
   - `drivers/usb/dwc2/platform.c:333-336` (driver removal)
   - `drivers/usb/dwc2/core_intr.c:314-317` (session request interrupt)
   - `drivers/usb/dwc2/core_intr.c:447-450` (wakeup detected interrupt)
   - `drivers/usb/dwc2/gadget.c:3738-3741` (USB reset detect interrupt)

2. **Fixes a Real Bug**: The commit message describes a specific
   hardware state issue: "Even when the udc is not enabled, connecting
   this powered but not clocked phy leads to enumeration errors on the
   host side." This indicates a functional problem that affects users.

3. **Low Risk, High Consistency**: The fix simply adds the same clock
   gating exit pattern that already exists in 4+ other locations in the
   same driver. This demonstrates it's a well-tested, safe pattern.

4. **Critical Hardware State Management**: Clock gating is a fundamental
   power management feature, and incorrect state handling can cause
   system hangs or hardware enumeration failures, as evidenced by the
   related fix in commit 2c6b6afa59e7 which had to be marked for stable.

5. **Matches Historical Precedent**: Looking at the reference commits:
   - Similar Commit #2 (YES): "usb: dwc2: gadget: Fix exiting from clock
     gating" - This shows clock gating exit fixes are considered
     backport-worthy
   - Similar Commit #3 (YES): "usb: dwc2: do not gate off the hardware
     if it does not support clock gating" - This reinforces that clock
     gating correctness is critical

6. **Stable Tree Criteria Met**:
   - ✅ Fixes important bug (PHY enumeration errors)
   - ✅ Small and contained change (6 lines)
   - ✅ No architectural changes
   - ✅ Minimal regression risk (uses existing, proven pattern)
   - ✅ Confined to dwc2 subsystem

7. **Recent Historical Context**: The git history shows multiple recent
   clock gating fixes that were marked for stable (31f42da31417,
   2c6b6afa59e7), indicating this subsystem area is actively maintained
   and these types of fixes are important for stable trees.

The commit addresses a state consistency issue where the clock gating
state becomes invalid when the UDC is stopped while suspended, leading
to hardware enumeration problems. This is exactly the type of subtle but
important hardware state management bug that stable trees are designed
to fix.

 drivers/usb/dwc2/gadget.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/usb/dwc2/gadget.c b/drivers/usb/dwc2/gadget.c
index ce20c06a90253..c0db3c52831a2 100644
--- a/drivers/usb/dwc2/gadget.c
+++ b/drivers/usb/dwc2/gadget.c
@@ -4601,6 +4601,12 @@ static int dwc2_hsotg_udc_stop(struct usb_gadget *gadget)
 	if (!hsotg)
 		return -ENODEV;
 
+	/* Exit clock gating when driver is stopped. */
+	if (hsotg->params.power_down == DWC2_POWER_DOWN_PARAM_NONE &&
+	    hsotg->bus_suspended && !hsotg->params.no_clock_gating) {
+		dwc2_gadget_exit_clock_gating(hsotg, 0);
+	}
+
 	/* all endpoints should be shutdown */
 	for (ep = 1; ep < hsotg->num_of_eps; ep++) {
 		if (hsotg->eps_in[ep])
-- 
2.39.5

