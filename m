Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0DEB3431F5;
	Fri,  7 Aug 2026 15:37:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786117048; cv=none; b=GyD4ofbrlC5B4S3J0GZYQG3EMr3insecjfdcDwHz1MzECjF4qHB6+PTb+10OGeqJXaViczVF/YiLn0gx7dMjgXTNPzZ2FZMtf2GI6SphC9Vw1o832PFWB5+EppXf0aPl5/iu3B9lm/Z0mdOiFgtKn/AJ2YCJgIQ+u8XpLyK+8eU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786117048; c=relaxed/simple;
	bh=EcAva/tZTPkt5edMV8cOsdbgYWE8mZSddldy14t41gE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aczA1mwbHYskPHkfOm+EniAsHny+idVSZoMTfPrwd+UURlWubZYRG9l1CciUcobFEvwHhf31teJuKYjOvZ4HjMv267au5MWtZdyMoULV5FJpYxFkCrg8xvYpSVPYaBpXxMSdREPB6/K9iZfYCG9/zuzzmi295REHWKQyYIRL9fI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yC12wj9F; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yC12wj9F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A0EF1F000E9;
	Fri,  7 Aug 2026 15:37:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786117047;
	bh=HmGFhWLGQ8FbWnAEz1OCpDaVI8BKTK7k64bIBPhAUX4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yC12wj9FMFSmijx+8w6NQxncxenUSvwXlo8ngWvkksA7kbNg+d5I31SmX3oeRQNnr
	 3ZSCqMUifmpMnYaBySrZPP3Pp2P4Vy2veKC08y3a/H5TT9RopcaZdw4oIOpyoXlbZ6
	 16bZIwQ3XbBAn0Frci901IH4FmbIbbfR3lNTqJWU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Suman Ghosh <sumang@marvell.com>,
	Ratheesh Kannoth <rkannoth@marvell.com>,
	Simon Horman <horms@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 182/438] octeontx2-pf: Set correct sequence for carrier off and tx queue stop
Date: Fri,  7 Aug 2026 16:36:18 +0200
Message-ID: <20260807143431.911527865@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143428.008222056@linuxfoundation.org>
References: <20260807143428.008222056@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
index 2e33b33ec9934..c995f29008590 100644
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



