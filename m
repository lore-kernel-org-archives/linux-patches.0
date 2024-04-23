Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1097147C77;
	Tue, 23 Apr 2024 21:45:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713908717; cv=none; b=jqXsgxAmnNY1pT27d0YC2SoVuJFwoH22X8KR00Pvonqd+9Fyj0v+ONI9DCMnhdfa2udFZgfT+xhEQyJYqy9CQ3uASDnBqGGpM4bapkpLqAwjYV6yFf1o5qxFWp+sVu15wyE3Ikse1IA6scDiJgX5VxDD/ZfM4OvnE0cTYDJ0/5o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713908717; c=relaxed/simple;
	bh=ZR7ZMCxVic7/I3Z+BjPCFOwKalfYvzuE8jWYJ7ONmAU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NATLsE+7vMWk2xLKdsiE20NAqJiGq3j0RQPy07YYpk5X9AmsZmHxMxn3N2iskqR8oRWIHXeLJL9e01GRMWMhjE2hpBA8OSvvWhmF1HLAoTXxFHOUJusgHeaCW9nuLk+PC3+Rx/5djp6ah2VDuxOGjkyOUGPsU+35ORI8MwVF/Yc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=w4KEA/R/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="w4KEA/R/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8679CC3277B;
	Tue, 23 Apr 2024 21:45:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713908717;
	bh=ZR7ZMCxVic7/I3Z+BjPCFOwKalfYvzuE8jWYJ7ONmAU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=w4KEA/R/nN9okw5zzlyuiGNK5WJ85fhFETkcLqh3/t3OLXuAmR48Pk2ChdfJi86se
	 aTaXJL9mPabUOlvwO6Pj6QNhnJ0rYxSSDHZut+z92jybA8kU6XhYz20zOvH/DMo/eD
	 Dao0fUJeJ2laMJ16FZ8F0UqJU0KAdsij2WldUhQQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Guralnik <michaelgur@nvidia.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 050/141] RDMA/mlx5: Fix port number for counter query in multi-port configuration
Date: Tue, 23 Apr 2024 14:38:38 -0700
Message-ID: <20240423213854.884086239@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240423213853.356988651@linuxfoundation.org>
References: <20240423213853.356988651@linuxfoundation.org>
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
index 9c8a7b206dcf4..e61efed320f11 100644
--- a/drivers/infiniband/hw/mlx5/mad.c
+++ b/drivers/infiniband/hw/mlx5/mad.c
@@ -188,7 +188,8 @@ static int process_pma_cmd(struct mlx5_ib_dev *dev, u32 port_num,
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



