Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D178D63BB
	for <patches@lists.linux.dev>; Mon, 20 Feb 2023 14:00:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54D7BC433EF;
	Mon, 20 Feb 2023 14:00:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1676901605;
	bh=RVAmsKFFqi1nPo2mQN1wZxx/J0Rv7F0X8WDNwR/eqQ4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SiyJ/5LAPPU0QIa6wapOybr3zz9rLrwTGpohNkcEGFaPlOBAT/ng10VNinUdGXXHF
	 6DEqye847YboJbfakPCY1y/FMjEZxGETWq3NXu/tx7Nac32p9qulU7YwCwa4mRj3mc
	 zEQrudPNRfR2xAWALJPISSxgbZUD7t/8L/sy9tZo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jesse Brandeburg <jesse.brandeburg@intel.com>,
	Rafal Romanowski <rafal.romanowski@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>
Subject: [PATCH 6.1 081/118] ice: fix lost multicast packets in promisc mode
Date: Mon, 20 Feb 2023 14:36:37 +0100
Message-Id: <20230220133603.646792610@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230220133600.368809650@linuxfoundation.org>
References: <20230220133600.368809650@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jesse Brandeburg <jesse.brandeburg@intel.com>

commit 43fbca02c2ddc39ff5879b6f3a4a097b1ba02098 upstream.

There was a problem reported to us where the addition of a VF with an IPv6
address ending with a particular sequence would cause the parent device on
the PF to no longer be able to respond to neighbor discovery packets.

In this case, we had an ovs-bridge device living on top of a VLAN, which
was on top of a PF, and it would not be able to talk anymore (the neighbor
entry would expire and couldn't be restored).

The root cause of the issue is that if the PF is asked to be in IFF_PROMISC
mode (promiscuous mode) and it had an ipv6 address that needed the
33:33:ff:00:00:04 multicast address to work, then when the VF was added
with the need for the same multicast address, the VF would steal all the
traffic destined for that address.

The ice driver didn't auto-subscribe a request of IFF_PROMISC to the
"multicast replication from other port's traffic" meaning that it won't get
for instance, packets with an exact destination in the VF, as above.

The VF's IPv6 address, which adds a "perfect filter" for 33:33:ff:00:00:04,
results in no packets for that multicast address making it to the PF (which
is in promisc but NOT "multicast replication").

The fix is to enable "multicast promiscuous" whenever the driver is asked
to enable IFF_PROMISC, and make sure to disable it when appropriate.

Fixes: e94d44786693 ("ice: Implement filter sync, NDO operations and bump version")
Signed-off-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
Tested-by: Rafal Romanowski <rafal.romanowski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/intel/ice/ice_main.c |   26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)

--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -270,6 +270,8 @@ static int ice_set_promisc(struct ice_vs
 	if (status && status != -EEXIST)
 		return status;
 
+	netdev_dbg(vsi->netdev, "set promisc filter bits for VSI %i: 0x%x\n",
+		   vsi->vsi_num, promisc_m);
 	return 0;
 }
 
@@ -295,6 +297,8 @@ static int ice_clear_promisc(struct ice_
 						    promisc_m, 0);
 	}
 
+	netdev_dbg(vsi->netdev, "clear promisc filter bits for VSI %i: 0x%x\n",
+		   vsi->vsi_num, promisc_m);
 	return status;
 }
 
@@ -423,6 +427,16 @@ static int ice_vsi_sync_fltr(struct ice_
 				}
 				err = 0;
 				vlan_ops->dis_rx_filtering(vsi);
+
+				/* promiscuous mode implies allmulticast so
+				 * that VSIs that are in promiscuous mode are
+				 * subscribed to multicast packets coming to
+				 * the port
+				 */
+				err = ice_set_promisc(vsi,
+						      ICE_MCAST_PROMISC_BITS);
+				if (err)
+					goto out_promisc;
 			}
 		} else {
 			/* Clear Rx filter to remove traffic from wire */
@@ -439,6 +453,18 @@ static int ice_vsi_sync_fltr(struct ice_
 				    NETIF_F_HW_VLAN_CTAG_FILTER)
 					vlan_ops->ena_rx_filtering(vsi);
 			}
+
+			/* disable allmulti here, but only if allmulti is not
+			 * still enabled for the netdev
+			 */
+			if (!(vsi->current_netdev_flags & IFF_ALLMULTI)) {
+				err = ice_clear_promisc(vsi,
+							ICE_MCAST_PROMISC_BITS);
+				if (err) {
+					netdev_err(netdev, "Error %d clearing multicast promiscuous on VSI %i\n",
+						   err, vsi->vsi_num);
+				}
+			}
 		}
 	}
 	goto exit;


