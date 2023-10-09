Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA3EA18E05
	for <patches@lists.linux.dev>; Mon,  9 Oct 2023 13:31:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wJBy9Pr9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63EF3C433C8;
	Mon,  9 Oct 2023 13:31:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696858283;
	bh=y0EL5b0Oa2UCpvIDw+ZyPR1ohp+GNOj6rfQnVyE6R14=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wJBy9Pr98/9ieI6JZt4GT0Lo5P957FviqHMW/L1yH/CNSYh6HrGlCSBYbkQGFll00
	 QIlKmItaYsdrjemxbtUUb/8sFL/CIZpkQb1jUtBLxETo/EQ3uv6uGKnCr2ASGOGpy8
	 NfQphd50UWV2s+IEjrZ350nJXDG3CRd7f50djx8M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dhruva Gole <d-gole@ti.com>,
	Kevin Hilman <khilman@baylibre.com>,
	Tony Lindgren <tony@atomide.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 046/131] bus: ti-sysc: Fix SYSC_QUIRK_SWSUP_SIDLE_ACT handling for uart wake-up
Date: Mon,  9 Oct 2023 15:01:26 +0200
Message-ID: <20231009130117.719401456@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231009130116.329529591@linuxfoundation.org>
References: <20231009130116.329529591@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tony Lindgren <tony@atomide.com>

[ Upstream commit e5deb8f76e64d94ccef715e75ebafffd0c312d80 ]

The uarts should be tagged with SYSC_QUIRK_SWSUP_SIDLE instead of
SYSC_QUIRK_SWSUP_SIDLE_ACT. The difference is that SYSC_QUIRK_SWSUP_SIDLE
is used to force idle target modules rather than block idle during usage.

The SYSC_QUIRK_SWSUP_SIDLE_ACT should disable autoidle and wake-up when
a target module is active, and configure autoidle and wake-up when a
target module is inactive. We are missing configuring the target module
on sysc_disable_module(), and missing toggling of the wake-up bit.

Let's fix the issue to allow uart wake-up to work.

Fixes: fb685f1c190e ("bus: ti-sysc: Handle swsup idle mode quirks")
Tested-by: Dhruva Gole <d-gole@ti.com>
Tested-by: Kevin Hilman <khilman@baylibre.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bus/ti-sysc.c | 22 +++++++++++++++++-----
 1 file changed, 17 insertions(+), 5 deletions(-)

diff --git a/drivers/bus/ti-sysc.c b/drivers/bus/ti-sysc.c
index b542c2b2aef49..70339f73181ea 100644
--- a/drivers/bus/ti-sysc.c
+++ b/drivers/bus/ti-sysc.c
@@ -1023,6 +1023,11 @@ static int sysc_enable_module(struct device *dev)
 	if (ddata->cfg.quirks & (SYSC_QUIRK_SWSUP_SIDLE |
 				 SYSC_QUIRK_SWSUP_SIDLE_ACT)) {
 		best_mode = SYSC_IDLE_NO;
+
+		/* Clear WAKEUP */
+		if (regbits->enwkup_shift >= 0 &&
+		    ddata->cfg.sysc_val & BIT(regbits->enwkup_shift))
+			reg &= ~BIT(regbits->enwkup_shift);
 	} else {
 		best_mode = fls(ddata->cfg.sidlemodes) - 1;
 		if (best_mode > SYSC_IDLE_MASK) {
@@ -1143,6 +1148,13 @@ static int sysc_disable_module(struct device *dev)
 		}
 	}
 
+	if (ddata->cfg.quirks & SYSC_QUIRK_SWSUP_SIDLE_ACT) {
+		/* Set WAKEUP */
+		if (regbits->enwkup_shift >= 0 &&
+		    ddata->cfg.sysc_val & BIT(regbits->enwkup_shift))
+			reg |= BIT(regbits->enwkup_shift);
+	}
+
 	reg &= ~(SYSC_IDLE_MASK << regbits->sidle_shift);
 	reg |= best_mode << regbits->sidle_shift;
 	if (regbits->autoidle_shift >= 0 &&
@@ -1371,16 +1383,16 @@ static const struct sysc_revision_quirk sysc_revision_quirks[] = {
 	SYSC_QUIRK("timer", 0, 0, 0x10, -ENODEV, 0x4fff1301, 0xffff00ff,
 		   0),
 	SYSC_QUIRK("uart", 0, 0x50, 0x54, 0x58, 0x00000046, 0xffffffff,
-		   SYSC_QUIRK_SWSUP_SIDLE | SYSC_QUIRK_LEGACY_IDLE),
+		   SYSC_QUIRK_SWSUP_SIDLE_ACT | SYSC_QUIRK_LEGACY_IDLE),
 	SYSC_QUIRK("uart", 0, 0x50, 0x54, 0x58, 0x00000052, 0xffffffff,
-		   SYSC_QUIRK_SWSUP_SIDLE | SYSC_QUIRK_LEGACY_IDLE),
+		   SYSC_QUIRK_SWSUP_SIDLE_ACT | SYSC_QUIRK_LEGACY_IDLE),
 	/* Uarts on omap4 and later */
 	SYSC_QUIRK("uart", 0, 0x50, 0x54, 0x58, 0x50411e03, 0xffff00ff,
-		   SYSC_QUIRK_SWSUP_SIDLE | SYSC_QUIRK_LEGACY_IDLE),
+		   SYSC_QUIRK_SWSUP_SIDLE_ACT | SYSC_QUIRK_LEGACY_IDLE),
 	SYSC_QUIRK("uart", 0, 0x50, 0x54, 0x58, 0x47422e03, 0xffffffff,
-		   SYSC_QUIRK_SWSUP_SIDLE | SYSC_QUIRK_LEGACY_IDLE),
+		   SYSC_QUIRK_SWSUP_SIDLE_ACT | SYSC_QUIRK_LEGACY_IDLE),
 	SYSC_QUIRK("uart", 0, 0x50, 0x54, 0x58, 0x47424e03, 0xffffffff,
-		   SYSC_QUIRK_SWSUP_SIDLE | SYSC_QUIRK_LEGACY_IDLE),
+		   SYSC_QUIRK_SWSUP_SIDLE_ACT | SYSC_QUIRK_LEGACY_IDLE),
 
 	/* Quirks that need to be set based on the module address */
 	SYSC_QUIRK("mcpdm", 0x40132000, 0, 0x10, -ENODEV, 0x50000800, 0xffffffff,
-- 
2.40.1



