Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 787EC26CE32;
	Mon, 13 Apr 2026 16:20:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776097221; cv=none; b=awX3C+lpmfuLblBgcXEM9aC8YksUjg3Qgtp+1Q+C/mGWGhyUz+/wtUqe0fLjpnZKrCF2No1ayX+fKOyR5Qutq40U3qLIGqzuVTL5mq/DoVGyCkLnwbRFoT4/iG0NGBKSXwKqxdrsy9LHonDRJq8bs1X0jf6aMDGLbviJCm/F4Zs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776097221; c=relaxed/simple;
	bh=VSd8xqjU6QYZaas245o4aE8uwwg319yVsrPjQH1iM7Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gkLxn0Z7xMJhq0myF9Ft3mCWKu5daJUQzlh7p+g+mkWMy9vo0bCwpirwAWv2PEaaJ4+lGu2FXo2V3F5D2SxtmXtlzaX2/xpIyYe/FAXKhfMvlQCV6xuvu6jMJh/ysJ2/1nNkNL67tVJ5O89+IKdQP9BFDuPMsEQbuNx0beCTBCI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=v8iN8zqz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="v8iN8zqz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BF77C2BCAF;
	Mon, 13 Apr 2026 16:20:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776097221;
	bh=VSd8xqjU6QYZaas245o4aE8uwwg319yVsrPjQH1iM7Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=v8iN8zqzICqBuNPwGVZc8GfB8PQEuSM0EEq19EWf/NmCNUZlpy1HUIVpuMj70ksXD
	 4s5YwEtI7eM8R0Bd0lAMYwvOlXOZL46D5vKic4sc1rpD/OrF7Q8YU2EaMj3sSAnEHE
	 Shdg7irC3IH1bupRr6//Mt5bZv5s60wHJ4LwvDiU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thierry Reding <treding@nvidia.com>,
	Johan Hovold <johan@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 020/570] drm/tegra: dsi: fix device leak on probe
Date: Mon, 13 Apr 2026 17:52:31 +0200
Message-ID: <20260413155831.174644642@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155830.386096114@linuxfoundation.org>
References: <20260413155830.386096114@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 7bb26655cb3cc..74d27b564d564 100644
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



