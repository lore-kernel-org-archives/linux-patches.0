Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3953B223DD1;
	Mon,  2 Jun 2025 14:22:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748874148; cv=none; b=iQsk5Y1VOPsjCGURFlue9j7SBOwKwBJpqlNL18jL+LGAplaWSqS+0AWj5d8JAxBQ+d5ZsL4EiA0pOQWTg/wIgl7AKzfj3wPq4KK4cRdNv7bUE8rPKi8kWrpM5eVrBUGWe2jXZCsBwQarETSlAnsmoTbr6dIV7lS0Z3LuDWlbhkM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748874148; c=relaxed/simple;
	bh=1oa70gD1QiTB9V25h6rJOxpTu0M4YBzMnMO/f8iRc5Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aIsb1eT1EBO1qEFjR6eAh4CJQdHQeT7uby8FX/vqGX/mJE/y3mbQFLSFwP2B/S7kaTUYcXRhSUIF58wL0H/56s025TjZi6Wq4YRkEkTjbzte9m8Xzz2/6d2OqXw2TTxTEWVjy20S1aeywEguEhtTr7TX7egr0KgnGIfY1L7OKvM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xvbP7X21; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xvbP7X21"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB01CC4CEEB;
	Mon,  2 Jun 2025 14:22:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748874148;
	bh=1oa70gD1QiTB9V25h6rJOxpTu0M4YBzMnMO/f8iRc5Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xvbP7X210XS+APgVWdsmHD7+DV3DmdWaJSMiJ0YelGvXm37x63OLXHqRtK9Wr7PW0
	 +jFvWKDzKa5AoGmUIy00pBBcmfP6zpLQX2T3XzOyqsXG7FOol6Jb8Irg5zcincjBtb
	 KhiTX6091z5ymUG+RLDhqTZzdJRYuSSJcmWjy6Jg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jacob Keller <jacob.e.keller@intel.com>,
	Michal Swiatkowski <michal.swiatkowski@linux.intel.com>,
	Simon Horman <horms@kernel.org>,
	Sujai Buvaneswaran <sujai.buvaneswaran@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 343/444] ice: fix vf->num_mac count with port representors
Date: Mon,  2 Jun 2025 15:46:47 +0200
Message-ID: <20250602134354.860902083@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134340.906731340@linuxfoundation.org>
References: <20250602134340.906731340@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jacob Keller <jacob.e.keller@intel.com>

[ Upstream commit bbd95160a03dbfcd01a541f25c27ddb730dfbbd5 ]

The ice_vc_repr_add_mac() function indicates that it does not store the MAC
address filters in the firmware. However, it still increments vf->num_mac.
This is incorrect, as vf->num_mac should represent the number of MAC
filters currently programmed to firmware.

Indeed, we only perform this increment if the requested filter is a unicast
address that doesn't match the existing vf->hw_lan_addr. In addition,
ice_vc_repr_del_mac() does not decrement the vf->num_mac counter. This
results in the counter becoming out of sync with the actual count.

As it turns out, vf->num_mac is currently only used in legacy made without
port representors. The single place where the value is checked is for
enforcing a filter limit on untrusted VFs.

Upcoming patches to support VF Live Migration will use this value when
determining the size of the TLV for MAC address filters. Fix the
representor mode function to stop incrementing the counter incorrectly.

Fixes: ac19e03ef780 ("ice: allow process VF opcodes in different ways")
Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Reviewed-by: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Tested-by: Sujai Buvaneswaran <sujai.buvaneswaran@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ice/ice_virtchnl.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_virtchnl.c b/drivers/net/ethernet/intel/ice/ice_virtchnl.c
index e709b10a29761..1edcf93031831 100644
--- a/drivers/net/ethernet/intel/ice/ice_virtchnl.c
+++ b/drivers/net/ethernet/intel/ice/ice_virtchnl.c
@@ -3769,7 +3769,6 @@ static int ice_vc_repr_add_mac(struct ice_vf *vf, u8 *msg)
 		}
 
 		ice_vfhw_mac_add(vf, &al->list[i]);
-		vf->num_mac++;
 		break;
 	}
 
-- 
2.39.5



