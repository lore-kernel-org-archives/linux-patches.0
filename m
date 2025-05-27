Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0AA1194A45;
	Tue, 27 May 2025 16:50:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748364639; cv=none; b=GA82X9yuiVGAHxook/dIucKcScs//V0cXd2HTLwE5BdfZ36bjKzuZqaNVIYk5BCu14IgoTAHhorJF53TiTCcj8C2qXWzdEaRx9paWRz4vabHIO6X3e1+EFRcKIJB0dFErA1BJWzPk5sBenhQCIOd4qUzrFNV1gdJtwPNPp6jVOM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748364639; c=relaxed/simple;
	bh=nGO36/wmuX3NuHUX9J6kH0Vj47N4sGr+poPp5nF4udA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QJvTNyFq0IqGor+lQ7Had3L2lx/oePJ9r6tBUk/xVVj6jGVTvRWggu6u6JkQgnLCFQt5zU8W+dxUsb9iyqcu+EQFOKS86pcw7s7/L++uZAURbN5wHT6la+R3MkICwsEqdmq1zYClCDvumbUoxdR0nxjiKlpWtq/l/kXDOM2Ho+s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VPJ765o6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VPJ765o6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52533C4CEE9;
	Tue, 27 May 2025 16:50:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748364638;
	bh=nGO36/wmuX3NuHUX9J6kH0Vj47N4sGr+poPp5nF4udA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VPJ765o65G1HUg9726xO37Og+3fl0/PxIXya7aqNWX+eP9xztkds4V3uXOvelhZU5
	 UBlNUO9g4M9atiJuTX2/LgD0IT12XemcP1bhTxaAi1c46bP2RDgLM7SWQ+xfRrxdnM
	 zm5I5Cz+4eMFJwMSz2wAV5BQeuw4PsEGH5K01bYU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wen Tao <wentao@uniontech.com>,
	Chen Linxuan <chenlinxuan@uniontech.com>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
	Tejun Heo <tj@kernel.org>,
	Yu Kuai <yukuai3@huawei.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 120/626] blk-cgroup: improve policy registration error handling
Date: Tue, 27 May 2025 18:20:13 +0200
Message-ID: <20250527162449.906831419@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162445.028718347@linuxfoundation.org>
References: <20250527162445.028718347@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chen Linxuan <chenlinxuan@uniontech.com>

[ Upstream commit e1a0202c6bfda24002a3ae2115154fa90104c649 ]

This patch improve the returned error code of blkcg_policy_register().

1. Move the validation check for cpd/pd_alloc_fn and cpd/pd_free_fn
   function pairs to the start of blkcg_policy_register(). This ensures
   we immediately return -EINVAL if the function pairs are not correctly
   provided, rather than returning -ENOSPC after locking and unlocking
   mutexes unnecessarily.

   Those locks should not contention any problems, as error of policy
   registration is a super cold path.

2. Return -ENOMEM when cpd_alloc_fn() failed.

Co-authored-by: Wen Tao <wentao@uniontech.com>
Signed-off-by: Wen Tao <wentao@uniontech.com>
Signed-off-by: Chen Linxuan <chenlinxuan@uniontech.com>
Reviewed-by: Michal Koutný <mkoutny@suse.com>
Acked-by: Tejun Heo <tj@kernel.org>
Reviewed-by: Yu Kuai <yukuai3@huawei.com>
Link: https://lore.kernel.org/r/3E333A73B6B6DFC0+20250317022924.150907-1-chenlinxuan@uniontech.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-cgroup.c | 22 ++++++++++++----------
 1 file changed, 12 insertions(+), 10 deletions(-)

diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index f1cf7f2909f3a..643d6bf66522e 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -1725,27 +1725,27 @@ int blkcg_policy_register(struct blkcg_policy *pol)
 	struct blkcg *blkcg;
 	int i, ret;
 
+	/*
+	 * Make sure cpd/pd_alloc_fn and cpd/pd_free_fn in pairs, and policy
+	 * without pd_alloc_fn/pd_free_fn can't be activated.
+	 */
+	if ((!pol->cpd_alloc_fn ^ !pol->cpd_free_fn) ||
+	    (!pol->pd_alloc_fn ^ !pol->pd_free_fn))
+		return -EINVAL;
+
 	mutex_lock(&blkcg_pol_register_mutex);
 	mutex_lock(&blkcg_pol_mutex);
 
 	/* find an empty slot */
-	ret = -ENOSPC;
 	for (i = 0; i < BLKCG_MAX_POLS; i++)
 		if (!blkcg_policy[i])
 			break;
 	if (i >= BLKCG_MAX_POLS) {
 		pr_warn("blkcg_policy_register: BLKCG_MAX_POLS too small\n");
+		ret = -ENOSPC;
 		goto err_unlock;
 	}
 
-	/*
-	 * Make sure cpd/pd_alloc_fn and cpd/pd_free_fn in pairs, and policy
-	 * without pd_alloc_fn/pd_free_fn can't be activated.
-	 */
-	if ((!pol->cpd_alloc_fn ^ !pol->cpd_free_fn) ||
-	    (!pol->pd_alloc_fn ^ !pol->pd_free_fn))
-		goto err_unlock;
-
 	/* register @pol */
 	pol->plid = i;
 	blkcg_policy[pol->plid] = pol;
@@ -1756,8 +1756,10 @@ int blkcg_policy_register(struct blkcg_policy *pol)
 			struct blkcg_policy_data *cpd;
 
 			cpd = pol->cpd_alloc_fn(GFP_KERNEL);
-			if (!cpd)
+			if (!cpd) {
+				ret = -ENOMEM;
 				goto err_free_cpds;
+			}
 
 			blkcg->cpd[pol->plid] = cpd;
 			cpd->blkcg = blkcg;
-- 
2.39.5



