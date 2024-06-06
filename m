Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 588BB1B0104;
	Thu,  6 Jun 2024 14:15:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683355; cv=none; b=pscP/as+qmPl/OU02XvlQIIrMIgtJo4msZ/aqfUA8WLqitjpSksJSYuxZSH4s298XxuudA4rIiF/R8yqoTh+hUcSH0S0uwVOhBIhrtPklSisa0mXd8ZtPCD+VqeZ3EmLQXN7477m4HE4FFMjrtWtSrMTYoFHOXjN+sr7uofvm9g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683355; c=relaxed/simple;
	bh=zjYI4d2O2c9ntIgIiP/xhH4TJNTwF50UoG8MWs/TQG4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GYPSK1iPV1IqMm9rUqnGVvb/fUhepjkfAegz/0sfvcRVd9eQx8375NhxivwwO4o6EqDNfTfiHgvtILP3X9pN1FSWeVNCyIgBxKqbQ/+CR5+e2J0MA8KmMPvo+7dxHHCNYbuY54LGqoUFtUGnON3ZyUH6ImZaC+vhHvcQH0QfSsQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eCXJgH7Y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eCXJgH7Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37AD3C32781;
	Thu,  6 Jun 2024 14:15:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683355;
	bh=zjYI4d2O2c9ntIgIiP/xhH4TJNTwF50UoG8MWs/TQG4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eCXJgH7YEquNSPfW7NgxPQ6oisXjhTUAzWMwKZi4M9eGQ5A4JFbSJ+ZpzHQccyebn
	 x83ev2V6p/uA1ZHOeF93KBrTXQXetouBOOWCUCYJzqTqL99ugexzR8Vz1yW1uVWkl6
	 OfHcbLNCaEX2ZmkWQmWrFX1ua3HbZYaWzuAB9CYc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Or Har-Toov <ohartoov@nvidia.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 236/473] RDMA/mlx5: Adding remote atomic access flag to updatable flags
Date: Thu,  6 Jun 2024 16:02:45 +0200
Message-ID: <20240606131707.637726752@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131659.786180261@linuxfoundation.org>
References: <20240606131659.786180261@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Or Har-Toov <ohartoov@nvidia.com>

[ Upstream commit 2ca7e93bc963d9ec2f5c24d117176851454967af ]

Currently IB_ACCESS_REMOTE_ATOMIC is blocked from being updated via UMR
although in some cases it should be possible. These cases are checked in
mlx5r_umr_can_reconfig function.

Fixes: ef3642c4f54d ("RDMA/mlx5: Fix error unwinds for rereg_mr")
Signed-off-by: Or Har-Toov <ohartoov@nvidia.com>
Link: https://lore.kernel.org/r/24dac73e2fa48cb806f33a932d97f3e402a5ea2c.1712140377.git.leon@kernel.org
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/mlx5/mr.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/mlx5/mr.c b/drivers/infiniband/hw/mlx5/mr.c
index 410cc5fd25239..b81b03aa2a629 100644
--- a/drivers/infiniband/hw/mlx5/mr.c
+++ b/drivers/infiniband/hw/mlx5/mr.c
@@ -1349,7 +1349,8 @@ static bool can_use_umr_rereg_access(struct mlx5_ib_dev *dev,
 	unsigned int diffs = current_access_flags ^ target_access_flags;
 
 	if (diffs & ~(IB_ACCESS_LOCAL_WRITE | IB_ACCESS_REMOTE_WRITE |
-		      IB_ACCESS_REMOTE_READ | IB_ACCESS_RELAXED_ORDERING))
+		      IB_ACCESS_REMOTE_READ | IB_ACCESS_RELAXED_ORDERING |
+		      IB_ACCESS_REMOTE_ATOMIC))
 		return false;
 	return mlx5r_umr_can_reconfig(dev, current_access_flags,
 				      target_access_flags);
-- 
2.43.0



