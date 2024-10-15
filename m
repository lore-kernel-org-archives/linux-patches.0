Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D90001EF95D;
	Tue, 15 Oct 2024 12:11:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728994272; cv=none; b=SuJE4npX6I3VmgDnAzHBdk0w761+juZBmLzoq6oqvaT4qN9bSP71WJVwjoWIq39WF6bzrqsZoVzXJW7Ia93WXPstoq56xIEsHEuogLgft3+x/M4jXMwe+ahJsjBNvrO3jortKwYan6mx5zJR4XT5q3c2Zn9mlGm4XF2X7CHOdw8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728994272; c=relaxed/simple;
	bh=/TVQGQdiT1hlxi+DB+8UJ/evxNcdqMrlsku1x2Fj/Iw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pqFsKwUbLygVn+7tt2QQrevhkAUFgis+FgoV6GcjhSj9DRLy2db/E/oTXuenkKiIXjlOO57IoQFQ9cG0FrZeHa7J4iVPGzxwX2Y/JF9M0gmJwJAhBcjsGH06h1wNSX0e7uUgaRaPYHeJn3YaYNQN+wRCZbl7nQ3iYjzTWrGTbV4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=W5HAy84R; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="W5HAy84R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07918C4CECE;
	Tue, 15 Oct 2024 12:11:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728994272;
	bh=/TVQGQdiT1hlxi+DB+8UJ/evxNcdqMrlsku1x2Fj/Iw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=W5HAy84R1IBJbFNlBIz7TgG3Mxuf7pxQfBillpJMCgFJpHmSq7Pz+IPkUxC90Agsa
	 rG2QwyCQGuXCHR9f03JPV85wgXoyOTLKg43SrN2sU0l8Mq0fD8yb3Uj6dCC09f2PPV
	 ksrDCZosGg22Rw4sWt/2NoFdmZgMQFeQ6JKAEOzI=
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
Subject: [PATCH 5.15 625/691] ice: fix VLAN replay after reset
Date: Tue, 15 Oct 2024 13:29:33 +0200
Message-ID: <20241015112505.137543786@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015112440.309539031@linuxfoundation.org>
References: <20241015112440.309539031@linuxfoundation.org>
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
index 128c67c6de777..08540c12a7920 100644
--- a/drivers/net/ethernet/intel/ice/ice_switch.c
+++ b/drivers/net/ethernet/intel/ice/ice_switch.c
@@ -2812,8 +2812,6 @@ ice_replay_vsi_fltr(struct ice_hw *hw, u16 vsi_handle, u8 recp_id,
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



