Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62CD928E00
	for <patches@lists.linux.dev>; Wed, 20 Sep 2023 11:54:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D2E3C433C9;
	Wed, 20 Sep 2023 11:54:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1695210849;
	bh=Crd/yO4pvY57kYT6TCwojIGXsUtmVlvGg6Yq/1aY7EQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HCYhY3MvyfBh64hAQ8VIU65kUUqQSuk3fm7Oc0E6iKt4GNnyOhmdflRtXeqmlgr5N
	 VPNaFXNjv/Iy1GT8eFAoKCtr16Haz3vdVEvXAXa3r3t9F/jFnwUUZ0A/zeZceyt12o
	 RdUZ8mp+M7x8LgpnOz1V9rnC1QJtveoIKWEYqLTk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paul Menzel <pmenzel@molgen.mpg.de>,
	Simon Horman <simon.horman@corigine.com>,
	Wojciech Drewek <wojciech.drewek@intel.com>,
	Sujai Buvaneswaran <sujai.buvaneswaran@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 016/139] ice: Dont tx before switchdev is fully configured
Date: Wed, 20 Sep 2023 13:29:10 +0200
Message-ID: <20230920112836.211127534@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230920112835.549467415@linuxfoundation.org>
References: <20230920112835.549467415@linuxfoundation.org>
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

From: Wojciech Drewek <wojciech.drewek@intel.com>

[ Upstream commit 7aa529a69e92b9aff585e569d5003f7c15d8d60b ]

There is possibility that ice_eswitch_port_start_xmit might be
called while some resources are still not allocated which might
cause NULL pointer dereference. Fix this by checking if switchdev
configuration was finished.

Reviewed-by: Paul Menzel <pmenzel@molgen.mpg.de>
Reviewed-by: Simon Horman <simon.horman@corigine.com>
Signed-off-by: Wojciech Drewek <wojciech.drewek@intel.com>
Tested-by: Sujai Buvaneswaran <sujai.buvaneswaran@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ice/ice_eswitch.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/intel/ice/ice_eswitch.c b/drivers/net/ethernet/intel/ice/ice_eswitch.c
index 2ffe5708a045b..7de4a8a4b563c 100644
--- a/drivers/net/ethernet/intel/ice/ice_eswitch.c
+++ b/drivers/net/ethernet/intel/ice/ice_eswitch.c
@@ -361,6 +361,9 @@ ice_eswitch_port_start_xmit(struct sk_buff *skb, struct net_device *netdev)
 	np = netdev_priv(netdev);
 	vsi = np->vsi;
 
+	if (!vsi || !ice_is_switchdev_running(vsi->back))
+		return NETDEV_TX_BUSY;
+
 	if (ice_is_reset_in_progress(vsi->back->state) ||
 	    test_bit(ICE_VF_DIS, vsi->back->state))
 		return NETDEV_TX_BUSY;
-- 
2.40.1



