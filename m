Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77CC71E87B;
	Mon, 23 Jun 2025 22:06:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750716372; cv=none; b=oyCQpkc95XIS972GCO3xn8BOA2GG7VvtGzA7rlhY64iZryXsT91x2DfL2hCjoyxOdvcczduIG8VQf0kCuYFymLMTApMrS+UhRtrwUJhYLqR6Y697B/7IoDIgKzSyHmvRO+/5QmKLdR86z1OP5s6SMvyEpPJoPOd/Ce6jOha9qXM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750716372; c=relaxed/simple;
	bh=KCF0BPkBVXbImiwHsdgNGG6jmQGfyhszI5o270ymwmU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BK7L638dKo5loB/dZo+olZxVKdPkECuvly49V2kIj7ep9WdsHgbRMW571sd12l0d0lGjwyjTaEYvX0OMz6LfRZlM0NslbpNMIedTMbeGNlGv/Pq/muiQq1L8Gl2uLdowwnSHx9ipQKulLrE1xE46l4nnDhQ1nvgp1lAd6rTsatk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ma49Jq87; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ma49Jq87"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3EBFC4CEEA;
	Mon, 23 Jun 2025 22:06:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750716370;
	bh=KCF0BPkBVXbImiwHsdgNGG6jmQGfyhszI5o270ymwmU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ma49Jq870K8pEXHldp0/4Nz0YDUtkx0fBO5G6tcir9i40Y2tx7PM7bhw5ufResNm9
	 /e1BOrO/3dF+ndX2y4aUyyaozN4plHT80earhZBE7Gxv8YOqEURy4YU0Fuhb6hXryN
	 ngMVacYZY/o1lwkwDZMMfpb1NOxN/7v+ZC4Q1EkA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Tariq Toukan <tariqt@nvidia.com>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 6.1 298/508] net/mlx5_core: Add error handling inmlx5_query_nic_vport_qkey_viol_cntr()
Date: Mon, 23 Jun 2025 15:05:43 +0200
Message-ID: <20250623130652.627601612@linuxfoundation.org>
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
@@ -497,19 +497,22 @@ int mlx5_query_nic_vport_qkey_viol_cntr(
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
 


