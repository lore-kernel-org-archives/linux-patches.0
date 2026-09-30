Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 955634F68C3;
	Wed, 30 Sep 2026 15:43:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790783021; cv=none; b=GBYdEtcbqO8f/ZWdE0iMu6IVAK7pVxfF0ZJor2FFtKb+78quMG/C7i6Q+SgBvnZ0vfr31U1MU/zVyeJ7Jrb8LXWbscVeCrmGW+4L/BPkeH933GNao/Z6FFC39xVZv/5v+TPqaCKzd/WdmGnvSYQXtT/tPOi8qt+aws8M1GNF9oI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790783021; c=relaxed/simple;
	bh=ptnSwOcb0PP3JJwet+179dSBbvpAdRHH+4WDt8G/UUU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a635pJWxUvMnnrlLyG4ENI9FGchIvvrIrYrI8Lg/SuS562pQFxflucHbx7JdeJhKg4h8ph6ZSDbe1qfEsvqNff49aXI/31PuBI1wiF9JT6EySG0wUCVTs0YiDFlUT7pVcWax7x11zijHzgYKULdOStfQCGY/aoiLH+C+wF/8ZxY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=N3XRj7F2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="N3XRj7F2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 454DB1F00893;
	Wed, 30 Sep 2026 15:43:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790783015;
	bh=lHuy4ieec96ah97FWQWgWMD1rrW5rooqXzRtEihgV+I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=N3XRj7F2h1KL9qF+5slFrXzZy9Aby494MFn+GcpCCA3WXyP8K19zlFxJIKgJlihK3
	 mp/ucbCclPbsCqX2FQFpUx39LCk2khh/oT5qZVF3ESrUQgLNMq9w+NffiOWUowWy5k
	 TbT6fSEVTvG3Vm38X588X7lZDoMJ2MFurdWB/pxs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yael Chemla <ychemla@nvidia.com>,
	Dragos Tatulea <dtatulea@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 248/595] net/mlx5: E-Switch: fix use-after-free in mlx5_eswitch_termtbl_put
Date: Wed, 30 Sep 2026 17:22:21 +0200
Message-ID: <20260930152353.051369667@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152347.700140858@linuxfoundation.org>
References: <20260930152347.700140858@linuxfoundation.org>
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

From: Yael Chemla <ychemla@nvidia.com>

[ Upstream commit 7ee07f601f8f507c9faf25c68a49396ab8950596 ]

In mlx5_eswitch_termtbl_put(), the zero-ref cleanup check reads
tt->ref_count after termtbl_mutex has been released.  Two concurrent
callers on the same mlx5_termtbl_handle race: one decrements ref_count
to zero, removes the hash entry, and calls kfree(tt) while the other
has already dropped the mutex and is about to evaluate
if (!tt->ref_count), producing a use-after-free.

Fix this by capturing the result of the decrement into a stack-local
last variable before dropping the mutex.  The cleanup decision is now
made entirely under termtbl_mutex, and tt is not touched after
kfree.

Fixes: 10caabdaad5a ("net/mlx5e: Use termination table for VLAN push actions")
Signed-off-by: Yael Chemla <ychemla@nvidia.com>
Reviewed-by: Dragos Tatulea <dtatulea@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Link: https://patch.msgid.link/20260902193514.3668880-1-tariqt@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../ethernet/mellanox/mlx5/core/eswitch_offloads_termtbl.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads_termtbl.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads_termtbl.c
index 132ea9997676a..345585529a30a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads_termtbl.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads_termtbl.c
@@ -162,12 +162,15 @@ void
 mlx5_eswitch_termtbl_put(struct mlx5_eswitch *esw,
 			 struct mlx5_termtbl_handle *tt)
 {
+	bool last;
+
 	mutex_lock(&esw->offloads.termtbl_mutex);
-	if (--tt->ref_count == 0)
+	last = (--tt->ref_count == 0);
+	if (last)
 		hash_del(&tt->termtbl_hlist);
 	mutex_unlock(&esw->offloads.termtbl_mutex);
 
-	if (!tt->ref_count) {
+	if (last) {
 		mlx5_del_flow_rules(tt->rule);
 		mlx5_destroy_flow_table(tt->termtbl);
 		kfree(tt);
-- 
2.53.0



