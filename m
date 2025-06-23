Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06C0919CC11;
	Mon, 23 Jun 2025 21:36:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750714608; cv=none; b=syx1HyjDyfy1vQ6SRRHY7aqUcA0wTxy2L3XbWjnzWAv4vZIUiT1MJS2JS5UW+rlaSuPxnl6/Cv9FLMUlcOK79jGntQVmavUfiHkfb0Q0g1yqyaDlWX0B/HUJc2UtFh/3ADq9PinREE85QW0Ovp5QYIzChTDevsxTqcO0t8/NVSM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750714608; c=relaxed/simple;
	bh=s8TEzrKie1pswt6jYo4M2s5TOryEEqs0P+A5g19OigA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=vELo7EU3qg9eDNnDUtl/toDxMbj2dUXwLM0+5ibaUwYkNCgEOZjtyUYXMWHxqFXjPqeaWgXUej5LlnypQSLpz3xMXaA+R8BUREq5cOd41MEEYK4KuQzBO/xhNK+CoMbsDJ2WUlYm40tI18wWypErq3r3Tn4gBBaXPaFAPR3BRfU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SO4u2g7N; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SO4u2g7N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93502C4CEEA;
	Mon, 23 Jun 2025 21:36:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750714607;
	bh=s8TEzrKie1pswt6jYo4M2s5TOryEEqs0P+A5g19OigA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SO4u2g7NvGhHI7DTNPc7DsbjmCsKE1uRxXvEgwiJzvaBZ5gjVPo+91ffx6pjlB478
	 9PKxU/8Nx2FsMVfAR1FtV5o278EFkXbBUOt2RgJSuOBPD3fecoojAl84+t0gq/QR3D
	 Ox9IBOjsn+KERiOMpDjS5Afh5SVlYh/Jc2IjV0Ds=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Tariq Toukan <tariqt@nvidia.com>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 5.15 198/411] net/mlx5_core: Add error handling inmlx5_query_nic_vport_qkey_viol_cntr()
Date: Mon, 23 Jun 2025 15:05:42 +0200
Message-ID: <20250623130638.659902261@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130632.993849527@linuxfoundation.org>
References: <20250623130632.993849527@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wentao Liang <vulab@iscas.ac.cn>

commit f0b50730bdd8f2734e548de541e845c0d40dceb6 upstream.

The function mlx5_query_nic_vport_qkey_viol_cntr() calls the function
mlx5_query_nic_vport_context() but does not check its return value. This
could lead to undefined behavior if the query fails. A proper
implementation can be found in mlx5_nic_vport_query_local_lb().

Add error handling for mlx5_query_nic_vport_context(). If it fails, free
the out buffer via kvfree() and return error code.

Fixes: 9efa75254593 ("net/mlx5_core: Introduce access functions to query vport RoCE fields")
Cc: stable@vger.kernel.org # v4.5
Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Link: https://patch.msgid.link/20250521133620.912-1-vulab@iscas.ac.cn
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/vport.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

--- a/drivers/net/ethernet/mellanox/mlx5/core/vport.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/vport.c
@@ -495,19 +495,22 @@ int mlx5_query_nic_vport_qkey_viol_cntr(
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
 
 	*qkey_viol_cntr = MLX5_GET(query_nic_vport_context_out, out,
 				   nic_vport_context.qkey_violation_counter);
-
+out:
 	kvfree(out);
 
-	return 0;
+	return err;
 }
 EXPORT_SYMBOL_GPL(mlx5_query_nic_vport_qkey_viol_cntr);
 


