Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7EAF3C276E;
	Tue, 21 Jul 2026 17:33:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784655220; cv=none; b=KL/zZO0DCjimqagor7gepwHx+isrN9jltNiSEV+BBaLSZSzpx1KF4EiO9LjHtPM8UFJ5rTF1e6uGoCPy1EXdDkCKZQTAdiH/RKqyhCayKKt1/PRg57g3lsH/YzGcFnyLKC21QGivDFQ9bH51hjW/rUug0EvudSWgm9zLqjVqwXA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784655220; c=relaxed/simple;
	bh=ju/uiXCIrqvHpTJxHv6nY8r6UExssNdqFYr3iOhWY40=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Aq7FknqfiZVnWDfs1kjCQ8584V/t4W+/fL05q1yz8xxIzlCACwEc0iAbcyRnzHWHZkfKU1gNO0b/048Rp85pH81Ys09D2+g30BMVDiVmz8z/6qx73oVcS/bQMf1w1lyVlJ1JS0M5lcFjsXXofOOeDTrLLiPUwF3t5f93swychdY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=b4pULqJl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="b4pULqJl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19B171F000E9;
	Tue, 21 Jul 2026 17:33:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784655219;
	bh=Q5xng0HYGoB8IZuUIB40ATiMDF3pe9nMmnTLrw36r54=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=b4pULqJlHHK/dInuZhJEE+n++kj+KS5PWkg0hBk/xyNrNNRx0vIt8Q8Mnasa5Xgzb
	 0irtBysc9JwABpfewUK2GaLgerVFV/i3jeh03HI1DTowlsv1COshXovbWItv19iHd2
	 2dHU9RyXVFST3FpoTGXpXZfEapV087zPOJQJen3o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Gur <michaelgur@nvidia.com>,
	Zhiping Zhang <zhipingz@meta.com>,
	Leon Romanovsky <leonro@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 7.1 2002/2077] net/mlx5: free mlx5_st_idx_data on final dealloc
Date: Tue, 21 Jul 2026 17:27:55 +0200
Message-ID: <20260721152639.933895983@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhiping Zhang <zhipingz@meta.com>

commit df6134b527a88b3e65ba6ae5073664af091d5fd2 upstream.

Workloads that repeatedly allocate and release mkeys carrying TPH
steering-tag hints (e.g. churning RDMA MRs) leak one
struct mlx5_st_idx_data per cycle; kmemleak flags it as unreferenced
and the kmalloc slab grows over time.

When the last reference to an ST table entry is dropped,
mlx5_st_dealloc_index() removed the entry from idx_xa but the backing
mlx5_st_idx_data allocation was never freed.

Free idx_data after the xa_erase() so the lifetime of the bookkeeping
struct matches the lifetime of the ST entry it tracks.

Cc: stable@vger.kernel.org
Fixes: 888a7776f4fb ("net/mlx5: Add support for device steering tag")
Reviewed-by: Michael Gur <michaelgur@nvidia.com>
Signed-off-by: Zhiping Zhang <zhipingz@meta.com>
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Link: https://patch.msgid.link/20260702222507.1234467-1-zhipingz@meta.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/lib/st.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/net/ethernet/mellanox/mlx5/core/lib/st.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lib/st.c
@@ -175,6 +175,7 @@ int mlx5_st_dealloc_index(struct mlx5_co
 
 	if (refcount_dec_and_test(&idx_data->usecount)) {
 		xa_erase(&st->idx_xa, st_index);
+		kfree(idx_data);
 		/* We leave PCI config space as was before, no mkey will refer to it */
 	}
 


