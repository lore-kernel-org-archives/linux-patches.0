Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC9EA19D082;
	Thu,  6 Jun 2024 14:11:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683085; cv=none; b=mDSnayqQ3SQGWrqcyFfXYhd1Z7PRvMqy0O32ic1j3ezdLS8fMjtHlPNKQixYdcPp0g2XU94UhR30FqjWT6vk7RAnGVFd6IxoXFOQ07n3HngVjBjf5hFwfdOCtIwuytr12DHABACv412QZSIU6KnQa1rqI+PZ3PFJr/AgAhr/Apw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683085; c=relaxed/simple;
	bh=lNSPcU2XwUVeuhVhxO45z0CBsESpO6RNcE3w2HfcOV4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p1ddnh0TJZhvhsxz1rlaapHQBZTgvmRWdCOShRkZZBAb2XLlzecb6RqbcfgK58VYOKGoFN4fqpuQQJkREa1S854qCfH3FJWtf0eiADP5sIG9j5ZwEutg32+DLLahXY4cAbOtlFwk2p0FtXoyBhjylTsadffewnl2++DsS7KXPME=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jBhGqi5P; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jBhGqi5P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B3F6C32782;
	Thu,  6 Jun 2024 14:11:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683085;
	bh=lNSPcU2XwUVeuhVhxO45z0CBsESpO6RNcE3w2HfcOV4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jBhGqi5Pw7M6ji+eLUVg1IJnR5XVJDVjIP2or05xIw5vQx1NgwCKpN1IrLjAgy1xu
	 GqlIyXz6xAqbIJVoVNQ2TTjtnvytw+KFdYIubeuoOlYwPyZX4LwjbdDXzULbnRxI9S
	 dRU8OIa2coEakWdGx55GKEIj9gxYB3jWvsCGZoR4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jacob Keller <jacob.e.keller@intel.com>,
	Pucha Himasekhar Reddy <himasekharx.reddy.pucha@intel.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 321/374] ice: fix accounting if a VLAN already exists
Date: Thu,  6 Jun 2024 16:05:00 +0200
Message-ID: <20240606131702.620511390@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131651.683718371@linuxfoundation.org>
References: <20240606131651.683718371@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

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
index 2e9ad27cb9d13..6e8f2aab60801 100644
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



