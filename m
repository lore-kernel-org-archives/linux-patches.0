Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BD8613DBA0;
	Mon, 16 Sep 2024 12:02:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726488125; cv=none; b=kaSd65SAqf0SrAPyK6DuGrdlpN2AL4jvf/TA0DwXcEcL8aYwkcL5aHdOE9CdVk8CBrmWsty2d//M7JLVLVknf4o96S3VX8JGp4SErYrngWGt4t1u6rp+w1uOVOekRjwL26lfi2AdTNMqjOJ8Pto9c2Rs7aTBbw3qEklc+is24PU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726488125; c=relaxed/simple;
	bh=3jz2K+W0srCoRgvaL6Mmojh+9hw1W1RUCtc8M0Q1ci8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sQIXUAYKrU2M0i+TV8VUqy2t6sshHi3MIBJrriDbM98mK/tu5WX8LGmR7od7x7S9Uyr8eLdWrjrgz7T8FgOwDH6k3zrS+QGbzGFwgmxB6QYotuoDPdK+ImljpEmSsrnuc4gmr/lv0jbFTSfpjGpa3Wuu1raUwMvSv9Ip70iJwVE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YioeOJqc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YioeOJqc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A95E4C4CEC4;
	Mon, 16 Sep 2024 12:02:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1726488125;
	bh=3jz2K+W0srCoRgvaL6Mmojh+9hw1W1RUCtc8M0Q1ci8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YioeOJqcqcYIcN4c7t3IzlUD/Dfcrs8aeZuVaFI6o9Wq+KfY62L+MYL8vJR1Q4eKO
	 3gBwsZBqPWStpjDTf+DU/4KxkZWx4CgXaBFAZcGEHrdVHIZ6WaBz92nTRM33XV9/9O
	 KYYAvXQTR2uxdFw6lcPkILeH/OogVsioYctFHsJM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Carolina Jubran <cjubran@nvidia.com>,
	Cosmin Ratiu <cratiu@nvidia.com>,
	Saeed Mahameed <saeedm@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 42/63] net/mlx5: Explicitly set scheduling element and TSAR type
Date: Mon, 16 Sep 2024 13:44:21 +0200
Message-ID: <20240916114222.543696544@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240916114221.021192667@linuxfoundation.org>
References: <20240916114221.021192667@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Carolina Jubran <cjubran@nvidia.com>

[ Upstream commit c88146abe4d0f8cf659b2b8883fdc33936d2e3b8 ]

Ensure the scheduling element type and TSAR type are explicitly
initialized in the QoS rate group creation.

This prevents potential issues due to default values.

Fixes: 1ae258f8b343 ("net/mlx5: E-switch, Introduce rate limiting groups API")
Signed-off-by: Carolina Jubran <cjubran@nvidia.com>
Reviewed-by: Cosmin Ratiu <cratiu@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/esw/qos.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/esw/qos.c b/drivers/net/ethernet/mellanox/mlx5/core/esw/qos.c
index 75015d370922..b8bf98a0a80a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/esw/qos.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/esw/qos.c
@@ -420,6 +420,7 @@ __esw_qos_create_rate_group(struct mlx5_eswitch *esw, struct netlink_ext_ack *ex
 {
 	u32 tsar_ctx[MLX5_ST_SZ_DW(scheduling_context)] = {};
 	struct mlx5_esw_rate_group *group;
+	__be32 *attr;
 	u32 divider;
 	int err;
 
@@ -427,6 +428,12 @@ __esw_qos_create_rate_group(struct mlx5_eswitch *esw, struct netlink_ext_ack *ex
 	if (!group)
 		return ERR_PTR(-ENOMEM);
 
+	MLX5_SET(scheduling_context, tsar_ctx, element_type,
+		 SCHEDULING_CONTEXT_ELEMENT_TYPE_TSAR);
+
+	attr = MLX5_ADDR_OF(scheduling_context, tsar_ctx, element_attributes);
+	*attr = cpu_to_be32(TSAR_ELEMENT_TSAR_TYPE_DWRR << 16);
+
 	MLX5_SET(scheduling_context, tsar_ctx, parent_element_id,
 		 esw->qos.root_tsar_ix);
 	err = mlx5_create_scheduling_element_cmd(esw->dev,
-- 
2.43.0



