Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8CBA4418DB;
	Tue, 21 Jul 2026 22:18:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784672292; cv=none; b=jWSn9fUHngZeRAOYMMGMgqJBILMiFctr2wRiJiW62R1Wr1CrkCBqbTBZ9hLyBERnaRNbN2D7Dk+2MgkQIIUSuXhgseF8PKVfXoAWJE/OsJpEicMy6H+3Ohdi4X5iOYfqNSFEL90b7LeYqCK7rg9LkYooi49lvQdHoNuzabkTrUg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784672292; c=relaxed/simple;
	bh=I/OisoI1JqAY9yFCs41pfs6T4FJ2GNNfHosZ9d8QY9o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Yt5TnMHJLat4/5sUhthxi3ZuHVBjorjsR2HpKSsCKLD5wEctXcEqZo6f3HjplUM7bjrgQPqo0CLonQeWL+QheSGkgfmCSlW4Ao0gzkXRzT2lVbmT4BAt1z4D23WUQlFpHHOes42qy8d4nD22WFIT+WPg/G5opJuq1g9Udp3tzW8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FtmxE1e/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FtmxE1e/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5B011F00A3A;
	Tue, 21 Jul 2026 22:18:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784672288;
	bh=/qLFegpMA2WAs8xXt/L/OJb98+G8m8hBQfKx++NNlng=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FtmxE1e/yvh3xUNVR/TT3KMgkLhhqslmFQKHXG3Rd/J3szhOSi9KHuURUQ65Ze/88
	 10s7FsnsJjB0Oqgt6AAIWBOX7g229TFnbx1WEoJvs41gHFmzO3LCI5w29+0fLM3v9Z
	 j/5nM4pQwDhJVhJW81t05j20xaOfzUQFI6g/5DVs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Suman Ghosh <sumang@marvell.com>,
	Nitin Shetty J <nshettyj@marvell.com>,
	Harshitha Ramamurthy <hramamurthy@google.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 541/843] octeontx2-pf: check DMAC extraction support before filtering
Date: Tue, 21 Jul 2026 17:22:56 +0200
Message-ID: <20260721152418.206153256@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152405.946368001@linuxfoundation.org>
References: <20260721152405.946368001@linuxfoundation.org>
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

[ Upstream commit 235acadd310533ba386ae61ad155b72bee381559 ]

Currently, configuring a VF MAC address via the PF (e.g., 'ip link
set <pf> vf 0 mac <mac>') blindly attempts to install a DMAC-based
hardware filter. However, the hardware parser profile might not
support DMAC extraction.

Check if the hardware parsing profile supports DMAC extraction
before adding the filter. Additionally, emit a warning message
to inform the operator if the MAC filter installation fails due
to missing DMAC extraction support. Update config->mac only
after hardware programming succeeds in otx2_set_vf_mac().

Fixes: f0c2982aaf98 ("octeontx2-pf: Add support for SR-IOV management functions")
Signed-off-by: Suman Ghosh <sumang@marvell.com>
Signed-off-by: Nitin Shetty J <nshettyj@marvell.com>
Reviewed-by: Harshitha Ramamurthy <hramamurthy@google.com>
Link: https://patch.msgid.link/20260702033451.2969880-1-nshettyj@marvell.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../ethernet/marvell/octeontx2/nic/otx2_pf.c  | 43 ++++++++++++++++---
 1 file changed, 37 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
index dfd85b0088e007..9d39b9fc2f6a8d 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
@@ -2171,10 +2171,42 @@ static int otx2_ioctl(struct net_device *netdev, struct ifreq *req, int cmd)
 
 static int otx2_do_set_vf_mac(struct otx2_nic *pf, int vf, const u8 *mac)
 {
+	struct npc_get_field_status_req *freq;
+	struct npc_get_field_status_rsp *frsp;
 	struct npc_install_flow_req *req;
 	int err;
 
 	mutex_lock(&pf->mbox.lock);
+
+	/* Skip installing the DMAC filter if the hardware parser profile
+	 * does not support DMAC extraction.
+	 */
+	freq = otx2_mbox_alloc_msg_npc_get_field_status(&pf->mbox);
+	if (!freq) {
+		err = -ENOMEM;
+		goto out;
+	}
+
+	freq->field = NPC_DMAC;
+	err = otx2_sync_mbox_msg(&pf->mbox);
+	if (err)
+		goto out;
+
+	frsp = (struct npc_get_field_status_rsp *)otx2_mbox_get_rsp
+	       (&pf->mbox.mbox, 0, &freq->hdr);
+	if (IS_ERR(frsp)) {
+		err = PTR_ERR(frsp);
+		goto out;
+	}
+
+	if (!frsp->enable) {
+		netdev_warn(pf->netdev,
+			    "VF %d MAC filter not installed: DMAC extraction not supported by parser profile\n",
+			    vf);
+		err = -EOPNOTSUPP;
+		goto out;
+	}
+
 	req = otx2_mbox_alloc_msg_npc_install_flow(&pf->mbox);
 	if (!req) {
 		err = -ENOMEM;
@@ -2213,13 +2245,12 @@ static int otx2_set_vf_mac(struct net_device *netdev, int vf, u8 *mac)
 	if (!is_valid_ether_addr(mac))
 		return -EINVAL;
 
-	config = &pf->vf_configs[vf];
-	ether_addr_copy(config->mac, mac);
-
 	ret = otx2_do_set_vf_mac(pf, vf, mac);
-	if (ret == 0)
-		dev_info(&pdev->dev,
-			 "Load/Reload VF driver\n");
+	if (ret == 0) {
+		config = &pf->vf_configs[vf];
+		ether_addr_copy(config->mac, mac);
+		dev_info(&pdev->dev, "Load/Reload VF driver\n");
+	}
 
 	return ret;
 }
-- 
2.53.0



