Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2101D3F7867;
	Tue, 31 Mar 2026 16:55:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774976130; cv=none; b=VM2+KlKDCPnq2mtJuLrZNQ7dI+ucTLwa6r0wAuYFy95lXlmwfJY3neMb7DTPoM+8rIgbauXjVUShzQb206Ln4SHVZ4vZwmhCacjHEYJ9Aoy45ToeJ//7baKyHOeek8S4FSCh9DXlDmodKP3OMdXA+ygDTE+TYqCTeIgA1cdCn0s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774976130; c=relaxed/simple;
	bh=Y2mElJTOI5RnN++B9XNGwnSbVJM8wUkAYpFprh/SgZg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Uyis6AWR4anx8Yl9mpo3Pt7xMrGNCZHHDN83Li6jph5BySxo3djeVxfar7uvavSWRx/xfmkT/XLo6Ifxj/gvcgSRbRBEITvTDYFMJNIVxMpCsyXcWdJvAT266ore0M2dTfQM2b7MlZto24kbFwmu8SuNCTH6bX4KmruHgHd/TlQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QJKRb7UD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QJKRb7UD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACD83C19423;
	Tue, 31 Mar 2026 16:55:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774976130;
	bh=Y2mElJTOI5RnN++B9XNGwnSbVJM8wUkAYpFprh/SgZg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QJKRb7UDGqqUpIfC2jU6DjRKn62yieLrtcoR9znVhzr3pDWZ+ZJg75dTz4u4/lnzl
	 wE5NjkT/x/blJ5O6NybyHn2uUkHnZRp263UORCb4H9I3K4zKIrjtVFSw6JuXvIfsow
	 XtX/t4KgGHITGLC0o4ERKLcPIIeVJHCTXbBkIpOw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Emil Tantilov <emil.s.tantilov@intel.com>,
	Simon Horman <horms@kernel.org>,
	Samuel Salin <Samuel.salin@intel.com>,
	Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Subject: [PATCH 6.12 219/244] idpf: check error for register_netdev() on init
Date: Tue, 31 Mar 2026 18:22:49 +0200
Message-ID: <20260331161749.853858856@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161741.651718120@linuxfoundation.org>
References: <20260331161741.651718120@linuxfoundation.org>
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

From: Emil Tantilov <emil.s.tantilov@intel.com>

[ Upstream commit 680811c67906191b237bbafe7dabbbad64649b39 ]

Current init logic ignores the error code from register_netdev(),
which will cause WARN_ON() on attempt to unregister it, if there was one,
and there is no info for the user that the creation of the netdev failed.

WARNING: CPU: 89 PID: 6902 at net/core/dev.c:11512 unregister_netdevice_many_notify+0x211/0x1a10
...
[ 3707.563641]  unregister_netdev+0x1c/0x30
[ 3707.563656]  idpf_vport_dealloc+0x5cf/0xce0 [idpf]
[ 3707.563684]  idpf_deinit_task+0xef/0x160 [idpf]
[ 3707.563712]  idpf_vc_core_deinit+0x84/0x320 [idpf]
[ 3707.563739]  idpf_remove+0xbf/0x780 [idpf]
[ 3707.563769]  pci_device_remove+0xab/0x1e0
[ 3707.563786]  device_release_driver_internal+0x371/0x530
[ 3707.563803]  driver_detach+0xbf/0x180
[ 3707.563816]  bus_remove_driver+0x11b/0x2a0
[ 3707.563829]  pci_unregister_driver+0x2a/0x250

Introduce an error check and log the vport number and error code.
On removal make sure to check VPORT_REG_NETDEV flag prior to calling
unregister and free on the netdev.

Add local variables for idx, vport_config and netdev for readability.

Fixes: 0fe45467a104 ("idpf: add create vport and netdev configuration")
Suggested-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Emil Tantilov <emil.s.tantilov@intel.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Tested-by: Samuel Salin <Samuel.salin@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
(cherry picked from commit 680811c67906191b237bbafe7dabbbad64649b39)
Signed-off-by: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/intel/idpf/idpf_lib.c |   31 ++++++++++++++++++++---------
 1 file changed, 22 insertions(+), 9 deletions(-)

--- a/drivers/net/ethernet/intel/idpf/idpf_lib.c
+++ b/drivers/net/ethernet/intel/idpf/idpf_lib.c
@@ -911,15 +911,19 @@ static int idpf_stop(struct net_device *
 static void idpf_decfg_netdev(struct idpf_vport *vport)
 {
 	struct idpf_adapter *adapter = vport->adapter;
+	u16 idx = vport->idx;
 
 	kfree(vport->rx_ptype_lkup);
 	vport->rx_ptype_lkup = NULL;
 
-	unregister_netdev(vport->netdev);
-	free_netdev(vport->netdev);
+	if (test_and_clear_bit(IDPF_VPORT_REG_NETDEV,
+			       adapter->vport_config[idx]->flags)) {
+		unregister_netdev(vport->netdev);
+		free_netdev(vport->netdev);
+	}
 	vport->netdev = NULL;
 
-	adapter->netdevs[vport->idx] = NULL;
+	adapter->netdevs[idx] = NULL;
 }
 
 /**
@@ -1541,13 +1545,22 @@ void idpf_init_task(struct work_struct *
 	}
 
 	for (index = 0; index < adapter->max_vports; index++) {
-		if (adapter->netdevs[index] &&
-		    !test_bit(IDPF_VPORT_REG_NETDEV,
-			      adapter->vport_config[index]->flags)) {
-			register_netdev(adapter->netdevs[index]);
-			set_bit(IDPF_VPORT_REG_NETDEV,
-				adapter->vport_config[index]->flags);
+		struct net_device *netdev = adapter->netdevs[index];
+		struct idpf_vport_config *vport_config;
+
+		vport_config = adapter->vport_config[index];
+
+		if (!netdev ||
+		    test_bit(IDPF_VPORT_REG_NETDEV, vport_config->flags))
+			continue;
+
+		err = register_netdev(netdev);
+		if (err) {
+			dev_err(&pdev->dev, "failed to register netdev for vport %d: %pe\n",
+				index, ERR_PTR(err));
+			continue;
 		}
+		set_bit(IDPF_VPORT_REG_NETDEV, vport_config->flags);
 	}
 
 	/* As all the required vports are created, clear the reset flag


