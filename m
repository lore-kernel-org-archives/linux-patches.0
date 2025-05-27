Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96FB91DFF0;
	Tue, 27 May 2025 17:53:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748368431; cv=none; b=kwPfRjUYJaYbhGDzC5bVCs+wBjzBP+eMSx5U8jcK0fXAUG7fVk7Im0qBBKVVmyxCAf0L0vPKRD3c9UZVqrkAPMtOBOHAjxBPN59Nx3lssx93IDucMitTWguYE22GNSUhu0moa2wtHgxUwGC178LBcVBL+bKisqyMD3k6voFdzRE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748368431; c=relaxed/simple;
	bh=XN0O65os7weCs88Ilx1DqaM/Yp9uvzKwXoLfi/kZBbs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jsVejBceOCBYuLuNwzhJp+vl+n53xqQkCfdoBQiZkF0gf7HlcW3V8vJZ50dZ3MhfA0lxZeawG8Y3K7Lg1YW4rvqO3WtZJaa6HzrkSlHLBMLa0P3fMfcpikvr9d1VNn9XFq17zT1bFkJnEMnQsZQf0FYCD130MZ+WdnBe16yQf+w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1NgIOE9c; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1NgIOE9c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 063D0C4CEE9;
	Tue, 27 May 2025 17:53:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748368431;
	bh=XN0O65os7weCs88Ilx1DqaM/Yp9uvzKwXoLfi/kZBbs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1NgIOE9cnok5vMpjGsybpnePIXyDr6X4Xc5ZKyNEL2usVRGPtS6fJOjF7CAmoZvvx
	 YlaIhzvxBsFd7xAVBuujJjkHHEtzThDkZNF687wOWIEk0RAgxjsJXcLQkrCdsJgvgC
	 oYJ15GqpZisZZ3xw5Pfh7T6kr+Kfy3n7UT4kWAbo=
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
Subject: [PATCH 6.14 703/783] ice: fix vf->num_mac count with port representors
Date: Tue, 27 May 2025 18:28:20 +0200
Message-ID: <20250527162541.749151588@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162513.035720581@linuxfoundation.org>
References: <20250527162513.035720581@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

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
index 1af51469f070b..9be9ce300fa4a 100644
--- a/drivers/net/ethernet/intel/ice/ice_virtchnl.c
+++ b/drivers/net/ethernet/intel/ice/ice_virtchnl.c
@@ -4211,7 +4211,6 @@ static int ice_vc_repr_add_mac(struct ice_vf *vf, u8 *msg)
 		}
 
 		ice_vfhw_mac_add(vf, &al->list[i]);
-		vf->num_mac++;
 		break;
 	}
 
-- 
2.39.5



