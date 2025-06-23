Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05F6916419;
	Mon, 23 Jun 2025 13:38:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750685921; cv=none; b=ps9SA7hWUgHdSR5tNJ6XcDNTLTht7O9AIHx4xLrCQKtwxnK0DMZRAaWh4B0kHvSYa1505p2pPsg42s+qYOKiS2milSF8O3XZWkzNIyfOy4zI00trgzp2RnP9m5NOgg3b72YV8YBG46wzZotnoMIoVhXJO2JhONNTDwCyw+XFuwI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750685921; c=relaxed/simple;
	bh=ckEtMiAk/Az2DAKAX+QzZGyW26KRIbIKRbwMF9xuQWg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DBUJHSZKxI0uD0k4SQ8KYcUNfB9uVFXnPWpfkP0F5tACt1SwhRwhHev8qGQQFxa489mS2fi4R71TCIi60rHkLbOoM8Q+CuAbiFd08t4ry4DSHKQBYpbiNP2TWVlxZ2YWgeu6v4aFZvsQvgUWwtJWv2l/Ky3tYUOut+f1KeMzhAM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KYV/1YjL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KYV/1YjL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84AF8C4CEEA;
	Mon, 23 Jun 2025 13:38:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750685920;
	bh=ckEtMiAk/Az2DAKAX+QzZGyW26KRIbIKRbwMF9xuQWg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KYV/1YjLvLaBK8KjHwV5TghLx7TDtyOPMk+Hw8/8k3Fk1zu0WQxN9Bkm7vsr8ehIJ
	 lLClXJyxgFq1Yac6MaRtMlEzAGhpjlKiSHBPj+uvv7sR+Gdj2dz5EtS+UCQfLsakKo
	 pbqbrABA6MHd6/GXIb1zAhkinx/UHFkVNsx4eIGE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Tariq Toukan <tariqt@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.6 012/290] net/mlx5: Add error handling in mlx5_query_nic_vport_node_guid()
Date: Mon, 23 Jun 2025 15:04:33 +0200
Message-ID: <20250623130627.344935100@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130626.910356556@linuxfoundation.org>
References: <20250623130626.910356556@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wentao Liang <vulab@iscas.ac.cn>

commit c6bb8a21cdad8c975a3a646b9e5c8df01ad29783 upstream.

The function mlx5_query_nic_vport_node_guid() calls the function
mlx5_query_nic_vport_context() but does not check its return value.
A proper implementation can be found in mlx5_nic_vport_query_local_lb().

Add error handling for mlx5_query_nic_vport_context(). If it fails, free
the out buffer via kvfree() and return error code.

Fixes: 9efa75254593 ("net/mlx5_core: Introduce access functions to query vport RoCE fields")
Cc: stable@vger.kernel.org # v4.5
Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Link: https://patch.msgid.link/20250524163425.1695-1-vulab@iscas.ac.cn
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/vport.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

--- a/drivers/net/ethernet/mellanox/mlx5/core/vport.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/vport.c
@@ -444,19 +444,22 @@ int mlx5_query_nic_vport_node_guid(struc
 {
 	u32 *out;
 	int outlen = MLX5_ST_SZ_BYTES(query_nic_vport_context_out);
+	int err;
 
 	out = kvzalloc(outlen, GFP_KERNEL);
 	if (!out)
 		return -ENOMEM;
 
-	mlx5_query_nic_vport_context(mdev, 0, out);
+	err = mlx5_query_nic_vport_context(mdev, 0, out);
+	if (err)
+		goto out;
 
 	*node_guid = MLX5_GET64(query_nic_vport_context_out, out,
 				nic_vport_context.node_guid);
-
+out:
 	kvfree(out);
 
-	return 0;
+	return err;
 }
 EXPORT_SYMBOL_GPL(mlx5_query_nic_vport_node_guid);
 


