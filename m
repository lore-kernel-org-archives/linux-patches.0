Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 373991D04A8;
	Wed,  2 Oct 2024 13:38:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727876322; cv=none; b=bco26uSGwLD3QpV3Ftfy9tT1swWwxyM18bqXCeTLuaKHF4IN3nGZdsS4Me5/jlnYcMx2NykUkzI/d14FTh0oxhsyNGVpHkbWAW1L7X9SbH8nHZiixxh44ntrvHttMTBUBPvaeV2FbQLrEP0UqvSuJN28qZpWSeMSd4h5qG27FkM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727876322; c=relaxed/simple;
	bh=nxlqZ2PXFWMuxVmVX/XSb7hRa5oMPlJWmXVfzpZLsxY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jAeB2Xr5s0IaTmm/fFoCOKPCXhPhvuYRKdO+TX56MugaGn+tMuCEjpyjTl2yeepaJubo3WFLQNm36yHWVgtOpAdxb/cjwph/V+OHX7mBRLojfdR/T6zA6XA7g9IteRTLjOyfPCKtFK/Rdc2BqlaCTDlM3DJqEtyhX1DZ2pzBJS8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lhKjL7iK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lhKjL7iK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2B21C4CECD;
	Wed,  2 Oct 2024 13:38:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727876322;
	bh=nxlqZ2PXFWMuxVmVX/XSb7hRa5oMPlJWmXVfzpZLsxY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lhKjL7iKiiaiKt8x2PSwvJSalfQcHjpnPd8aB66IWFb2hXzV58IJ/3+azjkrXeEVs
	 luJxWuHB8KydWMpcG+6ov3xZ4rYyqOVrHlOqOPrA/9pppTxvy4P/H+oqyyzW5kadHp
	 dP9dcisbJ+/S102COWl6kank9rIYq3maR/E2YHZ0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Guralnik <michaelgur@nvidia.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 405/695] RDMA/mlx5: Fix counter update on MR cache mkey creation
Date: Wed,  2 Oct 2024 14:56:43 +0200
Message-ID: <20241002125838.620882244@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125822.467776898@linuxfoundation.org>
References: <20241002125822.467776898@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Guralnik <michaelgur@nvidia.com>

[ Upstream commit 6f5cd6ac9a4201e4ba6f10b76a9da8044d6e38b0 ]

After an mkey is created, update the counter for pending mkeys before
reshceduling the work that is filling the cache.

Rescheduling the work with a full MR cache entry and a wrong 'pending'
counter will cause us to miss disabling the fill_to_high_water flag.
Thus leaving the cache full but with an indication that it's still
needs to be filled up to it's full size (2 * limit).
Next time an mkey will be taken from the cache, we'll unnecessarily
continue the process of filling the cache to it's full size.

Fixes: 57e7071683ef ("RDMA/mlx5: Implement mkeys management via LIFO queue")
Signed-off-by: Michael Guralnik <michaelgur@nvidia.com>
Link: https://patch.msgid.link/0f44f462ba22e45f72cb3d0ec6a748634086b8d0.1725362530.git.leon@kernel.org
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/mlx5/mr.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/mlx5/mr.c b/drivers/infiniband/hw/mlx5/mr.c
index 98bd8eaa393ef..f384fdcd0c740 100644
--- a/drivers/infiniband/hw/mlx5/mr.c
+++ b/drivers/infiniband/hw/mlx5/mr.c
@@ -211,9 +211,9 @@ static void create_mkey_callback(int status, struct mlx5_async_work *context)
 
 	spin_lock_irqsave(&ent->mkeys_queue.lock, flags);
 	push_mkey_locked(ent, mkey_out->mkey);
+	ent->pending--;
 	/* If we are doing fill_to_high_water then keep going. */
 	queue_adjust_cache_locked(ent);
-	ent->pending--;
 	spin_unlock_irqrestore(&ent->mkeys_queue.lock, flags);
 	kfree(mkey_out);
 }
-- 
2.43.0



