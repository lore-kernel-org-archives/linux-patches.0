Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84A551C07C4;
	Tue, 15 Oct 2024 12:54:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728996855; cv=none; b=Ltr620joXuX4oNUAQUKghM2IV3YGr5zOJzRZha4ZOSczpM6LUjJi1D/qVRrDYrGVJxlSjqE89u0gV9Dl6kdlJAh5a5LaQ8EqaAcOFwggTNjCur7+DBEb8/UF900DHr++MFjRJb7K9LUNjAe3ZA+GDrDXrgjzBBZeG384YqRvAos=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728996855; c=relaxed/simple;
	bh=SJ5JtrZAuQxNUuUHHcB0K6Q+fQP5/ZXpDVVstrM5Vmg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KHY+SbhEFZBKG0r2U9jHBCnxcfWXiskoM1LQKN5mpJ/QMwobY5/CSuAtAP7AQHm+1NTS098b4CKB2+nSA8xGsSV/ERGYJnZ8NQiB8wTRIf48O2gh7Z+AZxEE2mawCH/q0HpEpfL/pdlr4xh8MN0qIftwvTLvwXj+IfFvsGAaiXM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QpHsHLVP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QpHsHLVP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A92E1C4CEC6;
	Tue, 15 Oct 2024 12:54:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728996855;
	bh=SJ5JtrZAuQxNUuUHHcB0K6Q+fQP5/ZXpDVVstrM5Vmg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QpHsHLVPhEMTRIPl/XQHDJc4tX0DEW8qdc99h7VrLv7+viNynaPjEmKyQGzUaZ1kt
	 ezyz/tAgTjulT6xjO+nobH34Qf7wXwsnVk6ntyES2eh1fINhMFUP3zHUZr593ULl3S
	 TMNk8VBlgKgJYyt8h/qHp6qeG1LV3k7C7YOc22ms=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jacob Keller <jacob.e.keller@intel.com>,
	Rafal Romanowski <rafal.romanowski@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 019/518] ice: fix accounting for filters shared by multiple VSIs
Date: Tue, 15 Oct 2024 14:38:43 +0200
Message-ID: <20241015123917.576050757@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015123916.821186887@linuxfoundation.org>
References: <20241015123916.821186887@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 0155c45d9d7f..1645fb527fdb 100644
--- a/drivers/net/ethernet/intel/ice/ice_switch.c
+++ b/drivers/net/ethernet/intel/ice/ice_switch.c
@@ -1259,7 +1259,7 @@ ice_add_update_vsi_list(struct ice_hw *hw,
 
 		/* A rule already exists with the new VSI being added */
 		if (test_bit(vsi_handle, m_entry->vsi_list_info->vsi_map))
-			return 0;
+			return -EEXIST;
 
 		/* Update the previously created VSI list set with
 		 * the new VSI ID passed in
-- 
2.43.0



