Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64F6114BFBC;
	Tue, 23 Apr 2024 21:46:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713908800; cv=none; b=UGELLvnPg7fa/ImdVA2lnV1kOgEoJQyyddGsaNAxKS6tPZRgpu1cD5/J/giQ1mb5+p4yafB/di/4QWqCwgd1KGXNe7qO0IRZtXUfQeS9e24fp66T/v2lD+w61nkHV7za9vOu9d9whEn991fH/Voj5L2PyAXBQgRpnK95Ho7ingk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713908800; c=relaxed/simple;
	bh=7ArVNRRYMLum4jR27jHznaQgeDFdZVp8pCS219VQanc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eVdRA9lZV4BMFDJs7LmZRJR9lcGPLLBD7v4FBW4ftysBaprjFcWQCSr7M8s/ZpDEX1QkeCYwFathcCdF6svkjqt4ahrl3REWNy8KwFwqFe1gwU/SMy9av4RxAxFWspnLD4HWY9FEjWRy7Ql0qyZXBiSNa8EijgZESvD0Pt0HDzk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nQSDNLMY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nQSDNLMY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3147AC3277B;
	Tue, 23 Apr 2024 21:46:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713908800;
	bh=7ArVNRRYMLum4jR27jHznaQgeDFdZVp8pCS219VQanc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nQSDNLMYQkg/whJXhIozv3AU2HARXwx4IiiahPp9Go59wBVp4D9Ap/SxL1qILcwHF
	 zefKxsc+nP/5oO9ihQIiHKrPIS60zVYGkBidM2Zidv9vHaXBwZ3HQfq2/+vt0sK9AY
	 vDtfqV1bTyPKXlKdCt/9Hg/XBaBi3h8W8VzakhQ4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Guralnik <michaelgur@nvidia.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 29/71] RDMA/mlx5: Fix port number for counter query in multi-port configuration
Date: Tue, 23 Apr 2024 14:39:42 -0700
Message-ID: <20240423213845.150640751@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240423213844.122920086@linuxfoundation.org>
References: <20240423213844.122920086@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Guralnik <michaelgur@nvidia.com>

[ Upstream commit be121ffb384f53e966ee7299ffccc6eeb61bc73d ]

Set the correct port when querying PPCNT in multi-port configuration.
Distinguish between cases where switchdev mode was enabled to multi-port
configuration and don't overwrite the queried port to 1 in multi-port
case.

Fixes: 74b30b3ad5ce ("RDMA/mlx5: Set local port to one when accessing counters")
Signed-off-by: Michael Guralnik <michaelgur@nvidia.com>
Link: https://lore.kernel.org/r/9bfcc8ade958b760a51408c3ad654a01b11f7d76.1712134988.git.leon@kernel.org
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/mlx5/mad.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/mlx5/mad.c b/drivers/infiniband/hw/mlx5/mad.c
index f6f2df855c2ed..1082841807759 100644
--- a/drivers/infiniband/hw/mlx5/mad.c
+++ b/drivers/infiniband/hw/mlx5/mad.c
@@ -166,7 +166,8 @@ static int process_pma_cmd(struct mlx5_ib_dev *dev, u32 port_num,
 		mdev = dev->mdev;
 		mdev_port_num = 1;
 	}
-	if (MLX5_CAP_GEN(dev->mdev, num_ports) == 1) {
+	if (MLX5_CAP_GEN(dev->mdev, num_ports) == 1 &&
+	    !mlx5_core_mp_enabled(mdev)) {
 		/* set local port to one for Function-Per-Port HCA. */
 		mdev = dev->mdev;
 		mdev_port_num = 1;
-- 
2.43.0



