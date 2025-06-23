Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14EAC7482;
	Mon, 23 Jun 2025 21:17:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750713427; cv=none; b=RW5/XGEb5CHtQEAB/8iCKLELcaeJ3dUjVqdgt+SY2Zb43kJPXm3BJYRibc2xTjJeAxxUZEgGsG11jqk6ndApqOm7XuidMw4rLcVIGc8krs6254xP1/7N9gIGUfd6Z+X+kX5qVAo0JPVC2fOOh9lXaNUXl75XqgVwrsKGrp92+sI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750713427; c=relaxed/simple;
	bh=TcATOKFyb+BhZULp7TMDiAYcwWwKnGP1o/uHN/BoGmY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JC93Ah8YGBEg9219dJzw69UfJKm082M6VeVx+gHOla9sx7onJraHZwIBt5Cu+Re9OmRQrCh1fCAw9US/WO55f8I1pq54HS7cAD1V8tMdCRBpD4bZnl1ekQPdImpeum5dmRr00M1kCjmpQ2C9WXep0IGoNJxoqzyN02DZlJDOsi0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Va4TKey6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Va4TKey6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DB45C4CEEA;
	Mon, 23 Jun 2025 21:17:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750713426;
	bh=TcATOKFyb+BhZULp7TMDiAYcwWwKnGP1o/uHN/BoGmY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Va4TKey6v8cUUgRLO/Vje/tY3DQzQR9JekTFUEyy7NkPgtAQ5+sCFBnn1xEq9VInW
	 gRwKcOtwDWpqWgAVX9Xko3U6tKsdxFcZhoxc+6A4MjX8gWzGVN5NoBt9CEbf+id1ha
	 lryKP/NkZxMH5/NhOMf2eeAXG6cP9Nx80FpDadac=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Tariq Toukan <tariqt@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.10 165/355] net/mlx5: Add error handling in mlx5_query_nic_vport_node_guid()
Date: Mon, 23 Jun 2025 15:06:06 +0200
Message-ID: <20250623130631.662426749@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130626.716971725@linuxfoundation.org>
References: <20250623130626.716971725@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -440,19 +440,22 @@ int mlx5_query_nic_vport_node_guid(struc
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
 


