Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8674A46F4BE;
	Tue, 21 Jul 2026 18:48:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784659713; cv=none; b=Otb9YttHJfzkHSBZKdQ+Yp3rI1ykjw9UY/b8x0w4csJC2ss01U7DLaSZ7FUnKcWK7z5q2h0RrZ3212rnYrYbDHf+CmOjwPnR2mhQTGoTspH7HGWtLhVlv6Ja+i+LQ4TOS5pgp+g0RPTbISzg1oRo7mvSKkIgQ0KVagSCrQ6MnNU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784659713; c=relaxed/simple;
	bh=xLw41/9t1kQsTiJyiV2hRNvu5NSrMZm8YNO20hvAcpc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=as+xi0pIPA7rBA3PO9fZQcjaOd653SCa9AYyZaKyOy7/07O5K8xzuucN9M/qobmTXcg/3+1qokG0N71Cu4/kQBmEMokUy+1R6R9Lm1AWI16ASfga9CKl/PRcCzjrLNn6Tcc+29aHzP6BZ5C8vUH9CIuldEr4tHp302PuGDR8FUw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PKF1Jde5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PKF1Jde5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B582E1F000E9;
	Tue, 21 Jul 2026 18:48:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784659712;
	bh=jXHY+OpX6vJL4u2YudaBR7usYB5z+Qqi20SKSwQlMAQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PKF1Jde5uvFhFOdxSrzRtgPX1zwgOuktULPDVE3xyo1sSsbhA4i88Bq6IVTNLe5k8
	 1UbIqJmHao9lW6AolANvc6t2U/bvzOLggl+lEa1bDwMdhStV/g27y57dnfN8SCxQjA
	 DG84ZHGxrUbSGcmBLD9+yWDKoA8O2F0qgpp9pYVk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Guralnik <michaelgur@nvidia.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0688/2077] RDMA/core: Fix skipped usage for driver built FRMR key
Date: Tue, 21 Jul 2026 17:06:01 +0200
Message-ID: <20260721152609.021622091@linuxfoundation.org>
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

[ Upstream commit 3d7fd88aeff73f25ee740b3a65a3b4dd38ad7783 ]

When creating FRMR handles following a netlink command to pin handles,
use the key after driver callback instead of using the key passed directly
from user.

Fixes: 020d189d16a6 ("RDMA/core: Add pinned handles to FRMR pools")
Link: https://patch.msgid.link/r/20260610000145.820592-4-michaelgur@nvidia.com
Signed-off-by: Michael Guralnik <michaelgur@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/core/frmr_pools.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/core/frmr_pools.c b/drivers/infiniband/core/frmr_pools.c
index 5e992ff3d7cffd..6170466ea9581a 100644
--- a/drivers/infiniband/core/frmr_pools.c
+++ b/drivers/infiniband/core/frmr_pools.c
@@ -426,7 +426,7 @@ int ib_frmr_pools_set_pinned(struct ib_device *device, struct ib_frmr_key *key,
 	if (!handles)
 		return -ENOMEM;
 
-	ret = pools->pool_ops->create_frmrs(device, key, handles,
+	ret = pools->pool_ops->create_frmrs(device, &driver_key, handles,
 					    needed_handles);
 	if (ret) {
 		kfree(handles);
-- 
2.53.0



