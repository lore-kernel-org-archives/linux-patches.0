Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A2593F7867;
	Tue, 31 Mar 2026 16:56:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774976212; cv=none; b=CX6K6n67ulJmC+TyDqF6psoLrJHMtEi9/7PaIiHNorNOAShlwqFmoOAXKxVj+8yX6j1QO6lTtFlVM8+YYARTOKCe8WJ/5d5BoHBhyHYYuHRtSQdFk5C4gYPcFwe2nIMtMFmngevOo5qHpmeJx6Roh+uMtAOVscBjFeGLHO2818I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774976212; c=relaxed/simple;
	bh=kE25zzWLVyt8nhsSz6b8g2IAg5Y7wW4Lfi8A9beY4gM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YgyikD53eDyiVyEt+4pBNhOvVLLL1fLSw1WdI94BVjVCaYZcUdmxorbjij1ey0egPQCZCjVFiCDgF9GefHCsy1YhKqbI4Vcybb0rLHelwIthk5xaWlrPqKihbtxphfl0x45fpw+i+6Kuqcb/oMqBRjbjvllS1a4Q7ntEZjh/m+w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kAD5mc8v; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kAD5mc8v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CB3EC19423;
	Tue, 31 Mar 2026 16:56:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774976212;
	bh=kE25zzWLVyt8nhsSz6b8g2IAg5Y7wW4Lfi8A9beY4gM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kAD5mc8v7ru9Io9dMLFfno40FSp/jX1QsxchjJdmZcgcAixf3BoPav4l7l0XMELav
	 yCObqbx9gaOQM/8ATplK1zyfWl3IMSljdcSIh9/QAvHkUvDnNPc2Exd0DcMayJN/lp
	 pEwDMDy7FWDNRjCs3BExLHM3ShSQOw3H539HC83o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aaron Ma <aaron.ma@canonical.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>,
	Sunitha Mekala <sunithax.d.mekala@intel.com>
Subject: [PATCH 6.12 218/244] ice: Fix PTP NULL pointer dereference during VSI rebuild
Date: Tue, 31 Mar 2026 18:22:48 +0200
Message-ID: <20260331161749.816532483@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161741.651718120@linuxfoundation.org>
References: <20260331161741.651718120@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aaron Ma <aaron.ma@canonical.com>

[ Upstream commit fc6f36eaaedcf4b81af6fe1a568f018ffd530660 ]

Fix race condition where PTP periodic work runs while VSI is being
rebuilt, accessing NULL vsi->rx_rings.

The sequence was:
1. ice_ptp_prepare_for_reset() cancels PTP work
2. ice_ptp_rebuild() immediately queues PTP work
3. VSI rebuild happens AFTER ice_ptp_rebuild()
4. PTP work runs and accesses NULL vsi->rx_rings

Fix: Keep PTP work cancelled during rebuild, only queue it after
VSI rebuild completes in ice_rebuild().

Added ice_ptp_queue_work() helper function to encapsulate the logic
for queuing PTP work, ensuring it's only queued when PTP is supported
and the state is ICE_PTP_READY.

Error log:
[  121.392544] ice 0000:60:00.1: PTP reset successful
[  121.392692] BUG: kernel NULL pointer dereference, address: 0000000000000000
[  121.392712] #PF: supervisor read access in kernel mode
[  121.392720] #PF: error_code(0x0000) - not-present page
[  121.392727] PGD 0
[  121.392734] Oops: Oops: 0000 [#1] SMP NOPTI
[  121.392746] CPU: 8 UID: 0 PID: 1005 Comm: ice-ptp-0000:60 Tainted: G S                  6.19.0-rc6+ #4 PREEMPT(voluntary)
[  121.392761] Tainted: [S]=CPU_OUT_OF_SPEC
[  121.392773] RIP: 0010:ice_ptp_update_cached_phctime+0xbf/0x150 [ice]
[  121.393042] Call Trace:
[  121.393047]  <TASK>
[  121.393055]  ice_ptp_periodic_work+0x69/0x180 [ice]
[  121.393202]  kthread_worker_fn+0xa2/0x260
[  121.393216]  ? __pfx_ice_ptp_periodic_work+0x10/0x10 [ice]
[  121.393359]  ? __pfx_kthread_worker_fn+0x10/0x10
[  121.393371]  kthread+0x10d/0x230
[  121.393382]  ? __pfx_kthread+0x10/0x10
[  121.393393]  ret_from_fork+0x273/0x2b0
[  121.393407]  ? __pfx_kthread+0x10/0x10
[  121.393417]  ret_from_fork_asm+0x1a/0x30
[  121.393432]  </TASK>

Fixes: 803bef817807d ("ice: factor out ice_ptp_rebuild_owner()")
Signed-off-by: Aaron Ma <aaron.ma@canonical.com>
Tested-by: Sunitha Mekala <sunithax.d.mekala@intel.com> (A Contingent worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
(cherry picked from commit fc6f36eaaedcf4b81af6fe1a568f018ffd530660)
[Harshit: Backported to 6.12.y, ice_ptp_prepare_rebuild_sec() is not
present in 6.12.y]
Signed-off-by: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/intel/ice/ice_main.c |    3 +++
 drivers/net/ethernet/intel/ice/ice_ptp.c  |   17 ++++++++++++++---
 drivers/net/ethernet/intel/ice/ice_ptp.h  |    5 +++++
 3 files changed, 22 insertions(+), 3 deletions(-)

--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -7792,6 +7792,9 @@ static void ice_rebuild(struct ice_pf *p
 
 	/* Restore timestamp mode settings after VSI rebuild */
 	ice_ptp_restore_timestamp_mode(pf);
+
+	/* Start PTP periodic work after VSI is fully rebuilt */
+	ice_ptp_queue_work(pf);
 	return;
 
 err_vsi_rebuild:
--- a/drivers/net/ethernet/intel/ice/ice_ptp.c
+++ b/drivers/net/ethernet/intel/ice/ice_ptp.c
@@ -2754,6 +2754,20 @@ static void ice_ptp_periodic_work(struct
 }
 
 /**
+ * ice_ptp_queue_work - Queue PTP periodic work for a PF
+ * @pf: Board private structure
+ *
+ * Helper function to queue PTP periodic work after VSI rebuild completes.
+ * This ensures that PTP work only runs when VSI structures are ready.
+ */
+void ice_ptp_queue_work(struct ice_pf *pf)
+{
+	if (test_bit(ICE_FLAG_PTP_SUPPORTED, pf->flags) &&
+	    pf->ptp.state == ICE_PTP_READY)
+		kthread_queue_delayed_work(pf->ptp.kworker, &pf->ptp.work, 0);
+}
+
+/**
  * ice_ptp_prepare_for_reset - Prepare PTP for reset
  * @pf: Board private structure
  * @reset_type: the reset type being performed
@@ -2888,9 +2902,6 @@ void ice_ptp_rebuild(struct ice_pf *pf,
 
 	ptp->state = ICE_PTP_READY;
 
-	/* Start periodic work going */
-	kthread_queue_delayed_work(ptp->kworker, &ptp->work, 0);
-
 	dev_info(ice_pf_to_dev(pf), "PTP reset successful\n");
 	return;
 
--- a/drivers/net/ethernet/intel/ice/ice_ptp.h
+++ b/drivers/net/ethernet/intel/ice/ice_ptp.h
@@ -333,6 +333,7 @@ void ice_ptp_prepare_for_reset(struct ic
 void ice_ptp_init(struct ice_pf *pf);
 void ice_ptp_release(struct ice_pf *pf);
 void ice_ptp_link_change(struct ice_pf *pf, bool linkup);
+void ice_ptp_queue_work(struct ice_pf *pf);
 #else /* IS_ENABLED(CONFIG_PTP_1588_CLOCK) */
 static inline int ice_ptp_set_ts_config(struct ice_pf *pf, struct ifreq *ifr)
 {
@@ -384,6 +385,10 @@ static inline void ice_ptp_link_change(s
 {
 }
 
+static inline void ice_ptp_queue_work(struct ice_pf *pf)
+{
+}
+
 static inline int ice_ptp_clock_index(struct ice_pf *pf)
 {
 	return -1;


