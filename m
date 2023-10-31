Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 512762031C
	for <patches@lists.linux.dev>; Tue, 31 Oct 2023 17:03:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Lxapy8xU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE5F0C433C7;
	Tue, 31 Oct 2023 17:03:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1698771839;
	bh=IONTAcN3lQJ/owzFfnxSzRZqqgvcYVvVBzc0/X7wQxc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Lxapy8xUdm1/JJmDIXQ+dnvs+WCEP0JkaB0YjhTepY905BlYj8jCM4cPVRJCUlBZI
	 bQ4w6bQQDg98IZ2hmq3zYrbnyUHnQ7smjuy+bbxsCKxdmIkUKgpydGTX4YVZNqy0rk
	 o6iYocoUdeL3YUrBkSU15m5Ps0U3Z+AqzjaqxV80=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mateusz Palczewski <mateusz.palczewski@intel.com>,
	Simon Horman <horms@kernel.org>,
	Ivan Vecera <ivecera@redhat.com>,
	Jacob Keller <jacob.e.keller@intel.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>,
	Pucha Himasekhar Reddy <himasekharx.reddy.pucha@intel.com>
Subject: [PATCH 6.1 38/86] i40e: Fix I40E_FLAG_VF_VLAN_PRUNING value
Date: Tue, 31 Oct 2023 18:01:03 +0100
Message-ID: <20231031165919.819925098@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231031165918.608547597@linuxfoundation.org>
References: <20231031165918.608547597@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ivan Vecera <ivecera@redhat.com>

[ Upstream commit 665e7d83c5386f9abdc67b2e4b6e6d9579aadfcb ]

Commit c87c938f62d8f1 ("i40e: Add VF VLAN pruning") added new
PF flag I40E_FLAG_VF_VLAN_PRUNING but its value collides with
existing I40E_FLAG_TOTAL_PORT_SHUTDOWN_ENABLED flag.

Move the affected flag at the end of the flags and fix its value.

Reproducer:
[root@cnb-03 ~]# ethtool --set-priv-flags enp2s0f0np0 link-down-on-close on
[root@cnb-03 ~]# ethtool --set-priv-flags enp2s0f0np0 vf-vlan-pruning on
[root@cnb-03 ~]# ethtool --set-priv-flags enp2s0f0np0 link-down-on-close off
[ 6323.142585] i40e 0000:02:00.0: Setting link-down-on-close not supported on this port (because total-port-shutdown is enabled)
netlink error: Operation not supported
[root@cnb-03 ~]# ethtool --set-priv-flags enp2s0f0np0 vf-vlan-pruning off
[root@cnb-03 ~]# ethtool --set-priv-flags enp2s0f0np0 link-down-on-close off

The link-down-on-close flag cannot be modified after setting vf-vlan-pruning
because vf-vlan-pruning shares the same bit with total-port-shutdown flag
that prevents any modification of link-down-on-close flag.

Fixes: c87c938f62d8 ("i40e: Add VF VLAN pruning")
Cc: Mateusz Palczewski <mateusz.palczewski@intel.com>
Cc: Simon Horman <horms@kernel.org>
Signed-off-by: Ivan Vecera <ivecera@redhat.com>
Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
Tested-by: Pucha Himasekhar Reddy <himasekharx.reddy.pucha@intel.com> (A Contingent worker at Intel)
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/i40e/i40e.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e.h b/drivers/net/ethernet/intel/i40e/i40e.h
index a81f918091ccf..7d4cc4eafd59e 100644
--- a/drivers/net/ethernet/intel/i40e/i40e.h
+++ b/drivers/net/ethernet/intel/i40e/i40e.h
@@ -580,7 +580,6 @@ struct i40e_pf {
 #define I40E_FLAG_DISABLE_FW_LLDP		BIT(24)
 #define I40E_FLAG_RS_FEC			BIT(25)
 #define I40E_FLAG_BASE_R_FEC			BIT(26)
-#define I40E_FLAG_VF_VLAN_PRUNING		BIT(27)
 /* TOTAL_PORT_SHUTDOWN
  * Allows to physically disable the link on the NIC's port.
  * If enabled, (after link down request from the OS)
@@ -603,6 +602,7 @@ struct i40e_pf {
  *   in abilities field of i40e_aq_set_phy_config structure
  */
 #define I40E_FLAG_TOTAL_PORT_SHUTDOWN_ENABLED	BIT(27)
+#define I40E_FLAG_VF_VLAN_PRUNING		BIT(28)
 
 	struct i40e_client_instance *cinst;
 	bool stat_offsets_loaded;
-- 
2.42.0



