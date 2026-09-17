Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 351984D4881;
	Thu, 17 Sep 2026 18:42:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789670525; cv=none; b=pAS2TD9NSiXHVO5ZnEZoujBiTvgTvCCE/YePzO/ZbyX3YCqE4pM4sMxPmxxqT4i+LPEWH1GvDyXjWI2P23F1mRZ6WdJgw9wRtwBXa8G/xfW3TUUDarukjjvCr6b0wnVc7mTyEKuao9KDb8eT2dPDPXaMp7/MWil95yNPr2nR/RA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789670525; c=relaxed/simple;
	bh=yDFlqFVHETTSJ01WDNH83Kx74WJ82wMNLktm15ojTdI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ST9plyqsf4il6t4ZkVekS2zBgy3lm/K7hVtrXr5vvPOCrar/fYFWyKUFti6SsHoCFiUNz9HEYyPkFPGw3HgwX/sG3TVXCD+6o7Ol1IziMsiHjAxWmP4CQC8ud5wjNREUc93YUP/kdC6zv/4sCRgyWTvyc1VsthDxfCsRmabOJZ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rqdpM32j; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rqdpM32j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 478B41F000FF;
	Thu, 17 Sep 2026 18:42:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789670523;
	bh=zjjMwWQ/s/dGObn5fyyCiELJNNpFcida2p090UK5bt4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rqdpM32jp6m3jPSgmwZz54hLEan8+3X1MEnJbkk0ION1aaijTlQsUb72jgBxIcyWe
	 nvoiNrQHyUv0EfyzgEKJcYJNBoKUlbvQUHMYqn7VFbfZkl36XvGVXM5nlSk9ujOqzm
	 zaxSi6Swg34dGX1if+hzQwfeg+ZL8wRu00nJoZLU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yael Chemla <ychemla@nvidia.com>,
	Dragos Tatulea <dtatulea@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0690/1102] net/mlx5: E-Switch: fix use-after-free in mlx5_eswitch_termtbl_put
Date: Thu, 17 Sep 2026 16:10:33 +0100
Message-ID: <20260917151557.595248728@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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



