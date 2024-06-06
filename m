Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F6DE19884D;
	Thu,  6 Jun 2024 14:16:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683364; cv=none; b=BFkPYawXhzrUPQxz6xYuaPGcFnN0JjVnoDP4aeafBrBIg/lk2PbmO22irdIm55eE4/30VFALYQ78CFLsCXiI+oFQn/CqIBVgPI/0nGEQ06jwaft6Q8pf2g41BqF69jKT5Og0MeBrga0dRBnMEP5o5RnEAifWg3+QSdrif48Eh1Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683364; c=relaxed/simple;
	bh=qnoaaZ7GkGXBPyXV0dXmBesWB4OZc1jYKdJV8I8BTsA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aXmX1TnQCpj3n7MQDrckmfTYeDvGMlDCEvpVF3D1gb1E/Xiwk6p/QNdDbbHWisATqBJX+BJtDb4+MOEmzAG6gtcRJceM+3bNn/Oc+pQbehWmyHjdg5bJB4t6q4rwsWdU1lraTnNKfKE84ordmNBQrwG9JhMN6PPradmsd+xjm8Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=r/eL6lX5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="r/eL6lX5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB8CAC2BD10;
	Thu,  6 Jun 2024 14:16:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683363;
	bh=qnoaaZ7GkGXBPyXV0dXmBesWB4OZc1jYKdJV8I8BTsA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=r/eL6lX54pyX/GM2EOIW60ubmnqVytFCng9IhN+WABC4DMtSS9hzEF8FfwZvgoMyL
	 iZfMj7SCL4kQ87klWkxs/3+UU7baCp6821b3jTsEEiatLZK2ZcHeH7oUKpdS31cfwR
	 g/t/UT1lPBW1Bj6XZ9CySur19EJ38dQNkbzKDLdg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Niklas Schnelle <schnelle@linux.ibm.com>,
	Leon Romanovsky <leonro@nvidia.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 248/473] IB/mlx5: Use __iowrite64_copy() for write combining stores
Date: Thu,  6 Jun 2024 16:02:57 +0200
Message-ID: <20240606131708.195659292@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131659.786180261@linuxfoundation.org>
References: <20240606131659.786180261@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jason Gunthorpe <jgg@nvidia.com>

[ Upstream commit ef302283ddfceaba2657923af3f90fd58e6dff06 ]

mlx5 has a built in self-test at driver startup to evaluate if the
platform supports write combining to generate a 64 byte PCIe TLP or
not. This has proven necessary because a lot of common scenarios end up
with broken write combining (especially inside virtual machines) and there
is other way to learn this information.

This self test has been consistently failing on new ARM64 CPU
designs (specifically with NVIDIA Grace's implementation of Neoverse
V2). The C loop around writeq() generates some pretty terrible ARM64
assembly, but historically this has worked on a lot of existing ARM64 CPUs
till now.

We see it succeed about 1 time in 10,000 on the worst effected
systems. The CPU architects speculate that the load instructions
interspersed with the stores makes the WC buffers statistically flush too
often and thus the generation of large TLPs becomes infrequent. This makes
the boot up test unreliable in that it indicates no write-combining,
however userspace would be fine since it uses a ST4 instruction.

Further, S390 has similar issues where only the special zpci_memcpy_toio()
will actually generate large TLPs, and the open coded loop does not
trigger it at all.

Fix both ARM64 and S390 by switching to __iowrite64_copy() which now
provides architecture specific variants that have a high change of
generating a large TLP with write combining. x86 continues to use a
similar writeq loop in the generate __iowrite64_copy().

Fixes: 11f552e21755 ("IB/mlx5: Test write combining support")
Link: https://lore.kernel.org/r/6-v3-1893cd8b9369+1925-mlx5_arm_wc_jgg@nvidia.com
Tested-by: Niklas Schnelle <schnelle@linux.ibm.com>
Acked-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/mlx5/mem.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/mem.c b/drivers/infiniband/hw/mlx5/mem.c
index 96ffbbaf0a73d..5a22be14d958f 100644
--- a/drivers/infiniband/hw/mlx5/mem.c
+++ b/drivers/infiniband/hw/mlx5/mem.c
@@ -30,6 +30,7 @@
  * SOFTWARE.
  */
 
+#include <linux/io.h>
 #include <rdma/ib_umem_odp.h>
 #include "mlx5_ib.h"
 #include <linux/jiffies.h>
@@ -108,7 +109,6 @@ static int post_send_nop(struct mlx5_ib_dev *dev, struct ib_qp *ibqp, u64 wr_id,
 	__be32 mmio_wqe[16] = {};
 	unsigned long flags;
 	unsigned int idx;
-	int i;
 
 	if (unlikely(dev->mdev->state == MLX5_DEVICE_STATE_INTERNAL_ERROR))
 		return -EIO;
@@ -148,10 +148,8 @@ static int post_send_nop(struct mlx5_ib_dev *dev, struct ib_qp *ibqp, u64 wr_id,
 	 * we hit doorbell
 	 */
 	wmb();
-	for (i = 0; i < 8; i++)
-		mlx5_write64(&mmio_wqe[i * 2],
-			     bf->bfreg->map + bf->offset + i * 8);
-	io_stop_wc();
+	__iowrite64_copy(bf->bfreg->map + bf->offset, mmio_wqe,
+			 sizeof(mmio_wqe) / 8);
 
 	bf->offset ^= bf->buf_size;
 
-- 
2.43.0



