Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 296463803CD;
	Tue, 10 Mar 2026 11:26:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773141969; cv=none; b=R/I+OkiZH9ZeOe/u/9dwXbwzZ27uwIEL/J7tAWRPWRVgLP48yjMdS7YGz2RRY0vMN2Gg5/OfnYDpZiSXzBfgZXLkj18HvOW9uOAb3OaPGvXvJTKxMigkNofCSv9nI2UpRoxUZM42qy2aJFRuLCWxqemBnhjyBvMrP4TOXxhIVIU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773141969; c=relaxed/simple;
	bh=XaZYmPXj8HL1xMTAd2KDjT4nMHvNk3lcqK6w4LvHTFI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DOZ7l/oGgz6YYx7HCO9jV8ERaHfSlZmBz1nnjpbVBmV2n89vAen4cajrf+bE1Yx3GQ7e5U00v3e+rowskA8Shlz/Q+6gVjsjkJuDPuHu2mOYSjRBsK4xrJ4tPn701x6y/F3C3WRxPOFcEquNorx0S/sZ8cerXxRthN64/95VD2c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GNlqy8/5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GNlqy8/5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6EE82C2BC9E;
	Tue, 10 Mar 2026 11:26:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773141969;
	bh=XaZYmPXj8HL1xMTAd2KDjT4nMHvNk3lcqK6w4LvHTFI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GNlqy8/5A+j5B6bxv2WU8Q+rfuD8cJO6b44thLnJ7w1/+Tia67SrKs3aXEZXHqyii
	 m522rTB0K4CIT3kfy40GqHipZXmQ7LBwLIDAilkLPDV0mFmLuh3azICSzsKUv9qmpp
	 2jYGttNz0fu4ZjKv9dGgN1tv3DyleV59er3NePlb02lezRxQ3JwyOsX8GyiZGE6f4b
	 9OxD/vrhUocbbhgESkll3yq4HCfC9eNlRHs6R24vcnjGVv6WTVgxFEXuukyV/hU6z2
	 MGOiOsRZvsVNAL4kI6Hs8RcKGEWL/u6XtTv6QmXXuRDOiWoenI59jDrmtnntkUxiit
	 ZO95VAJLavlZA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Johan Hovold <johan@kernel.org>,
	Thierry Reding <treding@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 093/314] drm/tegra: dsi: fix device leak on probe
Date: Tue, 10 Mar 2026 07:15:52 -0400
Message-ID: <91453c91d4e9e86b775b25523450aae41b69cc8e.1773141555.git.sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1773141554.git.sashal@kernel.org>
References: <cover.1773141554.git.sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

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
index ddfb2858acbf1..5aa78b902adac 100644
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

