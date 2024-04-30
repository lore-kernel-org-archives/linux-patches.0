Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1C0112C7FB;
	Tue, 30 Apr 2024 10:51:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714474283; cv=none; b=kWuasnUp1iZoN48KqtbHkN7Mq0KPrqvyqeo+mFu4R+9ye040j0+z2FxSo+yIMqrIpF5lL0h4bRR3ZEkG2AYtCuWGtiH1nWBbB1nMwsCiXR6fAYgw6OzHZke8xHbi7J+BsPosCv/3OvMx+eESUhvcjDvxi0FQ+WX2Ra2r6OZYTyo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714474283; c=relaxed/simple;
	bh=FUHLIQNKUWe/4e45toY+7RDNDZY2Vw6RVKV4R7Nbkh4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bbUuqubZI2kv0wnihQLBBKJDWruUq/xQ7wiXUBQP0d+xeTFjF7KKiWsnuBtM3qWtox0/5xNkR2qYvJ4hNyFZA3w2o0TalDZVY3Cx2XA6DYD1WRQtxuQ5jRpxebq52DQqN0FfkqLTIxdpk/073cJdELpkH/eLaJdYvehdwkRSQ10=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rMLxXK0m; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rMLxXK0m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B8CEC2BBFC;
	Tue, 30 Apr 2024 10:51:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714474283;
	bh=FUHLIQNKUWe/4e45toY+7RDNDZY2Vw6RVKV4R7Nbkh4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rMLxXK0mjgEBYH1DWdttjjCkKBWBA1+sMwbhuvzwNXxQ3xft+Y65qneDbhDn5E4Ze
	 Y5indcurOSU5it9/2Leo53KwSL5+CoJNxv80hmbrAwaeuAtByzFfT+E1sLYA0bDQzw
	 OL0ssHsUC/aEvVpTdKaR36gISvQ2+sZoG8Hm8EQA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jacob Keller <jacob.e.keller@intel.com>,
	Dave Ertman <david.m.ertman@intel.com>,
	Mateusz Polchlopek <mateusz.polchlopek@intel.com>,
	Przemek Kitszel <przemyslaw.kitszel@intel.com>,
	Rafal Romanowski <rafal.romanowski@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 112/228] ice: fix LAG and VF lock dependency in ice_reset_vf()
Date: Tue, 30 Apr 2024 12:38:10 +0200
Message-ID: <20240430103107.041247854@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103103.806426847@linuxfoundation.org>
References: <20240430103103.806426847@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jacob Keller <jacob.e.keller@intel.com>

[ Upstream commit 96fdd1f6b4ed72a741fb0eb705c0e13049b8721f ]

9f74a3dfcf83 ("ice: Fix VF Reset paths when interface in a failed over
aggregate"), the ice driver has acquired the LAG mutex in ice_reset_vf().
The commit placed this lock acquisition just prior to the acquisition of
the VF configuration lock.

If ice_reset_vf() acquires the configuration lock via the ICE_VF_RESET_LOCK
flag, this could deadlock with ice_vc_cfg_qs_msg() because it always
acquires the locks in the order of the VF configuration lock and then the
LAG mutex.

Lockdep reports this violation almost immediately on creating and then
removing 2 VF:

======================================================
WARNING: possible circular locking dependency detected
6.8.0-rc6 #54 Tainted: G        W  O
------------------------------------------------------
kworker/60:3/6771 is trying to acquire lock:
ff40d43e099380a0 (&vf->cfg_lock){+.+.}-{3:3}, at: ice_reset_vf+0x22f/0x4d0 [ice]

but task is already holding lock:
ff40d43ea1961210 (&pf->lag_mutex){+.+.}-{3:3}, at: ice_reset_vf+0xb7/0x4d0 [ice]

which lock already depends on the new lock.

the existing dependency chain (in reverse order) is:

-> #1 (&pf->lag_mutex){+.+.}-{3:3}:
       __lock_acquire+0x4f8/0xb40
       lock_acquire+0xd4/0x2d0
       __mutex_lock+0x9b/0xbf0
       ice_vc_cfg_qs_msg+0x45/0x690 [ice]
       ice_vc_process_vf_msg+0x4f5/0x870 [ice]
       __ice_clean_ctrlq+0x2b5/0x600 [ice]
       ice_service_task+0x2c9/0x480 [ice]
       process_one_work+0x1e9/0x4d0
       worker_thread+0x1e1/0x3d0
       kthread+0x104/0x140
       ret_from_fork+0x31/0x50
       ret_from_fork_asm+0x1b/0x30

-> #0 (&vf->cfg_lock){+.+.}-{3:3}:
       check_prev_add+0xe2/0xc50
       validate_chain+0x558/0x800
       __lock_acquire+0x4f8/0xb40
       lock_acquire+0xd4/0x2d0
       __mutex_lock+0x9b/0xbf0
       ice_reset_vf+0x22f/0x4d0 [ice]
       ice_process_vflr_event+0x98/0xd0 [ice]
       ice_service_task+0x1cc/0x480 [ice]
       process_one_work+0x1e9/0x4d0
       worker_thread+0x1e1/0x3d0
       kthread+0x104/0x140
       ret_from_fork+0x31/0x50
       ret_from_fork_asm+0x1b/0x30

other info that might help us debug this:
 Possible unsafe locking scenario:
       CPU0                    CPU1
       ----                    ----
  lock(&pf->lag_mutex);
                               lock(&vf->cfg_lock);
                               lock(&pf->lag_mutex);
  lock(&vf->cfg_lock);

 *** DEADLOCK ***
4 locks held by kworker/60:3/6771:
 #0: ff40d43e05428b38 ((wq_completion)ice){+.+.}-{0:0}, at: process_one_work+0x176/0x4d0
 #1: ff50d06e05197e58 ((work_completion)(&pf->serv_task)){+.+.}-{0:0}, at: process_one_work+0x176/0x4d0
 #2: ff40d43ea1960e50 (&pf->vfs.table_lock){+.+.}-{3:3}, at: ice_process_vflr_event+0x48/0xd0 [ice]
 #3: ff40d43ea1961210 (&pf->lag_mutex){+.+.}-{3:3}, at: ice_reset_vf+0xb7/0x4d0 [ice]

stack backtrace:
CPU: 60 PID: 6771 Comm: kworker/60:3 Tainted: G        W  O       6.8.0-rc6 #54
Hardware name:
Workqueue: ice ice_service_task [ice]
Call Trace:
 <TASK>
 dump_stack_lvl+0x4a/0x80
 check_noncircular+0x12d/0x150
 check_prev_add+0xe2/0xc50
 ? save_trace+0x59/0x230
 ? add_chain_cache+0x109/0x450
 validate_chain+0x558/0x800
 __lock_acquire+0x4f8/0xb40
 ? lockdep_hardirqs_on+0x7d/0x100
 lock_acquire+0xd4/0x2d0
 ? ice_reset_vf+0x22f/0x4d0 [ice]
 ? lock_is_held_type+0xc7/0x120
 __mutex_lock+0x9b/0xbf0
 ? ice_reset_vf+0x22f/0x4d0 [ice]
 ? ice_reset_vf+0x22f/0x4d0 [ice]
 ? rcu_is_watching+0x11/0x50
 ? ice_reset_vf+0x22f/0x4d0 [ice]
 ice_reset_vf+0x22f/0x4d0 [ice]
 ? process_one_work+0x176/0x4d0
 ice_process_vflr_event+0x98/0xd0 [ice]
 ice_service_task+0x1cc/0x480 [ice]
 process_one_work+0x1e9/0x4d0
 worker_thread+0x1e1/0x3d0
 ? __pfx_worker_thread+0x10/0x10
 kthread+0x104/0x140
 ? __pfx_kthread+0x10/0x10
 ret_from_fork+0x31/0x50
 ? __pfx_kthread+0x10/0x10
 ret_from_fork_asm+0x1b/0x30
 </TASK>

To avoid deadlock, we must acquire the LAG mutex only after acquiring the
VF configuration lock. Fix the ice_reset_vf() to acquire the LAG mutex only
after we either acquire or check that the VF configuration lock is held.

Fixes: 9f74a3dfcf83 ("ice: Fix VF Reset paths when interface in a failed over aggregate")
Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Reviewed-by: Dave Ertman <david.m.ertman@intel.com>
Reviewed-by: Mateusz Polchlopek <mateusz.polchlopek@intel.com>
Tested-by: Przemek Kitszel <przemyslaw.kitszel@intel.com>
Tested-by: Rafal Romanowski <rafal.romanowski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Link: https://lore.kernel.org/r/20240423182723.740401-5-anthony.l.nguyen@intel.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ice/ice_vf_lib.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_vf_lib.c b/drivers/net/ethernet/intel/ice/ice_vf_lib.c
index 2ffdae9a82dfb..15ade19de55a2 100644
--- a/drivers/net/ethernet/intel/ice/ice_vf_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_vf_lib.c
@@ -863,6 +863,11 @@ int ice_reset_vf(struct ice_vf *vf, u32 flags)
 		return 0;
 	}
 
+	if (flags & ICE_VF_RESET_LOCK)
+		mutex_lock(&vf->cfg_lock);
+	else
+		lockdep_assert_held(&vf->cfg_lock);
+
 	lag = pf->lag;
 	mutex_lock(&pf->lag_mutex);
 	if (lag && lag->bonded && lag->primary) {
@@ -874,11 +879,6 @@ int ice_reset_vf(struct ice_vf *vf, u32 flags)
 			act_prt = ICE_LAG_INVALID_PORT;
 	}
 
-	if (flags & ICE_VF_RESET_LOCK)
-		mutex_lock(&vf->cfg_lock);
-	else
-		lockdep_assert_held(&vf->cfg_lock);
-
 	if (ice_is_vf_disabled(vf)) {
 		vsi = ice_get_vf_vsi(vf);
 		if (!vsi) {
@@ -963,14 +963,14 @@ int ice_reset_vf(struct ice_vf *vf, u32 flags)
 	ice_mbx_clear_malvf(&vf->mbx_info);
 
 out_unlock:
-	if (flags & ICE_VF_RESET_LOCK)
-		mutex_unlock(&vf->cfg_lock);
-
 	if (lag && lag->bonded && lag->primary &&
 	    act_prt != ICE_LAG_INVALID_PORT)
 		ice_lag_move_vf_nodes_cfg(lag, pri_prt, act_prt);
 	mutex_unlock(&pf->lag_mutex);
 
+	if (flags & ICE_VF_RESET_LOCK)
+		mutex_unlock(&vf->cfg_lock);
+
 	return err;
 }
 
-- 
2.43.0



