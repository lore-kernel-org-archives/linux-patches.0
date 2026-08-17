Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B76C243B6DE;
	Mon, 17 Aug 2026 14:35:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786977321; cv=none; b=H5evueH6CaMF46G5ihA8nfgUl8/bs/1FFbrJlGVNXob9ls1YdbTP8Dlbgg87gW3iL1xHqc/7QCgchjbmEtmseRZGPSqw/0iim0MTog0C2AM27Fq18hfGh6ZbIEZ6swa5bk1Ktj0a2RU83QoplERlnA2uQUBX/ijGmC+UraBibMI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786977321; c=relaxed/simple;
	bh=8envi+J6QKfKQbt5BLZpskcq31CWO64ZG96NN4dbUes=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FARxET26//qdy1D0UHtIqE+GTeskeG1CesSGr2LV7gb6XC3aDyF/UIMPR+Bp8YF7sj4O5FQWet65s8FaZt6wtYFQqz7MB2B7qLwXP0N0aeHTuc5V5Vd+A2Jited2voCIy2NiD7R8bz0+163Qowie/Dys1uZpZz26cOHV6G7Nmls=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2VkZ6LFv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2VkZ6LFv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D0491F000E9;
	Mon, 17 Aug 2026 14:35:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786977318;
	bh=zieYO3XvQCNZN6ASlCL2DjDGedG/Ckq3ArY66uYrOls=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2VkZ6LFvtSsTTylX4MFpPy4IJS+itx0YunnKGy+Ec5zDjgAHGYvsbE+U7fnidiEs2
	 oishEkpaY9e2X01Mmp3sME74p43OEh93LnbuI4SlfS3PULozifL/tF4tj9nOsESEL+
	 yZWUmJrd3UdZ/Vw1UY0KOlugR2UYsEKoZXwZkVJA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Suman Ghosh <sumang@marvell.com>,
	Ratheesh Kannoth <rkannoth@marvell.com>,
	Simon Horman <horms@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 288/456] octeontx2-pf: Set correct sequence for carrier off and tx queue stop
Date: Mon, 17 Aug 2026 15:31:18 +0200
Message-ID: <20260817132551.159033544@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132539.792407575@linuxfoundation.org>
References: <20260817132539.792407575@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 9d39b9fc2f6a8..a8a97197d6b76 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
@@ -849,8 +849,8 @@ static void otx2_handle_link_event(struct otx2_nic *pf)
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



