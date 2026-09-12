Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FEEB309F08;
	Sat, 12 Sep 2026 15:02:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789225342; cv=none; b=qFkbuFr8DeVYlME3QVKejG1V/yKHU/a3gxBezsPcCvUDBt5s1gLvex7q659d030Ht4Pm5pPT3H1xuJzaCbSpitn8c9oLrQtyZjZkZWWo2scmVw89jJXjwz/dTvPNBhwhiArO1OJld48La+i4WUVlHwOxMwYmvuONOxQ6K+Wd12g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789225342; c=relaxed/simple;
	bh=ZM5bcNlBXdx6udReAKrfZkzswz7SAU3XeboL77VrD8o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JqNR2xH1S2CoXaqFAjkq/sTcGYQ16RMXwNg4pGJkDLPQ3WyeslMkANWyTwdILV2AecAKoNkL63jMA2uOd9ECgW/6OQSsX1xjT3YynUyuKA7g56YHamubbjVfWryL2E4In4bAxPRLGOZfrR+V0hjmsmB5vWjDw24Vq6CGQORR2Ao=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0H5OhdhN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0H5OhdhN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22DCC1F000FF;
	Sat, 12 Sep 2026 15:02:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789225341;
	bh=HDE/uACAMWD2gE1ejVZsFG3p6M9MPjRKc7C84uGaxic=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0H5OhdhN/cpUkPX2ulI5htWBs+yeXkfhhZ6/stJqmsFmUtfNkuK6P4wfrSaG2tIEq
	 Y5zhE4ofwjquKzp6qf6WC5yOGTSL3RwrxRHEfTGmE95Uvh8Zrt2tSs0b1fKCS3Ei18
	 0xu5OSRzO/MWL3vbtiCH0E5htclODKXg1KzxmRMQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Petr Oros <poros@redhat.com>,
	Marcin Szycik <marcin.szycik@linux.intel.com>,
	Rafal Romanowski <rafal.romanowski@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1176/1424] ice: clear the default forwarding VSI rule when releasing a VSI
Date: Sat, 12 Sep 2026 09:00:08 +0200
Message-ID: <20260912065633.628074746@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 7aef40b50b898..3af3fc401331e 100644
--- a/drivers/net/ethernet/intel/ice/ice_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_lib.c
@@ -2948,6 +2948,9 @@ int ice_vsi_release(struct ice_vsi *vsi)
 		return -ENODEV;
 	pf = vsi->back;
 
+	if (ice_is_vsi_dflt_vsi(vsi))
+		ice_clear_dflt_vsi(vsi);
+
 	if (test_bit(ICE_FLAG_RSS_ENA, pf->flags))
 		ice_rss_clean(vsi);
 
-- 
2.53.0



