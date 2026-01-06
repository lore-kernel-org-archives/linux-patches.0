Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F061027F754;
	Tue,  6 Jan 2026 17:31:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767720693; cv=none; b=dciduRIswTMRhEWz0up2BbAnO/ijMYrIOFbe9KJkZ2gnPCuLOVmKaZY1k1GEIxsEeCGgdDEHcR5NtkZa/T9M2+Px4UR0ZrTds28WSaA/d52+5+TV++UyBZRW0IdfLNyQNkmXFiDivC4qTDqm4CCfqpDhqo67y8+sfQpF4nfHZ1Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767720693; c=relaxed/simple;
	bh=UnpzAm7g1jJIcaWC7gBCswZ2g9XpPf0bN3Ve8IKlqMI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZonddjMDfuYnCOYKJddyXmqon3+5GYBvJLdZU1Rq2hjEXCVD8Xl7uCwFCuP/CfiyGf5rc9H/vLNR3YJV6TcFa8vnFKS4gujeJaeqayQLnyVmENoVIFkHuhAGQ9OxpnyyR69iM15qtGcl36rPnlEXZA9gt2WEsLS5CxVTHESbpEg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CiP9z71h; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CiP9z71h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64B9FC116C6;
	Tue,  6 Jan 2026 17:31:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767720692;
	bh=UnpzAm7g1jJIcaWC7gBCswZ2g9XpPf0bN3Ve8IKlqMI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CiP9z71ho9FHrDfEBkEDNBDMjB38RFmhZ/XQYkVha3o1gZp9P2BZ3PhGukOZDxukR
	 Lh+lYgQGp3j+3mGs6ibFw+wfN+fYSzkClrbZ1J9CHpJ5BrXhbF3R+ssDn+syGjL2t7
	 Tq5pdzJIp1hb568Api+KKiWe8ElDp/crKcxffiOM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Raju Rangoju <Raju.Rangoju@amd.com>,
	Simon Horman <horms@kernel.org>,
	Shyam Sundar S K <Shyam-sundar.S-k@amd.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 312/567] amd-xgbe: reset retries and mode on RX adapt failures
Date: Tue,  6 Jan 2026 18:01:34 +0100
Message-ID: <20260106170502.869247439@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170451.332875001@linuxfoundation.org>
References: <20260106170451.332875001@linuxfoundation.org>
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

From: Raju Rangoju <Raju.Rangoju@amd.com>

[ Upstream commit df60c332caf95d70f967aeace826e7e2f0847361 ]

During the stress tests, early RX adaptation handshakes can fail, such
as missing the RX_ADAPT ACK or not receiving a coefficient update before
block lock is established. Continuing to retry RX adaptation in this
state is often ineffective if the current mode selection is not viable.

Resetting the RX adaptation retry counter when an RX_ADAPT request fails
to receive ACK or a coefficient update prior to block lock, and clearing
mode_set so the next bring-up performs a fresh mode selection rather
than looping on a likely invalid configuration.

Fixes: 4f3b20bfbb75 ("amd-xgbe: add support for rx-adaptation")
Signed-off-by: Raju Rangoju <Raju.Rangoju@amd.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Reviewed-by: Shyam Sundar S K <Shyam-sundar.S-k@amd.com>
Link: https://patch.msgid.link/20251215151728.311713-1-Raju.Rangoju@amd.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c b/drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c
index 32e633d11348..6d2c401bb246 100644
--- a/drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c
+++ b/drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c
@@ -2036,6 +2036,7 @@ static void xgbe_set_rx_adap_mode(struct xgbe_prv_data *pdata,
 {
 	if (pdata->rx_adapt_retries++ >= MAX_RX_ADAPT_RETRIES) {
 		pdata->rx_adapt_retries = 0;
+		pdata->mode_set = false;
 		return;
 	}
 
@@ -2082,6 +2083,7 @@ static void xgbe_rx_adaptation(struct xgbe_prv_data *pdata)
 		 */
 		netif_dbg(pdata, link, pdata->netdev, "Block_lock done");
 		pdata->rx_adapt_done = true;
+		pdata->rx_adapt_retries = 0;
 		pdata->mode_set = false;
 		return;
 	}
-- 
2.51.0



