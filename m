Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B5DD36404D;
	Sat, 12 Sep 2026 08:54:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789203256; cv=none; b=jX1OEoBZymTLyGx3/jdn0oJCiRmwp6iTUsz6ZDByq5zrFs7w8GeziON8s/FNEGviVoQiesPqYJZI3DXZbCjN8H0VBdwbW01QOtmY+xgwU7lp1EkPxBzAtW2ng3Xfr1uyxEUpPXpp/AirKHyqe8Uxu8E3JCYld+jGWdQzKM3BWw8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789203256; c=relaxed/simple;
	bh=RLyMa+IzgjMKqeg9MPY1UyTb2AmnE34a0CCZoMa3qI4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r+d3On/MS2YiuVTkHiC1ROq4HrALRa0yTsRa44fQ/odbA358/T+Rdm5xffi35dNWdEBCnufroRwYNmirwU/GAItBAMeuAOrLktVIRWb97K0aPv8g86V6I2pHZ7L6mJ4INE9NMdotIutvkQHZjbc6rH33JakkOH8N5hCcbGHicnM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dSH5ttqT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dSH5ttqT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11D691F000FF;
	Sat, 12 Sep 2026 08:54:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789203255;
	bh=5egpqeOAWCl0TRvgrU67nDI43tbuKiqqhYdBvRd074U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dSH5ttqTbaX//7fNf+AqECYzGgmIg92+Q9zly8WzeL/hPkgNjPgRg9ugMnTWLB2Hx
	 xVJ/P5nkWpDU1okSbhRH/lSQTkTf2mQlnB6kIlLb57JYNQml9VV87FWsEfdIFlLy/3
	 A/xrmO0WLC8eWYCmvQ1QndwZI0FJv9Yj6IQ7CkUg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Petr Oros <poros@redhat.com>,
	Marcin Szycik <marcin.szycik@linux.intel.com>,
	Rafal Romanowski <rafal.romanowski@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1369/1815] ice: clear the default forwarding VSI rule when releasing a VSI
Date: Sat, 12 Sep 2026 08:51:59 +0200
Message-ID: <20260912065721.166556946@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Petr Oros <poros@redhat.com>

[ Upstream commit d04287e27bf1c0b879a10d929c163f2da69715b6 ]

When a VSI is configured as the switch's default forwarding VSI
(ICE_SW_LKUP_DFLT) and is then torn down, the rule is left behind in
the switch. ice_vsi_release() no longer removes it, and the SR-IOV VF
free path (ice_free_vfs() -> ice_free_vf_res() -> ice_vf_vsi_release()
-> ice_vsi_release()) does not disable promiscuous mode either, which
only happens on VF reset in ice_vf_clear_all_promisc_modes().

A trusted VF that enters unicast promiscuous mode becomes the default
forwarding VSI (this is the default mode, when the PF does not have VF
true-promiscuous mode enabled). If the VFs are then destroyed without
the VF first leaving promiscuous mode, the ICE_SW_LKUP_DFLT rule for
the now-freed VSI is leaked. When VFs are recreated, a VSI reuses the
freed hw_vsi_id. If it is assigned a different VSI handle than the
leaked rule holds, ice_set_dflt_vsi() does not recognize it as
already-default, and ice_add_update_vsi_list() folds the dangling
(freed) handle into a VSI list, which the firmware rejects. The VSI
handle assigned on re-creation varies, so the failure is intermittent
rather than every cycle.

Reproduce by repeatedly running the cycle below on the two ports of the
same card, where $VF0 and $VF1 are the netdevs of vf 15 once they
appear. The VF must be brought up so iavf actually pushes the unicast
promiscuous request, and the rule must settle before the VFs are torn
down again:

  echo 16 > /sys/class/net/$PF0/device/sriov_numvfs
  echo 16 > /sys/class/net/$PF1/device/sriov_numvfs
  ip link set $PF0 vf 15 trust on
  ip link set $PF1 vf 15 trust on
  ip link set $VF0 up
  ip link set $VF1 up
  ip link set $VF0 promisc on
  ip link set $VF1 promisc on
  sleep 1
  echo 0 > /sys/class/net/$PF0/device/sriov_numvfs
  echo 0 > /sys/class/net/$PF1/device/sriov_numvfs

Within a few cycles the ice PF and iavf VF log:

  Failed to set VSI 25 as the default forwarding VSI, error -22
  Turning on/off promiscuous mode for VF 63 failed, error: -22
  PF returned error -53 (IAVF_ERR_ADMIN_QUEUE_ERROR) to our request 14

This cleanup used to live in ice_vsi_release() but was dropped by the
referenced refactor. Restore it. Clear the default forwarding VSI rule
in ice_vsi_release() when this VSI owns it, which covers every teardown
path.

Fixes: 6624e780a577 ("ice: split ice_vsi_setup into smaller functions")
Signed-off-by: Petr Oros <poros@redhat.com>
Reviewed-by: Marcin Szycik <marcin.szycik@linux.intel.com>
Tested-by: Rafal Romanowski <rafal.romanowski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ice/ice_lib.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/intel/ice/ice_lib.c b/drivers/net/ethernet/intel/ice/ice_lib.c
index 8cdc4fda89e97..9e08db376d3d0 100644
--- a/drivers/net/ethernet/intel/ice/ice_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_lib.c
@@ -2871,6 +2871,9 @@ int ice_vsi_release(struct ice_vsi *vsi)
 		return -ENODEV;
 	pf = vsi->back;
 
+	if (ice_is_vsi_dflt_vsi(vsi))
+		ice_clear_dflt_vsi(vsi);
+
 	if (test_bit(ICE_FLAG_RSS_ENA, pf->flags))
 		ice_rss_clean(vsi);
 
-- 
2.53.0



