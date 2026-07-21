Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C64DD47127A;
	Tue, 21 Jul 2026 18:49:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784659797; cv=none; b=R9d58ZkZaSycR54cN3UJAQ9v/w419zNavVdqEBROTfilpOhk8cP/3vomdZ6aDUXn3mBjidzFXHBNDOwX1tTNuF7Kqg0y7mMwlC2DMiVwQU5ytdfx6zzie2bIve10+aDCHGfQ01CgRVCNKe4JHOqRhUp119GGIXRO7tLe6621DsM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784659797; c=relaxed/simple;
	bh=fSvf7Q4pSDpvC14A3FnBL4lyzu863WweZxlcBttWRAE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kgNMIYA22Y4yApq5qHCEpIummmVpJFgzHGq7iyLB4OAFJloZJD1yoaer89KyZ2BwBsTYRuFp+LHBJ30DGQetO+1pQk5undfuBjkYJKHq06AYcTp6L6eWoj4M7DVpHdzi9AdpPifDU3/8fFlo0nseDXxqoBJMK7csVRuFKTYOnIQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sqjMyYdZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sqjMyYdZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3999C1F000E9;
	Tue, 21 Jul 2026 18:49:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784659796;
	bh=m6n1LjBXtY6SwgxTaMiTS7cUEM39NOF+btLeAFKlyVU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sqjMyYdZJfrN4CDfNRlKLPtl3tt2EWMnYG5GENo+LZIhNMnx1i2XeioNnTQdlQgoA
	 Qhm16+8T/pESxCeXC5XjtQokXTXDWPPRDd32rWNbtVgqoD3gViusX1MxlbD3Q6vVKr
	 9ykFmUVdfMXJ8WjWGd+QDj8oiiGzcp9YHq3/yuMg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Guralnik <michaelgur@nvidia.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0694/2077] RDMA/mlx5: Drop FRMR pool handle on UMR revoke failure
Date: Tue, 21 Jul 2026 17:06:07 +0200
Message-ID: <20260721152609.163333334@linuxfoundation.org>
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

From: Michael Guralnik <michaelgur@nvidia.com>

[ Upstream commit c37d79dd967d450ea02e0ee2b6438b8534bbd044 ]

When UMR revoke fails during MR cleanup, the handle is left in an
unknown state and cannot be returned to the pool. The driver already
destroys the mkey via the fallback path, but the pool's in_use counter
is never decremented, drifting upward over time.

Call ib_frmr_pool_drop on the revoke-failure path so the pool's
accounting stays consistent with the handles it has handed out.

Fixes: 36680ef7bceb ("RDMA/mlx5: Switch from MR cache to FRMR pools")
Link: https://patch.msgid.link/r/20260610000145.820592-10-michaelgur@nvidia.com
Signed-off-by: Michael Guralnik <michaelgur@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/mlx5/mr.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/mr.c b/drivers/infiniband/hw/mlx5/mr.c
index 723594efa094e6..4118cd2d15fd55 100644
--- a/drivers/infiniband/hw/mlx5/mr.c
+++ b/drivers/infiniband/hw/mlx5/mr.c
@@ -1398,9 +1398,11 @@ static int mlx5r_handle_mkey_cleanup(struct mlx5_ib_mr *mr)
 	bool is_odp = is_odp_mr(mr);
 	int ret;
 
-	if (mr->ibmr.frmr.pool && !mlx5_umr_revoke_mr_with_lock(mr)) {
-		ib_frmr_pool_push(mr->ibmr.device, &mr->ibmr);
-		return 0;
+	if (mr->ibmr.frmr.pool) {
+		if (!mlx5_umr_revoke_mr_with_lock(mr)) {
+			ib_frmr_pool_push(mr->ibmr.device, &mr->ibmr);
+			return 0;
+		}
 	}
 
 	if (is_odp)
@@ -1422,6 +1424,10 @@ static int mlx5r_handle_mkey_cleanup(struct mlx5_ib_mr *mr)
 		dma_resv_unlock(
 			to_ib_umem_dmabuf(mr->umem)->attach->dmabuf->resv);
 	}
+
+	if (mr->ibmr.frmr.pool && !ret)
+		ib_frmr_pool_drop(&mr->ibmr);
+
 	return ret;
 }
 
-- 
2.53.0



