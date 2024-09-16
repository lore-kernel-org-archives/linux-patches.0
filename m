Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBC89146A79;
	Mon, 16 Sep 2024 12:10:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726488622; cv=none; b=bvCJyVPHGYTr4PCCUe0TqLnaWE8nwrz1S5utBK9q6fhAaSv//e4u29mhd+YMHQdYeZDAcLFvPs7ouBMXZcMUQ9xpjrh3gwlGmmrxQqIAtX4kAf1zQ0UpQ26uVJLsHkakIXyZMGGMgcToRs8B4hylhw9YWj3Vkoe0/Rtz7YZBV9E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726488622; c=relaxed/simple;
	bh=qHvJN4F/BWMcPXv/I2lH8+he1edA1FwEvfAbHQA7Dss=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=esITiWj/owX22609QmvdBVlBxm/Ks5auUikpLJTShWPQmkv8QyZOD6KZ5yaaPMD+NFkpi3jlRdP4XerVpp/z3ubdX8LBsXUpLIyaUOYgYg3gRmGQSUad2ZEJShLUN95QHHs60rDGN+/z3IRHEhOyaYBdYZJh4EgYYbaYzaXViz0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YgGYEGSG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YgGYEGSG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6385BC4CEC4;
	Mon, 16 Sep 2024 12:10:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1726488621;
	bh=qHvJN4F/BWMcPXv/I2lH8+he1edA1FwEvfAbHQA7Dss=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YgGYEGSGdYMszRSwuH2wiRC8Ybio5RR/uIAN6yGRFBjPVEF9Ato6/w43UQIvB4N+5
	 ogs3MWQktTcsDXfbpp1fRhwgVbOUsxmJg0+bDyebBgK67Mlop5sElGm0CXtXvjQQTQ
	 P+0HrqIJ8TwGT7ILbT9HFf9f+v3BfbQtDMwxAOJ4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jacob Keller <jacob.e.keller@intel.com>,
	Rafal Romanowski <rafal.romanowski@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 56/91] ice: fix accounting for filters shared by multiple VSIs
Date: Mon, 16 Sep 2024 13:44:32 +0200
Message-ID: <20240916114226.357643645@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240916114224.509743970@linuxfoundation.org>
References: <20240916114224.509743970@linuxfoundation.org>
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

From: Jacob Keller <jacob.e.keller@intel.com>

[ Upstream commit e843cf7b34fe2e0c1afc55e1f3057375c9b77a14 ]

When adding a switch filter (such as a MAC or VLAN filter), it is expected
that the driver will detect the case where the filter already exists, and
return -EEXIST. This is used by calling code such as ice_vc_add_mac_addr,
and ice_vsi_add_vlan to avoid incrementing the accounting fields such as
vsi->num_vlan or vf->num_mac.

This logic works correctly for the case where only a single VSI has added a
given switch filter.

When a second VSI adds the same switch filter, the driver converts the
existing filter from an ICE_FWD_TO_VSI filter into an ICE_FWD_TO_VSI_LIST
filter. This saves switch resources, by ensuring that multiple VSIs can
re-use the same filter.

The ice_add_update_vsi_list() function is responsible for doing this
conversion. When first converting a filter from the FWD_TO_VSI into
FWD_TO_VSI_LIST, it checks if the VSI being added is the same as the
existing rule's VSI. In such a case it returns -EEXIST.

However, when the switch rule has already been converted to a
FWD_TO_VSI_LIST, the logic is different. Adding a new VSI in this case just
requires extending the VSI list entry. The logic for checking if the rule
already exists in this case returns 0 instead of -EEXIST.

This breaks the accounting logic mentioned above, so the counters for how
many MAC and VLAN filters exist for a given VF or VSI no longer accurately
reflect the actual count. This breaks other code which relies on these
counts.

In typical usage this primarily affects such filters generally shared by
multiple VSIs such as VLAN 0, or broadcast and multicast MAC addresses.

Fix this by correctly reporting -EEXIST in the case of adding the same VSI
to a switch rule already converted to ICE_FWD_TO_VSI_LIST.

Fixes: 9daf8208dd4d ("ice: Add support for switch filter programming")
Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Tested-by: Rafal Romanowski <rafal.romanowski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ice/ice_switch.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_switch.c b/drivers/net/ethernet/intel/ice/ice_switch.c
index 88ee2491312a..1b48fa8c435d 100644
--- a/drivers/net/ethernet/intel/ice/ice_switch.c
+++ b/drivers/net/ethernet/intel/ice/ice_switch.c
@@ -3072,7 +3072,7 @@ ice_add_update_vsi_list(struct ice_hw *hw,
 
 		/* A rule already exists with the new VSI being added */
 		if (test_bit(vsi_handle, m_entry->vsi_list_info->vsi_map))
-			return 0;
+			return -EEXIST;
 
 		/* Update the previously created VSI list set with
 		 * the new VSI ID passed in
-- 
2.43.0



