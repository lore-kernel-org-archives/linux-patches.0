Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FACD5187D3;
	Thu, 17 Sep 2026 17:23:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789665827; cv=none; b=YfDqEj43ujq4s1WpQzUKDgA4lMKaA0kW3s5Yb/xGjEWKJSBOSJPRlsE0FiWpMvnn/bAqQ5y8Nhb0IffHE0ZUSGlNn1YQpdkR+7JKYk8JrhIxVfU+lkBzBtAg11IJQU2TiUIHvMnjp7ILFB0v9eMYUVs5Uqr1htE7+f56Shz/Mqs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789665827; c=relaxed/simple;
	bh=Y513Qe5DwyTd1S1Uy1LloFaJtk7XikYtOWpLsqeOAf0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nZE8+JdpaEEj1KyHansGt/XbhPUBdxsPQ7+4z9spbb8engjg0tr9eRQniWXrmUcYakNgw4d6BTBvZIEVGZko9ch3bFq8ZMpWDsSJ70H4yPM+YWRCoz5BBizp9LxsUEnipaSccSHyivy2HONzlp990biA29yMcz8jUZt5P5t5owU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BnoBbCit; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BnoBbCit"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35A2B1F00893;
	Thu, 17 Sep 2026 17:23:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789665825;
	bh=J+kA+u0RcWwnZyuHtkbDK+BxaX6iBHs3/vsDWaRkiy8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BnoBbCitY8plMcfoXOq8baSMiPo1OAaRCaM4GmS3Sj2yF4vCyB6HYkfQp3bEi0rtU
	 ef8H25DBtQR6xiwF8CzFANui+wS+A/q6xiim9RXvTsKm4g5+xkA25QY9FBPItQMpYe
	 cUCAwtuCstGq2ITQgJqkJ62N3fh8NDynBNJMItOc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yael Chemla <ychemla@nvidia.com>,
	Dragos Tatulea <dtatulea@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0816/1250] net/mlx5: E-Switch: fix use-after-free in mlx5_eswitch_termtbl_put
Date: Thu, 17 Sep 2026 16:10:11 +0100
Message-ID: <20260917151614.047437660@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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



