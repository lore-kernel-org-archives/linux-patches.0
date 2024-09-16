Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF17B149C57;
	Mon, 16 Sep 2024 12:10:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726488624; cv=none; b=DgDK85X4dVNvtHYcDlth9MZelWwio3JEFtsLULGq6pvI+YcK7/KU4OFviteaYNUKAjS3HHnIKlZjgn74hjd8z9j5IH5CSLlQQxZ/FUuVSK+eewlK+JC3QvttNf0QDIRurXvL4h8SMsh15t6wTS7xkBik2ozmLcLDJDsZTE35gHo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726488624; c=relaxed/simple;
	bh=AmQYWwsiMxmWtlnHhaBcHsUmGZhAaELSpBl6ZRrVQCI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SWA01TCr/pWlcb5r/uXr26jRP6e88kr5wbVZW/OjPpzo8KGUWBwvL53OQXq2I4SQG7ZEDP8HwljUUiHtQHV/FEH7zjqbnuI5oO+F0Fgvs02NeeeNmKpfGsYE5lmPA8VImyinb/WcV4BgpU5EcWWDvDw1+e0SpvC7bcUvm0adXGY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=R1U36oBt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="R1U36oBt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 374D5C4CEC4;
	Mon, 16 Sep 2024 12:10:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1726488624;
	bh=AmQYWwsiMxmWtlnHhaBcHsUmGZhAaELSpBl6ZRrVQCI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=R1U36oBtVd95vgku0pQanaxqFRHjxE105cSaot+3PwM7Li8DkX/djAwkVz5B8c6h5
	 0+yIlmvRp31p0WWm9QG+Z8h5sUApP82qzL3EanXbHLa3bomJX749Tc4MzOQvmk97U4
	 aOOg0LOy62Aa62k8NLxK3EMZBJT5RcUmSpjp+uFM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michal Swiatkowski <michal.swiatkowski@linux.intel.com>,
	Michal Schmidt <mschmidt@redhat.com>,
	Dave Ertman <David.m.ertman@intel.com>,
	Rafal Romanowski <rafal.romanowski@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 57/91] ice: fix VSI lists confusion when adding VLANs
Date: Mon, 16 Sep 2024 13:44:33 +0200
Message-ID: <20240916114226.382579864@linuxfoundation.org>
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

From: Michal Schmidt <mschmidt@redhat.com>

[ Upstream commit d2940002b0aa42898de815a1453b29d440292386 ]

The description of function ice_find_vsi_list_entry says:
  Search VSI list map with VSI count 1

However, since the blamed commit (see Fixes below), the function no
longer checks vsi_count. This causes a problem in ice_add_vlan_internal,
where the decision to share VSI lists between filter rules relies on the
vsi_count of the found existing VSI list being 1.

The reproducing steps:
1. Have a PF and two VFs.
   There will be a filter rule for VLAN 0, referring to a VSI list
   containing VSIs: 0 (PF), 2 (VF#0), 3 (VF#1).
2. Add VLAN 1234 to VF#0.
   ice will make the wrong decision to share the VSI list with the new
   rule. The wrong behavior may not be immediately apparent, but it can
   be observed with debug prints.
3. Add VLAN 1234 to VF#1.
   ice will unshare the VSI list for the VLAN 1234 rule. Due to the
   earlier bad decision, the newly created VSI list will contain
   VSIs 0 (PF) and 3 (VF#1), instead of expected 2 (VF#0) and 3 (VF#1).
4. Try pinging a network peer over the VLAN interface on VF#0.
   This fails.

Reproducer script at:
https://gitlab.com/mschmidt2/repro/-/blob/master/RHEL-46814/test-vlan-vsi-list-confusion.sh
Commented debug trace:
https://gitlab.com/mschmidt2/repro/-/blob/master/RHEL-46814/ice-vlan-vsi-lists-debug.txt
Patch adding the debug prints:
https://gitlab.com/mschmidt2/linux/-/commit/f8a8814623944a45091a77c6094c40bfe726bfdb
(Unsafe, by the way. Lacks rule_lock when dumping in ice_remove_vlan.)

Michal Swiatkowski added to the explanation that the bug is caused by
reusing a VSI list created for VLAN 0. All created VFs' VSIs are added
to VLAN 0 filter. When a non-zero VLAN is created on a VF which is already
in VLAN 0 (normal case), the VSI list from VLAN 0 is reused.
It leads to a problem because all VFs (VSIs to be specific) that are
subscribed to VLAN 0 will now receive a new VLAN tag traffic. This is
one bug, another is the bug described above. Removing filters from
one VF will remove VLAN filter from the previous VF. It happens a VF is
reset. Example:
- creation of 3 VFs
- we have VSI list (used for VLAN 0) [0 (pf), 2 (vf1), 3 (vf2), 4 (vf3)]
- we are adding VLAN 100 on VF1, we are reusing the previous list
  because 2 is there
- VLAN traffic works fine, but VLAN 100 tagged traffic can be received
  on all VSIs from the list (for example broadcast or unicast)
- trust is turning on VF2, VF2 is resetting, all filters from VF2 are
  removed; the VLAN 100 filter is also removed because 3 is on the list
- VLAN traffic to VF1 isn't working anymore, there is a need to recreate
  VLAN interface to readd VLAN filter

One thing I'm not certain about is the implications for the LAG feature,
which is another caller of ice_find_vsi_list_entry. I don't have a
LAG-capable card at hand to test.

Fixes: 23ccae5ce15f ("ice: changes to the interface with the HW and FW for SRIOV_VF+LAG")
Reviewed-by: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
Signed-off-by: Michal Schmidt <mschmidt@redhat.com>
Reviewed-by: Dave Ertman <David.m.ertman@intel.com>
Tested-by: Rafal Romanowski <rafal.romanowski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ice/ice_switch.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_switch.c b/drivers/net/ethernet/intel/ice/ice_switch.c
index 1b48fa8c435d..355716e6bcc8 100644
--- a/drivers/net/ethernet/intel/ice/ice_switch.c
+++ b/drivers/net/ethernet/intel/ice/ice_switch.c
@@ -3142,7 +3142,7 @@ ice_find_vsi_list_entry(struct ice_hw *hw, u8 recp_id, u16 vsi_handle,
 
 	list_head = &sw->recp_list[recp_id].filt_rules;
 	list_for_each_entry(list_itr, list_head, list_entry) {
-		if (list_itr->vsi_list_info) {
+		if (list_itr->vsi_count == 1 && list_itr->vsi_list_info) {
 			map_info = list_itr->vsi_list_info;
 			if (test_bit(vsi_handle, map_info->vsi_map)) {
 				*vsi_list_id = map_info->vsi_list_id;
-- 
2.43.0



