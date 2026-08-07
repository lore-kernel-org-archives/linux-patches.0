Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC540281369;
	Fri,  7 Aug 2026 15:20:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786116012; cv=none; b=TyyKXNJgKFLLr/yhTqC88ga38VZ4EviH7lzzbBIJV9uPLgQhEviFvPnzqHJElTNfpb+1vWSA9h5vpBU+F9lNEAtrCULK3cdw+9CBFOaa/MyUG7/zmk+nkFZ5PqWkKCoX+EIiZ5MZK2Jiu70nA4fI5GbtreaVO5xVqJyetUotBcE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786116012; c=relaxed/simple;
	bh=d0g7hcuXUs4cjRwoUfaXVWiCCnoeivYDeZu/rSEl4W0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ubDGXUSAipy+GmaArZI3kSCmPph2GJNIXhMZ+rrs2kQd7HdsVvar1FVGnfnp/05t9hoMand6Q85rPvDCRmzWZXK/tmQtOCLfHQo6Vwe+EPmPRFNW0QZp3R6OkfFn029rtqfThE4Kg8etGQitS8pOORMeYnI9cxRWPcbEN7PWT4E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uDzvZfhX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uDzvZfhX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E48E1F00A3F;
	Fri,  7 Aug 2026 15:20:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786116011;
	bh=EF63fTGKnwCuZqw7+5okd46nFUQ9Dr2xQaeuHhSrLXM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uDzvZfhX9eF8AgiYGABSZiVwn811AY71so4zri6+zd97fSsUhqt+aUoYfxTla9qPb
	 E1HoeKAWCJKfFYmj8L2EHoN7wUZLaDSWKY7MAeu5x6xB+XD/f8O5JLtDsA3c6EwwbV
	 0Scdv9Sri7+fKWUcuYmLP4gdT88WQGNgSxRkLmrQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Suman Ghosh <sumang@marvell.com>,
	Ratheesh Kannoth <rkannoth@marvell.com>,
	Simon Horman <horms@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 082/261] octeontx2-pf: Set correct sequence for carrier off and tx queue stop
Date: Fri,  7 Aug 2026 16:37:19 +0200
Message-ID: <20260807143417.152390706@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143415.358597922@linuxfoundation.org>
References: <20260807143415.358597922@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index caea58f8fd86a..eb7ad5b3b629b 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
@@ -842,8 +842,8 @@ static void otx2_handle_link_event(struct otx2_nic *pf)
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



