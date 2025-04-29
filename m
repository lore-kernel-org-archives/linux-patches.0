Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7F55233713;
	Tue, 29 Apr 2025 17:33:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745947985; cv=none; b=OU5uGhdG1lS95pdtP58HWPyioL1pkmcvtD1eKnKtkXKCkErHsNu2APV60QTfJUJWCyMnqF7YDJ2Zx1+1j3IHxTAzfOlOfJg4IKRGqrIeVxSl9gsX5/MN/VCC3I3URZGiA4BBa2j5+679IAyiCy7KLz2tLDC/UzNHvQQ4t8TLAr4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745947985; c=relaxed/simple;
	bh=2hehMzesb4uVk2QVluTPR3+fU8i74zOj1TuziJutoXI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GjChqXb7ASslYPLNF4Cy+A0puAgTYATkm77V86E2W72fUGMZ1vMCoYicWS6nZlwnrBCfL7MqRt4VbX7+bhLxVxNSVlZ4b2XXJEY3i0+1WoBitIGSg66rT/NyrlWAg09hoJNlzjP6pjGP7AibmfooEy0za70YThHEYGCpZXZ/Xb4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aDyEqDU6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aDyEqDU6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2079CC4CEE3;
	Tue, 29 Apr 2025 17:33:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745947985;
	bh=2hehMzesb4uVk2QVluTPR3+fU8i74zOj1TuziJutoXI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aDyEqDU62heiRsHmKzdiv4YqT/FPi67a40sp/RIVH4Tr9OoTaA9cM9rWYegPHnL53
	 E16nMT8ijQ/pTkd29ilIjY5/B1amOgoIrUfPHpv0od2AXDdHRn2RLiCNrsGhD3lzCx
	 TQuAUG8Ow1bApF5BhIspMlm86bpWroWKV9mXYwrc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Cristian Ciocaltea <cristian.ciocaltea@collabora.com>,
	Heiko Stuebner <heiko@sntech.de>,
	Stephen Boyd <sboyd@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 161/280] clk: check for disabled clock-provider in of_clk_get_hw_from_clkspec()
Date: Tue, 29 Apr 2025 18:41:42 +0200
Message-ID: <20250429161121.704346319@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161115.008747050@linuxfoundation.org>
References: <20250429161115.008747050@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 5b4ab94193c2b..7de3dfdae4b50 100644
--- a/drivers/clk/clk.c
+++ b/drivers/clk/clk.c
@@ -5264,6 +5264,10 @@ of_clk_get_hw_from_clkspec(struct of_phandle_args *clkspec)
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



