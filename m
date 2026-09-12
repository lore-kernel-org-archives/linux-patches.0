Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22058390239;
	Sat, 12 Sep 2026 19:53:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789242809; cv=none; b=Z0TT+sE6cwteFmeHBiT/geukY4hfAtICj3n4yx9IMUbL80c5b8efTRQU5a9Q3yqyEu7BugHwENvSY4Uiyh1CquyyqFWc7lSykVZLZ0Yjk9CVzIidOJl8645fjsuCkzHoTavM2Ou+5mfzQ6BSV0fsuzZR53VA3los1fRsxG2s5U0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789242809; c=relaxed/simple;
	bh=+cCCybdTl/1wNf6uRYSKrqnHlVpJOHFBIng8kEePktM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HYPsHmizRX/1p9f3s2n8Jl5K7ZtEAiUtW0Tcot+ejERHoNMsS7hq9euiRpdJjrVUWv5YqiJK6zseLvZUCxC1hQFBZRBhyYDDuF1AwyBKAYYZIyE7v7VLz3hhgYZ10hDaw4cHmTPAVXShwZ9deDj+/Cs5sVmsEzn0cun6mtNThzQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uwF5KIRQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uwF5KIRQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E1191F000FF;
	Sat, 12 Sep 2026 19:53:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789242808;
	bh=n1FCiVQWeiV3rwqWO73aOHLL6ngu/vp7WimBaKNmK2E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uwF5KIRQq9qMkXr6jjKLeo38vz6aJNK/c6SttL0+cWE9VRr3aZwd3Agp7J8ZK7qVi
	 uLCER9YcL80wqHcRP+FqxpHCWA+ImgEpHBUVBT9rLntpruD1xt4tOSXfpaPZddZTA1
	 b335uISxMPLLQf3gzsP6VTJAOiFh1249r4rH9RwY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Leon Romanovsky <leonro@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 535/798] RDMA/mlx5: Send cong param changes to the resolved port mdev
Date: Sat, 12 Sep 2026 09:02:43 +0200
Message-ID: <20260912065529.391027658@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Leon Romanovsky <leonro@nvidia.com>

[ Upstream commit 033a79e308e4fe832b0924347eda8c4364055174 ]

mlx5_ib_set_cc_params() resolves the port-specific mlx5_core_dev via
mlx5_ib_get_native_port_mdev() but issued MLX5_CMD_OP_MODIFY_CONG_PARAMS
through dev->mdev. On an affiliated secondary RoCE port those pointers
refer to different devices, so a write to the secondary port's cc_params
debugfs file either altered the master port or failed with a master-side
command error, while the read path already used the resolved mdev and
returned the unchanged secondary value.

Issue the command to the resolved mdev, the same device whose capabilities
were checked when its debugfs directory was created. It is already
referenced by the get/put pair, so its lifetime is safe.

Fixes: 31578defe4eb ("RDMA/mlx5: Update mlx5_ib to use new cmd interface")
Link: https://patch.msgid.link/20260726-mlx5-ib-set-cc-params-applies-conges-v1-1-a253edafe1f3@nvidia.com
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/mlx5/cong.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/mlx5/cong.c b/drivers/infiniband/hw/mlx5/cong.c
index 30cbf20ee7286..6d667ae35ee98 100644
--- a/drivers/infiniband/hw/mlx5/cong.c
+++ b/drivers/infiniband/hw/mlx5/cong.c
@@ -339,7 +339,7 @@ static int mlx5_ib_set_cc_params(struct mlx5_ib_dev *dev, u8 port_num,
 	MLX5_SET(field_select_r_roce_rp, field, field_select_r_roce_rp,
 		 attr_mask);
 
-	err = mlx5_cmd_exec_in(dev->mdev, modify_cong_params, in);
+	err = mlx5_cmd_exec_in(mdev, modify_cong_params, in);
 	kvfree(in);
 alloc_err:
 	mlx5_ib_put_native_port_mdev(dev, port_num + 1);
-- 
2.53.0



