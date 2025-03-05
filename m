Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D025A2512C9;
	Wed,  5 Mar 2025 18:17:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741198636; cv=none; b=qGeOZRbMsLTIMJ7zd76Uv83sfjlmo3tUMVPa97RQjiHPwPOV9LiNHBWkbwgfkt4wtBBT7zFtSTYxfcW1AO2RP9uStfNk0wrtksELGE9ryB/UailTGJ65rx0eKJOVNXcWkudm8jdLYJDtqSIZYWqtCshyE8/r8YROd/RDq3IGxC4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741198636; c=relaxed/simple;
	bh=uCSDiswUyRinFCVIF7L2Gz5L0Y0f2YuY8GMNWAMs5KA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RTXERzht9KTgOnK220vatvKyRNHUu3qXUutiukPgT6wIUZ16jKYRMxujvMeZQs0rT+V4hDxb7J55nJ9GO7+ytn8dYpGIpwQiT1o2K7Wd7Su3+MOsF6UHms7T94xJ9FSElFeaUWbrgKHrKJ3D3bq7JyzEfF3TyYuaztoBHfWWtLw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ow3DkuyT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ow3DkuyT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E795AC4CED1;
	Wed,  5 Mar 2025 18:17:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741198636;
	bh=uCSDiswUyRinFCVIF7L2Gz5L0Y0f2YuY8GMNWAMs5KA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ow3DkuyTqXcHJdfK+VCJVnnoaLnY3mktqKkqTeVYKQHAg3ZlNj41SSBxWe+vZQeQr
	 PYdcJTvNx8dxDcBhVAxOsksmhnKzEb7ZyPC6S+CAqE9Cne1Djadkp8GVN4vZ6x/C3B
	 W3UNRnkXFRtFeOd8Q15q7DNhJd+7UKcRz7bNnK54=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Carolina Jubran <cjubran@nvidia.com>,
	Cosmin Ratiu <cratiu@nvidia.com>,
	Dragos Tatulea <dtatulea@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 055/157] net/mlx5: Fix vport QoS cleanup on error
Date: Wed,  5 Mar 2025 18:48:11 +0100
Message-ID: <20250305174507.517657831@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250305174505.268725418@linuxfoundation.org>
References: <20250305174505.268725418@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Carolina Jubran <cjubran@nvidia.com>

[ Upstream commit 7f3528f7d2f98b70e19a6bb7b130fc82c079ac54 ]

When enabling vport QoS fails, the scheduling node was never freed,
causing a leak.

Add the missing free and reset the vport scheduling node pointer to
NULL.

Fixes: be034baba83e ("net/mlx5: Make vport QoS enablement more flexible for future extensions")
Signed-off-by: Carolina Jubran <cjubran@nvidia.com>
Reviewed-by: Cosmin Ratiu <cratiu@nvidia.com>
Reviewed-by: Dragos Tatulea <dtatulea@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Link: https://patch.msgid.link/20250225072608.526866-2-tariqt@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/esw/qos.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/esw/qos.c b/drivers/net/ethernet/mellanox/mlx5/core/esw/qos.c
index 8b7c843446e11..07a28073a49ea 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/esw/qos.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/esw/qos.c
@@ -591,8 +591,11 @@ static int mlx5_esw_qos_vport_enable(struct mlx5_vport *vport, enum sched_node_t
 	sched_node->vport = vport;
 	vport->qos.sched_node = sched_node;
 	err = esw_qos_vport_enable(vport, parent, extack);
-	if (err)
+	if (err) {
+		__esw_qos_free_node(sched_node);
 		esw_qos_put(esw);
+		vport->qos.sched_node = NULL;
+	}
 
 	return err;
 }
-- 
2.39.5



