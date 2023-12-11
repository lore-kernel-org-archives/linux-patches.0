Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C87B9524B8;
	Mon, 11 Dec 2023 18:38:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CqOyRu6t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BBCBC433C7;
	Mon, 11 Dec 2023 18:38:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1702319881;
	bh=acGawn4Mg7rBtqN6aWiMeNXQrZ6GReNvsjlWFXSyiSg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CqOyRu6tuvWzu7mDnX+EONmVXHduG8NNxLZs28PiDDuIHns6lHHCyhTlYE7eyuOEG
	 WQ409XinjiHdAM0RO608Voj/OX3hTFib4b0m8S73SZn72BgtxBImRy8SpYgz7cXs9z
	 czFBhRizTwXm5dTGIZzDcgmA8zz9soBalSJt9xrY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Subbaraya Sundeep <sbhatta@marvell.com>,
	Simon Horman <horms@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 22/97] octeontx2-pf: Add missing mutex lock in otx2_get_pauseparam
Date: Mon, 11 Dec 2023 19:21:25 +0100
Message-ID: <20231211182020.722637816@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231211182019.802717483@linuxfoundation.org>
References: <20231211182019.802717483@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Subbaraya Sundeep <sbhatta@marvell.com>

[ Upstream commit 9572c949385aa2ef10368287c439bcb7935137c8 ]

All the mailbox messages sent to AF needs to be guarded
by mutex lock. Add the missing lock in otx2_get_pauseparam
function.

Fixes: 75f36270990c ("octeontx2-pf: Support to enable/disable pause frames via ethtool")
Signed-off-by: Subbaraya Sundeep <sbhatta@marvell.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c
index c6d408de06050..fc4ca8246df24 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c
@@ -254,9 +254,12 @@ static void otx2_get_pauseparam(struct net_device *netdev,
 	if (is_otx2_lbkvf(pfvf->pdev))
 		return;
 
+	mutex_lock(&pfvf->mbox.lock);
 	req = otx2_mbox_alloc_msg_cgx_cfg_pause_frm(&pfvf->mbox);
-	if (!req)
+	if (!req) {
+		mutex_unlock(&pfvf->mbox.lock);
 		return;
+	}
 
 	if (!otx2_sync_mbox_msg(&pfvf->mbox)) {
 		rsp = (struct cgx_pause_frm_cfg *)
@@ -264,6 +267,7 @@ static void otx2_get_pauseparam(struct net_device *netdev,
 		pause->rx_pause = rsp->rx_pause;
 		pause->tx_pause = rsp->tx_pause;
 	}
+	mutex_unlock(&pfvf->mbox.lock);
 }
 
 static int otx2_set_pauseparam(struct net_device *netdev,
-- 
2.42.0



