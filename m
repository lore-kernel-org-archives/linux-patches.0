Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5044D3F6C3E;
	Fri,  7 Aug 2026 14:47:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786114067; cv=none; b=NB1dLAgqgTFKMESH7U2i8U1KUvLBA87+7lIkm5wsUNRG+3UTxGXezGdC2xFtBjzFJzhFdHUE5IdUAXNFVND9+Lml9H9l0XTJL54UvIzztwDOyZOc6IzBrf8HEZmypzERcJ+Ihhv/roNNvb/G6tmrBK+479Q+xaLefeTpX6z/1OA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786114067; c=relaxed/simple;
	bh=XRk7Y+ZrJ32MBV9e7kA4dlHP5U/bKQez5U9GPwq/e78=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WqEHU3LTEB1qXXRgJ8FCI9YTp+UwpYS4nQglBaMWin5PMfx1Ov3M3NGAYpgGe6G7slVFeQ08xsu9okQE67OiBSA2fsTqTu2swsgHlWcCWqzCCJbrqd+zAKfnuQLSK9h2aHTFx6GeCVZ9P+7qIcbusSbLqeJTULxRqhwtt6YFsh4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tFyFJaJc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tFyFJaJc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90F151F000E9;
	Fri,  7 Aug 2026 14:47:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786114060;
	bh=zIVJ8uQJ7mdfTQ4h1IDYa/Vhbv9v5K0U8Uo3xrXBbhw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tFyFJaJcaGVSAVMUVbFaJifDI3BUhGdQiztIXF85sCOPB9aRhUr9GvA3LOrd2tEDh
	 IxAZwI/xkQHgOYqLpgR0tkDXH/6EOy/pn+FeLzJJb0PexDnrFOLcUYNUfBtBPowTpc
	 vCeTLJ32bTxsW341Nqx9WztXVNd79ph7CrMjZKm8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Suman Ghosh <sumang@marvell.com>,
	Ratheesh Kannoth <rkannoth@marvell.com>,
	Simon Horman <horms@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 123/337] octeontx2-pf: Set correct sequence for carrier off and tx queue stop
Date: Fri,  7 Aug 2026 16:35:26 +0200
Message-ID: <20260807143421.198834819@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143418.516897842@linuxfoundation.org>
References: <20260807143418.516897842@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index c314139e0d781..d03399585d01d 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
@@ -838,8 +838,8 @@ static void otx2_handle_link_event(struct otx2_nic *pf)
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



