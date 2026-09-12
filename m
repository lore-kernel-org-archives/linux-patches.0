Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC515390239;
	Sat, 12 Sep 2026 19:53:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789242812; cv=none; b=c+SvpLnQWXBzyvVobVdAUJTBmGnm2zMhtHnUmLxZ+0H3eCBtUdU3vSeri7mqW3a57weLCct++9GNMA6tn3ddD7ArtGTFXaWQ5YbGOWqm4un5ffQsTXOoULZGbvMiEyJQoPKIBZwT2CFgPzz0a0a7k8Z+r1ZhOg5Urjfejl0aILQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789242812; c=relaxed/simple;
	bh=/VERC4/R8rxdA4TRqagfiFpfQ1uvQJPJNLeWE2WOOJI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bR/AgWy4gdeJiscKxa+JfetSJgp+hWD8pAe6OO1xhuafk1fpZGuvmXWskuOm3s3o3IvjELA/nLKjsizIEB9tHP+CiC2Ju96+FNF8C/1xyDjYI4Qp+sw+Uv7FRNEDPzPzIulPR+/+I+QUH9TII6DUJXkXefcEVER+tLeupg7VYcI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JjQZXP9g; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JjQZXP9g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 544EE1F00893;
	Sat, 12 Sep 2026 19:53:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789242810;
	bh=oXfj/rfL8Nlj/8SbqNne2w9VCdptApPrTMWPueVxS8o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JjQZXP9gs4FZYCp44J2FG/U/oY4LIcfEdSHs6uYOnVU37Xctbx5+/hU8pSfB0zO+r
	 nqdeUd5n84ez0AYL0oRsieaLLPjBnXeJTn7KjL4gXTfQoUxkXNI+vXSbFVgQ9Xjpdf
	 9Dgc1qfNgcteSleZTdW/E5Y00vdAn+DzGDWvnKiw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Leon Romanovsky <leonro@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 536/798] RDMA/cxgb4: free STAG index when TPT entry write fails
Date: Sat, 12 Sep 2026 09:02:44 +0200
Message-ID: <20260912065529.413015652@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 02fb7c314ab46..3d26c79fc02ba 100644
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



