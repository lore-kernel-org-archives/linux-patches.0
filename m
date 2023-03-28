Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4354B8BE0
	for <patches@lists.linux.dev>; Tue, 28 Mar 2023 14:57:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9E8EC433D2;
	Tue, 28 Mar 2023 14:57:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1680015467;
	bh=ISMggMAqZfVE8egSemnM++tBJ/ydcvQ+e/J19MumQ5U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=i+EoQt5QX9D+Jc05ZGxeu+x0Hahn7VV1mTWSm2HEt9kBPsXOqyRPmCfR9fIVC24MG
	 IeBl/RyrgxqI9ClAps9WkYpngC9uduRBtw/E4Le+B9SxJpShlZrSCuv8p5s2zHM8EG
	 8M9jBGVSuBy/1Z23rMhm7D5A0GOB8xV635nDh7UA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michal Swiatkowski <michal.swiatkowski@intel.com>,
	Kalyan Kodamagula <kalyan.kodamagula@intel.com>,
	Sujai Buvaneswaran <sujai.buvaneswaran@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 060/224] ice: check if VF exists before mode check
Date: Tue, 28 Mar 2023 16:40:56 +0200
Message-Id: <20230328142619.859265291@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230328142617.205414124@linuxfoundation.org>
References: <20230328142617.205414124@linuxfoundation.org>
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



