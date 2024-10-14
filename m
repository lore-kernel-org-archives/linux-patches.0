Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D23CA1CBE8B;
	Mon, 14 Oct 2024 15:31:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728919865; cv=none; b=Fl5dANYqUYHQ4ojhQDtEYZbmYj9RNPKwHlo9+n7SjB9LfVxaiC2e/t49Qz1zPlIcexC5wahlNg2p6IEGGE+QY74zYDcyQCXcx2ZGpSBZ+PRUBGUJYQvZYifAX73O+i0koz37zfCc6VyRoDtwezXUWXjsVCt/CmA0WjIokPD7NjA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728919865; c=relaxed/simple;
	bh=giqtbApfFCdP4Af9snZJ3LxGk82gFh7khPkoCK1q2Gc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AkpnehjxYLQKPbUOrHle78BlYDTU+CrqeRbUAay+XTYZSwD0nhtYWGc34BgahQUd5O35gr7mGD8EnJ/72+s2q5m8x7QPXWAoTUV7StP2om01ypO88HW1MOAOZeG1AnLVVLw+IdGcndE2dCnnc3ecyA7PgIotug/2WpiQE65qqxY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CyZIUG2f; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CyZIUG2f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BCE6C4CEC3;
	Mon, 14 Oct 2024 15:31:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728919865;
	bh=giqtbApfFCdP4Af9snZJ3LxGk82gFh7khPkoCK1q2Gc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CyZIUG2fvwiHoo4AnI0h9mIt4x+m0uQJXy5ci0DeFk6c4kBu3EdPqoD8ll6K1g7Yd
	 ri4DIY4OcRwAFpdFpIJmYkarAoN1UVuTSfLoVOC2wM1nf4mE10FClqeo0BFN+cqVUM
	 ifdazD/ut59Ny/Z8zlAIL5xMcY4WCHdSw9mU9iyk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Przemek Kitszel <przemyslaw.kitszel@intel.com>,
	Dave Ertman <david.m.ertman@intel.com>,
	Jacob Keller <jacob.e.keller@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	Pucha Himasekhar Reddy <himasekharx.reddy.pucha@intel.com>
Subject: [PATCH 6.1 728/798] ice: fix VLAN replay after reset
Date: Mon, 14 Oct 2024 16:21:22 +0200
Message-ID: <20241014141246.671655789@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
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

From: Dave Ertman <david.m.ertman@intel.com>

[ Upstream commit 0eae2c136cb624e4050092feb59f18159b4f2512 ]

There is a bug currently when there are more than one VLAN defined
and any reset that affects the PF is initiated, after the reset rebuild
no traffic will pass on any VLAN but the last one created.

This is caused by the iteration though the VLANs during replay each
clearing the vsi_map bitmap of the VSI that is being replayed.  The
problem is that during rhe replay, the pointer to the vsi_map bitmap
is used by each successive vlan to determine if it should be replayed
on this VSI.

The logic was that the replay of the VLAN would replace the bit in the map
before the next VLAN would iterate through.  But, since the replay copies
the old bitmap pointer to filt_replay_rules and creates a new one for the
recreated VLANS, it does not do this, and leaves the old bitmap broken
to be used to replay the remaining VLANs.

Since the old bitmap will be cleaned up in post replay cleanup, there is
no need to alter it and break following VLAN replay, so don't clear the
bit.

Fixes: 334cb0626de1 ("ice: Implement VSI replay framework")
Reviewed-by: Przemek Kitszel <przemyslaw.kitszel@intel.com>
Signed-off-by: Dave Ertman <david.m.ertman@intel.com>
Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
Tested-by: Pucha Himasekhar Reddy <himasekharx.reddy.pucha@intel.com> (A Contingent worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ice/ice_switch.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_switch.c b/drivers/net/ethernet/intel/ice/ice_switch.c
index dc4ce3bd412d2..3a29ae46fb397 100644
--- a/drivers/net/ethernet/intel/ice/ice_switch.c
+++ b/drivers/net/ethernet/intel/ice/ice_switch.c
@@ -6317,8 +6317,6 @@ ice_replay_vsi_fltr(struct ice_hw *hw, u16 vsi_handle, u8 recp_id,
 		if (!itr->vsi_list_info ||
 		    !test_bit(vsi_handle, itr->vsi_list_info->vsi_map))
 			continue;
-		/* Clearing it so that the logic can add it back */
-		clear_bit(vsi_handle, itr->vsi_list_info->vsi_map);
 		f_entry.fltr_info.vsi_handle = vsi_handle;
 		f_entry.fltr_info.fltr_act = ICE_FWD_TO_VSI;
 		/* update the src in case it is VSI num */
-- 
2.43.0



