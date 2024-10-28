Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31BF31DFFD;
	Mon, 28 Oct 2024 06:45:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730097956; cv=none; b=NGkRCIWJVSTBbKJ/A5W0pRIpMM7VhgN9h3ljvGHshVLJQjAjlPEvhcxn4VhjrSsO5eQHRHa8uqPEa36IXX5zjccDCLksgnM2767yELoH915UOlrv4rQD/G9Rl1/U+0YFYfPoDQd8cfKcBBLgjyJOGQLlRQUDvR1Q5C14+YfleKw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730097956; c=relaxed/simple;
	bh=wjqIRVQ9UVNj2ONUiBJz63mq1fX88HTk/nr7hUD1HAU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WEdNSE6cn6/b4WismnopokDhVHERrO2Jw82teEkLhq+jD+LdZECfS2XJgM/SQ+KO+qMW4nc8xt2oW0AwFoXK+nTrZQhrRjSM1isU43InC+XmkMBVTmF0powYZvaqZtzwy1dGPR04y6yTeqcebb0q7TOeMD2ZlgCT682aD4F+EYU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=X6tp2QFq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="X6tp2QFq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6CF8C4CEC3;
	Mon, 28 Oct 2024 06:45:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730097956;
	bh=wjqIRVQ9UVNj2ONUiBJz63mq1fX88HTk/nr7hUD1HAU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=X6tp2QFqUDhr1p6LB900J5T+PiaHqRhp7CNfUEOu2Xc38lwyYtgUg6AEu8LbqLI2n
	 Tj2efMx1AtamTY2co28nNtE719dvPBMvmHMHwvwkGiG+6OGEZ/Fnc+1/X8R7iqeFL/
	 4mPwOmpD2rtl6esyqTDZp9Wq/rkHZnWTCjXfUoJ0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anumula Murali Mohan Reddy <anumula@chelsio.com>,
	Potnuri Bharat Teja <bharat@chelsio.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 014/261] RDMA/core: Fix ENODEV error for iWARP test over vlan
Date: Mon, 28 Oct 2024 07:22:36 +0100
Message-ID: <20241028062312.367254508@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241028062312.001273460@linuxfoundation.org>
References: <20241028062312.001273460@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Anumula Murali Mohan Reddy <anumula@chelsio.com>

[ Upstream commit 5069d7e202f640a36cf213a432296c85113a52f7 ]

If traffic is over vlan, cma_validate_port() fails to match vlan
net_device ifindex with bound_if_index and results in ENODEV error.
It is because rdma_copy_src_l2_addr() always assigns bound_if_index with
real net_device ifindex.
This patch fixes the issue by assigning bound_if_index with vlan
net_device index if traffic is over vlan.

Fixes: f8ef1be816bf ("RDMA/cma: Avoid GID lookups on iWARP devices")
Signed-off-by: Anumula Murali Mohan Reddy <anumula@chelsio.com>
Signed-off-by: Potnuri Bharat Teja <bharat@chelsio.com>
Link: https://patch.msgid.link/20241008114334.146702-1-anumula@chelsio.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/core/addr.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/infiniband/core/addr.c b/drivers/infiniband/core/addr.c
index be0743dac3fff..c4cf26f1d1496 100644
--- a/drivers/infiniband/core/addr.c
+++ b/drivers/infiniband/core/addr.c
@@ -269,6 +269,8 @@ rdma_find_ndev_for_src_ip_rcu(struct net *net, const struct sockaddr *src_in)
 		break;
 #endif
 	}
+	if (!ret && dev && is_vlan_dev(dev))
+		dev = vlan_dev_real_dev(dev);
 	return ret ? ERR_PTR(ret) : dev;
 }
 
-- 
2.43.0



