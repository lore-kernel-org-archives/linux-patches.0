Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 620493B19AB;
	Sat, 12 Sep 2026 18:54:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789239258; cv=none; b=I149tvcRVqD1syQe3ijGAq2L1hgV+/DChxz6qXLh3LH8lRePPnBrG8YEpsBOnafzIt3qNcGEpMl7/6Y9ZhiFfIlifY6rLvMTG8JY3uHyMKITkah8Yvq1TytyTBm7CFFuSD7yKydWeVqGBgfd79oLcJkdDLMLJEehy5E3Kp084Ns=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789239258; c=relaxed/simple;
	bh=/Mv8hT0fSyfmtLbCiu/wC3m6Sa66g2VVRX4banJtRpI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KSYnf91SRqJ2+iGHZ7/kz/szJCcB2bjFaHPcvAQkNzMhwDDBKhTRKFKKuWN4pekCvvhtlMgFVzxxWKsPjNcYwcnqjGelnTU8SXMJRUa38mMP9aAAcULF2+Q0qcIVS6TFg5vrmWr+2q+jXl2kHVejJ2lwqPQepFz6E3D/stK4rL8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vbm45zD4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vbm45zD4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED6CC1F000FF;
	Sat, 12 Sep 2026 18:54:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789239257;
	bh=6v4tK0gcGVkG2lZN1GMk0P1CuztNH/h047utJ3DXJNo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vbm45zD4wtTmi35+LKcG5mP1FHgZJT2tuWSFqqLRyrbN1oAzR9RXE02saiFc8SHRE
	 863z4MDV5vAE4xQO0wC+9VAhHBANyRJlIvpRlVOyUVDjds1/nTF/+ZGYTUByUza6RC
	 sZ9yic3WMdUEddA1hm+NuuUR4zjvAfwc9lgqD2Q0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Leon Romanovsky <leonro@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 626/935] RDMA/cxgb4: free STAG index when TPT entry write fails
Date: Sat, 12 Sep 2026 09:00:56 +0200
Message-ID: <20260912065541.197679951@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Leon Romanovsky <leonro@nvidia.com>

[ Upstream commit fdfb5cea4bf070cdb31d997efd87bb684df041fd ]

write_tpt_entry() allocates a new STAG index with c4iw_get_resource() and
bumps stats.stag.cur before programming the entry.  When
write_adapter_mem() fails, it returns the error without releasing the index
or reversing the statistic.  No MR is inserted into rhp->mrs, so
deregistration never reclaims it, leaking the index until device teardown.

Record whether this call allocated the index and, on a failed write, return
it to tpt_table and decrement stats.stag.cur.  Key the rollback on both the
write error and that flag, not the error alone: a non-reset update carries
a caller-owned STAG that this call did not allocate and must not free.

Fixes: ec3eead21718 ("RDMA/cxgb4: Remove kfifo usage")
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/cxgb4/mem.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/cxgb4/mem.c b/drivers/infiniband/hw/cxgb4/mem.c
index 88db7e527728c..9c24789bbb54b 100644
--- a/drivers/infiniband/hw/cxgb4/mem.c
+++ b/drivers/infiniband/hw/cxgb4/mem.c
@@ -277,6 +277,7 @@ static int write_tpt_entry(struct c4iw_rdev *rdev, u32 reset_tpt_entry,
 	int err;
 	struct fw_ri_tpte *tpt;
 	u32 stag_idx;
+	bool stag_idx_allocated = false;
 	static atomic_t key;
 
 	if (c4iw_fatal_error(rdev))
@@ -299,6 +300,7 @@ static int write_tpt_entry(struct c4iw_rdev *rdev, u32 reset_tpt_entry,
 			return -ENOMEM;
 		}
 		mutex_lock(&rdev->stats.lock);
+		stag_idx_allocated = true;
 		rdev->stats.stag.cur += 32;
 		if (rdev->stats.stag.cur > rdev->stats.stag.max)
 			rdev->stats.stag.max = rdev->stats.stag.cur;
@@ -333,7 +335,7 @@ static int write_tpt_entry(struct c4iw_rdev *rdev, u32 reset_tpt_entry,
 				(rdev->lldi.vr->stag.start >> 5),
 				sizeof(*tpt), tpt, skb, wr_waitp);
 
-	if (reset_tpt_entry) {
+	if (reset_tpt_entry || (err && stag_idx_allocated)) {
 		c4iw_put_resource(&rdev->resource.tpt_table, stag_idx);
 		mutex_lock(&rdev->stats.lock);
 		rdev->stats.stag.cur -= 32;
-- 
2.53.0



