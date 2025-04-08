Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92BBB20897E;
	Tue,  8 Apr 2025 11:15:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744110950; cv=none; b=DCf/p74XQg/GU2MpkZLEPQB2QZ1Wr8Gf4igzdqeNINNvpNvRubh+3vV848LtYZEKm92M0MAEA1R0DB9H8k9kfwiS1NGrRbr7osZEMErtxAa5czP5r+FrIWmfsAS4Cf61Pbw5gYGtSG+UCcLq4uu28jvqQsXlyMWBwR4rH4VZLzY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744110950; c=relaxed/simple;
	bh=1Ga/1XcHc6A5h/ZyD3wHLc9nVvvtzFLnfHLkcHxY5nE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mDsZkQYK7qEEznnyW5mdDjnUZSCFQPiIVIl8JjTzNsBgBFMlqLm6jrhZiC4JgaOFyYRcFak7CqIIDGe8EhAinKtAn9FmUXGNSF0Ju4U1iez0ihr7MIxo3OSX68wfit0k9HSkDiZdsuaJuilasXpFzFLLHO1O03bGr05MUHccDQg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Kddhce6G; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Kddhce6G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AEF80C4CEE5;
	Tue,  8 Apr 2025 11:15:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744110950;
	bh=1Ga/1XcHc6A5h/ZyD3wHLc9nVvvtzFLnfHLkcHxY5nE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Kddhce6G3trWcZOIJ3IwNNUIoEYEqTAemhtTaaCYgDFsSY/OmkNDVgUC3RVx2hxTK
	 YyVJ7fZ8yNN4ZAs2LLSdka7fMAzlaTRJLnDgYNOyEbjVdz4N6m8hzpgy6x0BoXf6XY
	 fK6jJX77tfCYtYFHL1gZCNKlMcHgoWkuXmVE8//4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Emil Tantilov <emil.s.tantilov@intel.com>,
	Simon Horman <horms@kernel.org>,
	Samuel Salin <Samuel.salin@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 214/731] idpf: check error for register_netdev() on init
Date: Tue,  8 Apr 2025 12:41:51 +0200
Message-ID: <20250408104919.260773256@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/idpf/idpf_lib.c | 31 +++++++++++++++-------
 1 file changed, 22 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/intel/idpf/idpf_lib.c b/drivers/net/ethernet/intel/idpf/idpf_lib.c
index a3d6b8f198a86..a055a47449f12 100644
--- a/drivers/net/ethernet/intel/idpf/idpf_lib.c
+++ b/drivers/net/ethernet/intel/idpf/idpf_lib.c
@@ -927,15 +927,19 @@ static int idpf_stop(struct net_device *netdev)
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
@@ -1536,13 +1540,22 @@ void idpf_init_task(struct work_struct *work)
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
-- 
2.39.5



