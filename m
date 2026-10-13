Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C115D4F052F;
	Tue, 13 Oct 2026 11:50:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791892216; cv=none; b=nJtOIQ9iBqPACq6sUzq4MTgLPBO8SbgoFArG6sBi7udZ70U5sZNjpIVNvy8ZFaPVPSj83THtBre31b5QAtkDLgV41o69SrLzEO3/bfnhjgSqAYcw9jRYFOg3Hi7tdeULELcyGTPTbN6/LvfDhYRgbNRKpFZlmLgl7tU4Q8eLpnw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791892216; c=relaxed/simple;
	bh=xJtJkFPhXCjNs+kv3vYDCelvH3fTJV/QyTQ+nNKDUro=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mCZ1Ddgy7+H/MTo4gLAA2eoDum89tgX/sKvqUP6xV2G6SEQMnNS4hf7RKMF67uk/5f/vyISBeepsxgtjhJMwwtDw4RV9R4/hhIJVvtXSC4c/TIkWm+ZqGOb743fojerKBbl/UlikkLXTooFOBzbJoLee/+NL0IPzwT35LCH0LzI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zb68GF/Q; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zb68GF/Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 240B11F000FF;
	Tue, 13 Oct 2026 11:50:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791892215;
	bh=cS+8eOmFR5O4d6smB4yS9YBrjYVCTRFjq5vLAu1384Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zb68GF/Qpm/b6aGQCwpfCEA5QMMu9nHZ5IP32OCd6P9uBqJ/1ki9CcFmRqQF2NDqg
	 V6W08eLDi3ma5D13F+qfnN/DVKlA1YJOnKA6UOlVp206nF8K8OrVdc18YeHKpdguaY
	 5vMjyVTCS+uqT5LJ1XHi51/KL0LgvZsVBePzE9Pg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shawn Lin <shawn.lin@rock-chips.com>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Ulf Hansson <ulfh@kernel.org>
Subject: [PATCH 7.2 099/281] pmdomain: rockchip: dont ignore clock lookup errors on attach
Date: Tue, 13 Oct 2026 13:36:55 +0200
Message-ID: <20261013112857.541399166@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112855.045212108@linuxfoundation.org>
References: <20261013112855.045212108@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shawn Lin <shawn.lin@rock-chips.com>

commit 4c66c423593e26273ea0d644906ed007630c6f6d upstream.

rockchip_pd_attach_dev() treated every of_clk_get() error as the end
of the clock list, so a clock that exists but is not available yet
(e.g. -EPROBE_DEFER) was silently skipped and the device ended up
without pm_clk management.  Only -ENOENT means there are no more
clocks.

Fixes: 7c696693a4f5 ("soc: rockchip: power-domain: Add power domain driver")
Signed-off-by: Shawn Lin <shawn.lin@rock-chips.com>
Reviewed-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Cc: stable@vger.kernel.org
Signed-off-by: Ulf Hansson <ulfh@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pmdomain/rockchip/pm-domains.c |   14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

--- a/drivers/pmdomain/rockchip/pm-domains.c
+++ b/drivers/pmdomain/rockchip/pm-domains.c
@@ -745,7 +745,19 @@ static int rockchip_pd_attach_dev(struct
 	}
 
 	i = 0;
-	while ((clk = of_clk_get(dev->of_node, i++)) && !IS_ERR(clk)) {
+	while (1) {
+		clk = of_clk_get(dev->of_node, i++);
+		if (IS_ERR(clk)) {
+			error = PTR_ERR(clk);
+			if (error == -ENOENT)
+				break;
+
+			dev_err(dev, "failed to get clock %d: %d\n", i - 1,
+				error);
+			pm_clk_destroy(dev);
+			return error;
+		}
+
 		dev_dbg(dev, "adding clock '%pC' to list of PM clocks\n", clk);
 		error = pm_clk_add_clk(dev, clk);
 		if (error) {


