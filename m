Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5845E33438F;
	Thu, 27 Nov 2025 14:59:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764255558; cv=none; b=jEdPDkkwQ5+eeUifOsJuUrkeDSU8oGMO3lAFMWVjsjq4s2DPU8+Kyo5FJrCFSYBSDNeeAOsqP8PAzTXXWTyQBudxoBpME5xViL7Crq8BA5YgYO8mgv0s6s9dmQzWxrBKcl6Nu9tRt+ncte9EjIjMazhIIwoolX4XYI11op7GqAk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764255558; c=relaxed/simple;
	bh=ofseeXZ4kDeJLrJvvODq4lbWkdNVzBnzdh0/xIFn4XA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kDwDMWl8hZj5+KH5HXmShDb+zAyjRMBOwTwzP6obPcsKKFMfU9F9KprSBS/IMRViXwpAyRrbR+MrtIUmGlfnmwVAhqsXkqjxpZ6mdgQil87P0/MomdQZXCG796EcZZ3RVScSGIJfC6FYuwZ/ATa6scudBK/kn7zjmBvqUtIBklw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iJkoXavI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iJkoXavI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D09C2C113D0;
	Thu, 27 Nov 2025 14:59:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764255558;
	bh=ofseeXZ4kDeJLrJvvODq4lbWkdNVzBnzdh0/xIFn4XA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iJkoXavIHWiN3HlN+QIPyvAPfVYkxP8hUsQ3s2gp79jbZOc/B4pP3Ns8DFx24r0no
	 ibVubxPdqatlkrIpYLgnu8Zx7D2IJjeZBy3efzER2SM5+Fb5f3naIPT0gKgQKbBc6G
	 JhdAIEsEy5rlA57xaPaaTdYUnkWvLx9rDCrxhEps=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Diogo Ivo <diogo.ivo@tecnico.ulisboa.pt>,
	Thierry Reding <treding@nvidia.com>
Subject: [PATCH 6.17 035/175] Revert "drm/tegra: dsi: Clear enable register if powered by bootloader"
Date: Thu, 27 Nov 2025 15:44:48 +0100
Message-ID: <20251127144044.248892553@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251127144042.945669935@linuxfoundation.org>
References: <20251127144042.945669935@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

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
@@ -913,15 +913,6 @@ static void tegra_dsi_encoder_enable(str
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


