Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9D3518D65C;
	Mon, 28 Oct 2024 06:37:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730097476; cv=none; b=lU8dDbXR/zqlOudEFSejftkIjjBJl8c5SorHLZpP48i1Tf62KZ0675586OG52vjut9yDFQUMqdPgZvzcF0lLeAA0wUch8DxE2MB58M3Ja1M3V7tG3lDz5ErzSFk/Jd6WD9nTxPPCwo00bMYPaQre3MXSPOC46nRuqVr5TtgtB6U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730097476; c=relaxed/simple;
	bh=66zaUuoWfwlq1sS8vRtUuZdrpciw0pxp4HIA2TCC90c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=swKluWZrGAG6Y9jpHnl9YgTp4GFZyrb0+L6Bbwe7SKhvLbXFHnOtVCKLJzMZMLmVq/XN65dyLip5mBWqY02i3M23zWIX1ANBbRhWeHR6wPkVRxSvuWfFZZ04DVSefF9M9l8YL5Sv86+kQ36ZnuSWuv5KV30y3zEN/bsHh+c/25Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YPFAABQX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YPFAABQX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19C24C4CEC3;
	Mon, 28 Oct 2024 06:37:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730097476;
	bh=66zaUuoWfwlq1sS8vRtUuZdrpciw0pxp4HIA2TCC90c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YPFAABQX2Ooz4qTmcq1cPYwBdEAzbO5K1LRnPDw9bQH1DnAIBuXQ6NxoTtSOSWBYE
	 v7cWFzzDjRBgIeH++n5QNvLr8Iq75XSwaDgz4L2vOTNN6L3vD2py3B7ZbqzFyZ+yqI
	 ya0/eBYK4rXImpC3VdDr/poORM/pCw0rKGUSfZCk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anumula Murali Mohan Reddy <anumula@chelsio.com>,
	Potnuri Bharat Teja <bharat@chelsio.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 010/208] RDMA/core: Fix ENODEV error for iWARP test over vlan
Date: Mon, 28 Oct 2024 07:23:10 +0100
Message-ID: <20241028062306.911286655@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241028062306.649733554@linuxfoundation.org>
References: <20241028062306.649733554@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index f253295795f0a..fd78d678877c4 100644
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



