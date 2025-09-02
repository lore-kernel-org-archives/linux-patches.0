Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64974305076;
	Tue,  2 Sep 2025 13:26:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756819608; cv=none; b=aFzQN3MeeMPG6QVXI6cB2YbpVLvqOh8VMw2WxZebsuhaI6KrY+RHCrAt5PNRsxuYmdnO5p6JjSusdoDqG5S1NeCzBAACQT3S94SeGBkyeme9MicI+8x0CLE5x4JP77zilHIctVAQG8er5B7ZFhIzEPfZ9biNK13WKo1mkswrPHA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756819608; c=relaxed/simple;
	bh=5BMB1BYZe78SNzSakXOhv2TRpDP873h+LO9MjF4FbU0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n3DkXldjY9lA3hbJKPhFzNbEQeJPDUOVx0Vc1yOJ5zfsP7LV0wAS9194K9xZ0zKE3+FnKNdJueV2qPG5kBLT7O9Uw4vrv7fsA0VLBYP1nMgQD3v58pq2grSR8r/YduQvg0Bqbq+3g7TAc48DgZu3uWhHW/sufUTDSNLAa//2Xig=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ChtaCIGz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ChtaCIGz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDF31C4CEF5;
	Tue,  2 Sep 2025 13:26:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756819608;
	bh=5BMB1BYZe78SNzSakXOhv2TRpDP873h+LO9MjF4FbU0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ChtaCIGzIXrBEqHW/OeYxn6ZePmJeW+r718IEWdpm8xXYEiNoECvGqI3/gY7attL3
	 qnvDO4jRiR4XI8m6TPVD2rSu6iMN4EX4XC4J9ZETEVA71wJmJX6YOIhK0D0a4Ap+hp
	 6nToszjHqKFKcP9ITysiNo7T26K1KebTmWr7DHz4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Moshe Shemesh <moshe@nvidia.com>,
	Mark Bloch <mbloch@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 085/142] net/mlx5: Prevent flow steering mode changes in switchdev mode
Date: Tue,  2 Sep 2025 15:19:47 +0200
Message-ID: <20250902131951.521998237@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250902131948.154194162@linuxfoundation.org>
References: <20250902131948.154194162@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Moshe Shemesh <moshe@nvidia.com>

[ Upstream commit cf9a8627b9a369ba01d37be6f71b297beb688faa ]

Changing flow steering modes is not allowed when eswitch is in switchdev
mode. This fix ensures that any steering mode change, including to
firmware steering, is correctly blocked while eswitch mode is switchdev.

Fixes: e890acd5ff18 ("net/mlx5: Add devlink flow_steering_mode parameter")
Signed-off-by: Moshe Shemesh <moshe@nvidia.com>
Signed-off-by: Mark Bloch <mbloch@nvidia.com>
Link: https://patch.msgid.link/20250825143435.598584-9-mbloch@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/fs_core.c | 15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c b/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
index 3dd9a6f407092..29ce09af59aef 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
@@ -3706,6 +3706,13 @@ static int mlx5_fs_mode_validate(struct devlink *devlink, u32 id,
 	char *value = val.vstr;
 	u8 eswitch_mode;
 
+	eswitch_mode = mlx5_eswitch_mode(dev);
+	if (eswitch_mode == MLX5_ESWITCH_OFFLOADS) {
+		NL_SET_ERR_MSG_FMT_MOD(extack,
+				       "Changing fs mode is not supported when eswitch offloads enabled.");
+		return -EOPNOTSUPP;
+	}
+
 	if (!strcmp(value, "dmfs"))
 		return 0;
 
@@ -3731,14 +3738,6 @@ static int mlx5_fs_mode_validate(struct devlink *devlink, u32 id,
 		return -EINVAL;
 	}
 
-	eswitch_mode = mlx5_eswitch_mode(dev);
-	if (eswitch_mode == MLX5_ESWITCH_OFFLOADS) {
-		NL_SET_ERR_MSG_FMT_MOD(extack,
-				       "Moving to %s is not supported when eswitch offloads enabled.",
-				       value);
-		return -EOPNOTSUPP;
-	}
-
 	return 0;
 }
 
-- 
2.50.1



