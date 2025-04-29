Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A056324503E;
	Tue, 29 Apr 2025 17:27:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745947660; cv=none; b=Y9p8HGgJiXOcWxCu6uWOSER0jYs/m2C1Dq/5R2vva17Y0ob86Behicva24x+CvSIE1ccngs0WfOgfPkGNczRbmDO1kShiQ9sY8EgmZx/uGTAjhLHsVFyNdXsu8+0q0RL931yf6+LUujOQ/CAOMfCwAx/FpVJMYA7mqDAOc/b8g8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745947660; c=relaxed/simple;
	bh=M2nH/BDMCIAKyMBKg+9yXthNM196KwHY+cjxOY42CxA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Mrdbu7wVXkfSUcQQ75SJqYj72YIqCIdVsqCtVYVXpVq7Cexy75BbcQuywrRdoV4d4IqzwrNRZpV9n0snShSE0qtwov+hdn+LSgTgR2IqjXedQNs8WwcEOArdvx9tJ4F1g6+QRN+2fx499bRMIIC/qutK/tVUg1eThH7XcR1ALj8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YVTxRgoK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YVTxRgoK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F490C4CEE3;
	Tue, 29 Apr 2025 17:27:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745947660;
	bh=M2nH/BDMCIAKyMBKg+9yXthNM196KwHY+cjxOY42CxA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YVTxRgoKlP+zABwdRZ/YOyDaKZt3Fv5j36IGNx444JPh1yBxZEwoU/U99AIiik5A4
	 p155rRUWvLCd9GmGacXDl4tczvpF+KtYn0xV+KN9qjuEKPOS3465zMK9hZdRpXivbe
	 ak4E7EfQQSE7mvG5EqyBGL2+0atS5nApB/Wx6tPI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Henry Martin <bsdhenrymartin@gmail.com>,
	Mark Bloch <mbloch@nvidia.com>,
	Michal Swiatkowski <michal.swiatkowski@linux.intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 066/280] net/mlx5: Fix null-ptr-deref in mlx5_create_{inner_,}ttc_table()
Date: Tue, 29 Apr 2025 18:40:07 +0200
Message-ID: <20250429161117.811841849@linuxfoundation.org>
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

From: Henry Martin <bsdhenrymartin@gmail.com>

[ Upstream commit 91037037ee3d611ce17f39d75f79c7de394b122a ]

Add NULL check for mlx5_get_flow_namespace() returns in
mlx5_create_inner_ttc_table() and mlx5_create_ttc_table() to prevent
NULL pointer dereference.

Fixes: 137f3d50ad2a ("net/mlx5: Support matching on l4_type for ttc_table")
Signed-off-by: Henry Martin <bsdhenrymartin@gmail.com>
Reviewed-by: Mark Bloch <mbloch@nvidia.com>
Reviewed-by: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
Link: https://patch.msgid.link/20250418023814.71789-2-bsdhenrymartin@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/lib/fs_ttc.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lib/fs_ttc.c b/drivers/net/ethernet/mellanox/mlx5/core/lib/fs_ttc.c
index 9f13cea164465..510879e1ba30e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lib/fs_ttc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lib/fs_ttc.c
@@ -636,6 +636,11 @@ struct mlx5_ttc_table *mlx5_create_inner_ttc_table(struct mlx5_core_dev *dev,
 	}
 
 	ns = mlx5_get_flow_namespace(dev, params->ns_type);
+	if (!ns) {
+		kvfree(ttc);
+		return ERR_PTR(-EOPNOTSUPP);
+	}
+
 	groups = use_l4_type ? &inner_ttc_groups[TTC_GROUPS_USE_L4_TYPE] :
 			       &inner_ttc_groups[TTC_GROUPS_DEFAULT];
 
@@ -709,6 +714,11 @@ struct mlx5_ttc_table *mlx5_create_ttc_table(struct mlx5_core_dev *dev,
 	}
 
 	ns = mlx5_get_flow_namespace(dev, params->ns_type);
+	if (!ns) {
+		kvfree(ttc);
+		return ERR_PTR(-EOPNOTSUPP);
+	}
+
 	groups = use_l4_type ? &ttc_groups[TTC_GROUPS_USE_L4_TYPE] :
 			       &ttc_groups[TTC_GROUPS_DEFAULT];
 
-- 
2.39.5



