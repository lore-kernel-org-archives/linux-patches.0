Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD7122609FD;
	Wed, 20 May 2026 17:10:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779297031; cv=none; b=ii70cd8RCGolicMYtZeBaj+p3ZbkMX/PREyqjM9/Q7+r/jz/O4ubu1frqNU+6U7a90R4hDRZJoq61b22IJ+o9lSWlPlvo1hZtZTgyMWV89NyrKvOVVgRlP2Qs4Z+9mMTzssBk/3pYHb4GmaaEOgtx8DnYTpEh7Gvfpp7/PwTGDw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779297031; c=relaxed/simple;
	bh=e8ko9F2DKE/BAd3faVais/uKlp9kwbAntajvZpq1jLs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=E/zC9hWq5G4sf0jY/U+lJy1gxEwirfbj9dbrGGQ7SMPkCkoCWNH5pferncAWPdSoKEg+xcM3a2M15EG2tutOvvOZi0XupdPIn23qcsYKKO6bChok9mkWyoVMNsGt4XxhYrtuf6gp6ZURaBBI162CieGC6/mHzlQGeGfAiP0S7ZU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Becd/TIU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Becd/TIU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1ED1A1F00893;
	Wed, 20 May 2026 17:10:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779297030;
	bh=RdtuDGiVj75Bi3X1WNJ89XfUxi/fV9kWZd9NAtNBF/Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Becd/TIUDH+ugnd9kIuRf4xIAhmEif/ZB1rRAU1iCJpWR0tHBe9irRjHchqJREpDG
	 6xkgB7PyefxJxHCqV4Kp95H/+dK+QIsTmL00Pi5viBR8pfHDl5FaqQXsBRQKsX3Zym
	 /5CDxv3vevyv+p/zOHrP2zp82kr71ghk42279kF8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Petr Oros <poros@redhat.com>,
	Rafal Romanowski <rafal.romanowski@intel.com>,
	Jacob Keller <jacob.e.keller@intel.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 1024/1146] ice: fix NULL pointer dereference in ice_reset_all_vfs()
Date: Wed, 20 May 2026 18:21:14 +0200
Message-ID: <20260520162211.403842625@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Petr Oros <poros@redhat.com>

[ Upstream commit 54ef02487914c24170c7e1c061e45212dc55365e ]

ice_reset_all_vfs() ignores the return value of ice_vf_rebuild_vsi().
When the VSI rebuild fails (e.g. during NVM firmware update via
nvmupdate64e), ice_vsi_rebuild() tears down the VSI on its error path,
leaving txq_map and rxq_map as NULL. The subsequent unconditional call
to ice_vf_post_vsi_rebuild() leads to a NULL pointer dereference in
ice_ena_vf_q_mappings() when it accesses vsi->txq_map[0].

The single-VF reset path in ice_reset_vf() already handles this
correctly by checking the return value of ice_vf_reconfig_vsi() and
skipping ice_vf_post_vsi_rebuild() on failure.

Apply the same pattern to ice_reset_all_vfs(): check the return value
of ice_vf_rebuild_vsi() and skip ice_vf_post_vsi_rebuild() and
ice_eswitch_attach_vf() on failure. The VF is left safely disabled
(ICE_VF_STATE_INIT not set, VFGEN_RSTAT not set to VFACTIVE) and can
be recovered via a VFLR triggered by a PCI reset of the VF
(sysfs reset or driver rebind).

Note that this patch does not prevent the VF VSI rebuild from failing
during NVM update — the underlying cause is firmware being in a
transitional state while the EMP reset is processed, which can cause
Admin Queue commands (ice_add_vsi, ice_cfg_vsi_lan) to fail. This
patch only prevents the subsequent NULL pointer dereference that
crashes the kernel when the rebuild does fail.

 crash> bt
     PID: 50795    TASK: ff34c9ee708dc680  CPU: 1    COMMAND: "kworker/u512:5"
      #0 [ff72159bcfe5bb50] machine_kexec at ffffffffaa8850ee
      #1 [ff72159bcfe5bba8] __crash_kexec at ffffffffaaa15fba
      #2 [ff72159bcfe5bc68] crash_kexec at ffffffffaaa16540
      #3 [ff72159bcfe5bc70] oops_end at ffffffffaa837eda
      #4 [ff72159bcfe5bc90] page_fault_oops at ffffffffaa893997
      #5 [ff72159bcfe5bce8] exc_page_fault at ffffffffab528595
      #6 [ff72159bcfe5bd10] asm_exc_page_fault at ffffffffab600bb2
         [exception RIP: ice_ena_vf_q_mappings+0x79]
         RIP: ffffffffc0a85b29  RSP: ff72159bcfe5bdc8  RFLAGS: 00010206
         RAX: 00000000000f0000  RBX: ff34c9efc9c00000  RCX: 0000000000000000
         RDX: 0000000000000000  RSI: 0000000000000010  RDI: ff34c9efc9c00000
         RBP: ff34c9efc27d4828   R8: 0000000000000093   R9: 0000000000000040
         R10: ff34c9efc27d4828  R11: 0000000000000040  R12: 0000000000100000
         R13: 0000000000000010  R14:   R15:
         ORIG_RAX: ffffffffffffffff  CS: 0010  SS: 0018
      #7 [ff72159bcfe5bdf8] ice_sriov_post_vsi_rebuild at ffffffffc0a85e2e [ice]
      #8 [ff72159bcfe5be08] ice_reset_all_vfs at ffffffffc0a920b4 [ice]
      #9 [ff72159bcfe5be48] ice_service_task at ffffffffc0a31519 [ice]
     #10 [ff72159bcfe5be88] process_one_work at ffffffffaa93dca4
     #11 [ff72159bcfe5bec8] worker_thread at ffffffffaa93e9de
     #12 [ff72159bcfe5bf18] kthread at ffffffffaa946663
     #13 [ff72159bcfe5bf50] ret_from_fork at ffffffffaa8086b9

 The panic occurs attempting to dereference the NULL pointer in RDX at
 ice_sriov.c:294, which loads vsi->txq_map (offset 0x4b8 in ice_vsi).

 The faulting VSI is an allocated slab object but not fully initialized
 after a failed ice_vsi_rebuild():

  crash> struct ice_vsi 0xff34c9efc27d4828
    netdev = 0x0,
    rx_rings = 0x0,
    tx_rings = 0x0,
    q_vectors = 0x0,
    txq_map = 0x0,
    rxq_map = 0x0,
    alloc_txq = 0x10,
    num_txq = 0x10,
    alloc_rxq = 0x10,
    num_rxq = 0x10,

 The nvmupdate64e process was performing NVM firmware update:

  crash> bt 0xff34c9edd1a30000
  PID: 49858    TASK: ff34c9edd1a30000  CPU: 1    COMMAND: "nvmupdate64e"
   #0 [ff72159bcd617618] __schedule at ffffffffab5333f8
   #4 [ff72159bcd617750] ice_sq_send_cmd at ffffffffc0a35347 [ice]
   #5 [ff72159bcd6177a8] ice_sq_send_cmd_retry at ffffffffc0a35b47 [ice]
   #6 [ff72159bcd617810] ice_aq_send_cmd at ffffffffc0a38018 [ice]
   #7 [ff72159bcd617848] ice_aq_read_nvm at ffffffffc0a40254 [ice]
   #8 [ff72159bcd6178b8] ice_read_flat_nvm at ffffffffc0a4034c [ice]
   #9 [ff72159bcd617918] ice_devlink_nvm_snapshot at ffffffffc0a6ffa5 [ice]

 dmesg:
  ice 0000:13:00.0: firmware recommends not updating fw.mgmt, as it
    may result in a downgrade. continuing anyways
  ice 0000:13:00.1: ice_init_nvm failed -5
  ice 0000:13:00.1: Rebuild failed, unload and reload driver

Fixes: 12bb018c538c ("ice: Refactor VF reset")
Signed-off-by: Petr Oros <poros@redhat.com>
Tested-by: Rafal Romanowski <rafal.romanowski@intel.com>
Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Link: https://patch.msgid.link/20260427-jk-iwl-net-petr-oros-fixes-v1-5-cdcb48303fd8@intel.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ice/ice_vf_lib.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_vf_lib.c b/drivers/net/ethernet/intel/ice/ice_vf_lib.c
index c8bc952f05cdb..51259a4fdda4b 100644
--- a/drivers/net/ethernet/intel/ice/ice_vf_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_vf_lib.c
@@ -804,7 +804,12 @@ void ice_reset_all_vfs(struct ice_pf *pf)
 			ice_vf_ctrl_invalidate_vsi(vf);
 
 		ice_vf_pre_vsi_rebuild(vf);
-		ice_vf_rebuild_vsi(vf);
+		if (ice_vf_rebuild_vsi(vf)) {
+			dev_err(dev, "VF %u VSI rebuild failed, leaving VF disabled\n",
+				vf->vf_id);
+			mutex_unlock(&vf->cfg_lock);
+			continue;
+		}
 		ice_vf_post_vsi_rebuild(vf);
 
 		ice_eswitch_attach_vf(pf, vf);
-- 
2.53.0



