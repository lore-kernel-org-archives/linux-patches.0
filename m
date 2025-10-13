Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE83530C614;
	Mon, 13 Oct 2025 15:36:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760369810; cv=none; b=uQL4cq70rGYTWDLl6hUI5BtR+06WXdqOmO0/XxPPWfebK0/Opm3YF/vOb7fLvv4yx/wuLwS9dWG1vdxCrTLr0eTDB4vuTuZQck0kUiAdr31d+m9vxBsg+Mtyp2KHu9MPqOOqxUn5kO7GW1UyTztEO2UzE+OYLtam1D9W2RLyevQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760369810; c=relaxed/simple;
	bh=241kqRbkJsTjz0tqmrgNVgTHOd1xXZn953hMDZp/dwI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=meYzomCCg0G9RSS8barkU4NAXn4mrK57H4sJWx1hO9xOX28676DDmRtBemA8JM2FMTzh/1VbjYahDT00KADBsMrgoq4/MC+2eVe79gHOC1NkZlzJXUqWqFxd0er0fhzLNt14487WDE9xgMmEwSKMNJ4IEsRPkNH/yisYuoYxDV8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lL+UasWr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lL+UasWr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1883EC4CEE7;
	Mon, 13 Oct 2025 15:36:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760369810;
	bh=241kqRbkJsTjz0tqmrgNVgTHOd1xXZn953hMDZp/dwI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lL+UasWrB9sVL1aUoFyUM6b59IXWNu3qaWbGaJJhd47YttHtX1R2Qjwho2X5Wo5Mi
	 6kx9H2eUsmhqAsnkN2OFcGKODrujTh1RjCK82Bbu1PVXEz81PHhOo5Krb87+5Hj2BW
	 PHm4eKwLfKcUF3ec+ZiecK9j5+uQ2dXHkd98lHys=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Edward Srouji <edwards@nvidia.com>,
	Michael Guralnik <michaelgur@nvidia.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 344/563] RDMA/mlx5: Fix page size bitmap calculation for KSM mode
Date: Mon, 13 Oct 2025 16:43:25 +0200
Message-ID: <20251013144423.732584269@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144411.274874080@linuxfoundation.org>
References: <20251013144411.274874080@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Edward Srouji <edwards@nvidia.com>

[ Upstream commit 372fdb5c75b61f038f4abf596abdcf01acbdb7af ]

When using KSM (Key Scatter-gather Memory) access mode, the HW requires
the IOVA to be aligned to the selected page size.
Without this alignment, the HW may not function correctly.

Currently, mlx5_umem_mkc_find_best_pgsz() does not filter out page sizes
that would result in misaligned IOVAs for KSM mode. This can lead to
selecting page sizes that are incompatible with the given IOVA.

Fix this by filtering the page size bitmap when in KSM mode, keeping
only page sizes to which the IOVA is aligned to.

Fixes: fcfb03597b7d ("RDMA/mlx5: Align mkc page size capability check to PRM")
Signed-off-by: Edward Srouji <edwards@nvidia.com>
Link: https://patch.msgid.link/20250824144839.154717-1-edwards@nvidia.com
Reviewed-by: Michael Guralnik <michaelgur@nvidia.com>
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/mlx5/mlx5_ib.h | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/infiniband/hw/mlx5/mlx5_ib.h b/drivers/infiniband/hw/mlx5/mlx5_ib.h
index 8d21ecf8a996f..15e3962633dc3 100644
--- a/drivers/infiniband/hw/mlx5/mlx5_ib.h
+++ b/drivers/infiniband/hw/mlx5/mlx5_ib.h
@@ -1803,6 +1803,10 @@ mlx5_umem_mkc_find_best_pgsz(struct mlx5_ib_dev *dev, struct ib_umem *umem,
 
 	bitmap = GENMASK_ULL(max_log_entity_size_cap, min_log_entity_size_cap);
 
+	/* In KSM mode HW requires IOVA and mkey's page size to be aligned */
+	if (access_mode == MLX5_MKC_ACCESS_MODE_KSM && iova)
+		bitmap &= GENMASK_ULL(__ffs64(iova), 0);
+
 	return ib_umem_find_best_pgsz(umem, bitmap, iova);
 }
 
-- 
2.51.0



