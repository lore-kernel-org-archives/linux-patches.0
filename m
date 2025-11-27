Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 060BA1DEFE8;
	Thu, 27 Nov 2025 14:47:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764254871; cv=none; b=n7WS3VXbIJsR5aZmhyd50/hryROahRd7cnxiFyZ44fMQlDDieFh8ZInbJxrxUOb0NHNqY8ld7Xck2yj5E0Lj0JKmodONcuj+Us9MkBeoDvtoxvYtVBZIto5NSHzqT/H8nrjr1ynX0RjeE/zGoVBQGZtpnFerhzi7tLsRRFwz7Qk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764254871; c=relaxed/simple;
	bh=l0OE53kvPCAxryiRmqfXxlpaUWj4LouVOPamzihiLbA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Xdf3ud7aePOgZ4Fcb6wt+JXgr8Cf7JgM0tIxQ+ncLcjOALxEzP3HB783UZ1Y3ri0ylzTRPd+GMuJKviZRVbie8xd8rbNiQKCqT6CEOo7ObBQ9zxTpaXmBIN9h5b3ny7uDOyQdqTyLvG1JzaPXpnF0fLFd1wp3jGW7SiYJJgMtos=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wh8LCjrb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wh8LCjrb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 416F2C4CEF8;
	Thu, 27 Nov 2025 14:47:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764254870;
	bh=l0OE53kvPCAxryiRmqfXxlpaUWj4LouVOPamzihiLbA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wh8LCjrbIOrDTgDiSLuwKsnrWh2vrZjCUnXxIhtZ6X9Y4Mg41V5LM8aSyxqfU/s1s
	 LwhD+K08DTFWcZ8Cn8KA4Y3LGW0WPmXf0AMbi6r5Qd/4uVFXqhQk7PnSyXE9a2J5UP
	 xZTDzvKKKP2Ne/jjBok2zF309JNaU2Xm8iY9KWFA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Diogo Ivo <diogo.ivo@tecnico.ulisboa.pt>,
	Thierry Reding <treding@nvidia.com>
Subject: [PATCH 6.6 15/86] Revert "drm/tegra: dsi: Clear enable register if powered by bootloader"
Date: Thu, 27 Nov 2025 15:45:31 +0100
Message-ID: <20251127144028.374404899@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251127144027.800761504@linuxfoundation.org>
References: <20251127144027.800761504@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Diogo Ivo <diogo.ivo@tecnico.ulisboa.pt>

commit 660b299bed2a2a55a1f9102d029549d0235f881c upstream.

Commit b6bcbce33596 ("soc/tegra: pmc: Ensure power-domains are in a
known state") was introduced so that all power domains get initialized
to a known working state when booting and it does this by shutting them
down (including asserting resets and disabling clocks) before registering
each power domain with the genpd framework, leaving it to each driver to
later on power its needed domains.

This caused the Google Pixel C to hang when booting due to a workaround
in the DSI driver introduced in commit b22fd0b9639e ("drm/tegra: dsi:
Clear enable register if powered by bootloader") meant to handle the case
where the bootloader enabled the DSI hardware module. The workaround relies
on reading a hardware register to determine the current status and after
b6bcbce33596 that now happens in a powered down state thus leading to
the boot hang.

Fix this by reverting b22fd0b9639e since currently we are guaranteed
that the hardware will be fully reset by the time we start enabling the
DSI module.

Fixes: b6bcbce33596 ("soc/tegra: pmc: Ensure power-domains are in a known state")
Cc: stable@vger.kernel.org
Signed-off-by: Diogo Ivo <diogo.ivo@tecnico.ulisboa.pt>
Signed-off-by: Thierry Reding <treding@nvidia.com>
Link: https://patch.msgid.link/20251103-diogo-smaug_ec_typec-v1-1-be656ccda391@tecnico.ulisboa.pt
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/tegra/dsi.c |    9 ---------
 1 file changed, 9 deletions(-)

--- a/drivers/gpu/drm/tegra/dsi.c
+++ b/drivers/gpu/drm/tegra/dsi.c
@@ -912,15 +912,6 @@ static void tegra_dsi_encoder_enable(str
 	u32 value;
 	int err;
 
-	/* If the bootloader enabled DSI it needs to be disabled
-	 * in order for the panel initialization commands to be
-	 * properly sent.
-	 */
-	value = tegra_dsi_readl(dsi, DSI_POWER_CONTROL);
-
-	if (value & DSI_POWER_CONTROL_ENABLE)
-		tegra_dsi_disable(dsi);
-
 	err = tegra_dsi_prepare(dsi);
 	if (err < 0) {
 		dev_err(dsi->dev, "failed to prepare: %d\n", err);


