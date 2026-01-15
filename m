Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6D253BF306;
	Thu, 15 Jan 2026 16:57:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768496259; cv=none; b=l2w/bg1ofrFxMpWimLm8jimXQx7tC0XnzvZAxfPjJLEuqoewEi3zJYi5Qvn2kJ5BRmoNJEJWAoi4INxzb6Ieey3bcNxecpEOC18lx/G1VZpA+QpUHpm5YrCffNjpKxeNkU7XImaGFfnw347e6F6fd1rrKIC7TsXs0msAmK71AGo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768496259; c=relaxed/simple;
	bh=1nkLWtqMlQjU+blhbBICwB3JS08f4+Okk1XEsWg/LH4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QWtUGuOkpEsfARoZ5Djcp1IaYAavJJ2FJ0RGyOlNEXh3traACjyjfpGL24rhzqL5e2bDRzrmNKq+PtSRRb91DX1GZQ6KVfFgVFVcY4h/XmcU3NlUTnOM7CLZ9WOpbc9+cnBj3gZPM1G09IWr79Cpddvws1FkVGDE12BU3RKLtk4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Z1AXrnF1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Z1AXrnF1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34CE5C116D0;
	Thu, 15 Jan 2026 16:57:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768496259;
	bh=1nkLWtqMlQjU+blhbBICwB3JS08f4+Okk1XEsWg/LH4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Z1AXrnF1TB6kzXZV9LUbgpgrQs3MkM85Sq4GvpCYJbKvGzP4tdw14zPIazWs3pMin
	 lgYlaWdw8OMoqGMR0xl1/gNurspsqBZBsIx6xz4xArWFwoHuRwzERh/dvvADdzvOF0
	 WELo7BrjjwCFD4rEWGkyJ2sc8EPojSbHx6RU/59g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sreedevi Joshi <sreedevi.joshi@intel.com>,
	Aleksandr Loktionov <aleksandr.loktionov@intel.com>,
	Sridhar Samudrala <sridhar.samudrala@intel.com>,
	Emil Tantilov <emil.s.tantilov@intel.com>,
	Simon Horman <horms@kernel.org>,
	Samuel Salin <Samuel.salin@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 133/181] idpf: Fix RSS LUT NULL ptr issue after soft reset
Date: Thu, 15 Jan 2026 17:47:50 +0100
Message-ID: <20260115164207.123108515@linuxfoundation.org>
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

From: Sreedevi Joshi <sreedevi.joshi@intel.com>

[ Upstream commit ebecca5b093895da801b3eba1a55b4ec4027d196 ]

During soft reset, the RSS LUT is freed and not restored unless the
interface is up. If an ethtool command that accesses the rss lut is
attempted immediately after reset, it will result in NULL ptr
dereference. Also, there is no need to reset the rss lut if the soft reset
does not involve queue count change.

After soft reset, set the RSS LUT to default values based on the updated
queue count only if the reset was a result of a queue count change and
the LUT was not configured by the user. In all other cases, don't touch
the LUT.

Steps to reproduce:

** Bring the interface down (if up)
ifconfig eth1 down

** update the queue count (eg., 27->20)
ethtool -L eth1 combined 20

** display the RSS LUT
ethtool -x eth1

[82375.558338] BUG: kernel NULL pointer dereference, address: 0000000000000000
[82375.558373] #PF: supervisor read access in kernel mode
[82375.558391] #PF: error_code(0x0000) - not-present page
[82375.558408] PGD 0 P4D 0
[82375.558421] Oops: Oops: 0000 [#1] SMP NOPTI
<snip>
[82375.558516] RIP: 0010:idpf_get_rxfh+0x108/0x150 [idpf]
[82375.558786] Call Trace:
[82375.558793]  <TASK>
[82375.558804]  rss_prepare.isra.0+0x187/0x2a0
[82375.558827]  rss_prepare_data+0x3a/0x50
[82375.558845]  ethnl_default_doit+0x13d/0x3e0
[82375.558863]  genl_family_rcv_msg_doit+0x11f/0x180
[82375.558886]  genl_rcv_msg+0x1ad/0x2b0
[82375.558902]  ? __pfx_ethnl_default_doit+0x10/0x10
[82375.558920]  ? __pfx_genl_rcv_msg+0x10/0x10
[82375.558937]  netlink_rcv_skb+0x58/0x100
[82375.558957]  genl_rcv+0x2c/0x50
[82375.558971]  netlink_unicast+0x289/0x3e0
[82375.558988]  netlink_sendmsg+0x215/0x440
[82375.559005]  __sys_sendto+0x234/0x240
[82375.559555]  __x64_sys_sendto+0x28/0x30
[82375.560068]  x64_sys_call+0x1909/0x1da0
[82375.560576]  do_syscall_64+0x7a/0xfa0
[82375.561076]  ? clear_bhb_loop+0x60/0xb0
[82375.561567]  entry_SYSCALL_64_after_hwframe+0x76/0x7e
<snip>

Fixes: 02cbfba1add5 ("idpf: add ethtool callbacks")
Signed-off-by: Sreedevi Joshi <sreedevi.joshi@intel.com>
Reviewed-by: Aleksandr Loktionov <aleksandr.loktionov@intel.com>
Reviewed-by: Sridhar Samudrala <sridhar.samudrala@intel.com>
Reviewed-by: Emil Tantilov <emil.s.tantilov@intel.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Tested-by: Samuel Salin <Samuel.salin@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/idpf/idpf_lib.c  | 20 ++++----------------
 drivers/net/ethernet/intel/idpf/idpf_txrx.c |  2 +-
 drivers/net/ethernet/intel/idpf/idpf_txrx.h |  1 +
 3 files changed, 6 insertions(+), 17 deletions(-)

diff --git a/drivers/net/ethernet/intel/idpf/idpf_lib.c b/drivers/net/ethernet/intel/idpf/idpf_lib.c
index 51716e5a84ef3..003bab3ce5ae6 100644
--- a/drivers/net/ethernet/intel/idpf/idpf_lib.c
+++ b/drivers/net/ethernet/intel/idpf/idpf_lib.c
@@ -1484,8 +1484,6 @@ static int idpf_vport_open(struct idpf_vport *vport, bool rtnl)
 {
 	struct idpf_netdev_priv *np = netdev_priv(vport->netdev);
 	struct idpf_adapter *adapter = vport->adapter;
-	struct idpf_vport_config *vport_config;
-	struct idpf_rss_data *rss_data;
 	int err;
 
 	if (test_bit(IDPF_VPORT_UP, np->state))
@@ -1579,19 +1577,6 @@ static int idpf_vport_open(struct idpf_vport *vport, bool rtnl)
 
 	idpf_restore_features(vport);
 
-	vport_config = adapter->vport_config[vport->idx];
-	rss_data = &vport_config->user_config.rss_data;
-
-	if (!rss_data->rss_lut) {
-		err = idpf_init_rss_lut(vport);
-		if (err) {
-			dev_err(&adapter->pdev->dev,
-				"Failed to initialize RSS LUT for vport %u: %d\n",
-				vport->vport_id, err);
-			goto disable_vport;
-		}
-	}
-
 	err = idpf_config_rss(vport);
 	if (err) {
 		dev_err(&adapter->pdev->dev, "Failed to configure RSS for vport %u: %d\n",
@@ -2068,7 +2053,6 @@ int idpf_initiate_soft_reset(struct idpf_vport *vport,
 		idpf_vport_stop(vport, false);
 	}
 
-	idpf_deinit_rss_lut(vport);
 	/* We're passing in vport here because we need its wait_queue
 	 * to send a message and it should be getting all the vport
 	 * config data out of the adapter but we need to be careful not
@@ -2094,6 +2078,10 @@ int idpf_initiate_soft_reset(struct idpf_vport *vport,
 	if (err)
 		goto err_open;
 
+	if (reset_cause == IDPF_SR_Q_CHANGE &&
+	    !netif_is_rxfh_configured(vport->netdev))
+		idpf_fill_dflt_rss_lut(vport);
+
 	if (vport_is_up)
 		err = idpf_vport_open(vport, false);
 
diff --git a/drivers/net/ethernet/intel/idpf/idpf_txrx.c b/drivers/net/ethernet/intel/idpf/idpf_txrx.c
index 39553689ffdbf..3698979b4c9ee 100644
--- a/drivers/net/ethernet/intel/idpf/idpf_txrx.c
+++ b/drivers/net/ethernet/intel/idpf/idpf_txrx.c
@@ -4641,7 +4641,7 @@ int idpf_config_rss(struct idpf_vport *vport)
  * idpf_fill_dflt_rss_lut - Fill the indirection table with the default values
  * @vport: virtual port structure
  */
-static void idpf_fill_dflt_rss_lut(struct idpf_vport *vport)
+void idpf_fill_dflt_rss_lut(struct idpf_vport *vport)
 {
 	struct idpf_adapter *adapter = vport->adapter;
 	u16 num_active_rxq = vport->num_rxq;
diff --git a/drivers/net/ethernet/intel/idpf/idpf_txrx.h b/drivers/net/ethernet/intel/idpf/idpf_txrx.h
index 7d20593bd8778..0472698ca1927 100644
--- a/drivers/net/ethernet/intel/idpf/idpf_txrx.h
+++ b/drivers/net/ethernet/intel/idpf/idpf_txrx.h
@@ -1085,6 +1085,7 @@ void idpf_vport_intr_update_itr_ena_irq(struct idpf_q_vector *q_vector);
 void idpf_vport_intr_deinit(struct idpf_vport *vport);
 int idpf_vport_intr_init(struct idpf_vport *vport);
 void idpf_vport_intr_ena(struct idpf_vport *vport);
+void idpf_fill_dflt_rss_lut(struct idpf_vport *vport);
 int idpf_config_rss(struct idpf_vport *vport);
 int idpf_init_rss_lut(struct idpf_vport *vport);
 void idpf_deinit_rss_lut(struct idpf_vport *vport);
-- 
2.51.0



