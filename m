Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 006E547127A;
	Tue, 21 Jul 2026 18:49:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784659790; cv=none; b=Ww0j0N9RewTCb9JMkFgq96pEJw0Dye1MebhgEnY1wlhf/0r3XPHeLeko0j6YIoNoyi21CAJbJ1NWAGITAYaiXBPidlG5ZdQImCYZQkdDcWfUal2PkcgbQOfEDs5FwYlaij66W7IYCKUhCl6IG2nP5UH1gqTdl3AfK3ZRpP5l2TI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784659790; c=relaxed/simple;
	bh=Bee/3cErJnD+XYSk/Rz8MM11SWMv3znOZiHju8f+aRU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BCg9Fd/RQTSzjvKzIWjqwfmJr7qqKLZPt6k1qer0r13JuUKaGcKBILgW3u1vf3IpVZ/tVEaHQu4lNeZJhicKz36VLM/83kpk9S7oOtFVLDZW8JKyByI9KYZ3BIg5BIz3PxynPutiHhaP54yFYC97VtotPTPR6HNJbudLVnxwKOs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=M4+4B0VH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="M4+4B0VH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5498F1F000E9;
	Tue, 21 Jul 2026 18:49:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784659788;
	bh=1e2ZMnyDVDZ17u7oBuKtEn2fzWP4aexX7yRCLfXT5UA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=M4+4B0VHMHt8vW01J6oL02CJldmYLyxkgyni5zRgkW15RBV/612DO4TDh8DALTzSv
	 QuQRNoDflndWXSJoOtk9SVp488WZooVbWMASZqR2sNIuyKA5a0T9KN6/bIrEXRI5yD
	 k3Qu3ZUlp5TUj6XBLOgQGHtaR3zgbZVZP2J9dTQI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Guralnik <michaelgur@nvidia.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0691/2077] RDMA/core: Avoid NULL dereference on FRMR bad usage
Date: Tue, 21 Jul 2026 17:06:04 +0200
Message-ID: <20260721152609.088830122@linuxfoundation.org>
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

[ Upstream commit 3937243095b5cfed6556bd1ea170790223f3eeb0 ]

In case a driver calls FRMR pop operation without a successful init,
return after triggering a warning to avoid the NULL dereference.

Fixes: ce5df0b891ed ("IB/core: Introduce FRMR pools")
Link: https://patch.msgid.link/r/20260610000145.820592-7-michaelgur@nvidia.com
Signed-off-by: Michael Guralnik <michaelgur@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/core/frmr_pools.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/core/frmr_pools.c b/drivers/infiniband/core/frmr_pools.c
index 1cfdddc3fcdaf6..892aedfe03bed4 100644
--- a/drivers/infiniband/core/frmr_pools.c
+++ b/drivers/infiniband/core/frmr_pools.c
@@ -529,7 +529,9 @@ int ib_frmr_pool_pop(struct ib_device *device, struct ib_mr *mr)
 	struct ib_frmr_pools *pools = device->frmr_pools;
 	struct ib_frmr_pool *pool;
 
-	WARN_ON_ONCE(!device->frmr_pools);
+	if (WARN_ON_ONCE(!pools))
+		return -EINVAL;
+
 	pool = ib_frmr_pool_find(pools, &mr->frmr.key);
 	if (!pool) {
 		pool = create_frmr_pool(device, &mr->frmr.key);
-- 
2.53.0



