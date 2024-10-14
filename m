Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2172913B7A1;
	Mon, 14 Oct 2024 14:44:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728917070; cv=none; b=piSuvAE/epKnsEsw9W/u02RLZ3hRR5uVzCtriHYpWfgyO0hVv9+Ncz3sR20T9Kkm6JEQ3k3j3tjy8Bw7a9VL03HzRqsEnioyyCtwfrjlDN8k7v2I6MTkYAXA0VlOzK+TND/ysbCA/X5wECS5vytApg7xMzGXQobpqFHDb8zMDKU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728917070; c=relaxed/simple;
	bh=OqVJlGzL6qjEED7NwAejmXjrPsxDLGZTlu512TO/eNY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PO1njB5biWmK6Q1PnP2ZWVEAGCNRvj1nwmQP8ZyEJpjtiaQ8R/H8oUQyo/TIRAI49IBF/lwZtYp//TsDs3HzodwIQbzMO3DlWlm8pGvuY2MzsCeXVg2O7s2pEp+F4ni1P1yENPZbUOq3PN5RsXldxJafiS4lWHIbLCPV4NGvO5E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SBjemqlq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SBjemqlq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EACCC4CEC3;
	Mon, 14 Oct 2024 14:44:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728917070;
	bh=OqVJlGzL6qjEED7NwAejmXjrPsxDLGZTlu512TO/eNY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SBjemqlq61XmSWlwpJQnz1bYYVxtTPzKRx2egT9s9Odzr7e11e0MnHcGI9UFLuQUY
	 4Sw8TMe9exDJJJkO7CDIPfh0PGfiDGVIzO1PaYi8PHqUlWhR9ZTqgk3tSKVzHcAKhk
	 1VFfrRMwMwgSeUuSB0N+B4BAJXEZiBewHQgiL6TY=
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
Subject: [PATCH 6.6 111/213] ice: fix VLAN replay after reset
Date: Mon, 14 Oct 2024 16:20:17 +0200
Message-ID: <20241014141047.299565936@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141042.954319779@linuxfoundation.org>
References: <20241014141042.954319779@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 355716e6bcc82..19f730a68fa21 100644
--- a/drivers/net/ethernet/intel/ice/ice_switch.c
+++ b/drivers/net/ethernet/intel/ice/ice_switch.c
@@ -6326,8 +6326,6 @@ ice_replay_vsi_fltr(struct ice_hw *hw, u16 vsi_handle, u8 recp_id,
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



