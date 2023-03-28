Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F6E28BE0
	for <patches@lists.linux.dev>; Tue, 28 Mar 2023 14:48:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A570CC433A0;
	Tue, 28 Mar 2023 14:48:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1680014914;
	bh=ISMggMAqZfVE8egSemnM++tBJ/ydcvQ+e/J19MumQ5U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=O0Z6Dgd5aqPGaIo6er3UVjtjPTOuVgOnYJLzUv/wB6o7nC5BVI4sJFUs0RHcyvLu/
	 cUStIYgrkh54gWpu6b/Ua1S+a656JfjlqVNocS7v6gxtgNFYzov7MC4hTgpghKBZLe
	 luvci45g/x9mG4cCM0jsmAfu6xeknVlKsKgiVWms=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michal Swiatkowski <michal.swiatkowski@intel.com>,
	Kalyan Kodamagula <kalyan.kodamagula@intel.com>,
	Sujai Buvaneswaran <sujai.buvaneswaran@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 068/240] ice: check if VF exists before mode check
Date: Tue, 28 Mar 2023 16:40:31 +0200
Message-Id: <20230328142622.570231611@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230328142619.643313678@linuxfoundation.org>
References: <20230328142619.643313678@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Michal Swiatkowski <michal.swiatkowski@intel.com>

[ Upstream commit 83b49e7f63da88a1544cba2b2e40bfabb24bd203 ]

Setting trust on VF should return EINVAL when there is no VF. Move
checking for switchdev mode after checking if VF exists.

Fixes: c54d209c78b8 ("ice: Wait for VF to be reset/ready before configuration")
Signed-off-by: Michal Swiatkowski <michal.swiatkowski@intel.com>
Signed-off-by: Kalyan Kodamagula <kalyan.kodamagula@intel.com>
Tested-by: Sujai Buvaneswaran <sujai.buvaneswaran@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ice/ice_sriov.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_sriov.c b/drivers/net/ethernet/intel/ice/ice_sriov.c
index 3ba1408c56a9a..b3849bc3d4fc6 100644
--- a/drivers/net/ethernet/intel/ice/ice_sriov.c
+++ b/drivers/net/ethernet/intel/ice/ice_sriov.c
@@ -1384,15 +1384,15 @@ int ice_set_vf_trust(struct net_device *netdev, int vf_id, bool trusted)
 	struct ice_vf *vf;
 	int ret;
 
+	vf = ice_get_vf_by_id(pf, vf_id);
+	if (!vf)
+		return -EINVAL;
+
 	if (ice_is_eswitch_mode_switchdev(pf)) {
 		dev_info(ice_pf_to_dev(pf), "Trusted VF is forbidden in switchdev mode\n");
 		return -EOPNOTSUPP;
 	}
 
-	vf = ice_get_vf_by_id(pf, vf_id);
-	if (!vf)
-		return -EINVAL;
-
 	ret = ice_check_vf_ready_for_cfg(vf);
 	if (ret)
 		goto out_put_vf;
-- 
2.39.2



