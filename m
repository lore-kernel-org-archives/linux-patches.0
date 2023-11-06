Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B08672374A
	for <patches@lists.linux.dev>; Mon,  6 Nov 2023 13:24:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zG3EJkEA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AD3EC433C8;
	Mon,  6 Nov 2023 13:24:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1699277060;
	bh=aVVCg6AFL+E0Xlbcua7v3xG1WcJlLsw0h++pLnehdPE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zG3EJkEAr9hAe5EeJrQkgH+cEsfOF2kRqIGDCOpfheVYqMp1EHtH4SyX096tEcIsL
	 ewm84ECDPuwhfK3viFyT3FmFSmIB+I7m8Ad0vI3WX9wbf3UZe2jRZ3gdaLDpQBo8Hd
	 tOb0HVlq3fQT68JcttdGk1taU+Xnadu4WPcIzLHk=
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
Subject: [PATCH 5.15 024/128] i40e: Fix I40E_FLAG_VF_VLAN_PRUNING value
Date: Mon,  6 Nov 2023 14:03:04 +0100
Message-ID: <20231106130310.223308642@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231106130309.112650042@linuxfoundation.org>
References: <20231106130309.112650042@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index b76e6f94edb05..22802222d34d1 100644
--- a/drivers/net/ethernet/intel/i40e/i40e.h
+++ b/drivers/net/ethernet/intel/i40e/i40e.h
@@ -566,7 +566,6 @@ struct i40e_pf {
 #define I40E_FLAG_DISABLE_FW_LLDP		BIT(24)
 #define I40E_FLAG_RS_FEC			BIT(25)
 #define I40E_FLAG_BASE_R_FEC			BIT(26)
-#define I40E_FLAG_VF_VLAN_PRUNING		BIT(27)
 /* TOTAL_PORT_SHUTDOWN
  * Allows to physically disable the link on the NIC's port.
  * If enabled, (after link down request from the OS)
@@ -589,6 +588,7 @@ struct i40e_pf {
  *   in abilities field of i40e_aq_set_phy_config structure
  */
 #define I40E_FLAG_TOTAL_PORT_SHUTDOWN_ENABLED	BIT(27)
+#define I40E_FLAG_VF_VLAN_PRUNING		BIT(28)
 
 	struct i40e_client_instance *cinst;
 	bool stat_offsets_loaded;
-- 
2.42.0



