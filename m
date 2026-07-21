Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7E06471262;
	Tue, 21 Jul 2026 18:42:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784659333; cv=none; b=OH9SAlSGwgGQkhFic9mEnDWlfrkqwfTIef39G4wLaAirc5k0gxPCPNcoTFPWMOi0pjGHfYFw3DEtP4n86ae+EKWlv1a1AbvCFT0OHxdo8YKowffalCetyCYuL7eriE6sK0aX+tyDvOonk8d4qins3au5zZ1ltk8VxjlC4CZ2bwU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784659333; c=relaxed/simple;
	bh=Mkn7bU2WLEGDZTyeFeWUVVwrPIjHej5Xtky5kxrBm9k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g6fv5cp1DUKgIE5eKY7P0K2nWKBws2LkS/QmgdVUw57KuGaFD7lInYYJKDTN4SbA1PyR6kYVHIxdu+CJ49RmOQDwUxTkosyOd6CmM7NxzDd6Rx7p5iMMDMDV0nzDxvrlarxEbzfXLxtezaHX0Y5FUvv+0mgyqH5ghCb+AmLnjfM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mXUgXmsz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mXUgXmsz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AFFC1F000E9;
	Tue, 21 Jul 2026 18:42:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784659332;
	bh=l2L0smBdygEonleqEsaHXfhYtSikWDHI1m13/l2q/+I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mXUgXmszxQ2ZYHKb41xe7SUebp9mQb1PqVNqTgHMd5BHrIe+26K/YOL9QWUDRME24
	 bCXMOC03nthxhqPRrokqUM943vP1Yu41iOHMU3d+OfY747a7f5r0bHompSNDzeFS+u
	 Hg52XfvsEWFLOdLas+RNSzZUs3lXcCkWzwT7hmzg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Gur <michaelgur@nvidia.com>,
	Zhiping Zhang <zhipingz@meta.com>,
	Leon Romanovsky <leonro@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 6.18 1479/1611] net/mlx5: free mlx5_st_idx_data on final dealloc
Date: Tue, 21 Jul 2026 17:26:35 +0200
Message-ID: <20260721152548.713141869@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -154,6 +154,7 @@ int mlx5_st_dealloc_index(struct mlx5_co
 
 	if (refcount_dec_and_test(&idx_data->usecount)) {
 		xa_erase(&st->idx_xa, st_index);
+		kfree(idx_data);
 		/* We leave PCI config space as was before, no mkey will refer to it */
 	}
 


