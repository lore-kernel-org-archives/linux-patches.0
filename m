Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D86A302CD6;
	Tue, 30 Sep 2025 15:18:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759245522; cv=none; b=LwJpMQXKGQLKkEHUcrLds0qCGIHU5VEdGmu/VB0wXE1qQjtInudair+q3D2Fx3aRK8q8tv/lue/LKnLHQnnNFBAkv6pQeP1RVtdtHfX2dKCf1u/ZobamQUzH0Kz3MRxhmyFZ6aoAgZaEdiVfdaPX6ydTcgaKRP/RigFr8aSBriw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759245522; c=relaxed/simple;
	bh=dFxI714c8OfyzaheSIYKqVVpTqQWnPPV/kO9rlKb1Mc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NGJDxU2vghpziMw1TflDPkJyHphtMtDyjvn8WBeICZgNfFoNVk/ZeubVNaHCcfv7RIS6uDSdHzJw9ixY16vdADhaL+WMc1uYIgXn/qZ5q+r46drdyhigN8A13HywsjLTzTgUIxzoJSZhSjEjJDalrnauwuvUDHBcnkt2HgBAvVo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BZJzhl6+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BZJzhl6+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A907C4CEF0;
	Tue, 30 Sep 2025 15:18:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759245521;
	bh=dFxI714c8OfyzaheSIYKqVVpTqQWnPPV/kO9rlKb1Mc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BZJzhl6+3BmUwVZo2B7jSMKxDJZLFeL5TeovTunEmo7dOToolmULDORj2AFAnMXf5
	 0jnMt2P8k0F7RhUnku2/775IBChAFoCpmNdBGLE0uU+pOqUYZSIWuJdJTPrCHchTfk
	 o932HgSSTsJL7tmGUU33QOCX6BT5M8SlsNUFmJ04=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Vadim Fedorenko <vadim.fedorenko@linux.dev>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 43/73] octeontx2-pf: Fix potential use after free in otx2_tc_add_flow()
Date: Tue, 30 Sep 2025 16:47:47 +0200
Message-ID: <20250930143822.388422447@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250930143820.537407601@linuxfoundation.org>
References: <20250930143820.537407601@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@linaro.org>

[ Upstream commit d9c70e93ec5988ab07ad2a92d9f9d12867f02c56 ]

This code calls kfree_rcu(new_node, rcu) and then dereferences "new_node"
and then dereferences it on the next line.  Two lines later, we take
a mutex so I don't think this is an RCU safe region.  Re-order it to do
the dereferences before queuing up the free.

Fixes: 68fbff68dbea ("octeontx2-pf: Add police action for TC flower")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Reviewed-by: Vadim Fedorenko <vadim.fedorenko@linux.dev>
Link: https://patch.msgid.link/aNKCL1jKwK8GRJHh@stanley.mountain
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/marvell/octeontx2/nic/otx2_tc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_tc.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_tc.c
index bb77ab7ddfefd..6833cbf853445 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_tc.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_tc.c
@@ -1039,7 +1039,6 @@ static int otx2_tc_add_flow(struct otx2_nic *nic,
 
 free_leaf:
 	otx2_tc_del_from_flow_list(flow_cfg, new_node);
-	kfree_rcu(new_node, rcu);
 	if (new_node->is_act_police) {
 		mutex_lock(&nic->mbox.lock);
 
@@ -1059,6 +1058,7 @@ static int otx2_tc_add_flow(struct otx2_nic *nic,
 
 		mutex_unlock(&nic->mbox.lock);
 	}
+	kfree_rcu(new_node, rcu);
 
 	return rc;
 }
-- 
2.51.0



