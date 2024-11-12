Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E03811A76C7;
	Tue, 12 Nov 2024 10:33:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731407629; cv=none; b=ZlPAY8rsd6HmYnlCkZWaPD2ZBzucVhCmHjRSRIqbIr6qRC33jBYVWOC8rQYFIb8jZn/KbV/E7mAQ947hvhuRj2/+UDnQVZnoJnVSiKm5wb13/kM79K57G37Um4lfjTZ7S17r6bl0p4L7fRmNMnF1jGJPtG80pvXetv3c4j6VXoI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731407629; c=relaxed/simple;
	bh=RjLoRp/YLq3dZEkdGb6Aact7eiO0+qyNruk+XmuBatE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n0Yn0AFEl0KgYaLHV5VeZjladdk1uQehxSbhvB0kLlA593k3pk0y20JHua97BHBLCTU3zBcfNoOyBWmy9L3EkcAXtbbAI7q51PlR3/A9KLGvFaGtu70Q3dB1xnIs4tYla66vZmgMrkbvsKR5SqnRkR/dJyuFbot00u2MrEYR3wQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=p4JamrEC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="p4JamrEC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64091C4CED6;
	Tue, 12 Nov 2024 10:33:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731407628;
	bh=RjLoRp/YLq3dZEkdGb6Aact7eiO0+qyNruk+XmuBatE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=p4JamrECx5a+DU+KkDR4G7jP2ZHfpTmxPcGPpA2Ii85dUGlFIgDQhIDjWjX4+vmO5
	 15jB7TTf1aLueTFrHdAIoDUXUseILvFjcv4MULvhS2IswZAx1kcJ3SjY+YtXYFgdy8
	 8kn27sApZDjYXupdt3Sc/wajhVLEtqIRKhJByLyE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wei Fang <wei.fang@nxp.com>,
	Vladimir Oltean <vladimir.oltean@nxp.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 034/119] net: enetc: allocate vf_state during PF probes
Date: Tue, 12 Nov 2024 11:20:42 +0100
Message-ID: <20241112101850.015170545@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241112101848.708153352@linuxfoundation.org>
References: <20241112101848.708153352@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wei Fang <wei.fang@nxp.com>

[ Upstream commit e15c5506dd39885cd047f811a64240e2e8ab401b ]

In the previous implementation, vf_state is allocated memory only when VF
is enabled. However, net_device_ops::ndo_set_vf_mac() may be called before
VF is enabled to configure the MAC address of VF. If this is the case,
enetc_pf_set_vf_mac() will access vf_state, resulting in access to a null
pointer. The simplified error log is as follows.

root@ls1028ardb:~# ip link set eno0 vf 1 mac 00:0c:e7:66:77:89
[  173.543315] Unable to handle kernel NULL pointer dereference at virtual address 0000000000000004
[  173.637254] pc : enetc_pf_set_vf_mac+0x3c/0x80 Message from sy
[  173.641973] lr : do_setlink+0x4a8/0xec8
[  173.732292] Call trace:
[  173.734740]  enetc_pf_set_vf_mac+0x3c/0x80
[  173.738847]  __rtnl_newlink+0x530/0x89c
[  173.742692]  rtnl_newlink+0x50/0x7c
[  173.746189]  rtnetlink_rcv_msg+0x128/0x390
[  173.750298]  netlink_rcv_skb+0x60/0x130
[  173.754145]  rtnetlink_rcv+0x18/0x24
[  173.757731]  netlink_unicast+0x318/0x380
[  173.761665]  netlink_sendmsg+0x17c/0x3c8

Fixes: d4fd0404c1c9 ("enetc: Introduce basic PF and VF ENETC ethernet drivers")
Signed-off-by: Wei Fang <wei.fang@nxp.com>
Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Tested-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Link: https://patch.msgid.link/20241031060247.1290941-2-wei.fang@nxp.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/freescale/enetc/enetc_pf.c    | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/freescale/enetc/enetc_pf.c b/drivers/net/ethernet/freescale/enetc/enetc_pf.c
index c153dc083aff0..a856047f1dfd6 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_pf.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc_pf.c
@@ -665,19 +665,11 @@ static int enetc_sriov_configure(struct pci_dev *pdev, int num_vfs)
 
 	if (!num_vfs) {
 		enetc_msg_psi_free(pf);
-		kfree(pf->vf_state);
 		pf->num_vfs = 0;
 		pci_disable_sriov(pdev);
 	} else {
 		pf->num_vfs = num_vfs;
 
-		pf->vf_state = kcalloc(num_vfs, sizeof(struct enetc_vf_state),
-				       GFP_KERNEL);
-		if (!pf->vf_state) {
-			pf->num_vfs = 0;
-			return -ENOMEM;
-		}
-
 		err = enetc_msg_psi_init(pf);
 		if (err) {
 			dev_err(&pdev->dev, "enetc_msg_psi_init (%d)\n", err);
@@ -696,7 +688,6 @@ static int enetc_sriov_configure(struct pci_dev *pdev, int num_vfs)
 err_en_sriov:
 	enetc_msg_psi_free(pf);
 err_msg_psi:
-	kfree(pf->vf_state);
 	pf->num_vfs = 0;
 
 	return err;
@@ -1283,6 +1274,12 @@ static int enetc_pf_probe(struct pci_dev *pdev,
 	pf = enetc_si_priv(si);
 	pf->si = si;
 	pf->total_vfs = pci_sriov_get_totalvfs(pdev);
+	if (pf->total_vfs) {
+		pf->vf_state = kcalloc(pf->total_vfs, sizeof(struct enetc_vf_state),
+				       GFP_KERNEL);
+		if (!pf->vf_state)
+			goto err_alloc_vf_state;
+	}
 
 	err = enetc_setup_mac_addresses(node, pf);
 	if (err)
@@ -1360,6 +1357,8 @@ static int enetc_pf_probe(struct pci_dev *pdev,
 	free_netdev(ndev);
 err_alloc_netdev:
 err_setup_mac_addresses:
+	kfree(pf->vf_state);
+err_alloc_vf_state:
 	enetc_psi_destroy(pdev);
 err_psi_create:
 	return err;
@@ -1386,6 +1385,7 @@ static void enetc_pf_remove(struct pci_dev *pdev)
 	enetc_free_si_resources(priv);
 
 	free_netdev(si->ndev);
+	kfree(pf->vf_state);
 
 	enetc_psi_destroy(pdev);
 }
-- 
2.43.0



