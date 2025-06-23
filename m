Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1154A15ADB4;
	Mon, 23 Jun 2025 22:22:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750717336; cv=none; b=BXdT/6BnvFIVTLWe/RTBsWl+0O4vbaRBzcy6M0QLMslbAgh+ZfmQWHeR29w/piEaV/44t+TdUxoj2dPkMVHgKwN02R2NQQfj6aictX7+2/tzKQla5u4DGCCj/eGA7+WhndytbXOVHEF4s96avPBTpur2tfXXY20+wz6zwOwPtzI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750717336; c=relaxed/simple;
	bh=tVfa/lib875ZIA9+a5JE7d2ZWUGmxUOcar3OQMDGDcc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=amBLAvAIPq11Rxu/FjV17fITVHZ2mkm+Fwp26h3Fp4vIaAsSVq2KjJOxppH2+G6RSoEjqQ4Ozu3A+KyKZ544evBj0MVLM2u6w9OiDWSuclMSEkq9ieDzU3dO955/gqpnAlwqWWpJKYcjiVlilVK6RuPR4O6d2nlxYNsmVpRR8Bw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GBftWpOr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GBftWpOr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9EED8C4CEEA;
	Mon, 23 Jun 2025 22:22:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750717335;
	bh=tVfa/lib875ZIA9+a5JE7d2ZWUGmxUOcar3OQMDGDcc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GBftWpOrz1xnKpegcwpmX3a879wDHsPftSkpYdp8y9T42NmMZ7eoux+/U53V1apD6
	 LVHB088WTBXImuqysuO0ZTWWq+3c4nVM+Ek6AzPUW0m+ut8PsYsUwCv0rp5CGRBejF
	 szr9jD4VaMI0a4UUM26loX0CV+8tmsaP9bbfNC7A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Grzegorz Nitka <grzegorz.nitka@intel.com>,
	Przemek Kitszel <przemyslaw.kitszel@intel.com>,
	Simon Horman <horms@kernel.org>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	Rinitha S <sx.rinitha@intel.com>
Subject: [PATCH 6.12 368/414] ice: fix eswitch code memory leak in reset scenario
Date: Mon, 23 Jun 2025 15:08:25 +0200
Message-ID: <20250623130651.159219736@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130642.015559452@linuxfoundation.org>
References: <20250623130642.015559452@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Grzegorz Nitka <grzegorz.nitka@intel.com>

[ Upstream commit 48c8b214974dc55283bd5f12e3a483b27c403bbc ]

Add simple eswitch mode checker in attaching VF procedure and allocate
required port representor memory structures only in switchdev mode.
The reset flows triggers VF (if present) detach/attach procedure.
It might involve VF port representor(s) re-creation if the device is
configured is switchdev mode (not legacy one).
The memory was blindly allocated in current implementation,
regardless of the mode and not freed if in legacy mode.

Kmemeleak trace:
unreferenced object (percpu) 0x7e3bce5b888458 (size 40):
  comm "bash", pid 1784, jiffies 4295743894
  hex dump (first 32 bytes on cpu 45):
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace (crc 0):
    pcpu_alloc_noprof+0x4c4/0x7c0
    ice_repr_create+0x66/0x130 [ice]
    ice_repr_create_vf+0x22/0x70 [ice]
    ice_eswitch_attach_vf+0x1b/0xa0 [ice]
    ice_reset_all_vfs+0x1dd/0x2f0 [ice]
    ice_pci_err_resume+0x3b/0xb0 [ice]
    pci_reset_function+0x8f/0x120
    reset_store+0x56/0xa0
    kernfs_fop_write_iter+0x120/0x1b0
    vfs_write+0x31c/0x430
    ksys_write+0x61/0xd0
    do_syscall_64+0x5b/0x180
    entry_SYSCALL_64_after_hwframe+0x76/0x7e

Testing hints (ethX is PF netdev):
- create at least one VF
    echo 1 > /sys/class/net/ethX/device/sriov_numvfs
- trigger the reset
    echo 1 > /sys/class/net/ethX/device/reset

Fixes: 415db8399d06 ("ice: make representor code generic")
Signed-off-by: Grzegorz Nitka <grzegorz.nitka@intel.com>
Reviewed-by: Przemek Kitszel <przemyslaw.kitszel@intel.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Tested-by: Rinitha S <sx.rinitha@intel.com> (A Contingent worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ice/ice_eswitch.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_eswitch.c b/drivers/net/ethernet/intel/ice/ice_eswitch.c
index ed21d7f55ac11..5b9a7ee278f17 100644
--- a/drivers/net/ethernet/intel/ice/ice_eswitch.c
+++ b/drivers/net/ethernet/intel/ice/ice_eswitch.c
@@ -502,10 +502,14 @@ ice_eswitch_attach(struct ice_pf *pf, struct ice_repr *repr, unsigned long *id)
  */
 int ice_eswitch_attach_vf(struct ice_pf *pf, struct ice_vf *vf)
 {
-	struct ice_repr *repr = ice_repr_create_vf(vf);
 	struct devlink *devlink = priv_to_devlink(pf);
+	struct ice_repr *repr;
 	int err;
 
+	if (!ice_is_eswitch_mode_switchdev(pf))
+		return 0;
+
+	repr = ice_repr_create_vf(vf);
 	if (IS_ERR(repr))
 		return PTR_ERR(repr);
 
-- 
2.39.5



