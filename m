Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07AA544C7C;
	Mon,  6 Jan 2025 15:36:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736177766; cv=none; b=sd+TPOcSpw6ZHRFGh0O9zq6XxgWhkZMaQCs7HcFgdt04j/A4E46yFdaKouUT12ExBDa7FRe+NCIyuPik/JyLtT29BTgN1e0ZuFFjw2MQ/SIjW+x31CwqEGVmQ2mFBq8Pd5cITHkRbNY6E9kvEe+qpBE/sb+uVHxv4FHU3XjNEU4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736177766; c=relaxed/simple;
	bh=hKBBfiaqH0JOLEBiNzUNJ6z5Ju7xPeC/RBKg0wm8ljg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ctV+lel78GNUP3MzLs0nxUi+kejRkxJAFCCE4RmgRbE8unrQBGcarpR4nYSeCdkWj8VEf0xt81QOZVPXIXL5Y9Lddyfm/KEkzT4qchqCeS6iLEQzJzw0Rxx3zhn2gBnIHdY7P9J/dOf34/mDqPDuazS7zP+++PjSqy1KAiGxLZI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Cw3mHqtU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Cw3mHqtU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7ED32C4CED2;
	Mon,  6 Jan 2025 15:36:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736177765;
	bh=hKBBfiaqH0JOLEBiNzUNJ6z5Ju7xPeC/RBKg0wm8ljg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Cw3mHqtUHMfSObAB3PHp+mnk6jXoHwHwNI0TAFSY3Fc6++CAYjfSwHXXVwtfdovkV
	 ziHZdA9hIWq4kS7pONmsCeZiDlZGVDxC69NzItUvYHdcd09EpMTqh7mSDm872zivBH
	 MQu5/x1TgKpoGSHIUqBPC23qgPXGhHxeo5DJr7yE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anumula Murali Mohan Reddy <anumula@chelsio.com>,
	Potnuri Bharat Teja <bharat@chelsio.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 018/156] RDMA/core: Fix ENODEV error for iWARP test over vlan
Date: Mon,  6 Jan 2025 16:15:04 +0100
Message-ID: <20250106151142.428616813@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151141.738050441@linuxfoundation.org>
References: <20250106151141.738050441@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Anumula Murali Mohan Reddy <anumula@chelsio.com>

[ Upstream commit a4048c83fd87c65657a4acb17d639092d4b6133d ]

If traffic is over vlan, cma_validate_port() fails to match
net_device ifindex with bound_if_index and results in ENODEV error.
As iWARP gid table is static, it contains entry corresponding  to
only one net device which is either real netdev or vlan netdev for
cases like  siw attached to a vlan interface.
This patch fixes the issue by assigning bound_if_index with net
device index, if real net device obtained from bound if index matches
with net device retrieved from gid table

Fixes: f8ef1be816bf ("RDMA/cma: Avoid GID lookups on iWARP devices")
Link: https://lore.kernel.org/all/ZzNgdrjo1kSCGbRz@chelsio.com/
Signed-off-by: Anumula Murali Mohan Reddy <anumula@chelsio.com>
Signed-off-by: Potnuri Bharat Teja <bharat@chelsio.com>
Link: https://patch.msgid.link/20241203140052.3985-1-anumula@chelsio.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/core/cma.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/cma.c
index 64ace0b968f0..91db10515d74 100644
--- a/drivers/infiniband/core/cma.c
+++ b/drivers/infiniband/core/cma.c
@@ -690,6 +690,7 @@ cma_validate_port(struct ib_device *device, u32 port,
 	int bound_if_index = dev_addr->bound_dev_if;
 	int dev_type = dev_addr->dev_type;
 	struct net_device *ndev = NULL;
+	struct net_device *pdev = NULL;
 
 	if (!rdma_dev_access_netns(device, id_priv->id.route.addr.dev_addr.net))
 		goto out;
@@ -714,6 +715,21 @@ cma_validate_port(struct ib_device *device, u32 port,
 
 		rcu_read_lock();
 		ndev = rcu_dereference(sgid_attr->ndev);
+		if (ndev->ifindex != bound_if_index) {
+			pdev = dev_get_by_index_rcu(dev_addr->net, bound_if_index);
+			if (pdev) {
+				if (is_vlan_dev(pdev)) {
+					pdev = vlan_dev_real_dev(pdev);
+					if (ndev->ifindex == pdev->ifindex)
+						bound_if_index = pdev->ifindex;
+				}
+				if (is_vlan_dev(ndev)) {
+					pdev = vlan_dev_real_dev(ndev);
+					if (bound_if_index == pdev->ifindex)
+						bound_if_index = ndev->ifindex;
+				}
+			}
+		}
 		if (!net_eq(dev_net(ndev), dev_addr->net) ||
 		    ndev->ifindex != bound_if_index) {
 			rdma_put_gid_attr(sgid_attr);
-- 
2.39.5



