Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05CAE19FA9D;
	Thu,  6 Jun 2024 14:20:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683634; cv=none; b=ItaYXRBy0OxdZpvXwHQFzEDustL99gcWEyudV4+qARvzasbu+WAevE1729hjjUtF/amRpD4p8IhlICxmiIKebtCDtSRah09C6FM1ALEf9G6O5PzbcismuOvCsPZHuGyDmnjL+vV9RgYIvPnJ1LbyjNqDWw835iKR8pFn35gU8AQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683634; c=relaxed/simple;
	bh=bNW87ASMCZ2dlJvzeSKssS5qRsdnHGQsREU/mmrM5e8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MpzF8WLIrcn5iQOhN0aIIIJpCb1ct+6DhteYM9N/ISYpyIRNNGDWmtmvSu6pYl3BDsmy2oLDbFEgCyPjYvyqzNFvwMDh5Vd54HmLAOlZ3QskZGJfmOBYKbGnXpbzXIZpJEGxYR9NOgVHtUiUr4ne5zGaqtRGbbaAYGh3mHqJFVk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Yz+jeiWo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Yz+jeiWo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82F8FC2BD10;
	Thu,  6 Jun 2024 14:20:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683633;
	bh=bNW87ASMCZ2dlJvzeSKssS5qRsdnHGQsREU/mmrM5e8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Yz+jeiWoVl0JSphX0vfLfRRsilbv10Rx4WJgojjsi+H95qx2+rsFnnHFm5PnEg3tk
	 gdtTXsQpdZp0RfjutfqUjfMPl6IXjYeX2Lz3hzegclNFM4JimQHL+h21v3MbTYUXRp
	 mNMFBUg71w2/L+unGOzoDimJYGz2ePsxfLObsFjA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jacob Keller <jacob.e.keller@intel.com>,
	Pucha Himasekhar Reddy <himasekharx.reddy.pucha@intel.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 454/473] ice: fix accounting if a VLAN already exists
Date: Thu,  6 Jun 2024 16:06:23 +0200
Message-ID: <20240606131714.705834078@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131659.786180261@linuxfoundation.org>
References: <20240606131659.786180261@linuxfoundation.org>
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

From: Jacob Keller <jacob.e.keller@intel.com>

[ Upstream commit 82617b9a04649e83ee8731918aeadbb6e6d7cbc7 ]

The ice_vsi_add_vlan() function is used to add a VLAN filter for the target
VSI. This function prepares a filter in the switch table for the given VSI.
If it succeeds, the vsi->num_vlan counter is incremented.

It is not considered an error to add a VLAN which already exists in the
switch table, so the function explicitly checks and ignores -EEXIST. The
vsi->num_vlan counter is still incremented.

This seems incorrect, as it means we can double-count in the case where the
same VLAN is added twice by the caller. The actual table will have one less
filter than the count.

The ice_vsi_del_vlan() function similarly checks and handles the -ENOENT
condition for when deleting a filter that doesn't exist. This flow only
decrements the vsi->num_vlan if it actually deleted a filter.

The vsi->num_vlan counter is used only in a few places, primarily related
to tracking the number of non-zero VLANs. If the vsi->num_vlans gets out of
sync, then ice_vsi_num_non_zero_vlans() will incorrectly report more VLANs
than are present, and ice_vsi_has_non_zero_vlans() could return true
potentially in cases where there are only VLAN 0 filters left.

Fix this by only incrementing the vsi->num_vlan in the case where we
actually added an entry, and not in the case where the entry already
existed.

Fixes: a1ffafb0b4a4 ("ice: Support configuring the device to Double VLAN Mode")
Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Tested-by: Pucha Himasekhar Reddy <himasekharx.reddy.pucha@intel.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://lore.kernel.org/r/20240523-net-2024-05-23-intel-net-fixes-v1-2-17a923e0bb5f@intel.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ice/ice_vsi_vlan_lib.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_vsi_vlan_lib.c b/drivers/net/ethernet/intel/ice/ice_vsi_vlan_lib.c
index 239266e9d5f12..80c16e04f6702 100644
--- a/drivers/net/ethernet/intel/ice/ice_vsi_vlan_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_vsi_vlan_lib.c
@@ -45,14 +45,15 @@ int ice_vsi_add_vlan(struct ice_vsi *vsi, struct ice_vlan *vlan)
 		return -EINVAL;
 
 	err = ice_fltr_add_vlan(vsi, vlan);
-	if (err && err != -EEXIST) {
+	if (!err)
+		vsi->num_vlan++;
+	else if (err == -EEXIST)
+		err = 0;
+	else
 		dev_err(ice_pf_to_dev(vsi->back), "Failure Adding VLAN %d on VSI %i, status %d\n",
 			vlan->vid, vsi->vsi_num, err);
-		return err;
-	}
 
-	vsi->num_vlan++;
-	return 0;
+	return err;
 }
 
 /**
-- 
2.43.0



