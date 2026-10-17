Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CD673B19BA;
	Sat, 17 Oct 2026 17:12:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792257134; cv=none; b=OsOlSTlSp6apCL+KR1INUKhxJwGiWvDAKvSLBuw4kRrGhfPLhg+oqgrVr2JUPhYFlWpVcp8hJh8+dCVTnpBY56k0IsOaWhdRmTzCEI17hvIYwlX1uk+jS4ls3uwJ+V6xC7A6dY6VpZ5qEiP5AQ4mkJ5ZEd+rEorbgPRSHk264Wo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792257134; c=relaxed/simple;
	bh=H3vvN/+XhK94QU8uCv723K0e6W21n3XCHhl9yKTc0s0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kaxppsMShiig2hxgm6K5V3gHOwyS4Xc6JRFUC7XC5lOXPag6klx/EHsZuImQTdw9GFtIWd85nlF36M+hr7gUx+weOdgitcXWD9WYUXGA3j24s0UZM2UnuxBa6TgJZ7YvmCVf+68KSFJJrVpjmk/JuNTP8kNlxfOdBFPlcV1m7Oo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vLpGDr6d; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vLpGDr6d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C266B1F000C4;
	Sat, 17 Oct 2026 17:12:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792257133;
	bh=orQCX9JevUm1v4ppMIty084pfeIvDGMzWOpsU/KFJ8M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vLpGDr6dhr6l/sLALAkJ7ynJBOLMes+1ZkeULIcTwK3asIajiP3mJ/1i/02dEp8ET
	 QIujwhrxJE5cXoBtCQbXJR6xnlWi3gHaaG8VFpL3osx17AP51KF93+dwRyMngfzzKc
	 JHBPjpzx9/IJHsTWQjFKxgo2KihSJkkQrIvH8fKE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jerome Tollet <jtollet@cisco.com>,
	Dragos Tatulea <dtatulea@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0435/1674] net/mlx5e: Prevent stale XSK buffer release on MPWQE refill retry
Date: Sat, 17 Oct 2026 17:45:07 +0200
Message-ID: <20261017160442.289398542@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index b8dd744536553..fadc3d2309a82 100644
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



