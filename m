Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59B6F33DEF9;
	Mon, 23 Mar 2026 14:53:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774277589; cv=none; b=n7TOfMMkdpBweDjpmi4PXOSU/+SRsuWiLFKozd6vj582uH/Kfv7hRw6WPLU2K4uF8NwuNwScsG9GIvIAmM7w3bGzHWf70ddpz4hy7jA185VOZjGT4bnOk5pio+cEqj5ZG9EO6mBi+b13uQRBVqUor+dXHjxtCP6iSsKOdQ0gvlw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774277589; c=relaxed/simple;
	bh=1w1GVoGZJfG5mmtvtP7t8Onwahcw/vdcwaSPJNUPkxw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TUc+zUz1HUjQrxMiVZOxtGt21tNr2lqW2kflmPD+meQacJmW6B61lLAOdyaIWGFM/INny/ql26DdBwhIKsN6/vgXGUuoZvzoj0nfkhkBFiyVSK00kznGW2PvEWrKEFNGhTEJ3O7KXGP5ojoYTLBUpOkn8bXizzJnsNPHHy9nv1w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EUaz5wCS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EUaz5wCS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1A31C4CEF7;
	Mon, 23 Mar 2026 14:53:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774277589;
	bh=1w1GVoGZJfG5mmtvtP7t8Onwahcw/vdcwaSPJNUPkxw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EUaz5wCSx7dM3memhmhndDEFN/1yHKOwrR66Tj2FECtpsj5y67gQ6OBzSSbTWLtEU
	 kfoPWmY6uN8r2POxA0J4FOawf+3BdQ7wn4ptkAWVB4ZULWe1iaP5VsAVbjpuvJ6xiR
	 sbhvgupC3KqC8gHJ6wDxOGIh5j1KV7j/gSmiqfyg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thierry Reding <treding@nvidia.com>,
	Johan Hovold <johan@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 041/567] drm/tegra: dsi: fix device leak on probe
Date: Mon, 23 Mar 2026 14:39:21 +0100
Message-ID: <20260323134534.811906342@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134533.749096647@linuxfoundation.org>
References: <20260323134533.749096647@linuxfoundation.org>
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

From: Johan Hovold <johan@kernel.org>

[ Upstream commit bfef062695570842cf96358f2f46f4c6642c6689 ]

Make sure to drop the reference taken when looking up the companion
(ganged) device and its driver data during probe().

Note that holding a reference to a device does not prevent its driver
data from going away so there is no point in keeping the reference.

Fixes: e94236cde4d5 ("drm/tegra: dsi: Add ganged mode support")
Fixes: 221e3638feb8 ("drm/tegra: Fix reference leak in tegra_dsi_ganged_probe")
Cc: stable@vger.kernel.org	# 3.19: 221e3638feb8
Cc: Thierry Reding <treding@nvidia.com>
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Thierry Reding <treding@nvidia.com>
Link: https://patch.msgid.link/20251121164201.13188-1-johan@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/tegra/dsi.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/tegra/dsi.c b/drivers/gpu/drm/tegra/dsi.c
index 49fc4690c63af..e98eb8d0c4d77 100644
--- a/drivers/gpu/drm/tegra/dsi.c
+++ b/drivers/gpu/drm/tegra/dsi.c
@@ -1539,11 +1539,9 @@ static int tegra_dsi_ganged_probe(struct tegra_dsi *dsi)
 			return -EPROBE_DEFER;
 
 		dsi->slave = platform_get_drvdata(gangster);
-
-		if (!dsi->slave) {
-			put_device(&gangster->dev);
+		put_device(&gangster->dev);
+		if (!dsi->slave)
 			return -EPROBE_DEFER;
-		}
 
 		dsi->slave->master = dsi;
 	}
-- 
2.51.0



