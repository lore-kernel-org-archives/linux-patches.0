Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C67DF31A7F5;
	Tue, 16 Dec 2025 12:11:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765887096; cv=none; b=jggiohUFBakkorvc0Dmc5rO3NV43K8sR7McOILke9AWGrfrMPOAnBHwlThv7BErrt7QA4Y9yH8aKI2jvgDlcSJm/PZu1ok7Fpao/mQy5QcE/6VCvybp3oVIlLQgbU/rRfTw6JV6cuZEBtgy1s726Xm7JpqEU87n2nYnGff+abaI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765887096; c=relaxed/simple;
	bh=ns/g47w/kKA0obY2s4oVE/s1jfDCo0oyk0xbQ7Wx3KU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XUWyCbKDKjDMfdNArfhT4Ie/1KhtEL/2zvT2f8c/fBn2YxbQwHrPkFJaD6ukZk6Vn+BGyRdKbQLuJIPRTGFurmL/c+n1NbIf6wYvLOM68GJsanbSZJobdslv9/nLiFNB1WVIazPxoElVYgXsfXXJGFD/KkPfRfoCXbTWtiMevYw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RDsRQq/B; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RDsRQq/B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34128C4CEF1;
	Tue, 16 Dec 2025 12:11:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765887096;
	bh=ns/g47w/kKA0obY2s4oVE/s1jfDCo0oyk0xbQ7Wx3KU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RDsRQq/BbaZ9bp81hIqnH3KwGLxR6qbSoM9hU3mTSyQqrUvPbwuh1aDNIUkN0E1sW
	 /J2/og8CkQy5oQTJqsS469TabLX6AZZXE2lu7Xftuq9DoceyiqVbe7i/fIJQ4jEcMa
	 Yr2UiD2DrNKIcrJ/qYmeTkDPH6Dc9CxD+2PZI+TI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Przemek Kitszel <przemyslaw.kitszel@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	Rinitha S <sx.rinitha@intel.com>
Subject: [PATCH 6.18 098/614] ice: move service task start out of ice_init_pf()
Date: Tue, 16 Dec 2025 12:07:45 +0100
Message-ID: <20251216111404.868619632@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111401.280873349@linuxfoundation.org>
References: <20251216111401.280873349@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Przemek Kitszel <przemyslaw.kitszel@intel.com>

[ Upstream commit 806c4f32a80627f8977fda53520afc41491d162f ]

Move service task start out of ice_init_pf(). Do analogous with deinit.
Service task is needed up to the very end of driver removal, later commit
of the series will move it later on execution timeline.

Signed-off-by: Przemek Kitszel <przemyslaw.kitszel@intel.com>
Tested-by: Rinitha S <sx.rinitha@intel.com> (A Contingent worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Stable-dep-of: 1390b8b3d2be ("ice: remove duplicate call to ice_deinit_hw() on error paths")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ice/ice.h      |  1 +
 drivers/net/ethernet/intel/ice/ice_main.c | 18 +++++++++++-------
 2 files changed, 12 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice.h b/drivers/net/ethernet/intel/ice/ice.h
index 22b8323ff0d0e..0e58a58c23eb3 100644
--- a/drivers/net/ethernet/intel/ice/ice.h
+++ b/drivers/net/ethernet/intel/ice/ice.h
@@ -1029,6 +1029,7 @@ int ice_open(struct net_device *netdev);
 int ice_open_internal(struct net_device *netdev);
 int ice_stop(struct net_device *netdev);
 void ice_service_task_schedule(struct ice_pf *pf);
+void ice_start_service_task(struct ice_pf *pf);
 int ice_load(struct ice_pf *pf);
 void ice_unload(struct ice_pf *pf);
 void ice_adv_lnk_speed_maps_init(void);
diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index 86f5859e88ef5..41c2f0d52ce0d 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -3951,7 +3951,6 @@ u16 ice_get_avail_rxq_count(struct ice_pf *pf)
  */
 static void ice_deinit_pf(struct ice_pf *pf)
 {
-	ice_service_task_stop(pf);
 	mutex_destroy(&pf->lag_mutex);
 	mutex_destroy(&pf->adev_mutex);
 	mutex_destroy(&pf->sw_mutex);
@@ -4030,6 +4029,14 @@ static void ice_set_pf_caps(struct ice_pf *pf)
 	pf->max_pf_rxqs = func_caps->common_cap.num_rxq;
 }
 
+void ice_start_service_task(struct ice_pf *pf)
+{
+	timer_setup(&pf->serv_tmr, ice_service_timer, 0);
+	pf->serv_tmr_period = HZ;
+	INIT_WORK(&pf->serv_task, ice_service_task);
+	clear_bit(ICE_SERVICE_SCHED, pf->state);
+}
+
 /**
  * ice_init_pf - Initialize general software structures (struct ice_pf)
  * @pf: board private structure to initialize
@@ -4049,12 +4056,6 @@ static int ice_init_pf(struct ice_pf *pf)
 
 	init_waitqueue_head(&pf->reset_wait_queue);
 
-	/* setup service timer and periodic service task */
-	timer_setup(&pf->serv_tmr, ice_service_timer, 0);
-	pf->serv_tmr_period = HZ;
-	INIT_WORK(&pf->serv_task, ice_service_task);
-	clear_bit(ICE_SERVICE_SCHED, pf->state);
-
 	mutex_init(&pf->avail_q_mutex);
 	pf->avail_txqs = bitmap_zalloc(pf->max_pf_txqs, GFP_KERNEL);
 	if (!pf->avail_txqs)
@@ -4745,6 +4746,7 @@ int ice_init_dev(struct ice_pf *pf)
 		ice_set_safe_mode_caps(hw);
 	}
 
+	ice_start_service_task(pf);
 	err = ice_init_pf(pf);
 	if (err) {
 		dev_err(dev, "ice_init_pf failed: %d\n", err);
@@ -4791,6 +4793,7 @@ int ice_init_dev(struct ice_pf *pf)
 	ice_clear_interrupt_scheme(pf);
 unroll_pf_init:
 	ice_deinit_pf(pf);
+	ice_service_task_stop(pf);
 	return err;
 }
 
@@ -4799,6 +4802,7 @@ void ice_deinit_dev(struct ice_pf *pf)
 	ice_free_irq_msix_misc(pf);
 	ice_deinit_pf(pf);
 	ice_deinit_hw(&pf->hw);
+	ice_service_task_stop(pf);
 
 	/* Service task is already stopped, so call reset directly. */
 	ice_reset(&pf->hw, ICE_RESET_PFR);
-- 
2.51.0



