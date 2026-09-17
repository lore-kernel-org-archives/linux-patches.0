Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D93A59B68B;
	Thu, 17 Sep 2026 15:39:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789659579; cv=none; b=pKOXsxoErTw/+IH13tZ6y6mu0fnICaVt41UeXKiuoMg1XKr3eUizEMeBhUdw7NunFYGQtlJ4sPRw2AlI8IwWUFj+w7VrfbIzcAy6hC7Gfqq1CS13mI/h0tjAqMxTYiSaHlVi6JsCXCqBRVJbQVozET0wqiBsuzbewIilNOkLTiM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789659579; c=relaxed/simple;
	bh=0Ua6By/19LxeHUWA8to7cDUlgnXtJUDWxoNXnjZkEn8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pUrtajiJlV4UW5ReP/nz223TcZwmG2AfXvWx9atXxIDvryoMFY1PUbOaaqip8HfJn+ATIepkTHjjV21rIs4uE2vZLXL8vchUKzcRMuDKtEkr9vUVObZke0qIZBrHRIkbTA6x9/oVV4Jp/LVendqj62u96nDuBQxDIi9nd+xJVBU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SfiW9hLi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SfiW9hLi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E4EE1F00893;
	Thu, 17 Sep 2026 15:39:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789659568;
	bh=5fnqt6LIR98LNvGi75BmhnyKz8MNfSnhIJ91fVrHYiM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SfiW9hLiLu2qW2kywNVQVkMtHEmUwEuDjPOnuF5IZVQkqtmVZV47/gblsalIK8w/T
	 JIutrx+A9JcrsxPLNUlmyBuGsZciuxzgME8SMbPAdyiEobM20HwzW4TE36cC4VQunL
	 qwOQ4/KNfs/++jjjIkP3pXM2Dg3T+7KtKk0dQhL0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Carolina Jubran <cjubran@nvidia.com>,
	Shahar Shitrit <shshitrit@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 301/733] net/mlx5e: Fix use-after-free race in sample_restore_put()
Date: Thu, 17 Sep 2026 16:10:09 +0100
Message-ID: <20260917151358.938889490@linuxfoundation.org>
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

From: Carolina Jubran <cjubran@nvidia.com>

[ Upstream commit af3aef0245abbab5e9f6302e7a7d6407187afb71 ]

Concurrent teardown of TC sample rules sharing the same restore
context may re-read restore->count after dropping restore_lock.
At that point another thread may already have completed cleanup and
freed the restore object.

Use the result of the refcount decrement while holding restore_lock to
determine whether cleanup is needed.

Fixes: 36a3196256bf ("net/mlx5e: TC, Add sampler restore handle API")
Signed-off-by: Carolina Jubran <cjubran@nvidia.com>
Reviewed-by: Shahar Shitrit <shshitrit@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Link: https://patch.msgid.link/20260902193341.3668809-1-tariqt@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/tc/sample.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/sample.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/sample.c
index 89490f687a9c6..93c62d3f3e5bd 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/sample.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/sample.c
@@ -311,12 +311,15 @@ sample_restore_get(struct mlx5e_tc_psample *tc_psample, u32 obj_id,
 static void
 sample_restore_put(struct mlx5e_tc_psample *tc_psample, struct mlx5e_sample_restore *restore)
 {
+	bool last;
+
 	mutex_lock(&tc_psample->restore_lock);
-	if (--restore->count == 0)
+	last = --restore->count == 0;
+	if (last)
 		hash_del(&restore->hlist);
 	mutex_unlock(&tc_psample->restore_lock);
 
-	if (!restore->count) {
+	if (last) {
 		mlx5_del_flow_rules(restore->rule);
 		mlx5_modify_header_dealloc(tc_psample->esw->dev, restore->modify_hdr);
 		kfree(restore);
-- 
2.53.0



