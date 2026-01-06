Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4496F35E53C;
	Tue,  6 Jan 2026 17:47:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767721672; cv=none; b=rk/4+2G1dtyxki/s0RwNEcsdkPGrLTmotNif/Daj7EkPYZMuVjSdUaXyfwWYuYvpEj+QvBCCVoDmEgqGJ4gvRTQgCs+IvW+Z9d0p033zdNkVopr9hDLOyl7lPZbq8ZvRSHsN4ZjkLDg9BKci0GvZ7PWlt8DTzSCMAx4d+TnkPtM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767721672; c=relaxed/simple;
	bh=Tle8bdFOSM+YyiVmdVN4+z3z1OzpFg1BHqGJaeiddRY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KFotiA/JHAJ8ncp0/vQYmvQtG+9vrgcaIKDVFPLIUXMbYID+YFzqUW4sKkAcUejZjFUdxj3gMm0hDLB6vAC6D82h+yyBWk2LyvJ0t0QBbROcOjoZcKrxVErL1fAOrDRfsTCfAjskPM/7S7Z94w+x/RfS9pXxdiE1fFl23hIzJlo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=L8lU+W2P; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="L8lU+W2P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD2E6C116C6;
	Tue,  6 Jan 2026 17:47:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767721672;
	bh=Tle8bdFOSM+YyiVmdVN4+z3z1OzpFg1BHqGJaeiddRY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=L8lU+W2PJzCA5jnBlDJoS9nkTQwtS4I5O/jCqq3sOmdcQRixhD1Z17JklGN82CwP6
	 AS+t77cgxd+J6l66z4VRV/PaDyFwxGwVxL3n/l+dnT86yOKF6H1p0RblbiBKccPKWp
	 T9B3Ir46unXKKKwJ0S7h/tU8otcDTE0fp1HM1esA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Raju Rangoju <Raju.Rangoju@amd.com>,
	Simon Horman <horms@kernel.org>,
	Shyam Sundar S K <Shyam-sundar.S-k@amd.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 037/312] amd-xgbe: reset retries and mode on RX adapt failures
Date: Tue,  6 Jan 2026 18:01:51 +0100
Message-ID: <20260106170549.197605306@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170547.832845344@linuxfoundation.org>
References: <20260106170547.832845344@linuxfoundation.org>
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
index a56efc1bee33..450a573960e7 100644
--- a/drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c
+++ b/drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c
@@ -1927,6 +1927,7 @@ static void xgbe_set_rx_adap_mode(struct xgbe_prv_data *pdata,
 {
 	if (pdata->rx_adapt_retries++ >= MAX_RX_ADAPT_RETRIES) {
 		pdata->rx_adapt_retries = 0;
+		pdata->mode_set = false;
 		return;
 	}
 
@@ -1973,6 +1974,7 @@ static void xgbe_rx_adaptation(struct xgbe_prv_data *pdata)
 		 */
 		netif_dbg(pdata, link, pdata->netdev, "Block_lock done");
 		pdata->rx_adapt_done = true;
+		pdata->rx_adapt_retries = 0;
 		pdata->mode_set = false;
 		return;
 	}
-- 
2.51.0



