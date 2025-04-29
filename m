Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9F572459EE;
	Tue, 29 Apr 2025 16:53:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745945580; cv=none; b=YJVUjIYUwMgOGTKc5z0M5+VxRng0IhIOnij4Owjr0QMZRTWEUz8abeRm6kICw2m4OdcWo36JDnHumNpM7HmZXV1sKtyX/XZ9n0vgk4iaXW6iNNbImrigIKC8noZUeaotKxL461kNOAkNhgLK+HUWe6SJl7/t+WBpvyxkYcUIZmM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745945580; c=relaxed/simple;
	bh=tl6a+qrLTThsts1jBDZioWp7NqKaGkoHQHOK3uHVA1Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Gaol3CKQPPVh8Guiwqyyb8vALvUjG34QzWsobo9m5VDBE1dZsCwF+KoS+BOwm2blDzFtFVlBafYs6o4sj7EG5SGX6VGTtI+FcE7IaQNbopMHhjPk6p1KTGX6Qi0mkI/AKhHGcCJnm8rMMRpmhAfHPEvhcapI5BzznVhriqCWja8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=etrO7raP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="etrO7raP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBDEFC4CEE3;
	Tue, 29 Apr 2025 16:52:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745945580;
	bh=tl6a+qrLTThsts1jBDZioWp7NqKaGkoHQHOK3uHVA1Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=etrO7raPQJ86yXpUCjuNXzayYYzXSznWsV7gc8hz4XtfgPWOs1kK59dHXRSSYNlLv
	 LfZCCm2RmJ/0bFCT8E76AGtXefcuBWc/7Fq0pqd9g3lJs93RCeF3yr4Dc7MUrXKpsD
	 YVjSeUFTDHKa9iEkeIwbhc3Pf88ySxvEAqVSrs4U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Cristian Ciocaltea <cristian.ciocaltea@collabora.com>,
	Heiko Stuebner <heiko@sntech.de>,
	Stephen Boyd <sboyd@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 161/179] clk: check for disabled clock-provider in of_clk_get_hw_from_clkspec()
Date: Tue, 29 Apr 2025 18:41:42 +0200
Message-ID: <20250429161055.891811602@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161049.383278312@linuxfoundation.org>
References: <20250429161049.383278312@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 56be3f97c265a..6ef5bf61fdd47 100644
--- a/drivers/clk/clk.c
+++ b/drivers/clk/clk.c
@@ -4727,6 +4727,10 @@ of_clk_get_hw_from_clkspec(struct of_phandle_args *clkspec)
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



