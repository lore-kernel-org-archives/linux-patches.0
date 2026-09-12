Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE48E3905E6;
	Sat, 12 Sep 2026 16:26:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789230411; cv=none; b=Jbj1S8M7+jWqqGem8hTQQ8zj99gWhuyQRVRUZNyc/cMn90BjKnzgPG2YIyNYwP8EVkOIC/sg6WgdoNWPKPbmfy2mc0euRVnvbzB+imcItOoUhitT8dIPXcQ1386uMviOIIHwouFFvq46v2IX+AejuBYBqKwfjVbwGWGygRjLu70=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789230411; c=relaxed/simple;
	bh=PV6qQWxHtlZDffKiinA4gYuy2GVQb7lOU5WKxMHNxM4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ueJVii2VZRkuq5vgkihAqdhsHUgRjQINxgIArJep+GUb7/a3AYCnUXX9QxEHNgMMyo0me3gE5pDWG+U6qbea7J2D8wcZ/BPratrtbp7/+SklIiHl2fDikGdXGoKZke7JkuRZCCZ0nVIyg6emI/4lzjf1zyV3wej6GiSuwHIA+QU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=u5/PUxie; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="u5/PUxie"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D46B81F000FF;
	Sat, 12 Sep 2026 16:26:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789230409;
	bh=BfNHHKsi8YZdEePwFayy0l5OREwScY7yuOEiAIBPWVY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=u5/PUxiey0+FyQ9FJM6fq5dY9GsvSv+JH3J/w8LzxhHWlvolDC/O2dhciZXBDM91W
	 80xcU5c2aNtR8L1Fz28/ouug4qmRJYvrwlfkRUsbsj/SWgrXDp6wnpfbqpJu3rwIf0
	 8As5AlxAyEUSuQqYkRh6hrIbseIBl5H4wmK/YcCA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Leon Romanovsky <leonro@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0745/1191] RDMA/cxgb4: free STAG index when TPT entry write fails
Date: Sat, 12 Sep 2026 08:57:53 +0200
Message-ID: <20260912065605.011598817@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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



