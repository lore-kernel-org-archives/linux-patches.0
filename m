Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CF50224AF2;
	Tue,  6 Jan 2026 18:01:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767722495; cv=none; b=DmdFMHfU4e69sD0aBUy/XYzY9cBNKHRhCVd9VcPOB6xnlbswGsitoETiPOoeZ7gX2rX37W3BWr4P1wX+i9gtpHvq0g8WiJLG2369Ips76HNaE5hB5RDY0JA1acwiKoN5HyEoXfKIYCL7/KHfik1gHewX5MJQ7W9dDcl5fNPm9mQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767722495; c=relaxed/simple;
	bh=Ioh3MfjA5eYhOZTZyJXnqtkD7toeBnvlqeqPubJ45f8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ubzCnki2BuZ60UxW00Q8X606nXsi77Q1wemlcfSSrqTm/Q5V/uW4hCaDZnRHeYAqapKo5s5L40s3YQkJs+b41gtbGn4k2zAqJgsUPUqXjno/R9wf4wDOfSfH8dJYjUlrmKIvIhHRo0816RXaZohP1NIhKHiJsCeMvmCMcrX3vPI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VlkQLOn7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VlkQLOn7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCAD6C116C6;
	Tue,  6 Jan 2026 18:01:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767722495;
	bh=Ioh3MfjA5eYhOZTZyJXnqtkD7toeBnvlqeqPubJ45f8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VlkQLOn7fXSRL+6mPDxZV74fxvt2NxSWBDivQFgd9uo6AsGTA3ytfv63qTvy/aAgf
	 vrZCAlNk3tddwNq5H3O0gKVLpYP620wKzXlv2020YxiEaHPl/HKNrNed4P5mg9+Uo9
	 PjP0Hc3/40IoBsoP/DkWZIMyIqKtlnyojXFj2f54=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Jo=C3=A3o=20Paulo=20Gon=C3=A7alves?= <joao.goncalves@toradex.com>,
	Emanuele Ghidoli <emanuele.ghidoli@toradex.com>,
	=?UTF-8?q?Herv=C3=A9=20Codina?= <herve.codina@bootlin.com>,
	Luca Ceresoli <luca.ceresoli@bootlin.com>,
	Maxime Ripard <mripard@kernel.org>
Subject: [PATCH 6.18 282/312] drm/bridge: ti-sn65dsi83: ignore PLL_UNLOCK errors
Date: Tue,  6 Jan 2026 18:05:56 +0100
Message-ID: <20260106170558.053868773@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170547.832845344@linuxfoundation.org>
References: <20260106170547.832845344@linuxfoundation.org>
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

From: Luca Ceresoli <luca.ceresoli@bootlin.com>

commit 35e282c1868de3c9d15f9a8812cbb2e7da06b0c1 upstream.

On hardware based on Toradex Verdin AM62 the recovery mechanism added by
commit ad5c6ecef27e ("drm: bridge: ti-sn65dsi83: Add error recovery
mechanism") has been reported [0] to make the display turn on and off and
and the kernel logging "Unexpected link status 0x01".

According to the report, the error recovery mechanism is triggered by the
PLL_UNLOCK error going active. Analysis suggested the board is unable to
provide the correct DSI clock neede by the SN65DSI84, to which the TI
SN65DSI84 reacts by raising the PLL_UNLOCK, while the display still works
apparently without issues.

On other hardware, where all the clocks are within the components
specifications, the PLL_UNLOCK bit does not trigger while the display is in
normal use. It can trigger for e.g. electromagnetic interference, which is
a transient event and exactly the reason why the error recovery mechanism
has been implemented.

Idelly the PLL_UNLOCK bit could be ignored when working out of
specification, but this requires to detect in software whether it triggers
because the device is working out of specification but visually correctly
for the user or for good reasons (e.g. EMI, or even because working out of
specifications but compromising the visual output).

The ongoing analysis as of this writing [1][2] has not yet found a way for
the driver to discriminate among the two cases. So as a temporary measure
mask the PLL_UNLOCK error bit unconditionally.

[0] https://lore.kernel.org/r/bhkn6hley4xrol5o3ytn343h4unkwsr26p6s6ltcwexnrsjsdx@mgkdf6ztow42
[1] https://lore.kernel.org/all/b71e941c-fc8a-4ac1-9407-0fe7df73b412@gmail.com/
[2] https://lore.kernel.org/all/20251125103900.31750-1-francesco@dolcini.it/

Fixes: ad5c6ecef27e ("drm: bridge: ti-sn65dsi83: Add error recovery mechanism")
Closes: https://lore.kernel.org/r/bhkn6hley4xrol5o3ytn343h4unkwsr26p6s6ltcwexnrsjsdx@mgkdf6ztow42
Cc: stable@vger.kernel.org # 6.15+
Reported-by: João Paulo Gonçalves <joao.goncalves@toradex.com>
Tested-by: Emanuele Ghidoli <emanuele.ghidoli@toradex.com>
Co-developed-by: Hervé Codina <herve.codina@bootlin.com>
Signed-off-by: Hervé Codina <herve.codina@bootlin.com>
Signed-off-by: Luca Ceresoli <luca.ceresoli@bootlin.com>
Link: https://patch.msgid.link/20251127-drm-ti-sn65dsi83-ignore-pll-unlock-v1-1-8a03fdf562e9@bootlin.com
Signed-off-by: Maxime Ripard <mripard@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/bridge/ti-sn65dsi83.c |   11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/bridge/ti-sn65dsi83.c
+++ b/drivers/gpu/drm/bridge/ti-sn65dsi83.c
@@ -429,7 +429,14 @@ static void sn65dsi83_handle_errors(stru
 	 */
 
 	ret = regmap_read(ctx->regmap, REG_IRQ_STAT, &irq_stat);
-	if (ret || irq_stat) {
+
+	/*
+	 * Some hardware (Toradex Verdin AM62) is known to report the
+	 * PLL_UNLOCK error interrupt while working without visible
+	 * problems. In lack of a reliable way to discriminate such cases
+	 * from user-visible PLL_UNLOCK cases, ignore that bit entirely.
+	 */
+	if (ret || irq_stat & ~REG_IRQ_STAT_CHA_PLL_UNLOCK) {
 		/*
 		 * IRQ acknowledged is not always possible (the bridge can be in
 		 * a state where it doesn't answer anymore). To prevent an
@@ -654,7 +661,7 @@ static void sn65dsi83_atomic_enable(stru
 	if (ctx->irq) {
 		/* Enable irq to detect errors */
 		regmap_write(ctx->regmap, REG_IRQ_GLOBAL, REG_IRQ_GLOBAL_IRQ_EN);
-		regmap_write(ctx->regmap, REG_IRQ_EN, 0xff);
+		regmap_write(ctx->regmap, REG_IRQ_EN, 0xff & ~REG_IRQ_EN_CHA_PLL_UNLOCK_EN);
 	} else {
 		/* Use the polling task */
 		sn65dsi83_monitor_start(ctx);


