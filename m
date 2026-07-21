Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E80593FDC06;
	Tue, 21 Jul 2026 16:02:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784649755; cv=none; b=htaZf9ydXuvy4vhZoiRPVu7zL44hl0rxQfWObh7Yc0qNE4AyWk34+DTkEuhjf+1pI9DKuIqzfOvcphyyn7NUlSbH61N0G5ynNR7PrJDZmBA6jrkFQZmL3afAZ7Fs5jmpStUl+C4XWhWHuxeMdqQ+I6oaPiwdwegHZl0Noq6etM0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784649755; c=relaxed/simple;
	bh=LuNHuFRGj59GzDFi10/c0/sMpNShL4QSbovYkJAoX2s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IjnATxLDuMgMF188GCHT1I0yz2iaY7ajii/r+LqElkeLBFwm6npjOFHtpkxTZTdSOnVL1qe/xLy08+hqV3vZP3MWxuM+GMncAkgP34CjFb7UcMCrTI+GIsghHKEi026VD6HcPfhQpeC7yljCy2goU/slFO/MMsTsWvbPhOlV6cg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lX53qQjK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lX53qQjK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 197471F000E9;
	Tue, 21 Jul 2026 16:02:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784649753;
	bh=e1yBG9i8enodS7ANSg35kGL8QRD4MPe8QBrE4YPBVz8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lX53qQjKXewIz3ZgP56wR8fMAg1ef6AEvqAkGBi48cVt+ur+0No/paHjnC9GmzAHV
	 h/+n5CSEkVNH1/J7E8u3X8SeHA60+26RyqzPK4frQWTFjqpprBQ9Mx6VyCaxt4d22W
	 ZcyF1kSiyPwDUgtTc7cNZWmjEFtubnxi7EzEfrOQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Guralnik <michaelgur@nvidia.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0687/2077] RDMA/mlx5: Fix TPH extraction in FRMR pool key
Date: Tue, 21 Jul 2026 17:06:00 +0200
Message-ID: <20260721152608.999023804@linuxfoundation.org>
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

[ Upstream commit fe683274fee497834d2e6b54b7342642e1f21892 ]

Fix reading the PH value from the FRMR pool key by shifting the pool key
to the relevant bits.

Fixes: 36680ef7bceb ("RDMA/mlx5: Switch from MR cache to FRMR pools")
Link: https://patch.msgid.link/r/20260610000145.820592-3-michaelgur@nvidia.com
Signed-off-by: Michael Guralnik <michaelgur@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/mlx5/mr.c | 16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/mr.c b/drivers/infiniband/hw/mlx5/mr.c
index 253545ae39fd53..7fbb01371f1f77 100644
--- a/drivers/infiniband/hw/mlx5/mr.c
+++ b/drivers/infiniband/hw/mlx5/mr.c
@@ -31,6 +31,7 @@
  * SOFTWARE.
  */
 
+#include <linux/bitfield.h>
 #include <linux/kref.h>
 #include <linux/random.h>
 #include <linux/debugfs.h>
@@ -163,9 +164,8 @@ static int get_unchangeable_access_flags(struct mlx5_ib_dev *dev,
 #define MLX5_FRMR_POOLS_KEY_VENDOR_KEY_SUPPORTED \
 	MLX5_FRMR_POOLS_KEY_ACCESS_MODE_KSM_MASK
 
-#define MLX5_FRMR_POOLS_KERNEL_KEY_PH_SHIFT 16
-#define MLX5_FRMR_POOLS_KERNEL_KEY_PH_MASK 0xFF0000
-#define MLX5_FRMR_POOLS_KERNEL_KEY_ST_INDEX_MASK 0xFFFF
+#define MLX5_FRMR_POOLS_KERNEL_KEY_PH_MASK GENMASK_ULL(23, 16)
+#define MLX5_FRMR_POOLS_KERNEL_KEY_ST_INDEX_MASK GENMASK_ULL(15, 0)
 
 static struct mlx5_ib_mr *
 _mlx5_frmr_pool_alloc(struct mlx5_ib_dev *dev, struct ib_umem *umem,
@@ -194,7 +194,8 @@ _mlx5_frmr_pool_alloc(struct mlx5_ib_dev *dev, struct ib_umem *umem,
 		ph ^= MLX5_IB_NO_PH;
 
 	mr->ibmr.frmr.key.kernel_vendor_key =
-		st_index | (ph << MLX5_FRMR_POOLS_KERNEL_KEY_PH_SHIFT);
+		FIELD_PREP(MLX5_FRMR_POOLS_KERNEL_KEY_ST_INDEX_MASK, st_index) |
+		FIELD_PREP(MLX5_FRMR_POOLS_KERNEL_KEY_PH_MASK, ph);
 	err = ib_frmr_pool_pop(&dev->ib_dev, &mr->ibmr);
 	if (err) {
 		kfree(mr);
@@ -271,9 +272,10 @@ static int mlx5r_create_mkeys(struct ib_device *device, struct ib_frmr_key *key,
 		 get_mkc_octo_size(access_mode, key->num_dma_blocks));
 	MLX5_SET(mkc, mkc, log_page_size, PAGE_SHIFT);
 
-	st_index = key->kernel_vendor_key &
-		   MLX5_FRMR_POOLS_KERNEL_KEY_ST_INDEX_MASK;
-	ph = key->kernel_vendor_key & MLX5_FRMR_POOLS_KERNEL_KEY_PH_MASK;
+	st_index = FIELD_GET(MLX5_FRMR_POOLS_KERNEL_KEY_ST_INDEX_MASK,
+			     key->kernel_vendor_key);
+	ph = FIELD_GET(MLX5_FRMR_POOLS_KERNEL_KEY_PH_MASK,
+		       key->kernel_vendor_key);
 	if (ph) {
 		/* Normalize ph: swap MLX5_IB_NO_PH for 0 */
 		if (ph == MLX5_IB_NO_PH)
-- 
2.53.0



