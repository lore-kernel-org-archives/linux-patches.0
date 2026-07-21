Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 072B74343F1;
	Tue, 21 Jul 2026 19:49:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784663381; cv=none; b=EFMFYVYP3BumxfWf1BPEah02+2GPOad+h+skg++LuuN7YshcfG7d4VYt8sjyk1go5PxxxHA4rfv0GuDMOdEYm2jkkIIr5GfOixSwwFs+BIp4I4RtDsscg9NgCOMUUN2R+gmxUH0y9hz9QJhO3UrsnSQ0ttzRkQJBwCuYjF0vRvw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784663381; c=relaxed/simple;
	bh=TOgTNzuBPg9IL0E0hj4QjEhGplkRBdMk3wltAFjJZts=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y15mnp2/z1bxxHjCJpD246GCPBxt68AiVXr45Ql71dFXUX+NZNIDYmMR3km6BWo7UtAQMpumsVyHZImOc2+ak3FS6/5xY605bYnAYU6sm3sRMe/V8hjdr71kzmnw3ifDkPXrF3bR/YPNlcFqwocITT6cJher6dCCrFLF8VoJDjY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sh/9+Twb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sh/9+Twb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60B801F000E9;
	Tue, 21 Jul 2026 19:49:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784663379;
	bh=J73+8gekRJFcK6d9xjCpaAVXimkOOdc2LqaCAKRkR8I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sh/9+TwbIvdPQNDaUcwamrdJZuAmGm8TtU9BxTsg5rX2oyEYbQ7evVDXHPnrIkWi2
	 TZ3Zlhza12U15ztZBnwh0QL1WvI9eeXeP3Cr6BlqVltfA79UVTgikW1x/qYRUm6RcV
	 NzK9r9MMp4n0ChyL5VWz2KN084XoDD5dpE2Aokmk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Suman Ghosh <sumang@marvell.com>,
	Nitin Shetty J <nshettyj@marvell.com>,
	Harshitha Ramamurthy <hramamurthy@google.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0784/1276] octeontx2-pf: check DMAC extraction support before filtering
Date: Tue, 21 Jul 2026 17:20:27 +0200
Message-ID: <20260721152503.624414990@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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
index dc4909149fdb85..b0b0b4929e8ce2 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
@@ -2365,10 +2365,42 @@ EXPORT_SYMBOL(otx2_ioctl);
 
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
@@ -2407,13 +2439,12 @@ static int otx2_set_vf_mac(struct net_device *netdev, int vf, u8 *mac)
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



