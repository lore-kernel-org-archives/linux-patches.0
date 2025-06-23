Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BE5170838;
	Mon, 23 Jun 2025 21:09:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750712970; cv=none; b=iVSUTu8EmxUarvqQ6oU3hP7EXedmkLSx1gBB6M9rwOJvz515e07Gx5v6PLcmSW8yITLd/6QTT1zEUaaa323cau3QVNWF3KZJLoT3CYD+xpCQtso+t+ye2WqlxRPriw4QwVjYBBXSQxLf9DV7fTThgyV6a/0eH+wrLp9ajCeiCGM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750712970; c=relaxed/simple;
	bh=E5AXWAWLerNpqnzexy9TYICWvrtRksoJd0MLE1QpXK8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Cofveo/aE+uS0EmVFJw2pAK0u+esvuvQtdisclT8gTXpXZ3NUrIBq51z2n+WVRcL45xppk/++7DAYzd7Fadbiu7xHLiaNzzARuHB4KmulFqE6CKnzIUUXOwLkrbJNPO+OXZAVHrwwcjSa3WD1ntuDbkh7xHlUJ2e7OR6x4yW/Gg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pGJ4Ii6T; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pGJ4Ii6T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6A8DC4CEEA;
	Mon, 23 Jun 2025 21:09:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750712970;
	bh=E5AXWAWLerNpqnzexy9TYICWvrtRksoJd0MLE1QpXK8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pGJ4Ii6TFEirfawCon5tLWWgiG/DQre5/fSJ1O8HQS6PVzASM2p+fiHnlp2Xrll37
	 V7+2jg3bguTnjPOdOGy3y3E0itVAayTB0UWmxyl/jx2kJy8YvQPwIdVd0wudkqr6GU
	 ZqzPu8lR5gs67WitVCZAC6LMsiNE3EyIpWow0sNk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Tariq Toukan <tariqt@nvidia.com>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 6.12 021/414] net/mlx5_core: Add error handling inmlx5_query_nic_vport_qkey_viol_cntr()
Date: Mon, 23 Jun 2025 15:02:38 +0200
Message-ID: <20250623130642.556024941@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130642.015559452@linuxfoundation.org>
References: <20250623130642.015559452@linuxfoundation.org>
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
@@ -519,19 +519,22 @@ int mlx5_query_nic_vport_qkey_viol_cntr(
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
 


