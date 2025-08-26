Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFFA920330;
	Tue, 26 Aug 2025 11:49:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756208976; cv=none; b=CTRQyTA03SQYD5gSqsSNo6na2jNWkdS562tvpYfHLzm/aX6BYqZhrCGgxIQQHsOkVw6YLYYkv+CZaggnMuhmijbw12I60G0lLp8xf8YzTmGC9VnBM0MPDnHHGZyudYDttji/EL7i9YQjxu79daD+WKrjHcplXTE2r5L4rTeiJQY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756208976; c=relaxed/simple;
	bh=oTadlIxveQuClDCBTtZT1YoCJrZFycW0I1fIPcowUi4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GielvSzZqAINsKkAUlhKvDV3wZyLAndeFQJSrF955ss+5bfVIir1tB6jGiLEd8VUqrJKWqB4Lzma7+QK9bYOqUrdziFa4ASrVrSg0F0Tz6bR33nEzUvn88b9pnRffiPLjyxFKBwcAtB0FLz/BA6L+gl+Rtaf9ibZYCsZ7OoE/Ts=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=j0XJ9w5x; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="j0XJ9w5x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BE02C116D0;
	Tue, 26 Aug 2025 11:49:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756208974;
	bh=oTadlIxveQuClDCBTtZT1YoCJrZFycW0I1fIPcowUi4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=j0XJ9w5xONqP8NQaUO0MnwUmedalG6Sn/TwknoKHCe0ojN5TGKJNhpyUKEx1WPa+/
	 wVV2d4De9p4MDmCTEzv6edi32D6JnlIIb0CMZ4RVrE2JJJDmQRnAABZXBRVgGq20DS
	 xP1b4i67/CvJrvHhcwOZByrHwCgqQ8lBB+Z2bQpA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Armen Ratner <armeng@nvidia.com>,
	Maher Sanalla <msanalla@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Alexei Lazar <alazar@nvidia.com>,
	Mark Bloch <mbloch@nvidia.com>,
	Przemek Kitszel <przemyslaw.kitszel@intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 317/322] net/mlx5e: Preserve shared buffer capacity during headroom updates
Date: Tue, 26 Aug 2025 13:12:12 +0200
Message-ID: <20250826110923.716767213@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110915.169062587@linuxfoundation.org>
References: <20250826110915.169062587@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Armen Ratner <armeng@nvidia.com>

[ Upstream commit 8b0587a885fdb34fd6090a3f8625cb7ac1444826 ]

When port buffer headroom changes, port_update_shared_buffer()
recalculates the shared buffer size and splits it in a 3:1 ratio
(lossy:lossless) - Currently, the calculation is:
lossless = shared / 4;
lossy = (shared / 4) * 3;

Meaning, the calculation dropped the remainder of shared % 4 due to
integer division, unintentionally reducing the total shared buffer
by up to three cells on each update. Over time, this could shrink
the buffer below usable size.

Fix it by changing the calculation to:
lossless = shared / 4;
lossy = shared - lossless;

This retains all buffer cells while still approximating the
intended 3:1 split, preventing capacity loss over time.

While at it, perform headroom calculations in units of cells rather than
in bytes for more accurate calculations avoiding extra divisions.

Fixes: a440030d8946 ("net/mlx5e: Update shared buffer along with device buffer changes")
Signed-off-by: Armen Ratner <armeng@nvidia.com>
Signed-off-by: Maher Sanalla <msanalla@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Alexei Lazar <alazar@nvidia.com>
Signed-off-by: Mark Bloch <mbloch@nvidia.com>
Reviewed-by: Przemek Kitszel <przemyslaw.kitszel@intel.com>
Link: https://patch.msgid.link/20250820133209.389065-9-mbloch@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../mellanox/mlx5/core/en/port_buffer.c        | 18 ++++++++----------
 1 file changed, 8 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/port_buffer.c b/drivers/net/ethernet/mellanox/mlx5/core/en/port_buffer.c
index 5ae787656a7c..3efa8bf1d14e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/port_buffer.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/port_buffer.c
@@ -272,8 +272,8 @@ static int port_update_shared_buffer(struct mlx5_core_dev *mdev,
 	/* Total shared buffer size is split in a ratio of 3:1 between
 	 * lossy and lossless pools respectively.
 	 */
-	lossy_epool_size = (shared_buffer_size / 4) * 3;
 	lossless_ipool_size = shared_buffer_size / 4;
+	lossy_epool_size    = shared_buffer_size - lossless_ipool_size;
 
 	mlx5e_port_set_sbpr(mdev, 0, MLX5_EGRESS_DIR, MLX5_LOSSY_POOL, 0,
 			    lossy_epool_size);
@@ -288,14 +288,12 @@ static int port_set_buffer(struct mlx5e_priv *priv,
 	u16 port_buff_cell_sz = priv->dcbx.port_buff_cell_sz;
 	struct mlx5_core_dev *mdev = priv->mdev;
 	int sz = MLX5_ST_SZ_BYTES(pbmc_reg);
-	u32 new_headroom_size = 0;
-	u32 current_headroom_size;
+	u32 current_headroom_cells = 0;
+	u32 new_headroom_cells = 0;
 	void *in;
 	int err;
 	int i;
 
-	current_headroom_size = port_buffer->headroom_size;
-
 	in = kzalloc(sz, GFP_KERNEL);
 	if (!in)
 		return -ENOMEM;
@@ -306,12 +304,14 @@ static int port_set_buffer(struct mlx5e_priv *priv,
 
 	for (i = 0; i < MLX5E_MAX_NETWORK_BUFFER; i++) {
 		void *buffer = MLX5_ADDR_OF(pbmc_reg, in, buffer[i]);
+		current_headroom_cells += MLX5_GET(bufferx_reg, buffer, size);
+
 		u64 size = port_buffer->buffer[i].size;
 		u64 xoff = port_buffer->buffer[i].xoff;
 		u64 xon = port_buffer->buffer[i].xon;
 
-		new_headroom_size += size;
 		do_div(size, port_buff_cell_sz);
+		new_headroom_cells += size;
 		do_div(xoff, port_buff_cell_sz);
 		do_div(xon, port_buff_cell_sz);
 		MLX5_SET(bufferx_reg, buffer, size, size);
@@ -320,10 +320,8 @@ static int port_set_buffer(struct mlx5e_priv *priv,
 		MLX5_SET(bufferx_reg, buffer, xon_threshold, xon);
 	}
 
-	new_headroom_size /= port_buff_cell_sz;
-	current_headroom_size /= port_buff_cell_sz;
-	err = port_update_shared_buffer(priv->mdev, current_headroom_size,
-					new_headroom_size);
+	err = port_update_shared_buffer(priv->mdev, current_headroom_cells,
+					new_headroom_cells);
 	if (err)
 		goto out;
 
-- 
2.50.1



