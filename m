Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA3A04ED18D;
	Thu, 17 Sep 2026 17:23:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789665794; cv=none; b=fERhzi1UME9zdG0hGTqajRiG/r75KM5IDqMYZntlYhaelse/1iQPkrqINPH3LL1DIVAmObxTGIHeleukWODQH1UEmOkYmI/Fqzm+D+TsGNT4JJ9JsePjM3HB6SkXTV7EDBNW1rVABhZ1dQUCs4cND6SCa7ffl/PBktlxVn/zaKw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789665794; c=relaxed/simple;
	bh=325fHv0XpKTm9FdS302C3EhvQXjjyZ5MoTADTgY7R0c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QE8uGzP9TorxJ/WC6uS3+a9yM21sWgt6CxvYoXgZmjTE1qcggvzTxBwirMSLkSAUg4ATTvzDXE4kP+AUb//JZRntIeCZvg4LIvvivl6sVfFs66hG8rA1+7hWF8xaEn4ErtFBHDFYwNA/F/mnGi2CTsWMbgC52s1pHs+WsIzNpoE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Qt1E9SlS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Qt1E9SlS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFE4D1F000FF;
	Thu, 17 Sep 2026 17:23:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789665792;
	bh=CV1+bp5vOpwV64ofX9SkM1aOUqmIoIB7fckCIMcNJgw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Qt1E9SlSgiWBw3u6uBvQyTI9LNP9jhz4UQDXE+XJW2ZEP1sT3qFFgQe3I6x2/9KZ5
	 ceCMQdrSCuIWNepBkYCnNoB6TaJTAwx0TlOK++UsGjqfKll5YuNhzS7MYjXTXYyueY
	 qVxESbFXjxkQyPiwM1QNhDe2ZprTB8uuwXt+TAV0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Carolina Jubran <cjubran@nvidia.com>,
	Shahar Shitrit <shshitrit@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0815/1250] net/mlx5e: Fix use-after-free race in sample_restore_put()
Date: Thu, 17 Sep 2026 16:10:10 +0100
Message-ID: <20260917151614.019710600@linuxfoundation.org>
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
index 5db239cae8145..5ae13af900308 100644
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



