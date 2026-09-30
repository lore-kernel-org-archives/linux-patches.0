Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7E14A59;
	Wed, 30 Sep 2026 18:04:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790791473; cv=none; b=pQsHdlw1cv6DzWm7YvvrcFTvPtU7seqRTgJh7QDX1R/PGJF1BDwhDAnNWkTHoGSjpApAivqJeOsju9LQl7fzAa76anV0EsuuDm3v/lGquBgs+xlvkx+eUevwA2D+pjn0wqh1Uqe+7THdkR7bel+956FvM/3JlRBjWqted3jNLKU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790791473; c=relaxed/simple;
	bh=JqabhD0xGmdLL41pD9VLvgvcB7Z1JrtsZiimLKuwQRw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UYpKWtP49XcWb974RVj1eenyOhZsaOf7JB1eOWaTyV4aVkX3++RqSVRMlhWx0fEy5FGOn6lpDnV1ZKAOm1bORT3ZriF6hH4yfwA//o+c1tKKNR8/bHIDFSkHLadVe8EBgNBjmSp6jDeCz6eTOT8/GDAYPlg6rZFTnqQmpoAhO4s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=N3PB17Ov; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="N3PB17Ov"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 092CF1F000FF;
	Wed, 30 Sep 2026 18:04:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790791471;
	bh=BNxUFIUScdhVOCmgVRCdTkQmenRWq/B4ymFrWB1I460=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=N3PB17OvLyOe/mIrjTKPcH7x7nnPmRv9F2fH/TxmYHEBNEQAa79woofTaezNc5XXg
	 A9THhmBV0FYWMvlVBfMzjMV+VTgmjDcTmUcnwN7tKs8sLcDcpcdYmKEwNF7q+SyN7b
	 186AsuxyBHJQElSmY9SquLLVeqzgQVlQPhIkfwj4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Carolina Jubran <cjubran@nvidia.com>,
	Shahar Shitrit <shshitrit@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 312/752] net/mlx5e: Fix use-after-free race in sample_restore_put()
Date: Wed, 30 Sep 2026 17:23:02 +0200
Message-ID: <20260930152405.048063606@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152358.131179731@linuxfoundation.org>
References: <20260930152358.131179731@linuxfoundation.org>
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
index d08723a444e3f..74d97e60c0115 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/sample.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/sample.c
@@ -335,12 +335,15 @@ sample_restore_get(struct mlx5e_tc_psample *tc_psample, u32 obj_id,
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



