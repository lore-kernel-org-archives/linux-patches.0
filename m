Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4690E221D92;
	Tue, 29 Apr 2025 18:05:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745949926; cv=none; b=VxQOg7JYxnnyrlFthEGoseUav9l7WANUy4MKX6nLaj6xkCPLot0ElPcz49w5pI8FmxTECg7Bh87DRoz/rPqKnSZWIB0ofgTSsYZINeibCyXdHb2WLKpMDLeOWB/KmvpTMvFyRn12m6ZGzpA6MNbX2Va8LDFjnCDVrDM7cQnpLwc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745949926; c=relaxed/simple;
	bh=JlUXo1RZhUle+p1y1KpQlWd5sA10+FhoymyPAmt6f0Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ncGztNoNHGxJCO06McaiRPVSVolSjGnIb5aoDB6ZOfcII5i91C0nP9x2sZDwMTxde0vPJwFPNujs8jCEKtz8iuCOpiHuh4vNYDu0V70Eu+TjCoQUfj9PeNDS/4OhHcgoEXiLIGmRMGjuA3yBsLWPEuCz8KcCFp21ga/8c/lzmIc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SmsEWkMn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SmsEWkMn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9ABAC4CEE3;
	Tue, 29 Apr 2025 18:05:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745949926;
	bh=JlUXo1RZhUle+p1y1KpQlWd5sA10+FhoymyPAmt6f0Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SmsEWkMnJWFBDC7EHTNemgJWetQkPfaw+BlFNCHacaXerlatKn7F3NO7KPQxNd/c9
	 DuFhxTV/afjkPm4JZ7b33Y4iYI2qpii+v07frrEYxlFG8bfwKXtoi4p06veCwhdPVV
	 nKnSzfm7oYv0/fNoR2fKYsBOH/H60ujVVEMJlXiE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Cristian Ciocaltea <cristian.ciocaltea@collabora.com>,
	Heiko Stuebner <heiko@sntech.de>,
	Stephen Boyd <sboyd@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 101/167] clk: check for disabled clock-provider in of_clk_get_hw_from_clkspec()
Date: Tue, 29 Apr 2025 18:43:29 +0200
Message-ID: <20250429161055.834228371@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161051.743239894@linuxfoundation.org>
References: <20250429161051.743239894@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Heiko Stuebner <heiko@sntech.de>

[ Upstream commit b20150d499b3ee5c2d632fbc5ac94f98dd33accf ]

of_clk_get_hw_from_clkspec() checks all available clock-providers by
comparing their of nodes to the one from the clkspec. If no matching
clock provider is found, the function returns -EPROBE_DEFER to cause a
re-check at a later date. If a matching clock provider is found, an
authoritative answer can be retrieved from it whether the clock exists
or not.

This does not take into account that the clock-provider may never
appear, because it's node is disabled. This can happen when a clock is
optional, provided by a separate block which never gets enabled.

One example of this happening is the rk3588's VOP, which has optional
additional display clocks coming from PLLs inside the hdmiphy blocks.
These can be used for better rates, but the system will also work
without them.

The problem around that is described in the followups to[1]. As we
already know the of node of the presumed clock provider, add a check via
of_device_is_available() whether this is a "valid" device node. This
prevents eternal defer loops.

Link: https://lore.kernel.org/dri-devel/20250215-vop2-hdmi1-disp-modes-v1-3-81962a7151d6@collabora.com/ [1]
Reviewed-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Tested-by: Cristian Ciocaltea <cristian.ciocaltea@collabora.com>
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Link: https://lore.kernel.org/r/20250222223733.2990179-1-heiko@sntech.de
[sboyd@kernel.org: Reword commit text a bit]
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/clk.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/clk/clk.c b/drivers/clk/clk.c
index 8ecbb8f494655..5a01ba04e47cf 100644
--- a/drivers/clk/clk.c
+++ b/drivers/clk/clk.c
@@ -5128,6 +5128,10 @@ of_clk_get_hw_from_clkspec(struct of_phandle_args *clkspec)
 	if (!clkspec)
 		return ERR_PTR(-EINVAL);
 
+	/* Check if node in clkspec is in disabled/fail state */
+	if (!of_device_is_available(clkspec->np))
+		return ERR_PTR(-ENOENT);
+
 	mutex_lock(&of_clk_mutex);
 	list_for_each_entry(provider, &of_clk_providers, link) {
 		if (provider->node == clkspec->np) {
-- 
2.39.5



