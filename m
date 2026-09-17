Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00483358D27;
	Thu, 17 Sep 2026 15:39:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789659579; cv=none; b=em0fWxRH1nS7AAzbZMOl1vKQ1h9634r+piQSdDJPjvxUe+1r7cwR+pjC0NIXoPp2bxUvRpno5nXVQoMMg+5mS4Gie03xOVUabg1OPvYzy3G8TYn9GZETvkN1ZSduuuxYqOliWqKS9y8uZ33THY0m5KCAKMX724Jda2uypXiaoE0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789659579; c=relaxed/simple;
	bh=apDLHlFCn6aS79UfhM3Q5NELnPSCxhoetRP6BB2jQ2A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bh8x0LQMpFNkk3BK9C/T7yIYQsGcpcC555lSfgKMJcQqncib58zOhkyWhqe1OKvl85GadXLQODJeqISZn8s4Hl1Eb1JDLVIDycWsBHBLOFWsYMXb0yb1Gdl8WS3zmEtyQpbK7nJT2IiygFkZdPtJrlVCIYq9P3cKWccJO/eP2Oo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dJr7befP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dJr7befP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44ABA1F00898;
	Thu, 17 Sep 2026 15:39:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789659571;
	bh=LSY1Co14MQQDMP1+tIYJQWyiUwI+Vl9hLbmW2NSIzn4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dJr7befPMpehKJeuZte6zTs+Y1dz1jzzGJ5PplDkHq1Qb9De2L6o9s3M5nYLOxiAC
	 FRPwoW4XYT4N5zVO7yvX1PmW8RW/PzCJcCwx54SMgqKNbjY+2cp1v19WlYCzbZ4sdy
	 lWwDIw7EyLtup9FXFLn4ywaHKzCbUkexaTCZOCxY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yael Chemla <ychemla@nvidia.com>,
	Dragos Tatulea <dtatulea@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 302/733] net/mlx5: E-Switch: fix use-after-free in mlx5_eswitch_termtbl_put
Date: Thu, 17 Sep 2026 16:10:10 +0100
Message-ID: <20260917151358.964972138@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
index 19f65d4c4def9..d43f073601596 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads_termtbl.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads_termtbl.c
@@ -163,12 +163,15 @@ void
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



