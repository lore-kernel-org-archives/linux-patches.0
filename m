Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0EC43A1A8;
	Mon, 18 Dec 2023 14:12:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="h66bqrEh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD3CFC433C7;
	Mon, 18 Dec 2023 14:12:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1702908755;
	bh=luz9Bq6fI2y6USpaODGVJQPOZi4tnyuvZo89xOKMcZc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=h66bqrEhfzVN09hymJiZAjLlZG0rqvmLnaw8id2BZPNxE6aeUHV+dIwoc5KkJoEA9
	 sZyewO4/avJv08LBZUJPOnmeskC5kiEeEVpro1J5WtEkFN0ifTKee2xgw914umFAaz
	 5QXyTyrLPFdqAvpinv3bVKUUA+5vpo+KL8mAlYhA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hariprasad Kelam <hkelam@marvell.com>,
	Sunil Kovvuri Goutham <sgoutham@marvell.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 21/83] octeontx2-pf: Fix promisc mcam entry action
Date: Mon, 18 Dec 2023 14:51:42 +0100
Message-ID: <20231218135050.681843907@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231218135049.738602288@linuxfoundation.org>
References: <20231218135049.738602288@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hariprasad Kelam <hkelam@marvell.com>

[ Upstream commit dbda436824ded8ef6a05bb82cd9baa8d42377a49 ]

Current implementation is such that, promisc mcam entry action
is set as multicast even when there are no trusted VFs. multicast
action causes the hardware to copy packet data, which reduces
the performance.

This patch fixes this issue by setting the promisc mcam entry action to
unicast instead of multicast when there are no trusted VFs. The same
change is made for the 'allmulti' mcam entry action.

Fixes: ffd2f89ad05c ("octeontx2-pf: Enable promisc/allmulti match MCAM entries.")
Signed-off-by: Hariprasad Kelam <hkelam@marvell.com>
Signed-off-by: Sunil Kovvuri Goutham <sgoutham@marvell.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../ethernet/marvell/octeontx2/nic/otx2_pf.c  | 25 ++++++++++++++++---
 1 file changed, 22 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
index 4eec574631c7e..f9bb0e9e73592 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
@@ -1589,6 +1589,21 @@ static void otx2_free_hw_resources(struct otx2_nic *pf)
 	mutex_unlock(&mbox->lock);
 }
 
+static bool otx2_promisc_use_mce_list(struct otx2_nic *pfvf)
+{
+	int vf;
+
+	/* The AF driver will determine whether to allow the VF netdev or not */
+	if (is_otx2_vf(pfvf->pcifunc))
+		return true;
+
+	/* check if there are any trusted VFs associated with the PF netdev */
+	for (vf = 0; vf < pci_num_vf(pfvf->pdev); vf++)
+		if (pfvf->vf_configs[vf].trusted)
+			return true;
+	return false;
+}
+
 static void otx2_do_set_rx_mode(struct otx2_nic *pf)
 {
 	struct net_device *netdev = pf->netdev;
@@ -1621,7 +1636,8 @@ static void otx2_do_set_rx_mode(struct otx2_nic *pf)
 	if (netdev->flags & (IFF_ALLMULTI | IFF_MULTICAST))
 		req->mode |= NIX_RX_MODE_ALLMULTI;
 
-	req->mode |= NIX_RX_MODE_USE_MCE;
+	if (otx2_promisc_use_mce_list(pf))
+		req->mode |= NIX_RX_MODE_USE_MCE;
 
 	otx2_sync_mbox_msg(&pf->mbox);
 	mutex_unlock(&pf->mbox.lock);
@@ -2440,11 +2456,14 @@ static int otx2_ndo_set_vf_trust(struct net_device *netdev, int vf,
 	pf->vf_configs[vf].trusted = enable;
 	rc = otx2_set_vf_permissions(pf, vf, OTX2_TRUSTED_VF);
 
-	if (rc)
+	if (rc) {
 		pf->vf_configs[vf].trusted = !enable;
-	else
+	} else {
 		netdev_info(pf->netdev, "VF %d is %strusted\n",
 			    vf, enable ? "" : "not ");
+		otx2_set_rx_mode(netdev);
+	}
+
 	return rc;
 }
 
-- 
2.43.0



