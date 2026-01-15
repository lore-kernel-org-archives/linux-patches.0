Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EC14396B75;
	Thu, 15 Jan 2026 16:57:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768496251; cv=none; b=mi1U2ZV8Z0V0o6515Jf7Xj67qa4hANmcq00kFmYwj/dlTK32yYeVZaXq8QYW3zeLjys1ZB4qn3lDNFjGBQxL66vMr/XUkEDCZpxCHpwjXB7mT8jIad8hLUvpDzLV47F6eFqh7/m/NaWE5LLZ4sBo0Kc9smnD9TqQOgwEvNegaAE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768496251; c=relaxed/simple;
	bh=7REO/mKc2xGslM2d5tugbKBcDJCIWAhZ4O7XZpXs244=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Tgw2v87fo+qNWRNNOIiAH9WVDn2KfPpd6YXxopmzQ2EUAN+xW4zEzNvtGyFtMoBk1hV95ck7Doie3dPYzalzGfxEJm27scaOG6fXENpJoxTLAml7ZcqZsc72qtz75wWl8qtMII1vn5uTTkbLnMW5txnzMi/4ZATpgg7DTZzPNQE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=c122WXN0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="c122WXN0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F9EBC19422;
	Thu, 15 Jan 2026 16:57:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768496251;
	bh=7REO/mKc2xGslM2d5tugbKBcDJCIWAhZ4O7XZpXs244=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=c122WXN0pc8SXha2Ew+RXSG6VFBrXWBWfajuWEHNov9kIVO+Uya+ppYqDmF1PA05b
	 FxZABzfnxHtRIqVqPGOo+3UkzFlKiBHq9WBx8S3kgvRHJPlTUwMKMoiK44mOkG/e9I
	 Ta6x1wRwBXNr1HCjNaExH72i8m898D/Xey47GkGk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Erik Gabriel Carrillo <erik.g.carrillo@intel.com>,
	Sreedevi Joshi <sreedevi.joshi@intel.com>,
	Przemek Kitszel <przemyslaw.kitszel@intel.com>,
	Aleksandr Loktionov <aleksandr.loktionov@intel.com>,
	Simon Horman <horms@kernel.org>,
	Mina Almasry <almasrymina@google.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 130/181] idpf: fix issue with ethtool -n command display
Date: Thu, 15 Jan 2026 17:47:47 +0100
Message-ID: <20260115164207.013309267@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164202.305475649@linuxfoundation.org>
References: <20260115164202.305475649@linuxfoundation.org>
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

From: Erik Gabriel Carrillo <erik.g.carrillo@intel.com>

[ Upstream commit 36aae2ea6bd76b8246caa50e34a4f4824f0a3be8 ]

When ethtool -n is executed on an interface to display the flow steering
rules, "rxclass: Unknown flow type" error is generated.

The flow steering list maintained in the driver currently stores only the
location and q_index but other fields of the ethtool_rx_flow_spec are not
stored. This may be enough for the virtchnl command to delete the entry.
However, when the ethtool -n command is used to query the flow steering
rules, the ethtool_rx_flow_spec returned is not complete causing the
error below.

Resolve this by storing the flow spec (fsp) when rules are added and
returning the complete flow spec when rules are queried.

Also, change the return value from EINVAL to ENOENT when flow steering
entry is not found during query by location or when deleting an entry.

Add logic to detect and reject duplicate filter entries at the same
location and change logic to perform upfront validation of all error
conditions before adding flow rules through virtchnl. This avoids the
need for additional virtchnl delete messages when subsequent operations
fail, which was missing in the original upstream code.

Example:
Before the fix:
ethtool -n eth1
2 RX rings available
Total 2 rules

rxclass: Unknown flow type
rxclass: Unknown flow type

After the fix:
ethtool -n eth1
2 RX rings available
Total 2 rules

Filter: 0
        Rule Type: TCP over IPv4
        Src IP addr: 10.0.0.1 mask: 0.0.0.0
        Dest IP addr: 0.0.0.0 mask: 255.255.255.255
        TOS: 0x0 mask: 0xff
        Src port: 0 mask: 0xffff
        Dest port: 0 mask: 0xffff
        Action: Direct to queue 0

Filter: 1
        Rule Type: UDP over IPv4
        Src IP addr: 10.0.0.1 mask: 0.0.0.0
        Dest IP addr: 0.0.0.0 mask: 255.255.255.255
        TOS: 0x0 mask: 0xff
        Src port: 0 mask: 0xffff
        Dest port: 0 mask: 0xffff
        Action: Direct to queue 0

Fixes: ada3e24b84a0 ("idpf: add flow steering support")
Signed-off-by: Erik Gabriel Carrillo <erik.g.carrillo@intel.com>
Co-developed-by: Sreedevi Joshi <sreedevi.joshi@intel.com>
Signed-off-by: Sreedevi Joshi <sreedevi.joshi@intel.com>
Reviewed-by: Przemek Kitszel <przemyslaw.kitszel@intel.com>
Reviewed-by: Aleksandr Loktionov <aleksandr.loktionov@intel.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Tested-by: Mina Almasry <almasrymina@google.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/idpf/idpf.h        |  3 +-
 .../net/ethernet/intel/idpf/idpf_ethtool.c    | 59 ++++++++++++-------
 2 files changed, 40 insertions(+), 22 deletions(-)

diff --git a/drivers/net/ethernet/intel/idpf/idpf.h b/drivers/net/ethernet/intel/idpf/idpf.h
index af8deb5fa80f0..df64d252b5642 100644
--- a/drivers/net/ethernet/intel/idpf/idpf.h
+++ b/drivers/net/ethernet/intel/idpf/idpf.h
@@ -284,8 +284,7 @@ struct idpf_port_stats {
 
 struct idpf_fsteer_fltr {
 	struct list_head list;
-	u32 loc;
-	u32 q_index;
+	struct ethtool_rx_flow_spec fs;
 };
 
 /**
diff --git a/drivers/net/ethernet/intel/idpf/idpf_ethtool.c b/drivers/net/ethernet/intel/idpf/idpf_ethtool.c
index 8477e7ba28706..8e9a93125b4aa 100644
--- a/drivers/net/ethernet/intel/idpf/idpf_ethtool.c
+++ b/drivers/net/ethernet/intel/idpf/idpf_ethtool.c
@@ -38,11 +38,15 @@ static int idpf_get_rxnfc(struct net_device *netdev, struct ethtool_rxnfc *cmd,
 		cmd->data = idpf_fsteer_max_rules(vport);
 		break;
 	case ETHTOOL_GRXCLSRULE:
-		err = -EINVAL;
+		err = -ENOENT;
 		spin_lock_bh(&vport_config->flow_steer_list_lock);
 		list_for_each_entry(f, &user_config->flow_steer_list, list)
-			if (f->loc == cmd->fs.location) {
-				cmd->fs.ring_cookie = f->q_index;
+			if (f->fs.location == cmd->fs.location) {
+				/* Avoid infoleak from padding: zero first,
+				 * then assign fields
+				 */
+				memset(&cmd->fs, 0, sizeof(cmd->fs));
+				cmd->fs = f->fs;
 				err = 0;
 				break;
 			}
@@ -56,7 +60,7 @@ static int idpf_get_rxnfc(struct net_device *netdev, struct ethtool_rxnfc *cmd,
 				err = -EMSGSIZE;
 				break;
 			}
-			rule_locs[cnt] = f->loc;
+			rule_locs[cnt] = f->fs.location;
 			cnt++;
 		}
 		if (!err)
@@ -158,7 +162,7 @@ static int idpf_add_flow_steer(struct net_device *netdev,
 	struct idpf_vport *vport;
 	u32 flow_type, q_index;
 	u16 num_rxq;
-	int err;
+	int err = 0;
 
 	vport = idpf_netdev_to_vport(netdev);
 	vport_config = vport->adapter->vport_config[np->vport_idx];
@@ -184,6 +188,29 @@ static int idpf_add_flow_steer(struct net_device *netdev,
 	if (!rule)
 		return -ENOMEM;
 
+	fltr = kzalloc(sizeof(*fltr), GFP_KERNEL);
+	if (!fltr) {
+		err = -ENOMEM;
+		goto out_free_rule;
+	}
+
+	/* detect duplicate entry and reject before adding rules */
+	spin_lock_bh(&vport_config->flow_steer_list_lock);
+	list_for_each_entry(f, &user_config->flow_steer_list, list) {
+		if (f->fs.location == fsp->location) {
+			err = -EEXIST;
+			break;
+		}
+
+		if (f->fs.location > fsp->location)
+			break;
+		parent = f;
+	}
+	spin_unlock_bh(&vport_config->flow_steer_list_lock);
+
+	if (err)
+		goto out;
+
 	rule->vport_id = cpu_to_le32(vport->vport_id);
 	rule->count = cpu_to_le32(1);
 	info = &rule->rule_info[0];
@@ -222,28 +249,20 @@ static int idpf_add_flow_steer(struct net_device *netdev,
 		goto out;
 	}
 
-	fltr = kzalloc(sizeof(*fltr), GFP_KERNEL);
-	if (!fltr) {
-		err = -ENOMEM;
-		goto out;
-	}
+	/* Save a copy of the user's flow spec so ethtool can later retrieve it */
+	fltr->fs = *fsp;
 
-	fltr->loc = fsp->location;
-	fltr->q_index = q_index;
 	spin_lock_bh(&vport_config->flow_steer_list_lock);
-	list_for_each_entry(f, &user_config->flow_steer_list, list) {
-		if (f->loc >= fltr->loc)
-			break;
-		parent = f;
-	}
-
 	parent ? list_add(&fltr->list, &parent->list) :
 		 list_add(&fltr->list, &user_config->flow_steer_list);
 
 	user_config->num_fsteer_fltrs++;
 	spin_unlock_bh(&vport_config->flow_steer_list_lock);
+	goto out_free_rule;
 
 out:
+	kfree(fltr);
+out_free_rule:
 	kfree(rule);
 	return err;
 }
@@ -297,14 +316,14 @@ static int idpf_del_flow_steer(struct net_device *netdev,
 	spin_lock_bh(&vport_config->flow_steer_list_lock);
 	list_for_each_entry_safe(f, iter,
 				 &user_config->flow_steer_list, list) {
-		if (f->loc == fsp->location) {
+		if (f->fs.location == fsp->location) {
 			list_del(&f->list);
 			kfree(f);
 			user_config->num_fsteer_fltrs--;
 			goto out_unlock;
 		}
 	}
-	err = -EINVAL;
+	err = -ENOENT;
 
 out_unlock:
 	spin_unlock_bh(&vport_config->flow_steer_list_lock);
-- 
2.51.0



