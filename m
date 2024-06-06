Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 435001B3737;
	Thu,  6 Jun 2024 14:17:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683421; cv=none; b=MRYRtj82by9qhori7vpolg1iV3Ri3VDSQRmFikwm9LA59NVLD/6xTuzIYuSgL7brITT6L/+jepE+v1cszRLMFvQfKFe5EV6DLHlptozJ2lukojVLt1Z+8RDk/prgMaA2Eta4Hvxmj3haN337ae+XjLoqb++SRvow47sMGM8Oerw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683421; c=relaxed/simple;
	bh=PN8SJ4IFAlas/WT6JiOMdGLd3UXdLq0w+QcnYpx2T9M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Na6Ldg4bjBkSaLI7eKKG16SnTzJWiQyNqSwcslm7737XDAv9BLRO2ty+kOyKrGtIfMUvjk6JGRIG/s5a2e5gCu81lGr4c187s5CiKXSnlBER8JvA9cor4xK7UaoyL0t3ElOyy6BAd2vpswIi7ecXa3/RzzMNWimGHFuGQhvCPzw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tIqgwK37; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tIqgwK37"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 239C2C32782;
	Thu,  6 Jun 2024 14:17:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683421;
	bh=PN8SJ4IFAlas/WT6JiOMdGLd3UXdLq0w+QcnYpx2T9M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tIqgwK37oeGGQsvcifU3f1JfwTlEbTT4lVzVfegpLBF3gy0JqJI5iDzRJkZrthpHT
	 x/AmwssWFjCf4t/EPqxTQGdCKPN9h1upImxbNyIcetv+c3fVSF9baFaB+lQjjVhGF5
	 CmePCNZ93ljypZW5EdgFbFX7sOCiV7Hcc61DJNNY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Or Har-Toov <ohartoov@nvidia.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 335/744] RDMA/mlx5: Uncacheable mkey has neither rb_key or cache_ent
Date: Thu,  6 Jun 2024 16:00:07 +0200
Message-ID: <20240606131743.205485550@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131732.440653204@linuxfoundation.org>
References: <20240606131732.440653204@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 16713baf0d060..6a57af8fa231b 100644
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



