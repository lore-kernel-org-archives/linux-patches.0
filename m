Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 986B543E06D;
	Mon, 17 Aug 2026 14:14:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786976089; cv=none; b=ec8EpkoAMSn3gTaHKiWOZgkzGJWrL4OPIONCZAwYpzNMwlBsjYg7NoKvKv4XCoBJp9+pX9UMudwLpYWO49TUcib+UhmGLIJb/WpgDNokaMNR9A7govNHPQ7nn+eeStWifTPrrDtkSpBSHahu+Lx25v/LYfk2JOBQEWXqNyKl3dg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786976089; c=relaxed/simple;
	bh=kA1q2kzHF/CGb1TamodsqKPiwoz3F+yPJsZRSAQWNmY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i6i1Lsc7wEJoMpz/Tm7V04uGf1XjrUBk/loZcprnpWlwjc49corIIyWlRJcugsc2rcZg1tMiXc9fNqdrA010y8uzpM7UHgKeu9s7oyi8yaJILaHs1jyNhWQaqow5wG3YQd38B1bQQK+0vUqMohQKr7M0RhB79i5fQOTbJwT97Do=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=P8gAXzOE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="P8gAXzOE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2D371F000E9;
	Mon, 17 Aug 2026 14:14:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786976088;
	bh=C5L57XmZ8XXWSMJ6QElbEGQEV/hwCVBIz0QEYPQUXS0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=P8gAXzOEUkmXM907yKYyvas8CHEmvQDSsoYJhhN6UZiyn8o30DcOnkHdOjokOk5pJ
	 QbpHTwuShYypFOJaeUCxO0NE0k8DQYDWPDJFtMgutJOh0H4XI+nQWJw20im63zEZVo
	 jb47ai3J5vkvi/xnkEgw2WWx93DYqzJoMGp/frO4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Suman Ghosh <sumang@marvell.com>,
	Ratheesh Kannoth <rkannoth@marvell.com>,
	Simon Horman <horms@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 236/389] octeontx2-pf: Set correct sequence for carrier off and tx queue stop
Date: Mon, 17 Aug 2026 15:31:15 +0200
Message-ID: <20260817132548.482928841@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132538.796021292@linuxfoundation.org>
References: <20260817132538.796021292@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 50a36639e0ced..ca2b8ae98bd26 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
@@ -840,8 +840,8 @@ static void otx2_handle_link_event(struct otx2_nic *pf)
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



