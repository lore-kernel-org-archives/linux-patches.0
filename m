Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C27B0569E
	for <patches@lists.linux.dev>; Sun, 28 May 2023 19:38:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FD0EC433EF;
	Sun, 28 May 2023 19:38:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1685302704;
	bh=Bsp0O2B4jKw3NxeXx7hewBA8JjuxP6RtkNDGOwycr+U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZHWj1MP9WueCDg2aEPcb5k65/XUzaulb6mGi1JxjHC+NDHvanVUybZF2Zj821SM3w
	 N/1p0/8F2trEAu1d5UIPcGtkjbYGQ0KuIBCnEAdsfqSS3R896pFSPjkEiw4zZT7MHM
	 +7lLSxtr5XIfrwehoErznsKbZqcDFXNJ2xkjlogM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shay Drory <shayd@nvidia.com>,
	Saeed Mahameed <saeedm@nvidia.com>
Subject: [PATCH 6.1 112/119] net/mlx5: Devcom, fix error flow in mlx5_devcom_register_device
Date: Sun, 28 May 2023 20:11:52 +0100
Message-Id: <20230528190839.198160452@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230528190835.386670951@linuxfoundation.org>
References: <20230528190835.386670951@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Shay Drory <shayd@nvidia.com>

commit af87194352cad882d787d06fb7efa714acd95427 upstream.

In case devcom allocation is failed, mlx5 is always freeing the priv.
However, this priv might have been allocated by a different thread,
and freeing it might lead to use-after-free bugs.
Fix it by freeing the priv only in case it was allocated by the
running thread.

Fixes: fadd59fc50d0 ("net/mlx5: Introduce inter-device communication mechanism")
Signed-off-by: Shay Drory <shayd@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/lib/devcom.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/net/ethernet/mellanox/mlx5/core/lib/devcom.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lib/devcom.c
@@ -112,7 +112,8 @@ struct mlx5_devcom *mlx5_devcom_register
 	priv->devs[idx] = dev;
 	devcom = mlx5_devcom_alloc(priv, idx);
 	if (!devcom) {
-		kfree(priv);
+		if (new_priv)
+			kfree(priv);
 		return ERR_PTR(-ENOMEM);
 	}
 


