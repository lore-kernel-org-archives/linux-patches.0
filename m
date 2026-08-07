Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB542340280;
	Fri,  7 Aug 2026 15:06:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786115198; cv=none; b=MppAhMzJxiap0ddj5cz3OIA+mUaMLDofMPzH245vUhDREyhcWPJiXEMox86pD9V7rluytgwWEVv0/3ltXL965aZUz+N955a2Vk0NzEgbOAvrHa292fq5sZOYiV4lDs9N1IGMWBvsEeASrf1e/FvpVNKov0mrdFu/ygg/HLxNTpI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786115198; c=relaxed/simple;
	bh=OJQyATNKLcm18IKc0KGRPUdnznuuD4OxdSY47+DdA5A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sxmsgtITwhyPb4PA1ZIhI5cWjpEcc7axF0SmdwC8PPK1CNqKhPSgV//az3DyxYcuBrfJSwaZByANGZYmY/9tXsC5Wp3DxbsnS6RXNkHl5xSHjm0jVXPhEHs+6Up01on8RRxBMVN8b8kY0dRK3dgWGVNwOytV4tK1LZY7KuO6liI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=K1cBFdW3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="K1cBFdW3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11E001F000E9;
	Fri,  7 Aug 2026 15:06:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786115197;
	bh=QCZZCnMfUfsEtLxKqKlMK0PoEgbUjrZWcFx8hVcDyVE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=K1cBFdW38gmq/Hu7FphDv4QLwGDeNRFHvdcnMPT6o/GBHTmFO3H0Dirdu75H5tqiG
	 cGolll9QEjhlVoJ84fAQpbJvR7XyaAz66t9o5dZpH6iP6oGe19cqg5MNHYU5ueCBse
	 fiZYs5mlxoAa03BpxfYQ664zJ3+OqwE91yyd/vis=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Suman Ghosh <sumang@marvell.com>,
	Ratheesh Kannoth <rkannoth@marvell.com>,
	Simon Horman <horms@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 148/396] octeontx2-pf: Set correct sequence for carrier off and tx queue stop
Date: Fri,  7 Aug 2026 16:35:08 +0200
Message-ID: <20260807143427.500899966@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143424.272339768@linuxfoundation.org>
References: <20260807143424.272339768@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Suman Ghosh <sumang@marvell.com>

[ Upstream commit 16809472409d998afcda402e32b8229b389337c4 ]

During link down event, we were doing netif_tx_stop_all_queues() first
and then netif_carrier_off(). This can cause a potential race since
carrier is still on during down event. This patch reverse the calling
order to fix the issue.

Fixes: 50fe6c02e5ad ("octeontx2-pf: Register and handle link notifications")
Signed-off-by: Suman Ghosh <sumang@marvell.com>
Signed-off-by: Ratheesh Kannoth <rkannoth@marvell.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20260724072831.2415281-1-rkannoth@marvell.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
index ae7bded777688..7e42d3291a9fd 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
@@ -889,8 +889,8 @@ static void otx2_handle_link_event(struct otx2_nic *pf)
 		netif_carrier_on(netdev);
 		netif_tx_start_all_queues(netdev);
 	} else {
-		netif_tx_stop_all_queues(netdev);
 		netif_carrier_off(netdev);
+		netif_tx_stop_all_queues(netdev);
 	}
 }
 
-- 
2.53.0



