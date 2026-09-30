Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F95043DEB5;
	Wed, 30 Sep 2026 19:07:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790795277; cv=none; b=tWIcKsYqk977Q/FHwR6ZETv8ynX61zUXPMIpgVr3HxTuhRzx6LOob74wxg7yoyMj8owNY68U+lUYBQFK0zqO5mpNuT0Pn4R6iAamNdakBWL2n6ItAuHcDab6yDj8Z9yFrNutU1LyO7bUfjyzb1jw2L+qbknXhCjf6AdRoSkITqo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790795277; c=relaxed/simple;
	bh=PaMeCe7LDGwjuNLy0WEMiBhvQ3MP30EG06jq504cZyA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NV7ATBHnPg3lyC84DURhlREqvhft/M04y1p1hM89Nghzk/TXh0JhQoCJB115CXUlrmAhucahQD9u6+i2ER+9/qdwCzkm4SDCfBUL5vt37qN1kWtJEkIkICX5koug7fNB7PfeHpqm1RgKjHDJpexUcxpz7CpqiMG4acsUawV9zI4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AtNdmhus; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AtNdmhus"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBEF91F0089A;
	Wed, 30 Sep 2026 19:07:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790795276;
	bh=FPSqXWaysyZgn0VnjEGrpkORyRc2Clh33rfzeVTiNUM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AtNdmhusSSA4WeOkqgbWcSoOwhofDrv04OCmY5wCTFjItD2N6RJqMAPxBj3jBieCV
	 iT4wBvrZu5D9dDnXne2gy+1axiID2yIsG5S6m6Vhqjep362ekij520Lczb0IzC5cFy
	 xeAO7ivmo1o+rZb+w6M04kRgKEYaNuuhlOm1A5iE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yael Chemla <ychemla@nvidia.com>,
	Dragos Tatulea <dtatulea@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0504/1193] net/mlx5: E-Switch: fix use-after-free in mlx5_eswitch_termtbl_put
Date: Wed, 30 Sep 2026 17:19:48 +0200
Message-ID: <20260930152445.360689264@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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
index 40bdc677f051d..e282f65b8756a 100644
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



