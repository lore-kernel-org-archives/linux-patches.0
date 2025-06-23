Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A5191E87B;
	Mon, 23 Jun 2025 22:06:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750716387; cv=none; b=ZE0a+02WYTw/xHunci1n2qTaAiJ9WBgAWCNZQKtp0DF0OQs/XVE6ClRlfKXuonLGoqQWCmHlKJWQHx2rz4WAGe1jMc4uQw04ikmhTeh22kld2rTPEV9gU/Qcgtj6ZQ5MNxO2Ucy4pnn8LqXnDXQhOxfPlOV8ju6GtyRPBZPCgJ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750716387; c=relaxed/simple;
	bh=5k3mo0uacMJWw8ilOx8lhtOORVJlogDENXE8oQEht5A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CCGlPkZqh1DZB0fV1RCf1SYQWEFkb9oJyDqrPAX5L1KKqUVuYIQTGyRdtRLMYhGf9TC3lmqnEz7tS4AZYTv2SuFiCp06oCf7ojdvWmUNmcMrLGwFz00H77mNc3c6M66eYTDOucG1XkbNybSQbbgz1Bzf3C/n1RCtvMdv2uVloAk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pks1WWB8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pks1WWB8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 007F6C4CEED;
	Mon, 23 Jun 2025 22:06:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750716387;
	bh=5k3mo0uacMJWw8ilOx8lhtOORVJlogDENXE8oQEht5A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pks1WWB8nOX0aRRzDHvm2IOXYyeC6qYLaXpus91X9z4NIkvwHPL7EsmQdddBSxGeO
	 4SGIc9JhrEmqawnCQoYrX8mUcegTVqky5nulvVuIP0SAvXwtGe+uoFrjaKgo1ex38D
	 EcxFLzDMkTh4pEwxJH1fQ4Mly30wlvbxisI4sgQk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Tariq Toukan <tariqt@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.1 299/508] net/mlx5: Add error handling in mlx5_query_nic_vport_node_guid()
Date: Mon, 23 Jun 2025 15:05:44 +0200
Message-ID: <20250623130652.654291441@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130645.255320792@linuxfoundation.org>
References: <20250623130645.255320792@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -443,19 +443,22 @@ int mlx5_query_nic_vport_node_guid(struc
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
 


