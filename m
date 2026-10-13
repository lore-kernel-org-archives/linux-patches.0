Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54E1B4F4753;
	Tue, 13 Oct 2026 12:46:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791895595; cv=none; b=uyGMNJu5t7KFtNculhV3eEKNENeLhSkIxXYfC2dDPLAEK7YiWCIyWoIM5i4X458kfsG8emuwMHTwFJTNI93DXuH09KtoMygxiH5DRTV6bEjMgeWOdFdwZoONXHLbapDed/sWE1x9FYf04TD1Kf/8j16hku0KBDpVvTbwDueHD5A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791895595; c=relaxed/simple;
	bh=Y4pnLEwd/WmlPxn1qnqBX2yMdczEkLmrXPMFVxXllw4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CapWa3d98mQJYcTwYSkSBzvE5pzrIxMmtCWIZ8nuT4/TS92HoilQt4qL4srui1aVxmpKvx2pTPWPUf8VieLFZq0/S2hLVa0QvHwHufHrtKVTDW8pN17fR5aPH+WUyiHSZcmvkQhV/TknrCXGxfEzSG3rXrnemNcC5xCWR8z2qyI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QUnt8wxZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QUnt8wxZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91ADC1F00893;
	Tue, 13 Oct 2026 12:46:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791895594;
	bh=BcOB6kUSiaFsWzuxIOotdSIcecTbK9xlsiPDvR/oZ8Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QUnt8wxZceX6EfdvoRkpk06yWhycPjqCVOYYWa2fezjbqCnIEQjo25lS4qH6vrHSq
	 BszmiRkEaGvCw9bWHfrN8LqcE1n22m9DjfcPVAPhGbOdt80kzjFiO/4Zozt6wDzPRv
	 oP51pKNtDMaW+NM5JAWfLmifX8f4n+UHKgKBhNEk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jerome Tollet <jtollet@cisco.com>,
	Dragos Tatulea <dtatulea@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 320/497] net/mlx5e: Prevent stale XSK buffer release on MPWQE refill retry
Date: Tue, 13 Oct 2026 13:38:07 +0200
Message-ID: <20261013112915.499138667@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112907.864180619@linuxfoundation.org>
References: <20261013112907.864180619@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jerome Tollet <jtollet@cisco.com>

[ Upstream commit 63811edf512584c946e5e96b100e9e280703bbb5 ]

With AF_XDP on a striding RQ, mlx5e defers releasing XSK buffers until
an MPWQE is refilled. If XSK allocation then returns -ENOMEM,
actual_wq_head is not advanced and a later NAPI poll retries the same
WQE.

mlx5e_free_rx_mpwqe() leaves each released slot marked as releasable. On
retry it can therefore call xsk_buff_free() again through stale pointers
after the frames have returned to the XSK pool and been reallocated.

Set all skip_release_bitmap bits in the common error path of
mlx5e_xsk_alloc_rx_mpwqe(). This matches mlx5e_alloc_rx_mpwqe(). A
successful allocation already clears the bitmap after replacing every
buffer, so retries become idempotent without changing the success path.

Fault injection forced three consecutive failures for one selected MPWQE.
Both an early allocation failure and a partial 8-of-16-buffer unwind
released the original 16 XSK buffers only once. Each error left a full
bitmap, the following NAPI retry skipped the release, and a later
successful allocation cleared it. A 20-second AF_XDP zero-copy pressure
run exercised 1,575,262 buffer allocation failures without invalid
descriptors, WQE errors, or kernel warnings.

Fixes: 4c2a13236807 ("net/mlx5e: RX, Defer page release in striding rq for better recycling")
Cc: stable@vger.kernel.org
Signed-off-by: Jerome Tollet <jtollet@cisco.com>
Reviewed-by: Dragos Tatulea <dtatulea@nvidia.com>
Link: https://patch.msgid.link/20260824141645.23700-3-jtollet@cisco.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/xsk/rx.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/rx.c
index 1b7132fa70de2..8dd3deb050f83 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/rx.c
@@ -3,6 +3,7 @@
 
 #include "rx.h"
 #include "en/xdp.h"
+#include <linux/bitmap.h>
 #include <net/xdp_sock_drv.h>
 #include <linux/filter.h>
 
@@ -153,6 +154,7 @@ int mlx5e_xsk_alloc_rx_mpwqe(struct mlx5e_rq *rq, u16 ix)
 		xsk_buff_free(xsk_buffs[batch]);
 
 err:
+	bitmap_fill(wi->skip_release_bitmap, rq->mpwqe.pages_per_wqe);
 	rq->stats->buff_alloc_err++;
 	return -ENOMEM;
 }
-- 
2.53.0



