Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7ABE91DC198;
	Thu, 12 Mar 2026 20:15:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773346517; cv=none; b=R2iEWoEQutckbGfzKS5rsrJ2Zrp8BCgMewb9SRscm388JH5toZEU3xZQ0vn288eAE65Nz8/T4U6V2l57W/8ZeoXBWBbMgDOv+GTm5p9RyHakM/jOTCGM/gSu1NWRbpmzs/zSreoYDwdYuD+sRr7hVZ78+QL+TI/7SkCkc22wtAU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773346517; c=relaxed/simple;
	bh=hJ1hMDeZK9Zo6GEUiyKJH59seWWiYT7JVzIRWvLB6+U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FX4WoIPwTCF0W4qbOZq6CHrxzdFNRGV6aHAnLEAZpHvzgOGESr42j1qNWfUKCtyMWjb4yDunjnFKKAEs+kQCl85+R2zuMpoDgfPAOddGQ0fmDKlFw8XwksKDhx2KpLRmzGUGdSNaMrolQ7nqb8pP3TSORXDhJ89zvSX5MVsGhRA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TWT9Mv4P; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TWT9Mv4P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07501C4CEF7;
	Thu, 12 Mar 2026 20:15:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773346517;
	bh=hJ1hMDeZK9Zo6GEUiyKJH59seWWiYT7JVzIRWvLB6+U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TWT9Mv4PT1+emntmbMdsVLXoy6fb4bGk29Hw8Bhc9wNzTWTgE96PRampZ/h9puhio
	 d0Xf8mDfhz7ZjJgx+3WggW1Fd0k1bii55kFZ2+yzk3c4gMMQ2/3ij0F7SruSTDja8/
	 XoyfvpZHBFXCuUu5giWR7eUxXb4KbcXSk+geRKV0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thierry Reding <treding@nvidia.com>,
	Johan Hovold <johan@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 063/265] drm/tegra: dsi: fix device leak on probe
Date: Thu, 12 Mar 2026 21:07:30 +0100
Message-ID: <20260312201020.488653112@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260312201018.128816016@linuxfoundation.org>
References: <20260312201018.128816016@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 532a8f4bee7fc..a796dc6742373 100644
--- a/drivers/gpu/drm/tegra/dsi.c
+++ b/drivers/gpu/drm/tegra/dsi.c
@@ -1540,11 +1540,9 @@ static int tegra_dsi_ganged_probe(struct tegra_dsi *dsi)
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



