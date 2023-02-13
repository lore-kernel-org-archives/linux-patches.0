Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 398A38F57
	for <patches@lists.linux.dev>; Mon, 13 Feb 2023 14:53:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B211AC4339B;
	Mon, 13 Feb 2023 14:53:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1676299992;
	bh=G51K7x/kDqa36i3xosmRM5c83YASFZgEZ0GkOPhNMOU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BVu8jnTBf1JlySIwW+qR1x74VACbuK4NSpzM2jKlY69i1oyJankXTuj2Eo1yH4Stb
	 95j8wWtKGG6K2t8lAltz+blZ4+MOZpP55otRbtu8y6JtSZwsSRA1dm8fNokVLAtHOO
	 VvGC6sWtNb2Wf+ZJOchJeginbhEDqL1k/9lYh6bw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Yingliang <yangyingliang@huawei.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 022/114] RDMA/usnic: use iommu_map_atomic() under spin_lock()
Date: Mon, 13 Feb 2023 15:47:37 +0100
Message-Id: <20230213144743.299900079@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230213144742.219399167@linuxfoundation.org>
References: <20230213144742.219399167@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Yang Yingliang <yangyingliang@huawei.com>

[ Upstream commit b7e08a5a63a11627601915473c3b569c1f6c6c06 ]

usnic_uiom_map_sorted_intervals() is called under spin_lock(), iommu_map()
might sleep, use iommu_map_atomic() to avoid potential sleep in atomic
context.

Fixes: e3cf00d0a87f ("IB/usnic: Add Cisco VIC low-level hardware driver")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Link: https://lore.kernel.org/r/20230129093757.637354-1-yangyingliang@huawei.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/usnic/usnic_uiom.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/hw/usnic/usnic_uiom.c b/drivers/infiniband/hw/usnic/usnic_uiom.c
index 67923ced6e2d1..b343f6f1bda57 100644
--- a/drivers/infiniband/hw/usnic/usnic_uiom.c
+++ b/drivers/infiniband/hw/usnic/usnic_uiom.c
@@ -277,8 +277,8 @@ static int usnic_uiom_map_sorted_intervals(struct list_head *intervals,
 				size = pa_end - pa_start + PAGE_SIZE;
 				usnic_dbg("va 0x%lx pa %pa size 0x%zx flags 0x%x",
 					va_start, &pa_start, size, flags);
-				err = iommu_map(pd->domain, va_start, pa_start,
-							size, flags);
+				err = iommu_map_atomic(pd->domain, va_start,
+						       pa_start, size, flags);
 				if (err) {
 					usnic_err("Failed to map va 0x%lx pa %pa size 0x%zx with err %d\n",
 						va_start, &pa_start, size, err);
@@ -294,8 +294,8 @@ static int usnic_uiom_map_sorted_intervals(struct list_head *intervals,
 				size = pa - pa_start + PAGE_SIZE;
 				usnic_dbg("va 0x%lx pa %pa size 0x%zx flags 0x%x\n",
 					va_start, &pa_start, size, flags);
-				err = iommu_map(pd->domain, va_start, pa_start,
-						size, flags);
+				err = iommu_map_atomic(pd->domain, va_start,
+						       pa_start, size, flags);
 				if (err) {
 					usnic_err("Failed to map va 0x%lx pa %pa size 0x%zx with err %d\n",
 						va_start, &pa_start, size, err);
-- 
2.39.0



