Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 609E617727;
	Mon, 27 May 2024 19:35:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716838511; cv=none; b=VFCMIZ5V786bBT0CNFXArEPVt4IjiZVyLa5/PKDzV969vLUVkpZPWD6A9ILLoRIbzQLFarDv9oG6ACHiQYcsfEEqXo+TeKKJTk6SRdSnQ+CUcZGSc9883Jy725hmwMPfagwAgnhE+rBxXa8Rki1tOSgPUjPF8lT0xGwk4Yz2FrA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716838511; c=relaxed/simple;
	bh=ZXpn9CwkzZGIJnSTy7oXwpdzKJYFneizXB/sui+dJho=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Xz44Qr7GnFzmmP+g3Cvi4soCJHpuiV0bOVEvaL1Lhncl/XRY91+gJmycHpB4mH/RHRfKrixt0h9wsXwquVY5d495zRPFI7Gn/yDuW5I5DAvsvA24Rn4Qfeqfv0aIrjfIIMMQH5wnJFvBuE5xjgCWmowYu57SvI0QsskL3wBpKUM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hsT0M1Nt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hsT0M1Nt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA2CFC2BBFC;
	Mon, 27 May 2024 19:35:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716838511;
	bh=ZXpn9CwkzZGIJnSTy7oXwpdzKJYFneizXB/sui+dJho=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hsT0M1NttEoXIVpTOSZpRHPfDrSfB1NQREfhYYQVVpmGusAfjTYH+2DFMMjLINPfE
	 Qkn/vEbbzbhduBsYq2kEG6L/xodLo3qDzBsD73pbTZ1bFutDYT6LfyMV/LQGQfdCf3
	 Ab9DBMkGUl2nSB5AAyeL8ascWXnMi4Kx8xhn98hU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Or Har-Toov <ohartoov@nvidia.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 421/493] RDMA/mlx5: Uncacheable mkey has neither rb_key or cache_ent
Date: Mon, 27 May 2024 20:57:03 +0200
Message-ID: <20240527185644.072505419@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185626.546110716@linuxfoundation.org>
References: <20240527185626.546110716@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Or Har-Toov <ohartoov@nvidia.com>

[ Upstream commit 0611a8e8b475fc5230b9a24d29c8397aaab20b63 ]

As some mkeys can't be modified with UMR due to some UMR limitations,
like the size of translation that can be updated, not all user mkeys can
be cached.

Fixes: dd1b913fb0d0 ("RDMA/mlx5: Cache all user cacheable mkeys on dereg MR flow")
Signed-off-by: Or Har-Toov <ohartoov@nvidia.com>
Link: https://lore.kernel.org/r/f2742dd934ed73b2d32c66afb8e91b823063880c.1712140377.git.leon@kernel.org
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/mlx5/mlx5_ib.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/mlx5/mlx5_ib.h b/drivers/infiniband/hw/mlx5/mlx5_ib.h
index bbe79b86c7178..989968ba74153 100644
--- a/drivers/infiniband/hw/mlx5/mlx5_ib.h
+++ b/drivers/infiniband/hw/mlx5/mlx5_ib.h
@@ -643,7 +643,7 @@ struct mlx5_ib_mkey {
 	unsigned int ndescs;
 	struct wait_queue_head wait;
 	refcount_t usecount;
-	/* User Mkey must hold either a rb_key or a cache_ent. */
+	/* Cacheable user Mkey must hold either a rb_key or a cache_ent. */
 	struct mlx5r_cache_rb_key rb_key;
 	struct mlx5_cache_ent *cache_ent;
 };
-- 
2.43.0



