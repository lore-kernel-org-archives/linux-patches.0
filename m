Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D63946444;
	Tue, 10 Sep 2024 09:50:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725961814; cv=none; b=ENNdTAbeShpVTVfB0wRuIglDIGWdk8dzBtedhHSqizswU0UHkgE72ZDFjP0q9oKrhh12HUHRrdJunEDTJIAKO+7A/Jd50DaSpj6REGRSRlH5h6olbfNOw4dVqHSQbOtN/yArD6KbF6YnNOmmah7lVoq0NfRp0nUwOlQktvI5b1E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725961814; c=relaxed/simple;
	bh=obSTcqWTZG8PJs9675NmCDrpMBbi/rjtp6zoWKrER6I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BW5NqWqZaEXsqrAuHAo4e2IhlJOJz+JJLT/bXSSzXD01Lw38LkWd6+ahGrxAAHLKsSugZvSZ2jMyE4pu3vyh5L/+OjGtWYb/PUr9reobsl9i327B0zFX6VgPz01rpzsktJ46eZlCTileYO44Lqsxtpayfsb06Tem2dc3iAGCcP0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ghZdS47y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ghZdS47y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B79FDC4CEC3;
	Tue, 10 Sep 2024 09:50:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725961814;
	bh=obSTcqWTZG8PJs9675NmCDrpMBbi/rjtp6zoWKrER6I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ghZdS47yVZPBsE3tMNNoCxEbk12wl/ntFONTdagtbHIqTu4koKLdbfi/0Jv3AxwI0
	 PBSf9rangSQn8DKxBJ07xExmvsk5QiM5XBlVlrVb2U8+Awd0+z7MwSuNfneVeo4MGg
	 ltyvPupu3gqFyPpLL/vY7eCGnLR7YfGUZQm0qAjk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jakub Kicinski <kuba@kernel.org>,
	Igor Bagnucki <igor.bagnucki@intel.com>,
	Dawid Osuchowski <dawid.osuchowski@linux.intel.com>,
	Michal Schmidt <mschmidt@redhat.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	Pucha Himasekhar Reddy <himasekharx.reddy.pucha@intel.com>
Subject: [PATCH 6.10 161/375] ice: Add netif_device_attach/detach into PF reset flow
Date: Tue, 10 Sep 2024 11:29:18 +0200
Message-ID: <20240910092627.887058566@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092622.245959861@linuxfoundation.org>
References: <20240910092622.245959861@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dawid Osuchowski <dawid.osuchowski@linux.intel.com>

[ Upstream commit d11a67634227f9f9da51938af085fb41a733848f ]

Ethtool callbacks can be executed while reset is in progress and try to
access deleted resources, e.g. getting coalesce settings can result in a
NULL pointer dereference seen below.

Reproduction steps:
Once the driver is fully initialized, trigger reset:
	# echo 1 > /sys/class/net/<interface>/device/reset
when reset is in progress try to get coalesce settings using ethtool:
	# ethtool -c <interface>

BUG: kernel NULL pointer dereference, address: 0000000000000020
PGD 0 P4D 0
Oops: Oops: 0000 [#1] PREEMPT SMP PTI
CPU: 11 PID: 19713 Comm: ethtool Tainted: G S                 6.10.0-rc7+ #7
RIP: 0010:ice_get_q_coalesce+0x2e/0xa0 [ice]
RSP: 0018:ffffbab1e9bcf6a8 EFLAGS: 00010206
RAX: 000000000000000c RBX: ffff94512305b028 RCX: 0000000000000000
RDX: 0000000000000000 RSI: ffff9451c3f2e588 RDI: ffff9451c3f2e588
RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000000
R10: ffff9451c3f2e580 R11: 000000000000001f R12: ffff945121fa9000
R13: ffffbab1e9bcf760 R14: 0000000000000013 R15: ffffffff9e65dd40
FS:  00007faee5fbe740(0000) GS:ffff94546fd80000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000000020 CR3: 0000000106c2e005 CR4: 00000000001706f0
Call Trace:
<TASK>
ice_get_coalesce+0x17/0x30 [ice]
coalesce_prepare_data+0x61/0x80
ethnl_default_doit+0xde/0x340
genl_family_rcv_msg_doit+0xf2/0x150
genl_rcv_msg+0x1b3/0x2c0
netlink_rcv_skb+0x5b/0x110
genl_rcv+0x28/0x40
netlink_unicast+0x19c/0x290
netlink_sendmsg+0x222/0x490
__sys_sendto+0x1df/0x1f0
__x64_sys_sendto+0x24/0x30
do_syscall_64+0x82/0x160
entry_SYSCALL_64_after_hwframe+0x76/0x7e
RIP: 0033:0x7faee60d8e27

Calling netif_device_detach() before reset makes the net core not call
the driver when ethtool command is issued, the attempt to execute an
ethtool command during reset will result in the following message:

    netlink error: No such device

instead of NULL pointer dereference. Once reset is done and
ice_rebuild() is executing, the netif_device_attach() is called to allow
for ethtool operations to occur again in a safe manner.

Fixes: fcea6f3da546 ("ice: Add stats and ethtool support")
Suggested-by: Jakub Kicinski <kuba@kernel.org>
Reviewed-by: Igor Bagnucki <igor.bagnucki@intel.com>
Signed-off-by: Dawid Osuchowski <dawid.osuchowski@linux.intel.com>
Tested-by: Pucha Himasekhar Reddy <himasekharx.reddy.pucha@intel.com> (A Contingent worker at Intel)
Reviewed-by: Michal Schmidt <mschmidt@redhat.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ice/ice_main.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index 253689dbf6c3..209bfd70c430 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -609,6 +609,9 @@ ice_prepare_for_reset(struct ice_pf *pf, enum ice_reset_req reset_type)
 			memset(&vsi->mqprio_qopt, 0, sizeof(vsi->mqprio_qopt));
 		}
 	}
+
+	if (vsi->netdev)
+		netif_device_detach(vsi->netdev);
 skip:
 
 	/* clear SW filtering DB */
@@ -7590,6 +7593,7 @@ static void ice_update_pf_netdev_link(struct ice_pf *pf)
  */
 static void ice_rebuild(struct ice_pf *pf, enum ice_reset_req reset_type)
 {
+	struct ice_vsi *vsi = ice_get_main_vsi(pf);
 	struct device *dev = ice_pf_to_dev(pf);
 	struct ice_hw *hw = &pf->hw;
 	bool dvm;
@@ -7734,6 +7738,9 @@ static void ice_rebuild(struct ice_pf *pf, enum ice_reset_req reset_type)
 		ice_rebuild_arfs(pf);
 	}
 
+	if (vsi && vsi->netdev)
+		netif_device_attach(vsi->netdev);
+
 	ice_update_pf_netdev_link(pf);
 
 	/* tell the firmware we are up */
-- 
2.43.0



