Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6E892E5B26;
	Tue,  8 Jul 2025 17:00:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751994059; cv=none; b=LL5TIwjxAezwhqRp4/zOixKQIeeuuwjS+yCHb6HzlgR8MmSeUTJ4ciltl/Kjbnp96X4tTNsegyOALrrb4idkDz0zwxBaHaxV9dhGQH6ZGUEA8W2pKQkup00+hMNhd2RyC6sBuzigX2YhHP6VUlcI3ZiGMW050VUKQikhSAlRrOM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751994059; c=relaxed/simple;
	bh=QnzYrFfXohLbjSWTnRoBjx+bwVWjTvEW4OQtNG0F2BM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=J201Okm8KmbA0Ni8wBmP7bpj3id9M0OjLuvkFGOBQ43QgrW/ifNxx2EP3s4bIdMNn0A0XAUBtf/K4vV/azL/8Yok3d/MIPQndOIW3EGA7uZE9mZgEdI83NzDcllxn9dl5qjmbJ7pc/XOIcPRLYkcUzIz8QdsVtoBVBSap75VCc4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=s/k96Ax1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="s/k96Ax1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1399CC4CEED;
	Tue,  8 Jul 2025 17:00:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751994059;
	bh=QnzYrFfXohLbjSWTnRoBjx+bwVWjTvEW4OQtNG0F2BM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=s/k96Ax1xDsJpbeFsMWYFHhaY9pFRET4bYr/UzfJ7XdmjycIzcvlifhngVmnE40OZ
	 oA4iAduyi1sQaw23kZcqAvF09LKd0ItrrjjmocA6xgq3beBl9hf4gV9T6lHsEI3HjC
	 P4aSeGXLeswAlmlGHsNBMYXrKYkxNAtiullMfK+8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Patrisious Haddad <phaddad@nvidia.com>,
	Michael Guralnik <michaelgur@nvidia.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 112/160] RDMA/mlx5: Fix CC counters query for MPV
Date: Tue,  8 Jul 2025 18:22:29 +0200
Message-ID: <20250708162234.576154849@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162231.503362020@linuxfoundation.org>
References: <20250708162231.503362020@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Patrisious Haddad <phaddad@nvidia.com>

[ Upstream commit acd245b1e33fc4b9d0f2e3372021d632f7ee0652 ]

In case, CC counters are querying for the second port use the correct
core device for the query instead of always using the master core device.

Fixes: aac4492ef23a ("IB/mlx5: Update counter implementation for dual port RoCE")
Signed-off-by: Patrisious Haddad <phaddad@nvidia.com>
Reviewed-by: Michael Guralnik <michaelgur@nvidia.com>
Link: https://patch.msgid.link/9cace74dcf106116118bebfa9146d40d4166c6b0.1750064969.git.leon@kernel.org
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/mlx5/counters.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/mlx5/counters.c b/drivers/infiniband/hw/mlx5/counters.c
index 870a089198116..79225f21a2837 100644
--- a/drivers/infiniband/hw/mlx5/counters.c
+++ b/drivers/infiniband/hw/mlx5/counters.c
@@ -279,7 +279,7 @@ static int mlx5_ib_get_hw_stats(struct ib_device *ibdev,
 			 */
 			goto done;
 		}
-		ret = mlx5_lag_query_cong_counters(dev->mdev,
+		ret = mlx5_lag_query_cong_counters(mdev,
 						   stats->value +
 						   cnts->num_q_counters,
 						   cnts->num_cong_counters,
-- 
2.39.5



