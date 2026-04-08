Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 612033D668E;
	Wed,  8 Apr 2026 18:22:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775672569; cv=none; b=k6j4tjnoOoCDP3DZFYi0r37NndSKNh/AAm2WEUj70DjWKIX/h6dOlr3yyb07zO8cUWfYXfJmv4EkBE3A6+HZ3niRkqVBB3FYUmtXgultbdH0QQJZlSvjp1INdmA13RfdBGUa5Tvy46FG6HCew/lOa0YoBPDjvMfSNPK+7iqylF4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775672569; c=relaxed/simple;
	bh=oYT9hBgHb3PV08u6ObhkroDxvOtzY/WNbc5T8evwQMs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ar9SpNMCQK3rGFQyZzzEBVv88/bq6exOe20XlrAJRmqUbd1X4DzvTrPlLg07ZTdoi/wuaCuLVtloNWoF9//NkbGSoQZJe/HaE18c+F4Gy+jllF4vPE/lXOCY8bpFADg3LeTgpGl8ge/cyc+hpUCr+hjiPPAI4lXHZd53h5TNYww=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=a3uGqt8F; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="a3uGqt8F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFAE0C19421;
	Wed,  8 Apr 2026 18:22:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775672569;
	bh=oYT9hBgHb3PV08u6ObhkroDxvOtzY/WNbc5T8evwQMs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=a3uGqt8FD3uU3HWVWt+C/tKXa9uooU00Ikk20IDYew+W4VhGIjXzBjOegzDkj27DJ
	 3f1mvaIdl9QFbXq6vXtEdWbTZqogy5bDIl5FjLPfhBg1sMyXoApR/txRzEUSun26hT
	 iu2uFwSDAikv/h9/DRWBuSybBdIqQtdlGJ9BoQm4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shay Drory <shayd@nvidia.com>,
	Mark Bloch <mbloch@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 056/160] net/mlx5: lag: Check for LAG device before creating debugfs
Date: Wed,  8 Apr 2026 20:02:23 +0200
Message-ID: <20260408175915.296686198@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175913.177092714@linuxfoundation.org>
References: <20260408175913.177092714@linuxfoundation.org>
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

From: Shay Drory <shayd@nvidia.com>

[ Upstream commit bf16bca6653679d8a514d6c1c5a2c67065033f14 ]

__mlx5_lag_dev_add_mdev() may return 0 (success) even when an error
occurs that is handled gracefully. Consequently, the initialization
flow proceeds to call mlx5_ldev_add_debugfs() even when there is no
valid LAG context.

mlx5_ldev_add_debugfs() blindly created the debugfs directory and
attributes. This exposed interfaces (like the members file) that rely on
a valid ldev pointer, leading to potential NULL pointer dereferences if
accessed when ldev is NULL.

Add a check to verify that mlx5_lag_dev(dev) returns a valid pointer
before attempting to create the debugfs entries.

Fixes: 7f46a0b7327a ("net/mlx5: Lag, add debugfs to query hardware lag state")
Signed-off-by: Shay Drory <shayd@nvidia.com>
Reviewed-by: Mark Bloch <mbloch@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Link: https://patch.msgid.link/20260330194015.53585-2-tariqt@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/lag/debugfs.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag/debugfs.c b/drivers/net/ethernet/mellanox/mlx5/core/lag/debugfs.c
index f4b777d4e1086..41ddca52e9547 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lag/debugfs.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lag/debugfs.c
@@ -163,8 +163,11 @@ DEFINE_SHOW_ATTRIBUTE(members);
 
 void mlx5_ldev_add_debugfs(struct mlx5_core_dev *dev)
 {
+	struct mlx5_lag *ldev = mlx5_lag_dev(dev);
 	struct dentry *dbg;
 
+	if (!ldev)
+		return;
 	dbg = debugfs_create_dir("lag", mlx5_debugfs_get_dev_root(dev));
 	dev->priv.dbg.lag_debugfs = dbg;
 
-- 
2.53.0



