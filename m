Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A19293C23
	for <patches@lists.linux.dev>; Mon, 19 Jun 2023 10:39:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B68B6C433C8;
	Mon, 19 Jun 2023 10:39:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1687171169;
	bh=YBTDJJCZEkChdkTkp1dIAV5uS1w/tYgwnsW+uFIKwCE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=n848PIb5bRtg4HpuYzN5yYw68d4j1x9n7xQkftu4a2Vc2PgbvckkrhiSN6MJuGnFM
	 k0pPYWtBbaIc0JVfGG2InS58WHgPdNYaxnfaMc68cDwEUsCmzdkUOjoIJBJAfYrqzM
	 Had1xHBkZZlRGduKvYhhaJj6TQZ1FXmiSyA7YWj8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jakub Buchocki <jakubx.buchocki@intel.com>,
	Przemek Kitszel <przemyslaw.kitszel@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Simon Horman <simon.horman@corigine.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	Pucha Himasekhar Reddy <himasekharx.reddy.pucha@intel.com>
Subject: [PATCH 6.3 172/187] ice: Fix ice module unload
Date: Mon, 19 Jun 2023 12:29:50 +0200
Message-ID: <20230619102205.987191282@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230619102157.579823843@linuxfoundation.org>
References: <20230619102157.579823843@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jakub Buchocki <jakubx.buchocki@intel.com>

[ Upstream commit 24b454bc354ab7b1aa918a4fe3d7696516f592d4 ]

Clearing the interrupt scheme before PFR reset,
during the removal routine, could cause the hardware
errors and possibly lead to system reboot, as the PF
reset can cause the interrupt to be generated.

Place the call for PFR reset inside ice_deinit_dev(),
wait until reset and all pending transactions are done,
then call ice_clear_interrupt_scheme().

This introduces a PFR reset to multiple error paths.

Additionally, remove the call for the reset from
ice_load() - it will be a part of ice_unload() now.

Error example:
[   75.229328] ice 0000:ca:00.1: Failed to read Tx Scheduler Tree - User Selection data from flash
[   77.571315] {1}[Hardware Error]: Hardware error from APEI Generic Hardware Error Source: 1
[   77.571418] {1}[Hardware Error]: event severity: recoverable
[   77.571459] {1}[Hardware Error]:  Error 0, type: recoverable
[   77.571500] {1}[Hardware Error]:   section_type: PCIe error
[   77.571540] {1}[Hardware Error]:   port_type: 4, root port
[   77.571580] {1}[Hardware Error]:   version: 3.0
[   77.571615] {1}[Hardware Error]:   command: 0x0547, status: 0x4010
[   77.571661] {1}[Hardware Error]:   device_id: 0000:c9:02.0
[   77.571703] {1}[Hardware Error]:   slot: 25
[   77.571736] {1}[Hardware Error]:   secondary_bus: 0xca
[   77.571773] {1}[Hardware Error]:   vendor_id: 0x8086, device_id: 0x347a
[   77.571821] {1}[Hardware Error]:   class_code: 060400
[   77.571858] {1}[Hardware Error]:   bridge: secondary_status: 0x2800, control: 0x0013
[   77.572490] pcieport 0000:c9:02.0: AER: aer_status: 0x00200000, aer_mask: 0x00100020
[   77.572870] pcieport 0000:c9:02.0:    [21] ACSViol                (First)
[   77.573222] pcieport 0000:c9:02.0: AER: aer_layer=Transaction Layer, aer_agent=Receiver ID
[   77.573554] pcieport 0000:c9:02.0: AER: aer_uncor_severity: 0x00463010
[   77.691273] {2}[Hardware Error]: Hardware error from APEI Generic Hardware Error Source: 1
[   77.691738] {2}[Hardware Error]: event severity: recoverable
[   77.691971] {2}[Hardware Error]:  Error 0, type: recoverable
[   77.692192] {2}[Hardware Error]:   section_type: PCIe error
[   77.692403] {2}[Hardware Error]:   port_type: 4, root port
[   77.692616] {2}[Hardware Error]:   version: 3.0
[   77.692825] {2}[Hardware Error]:   command: 0x0547, status: 0x4010
[   77.693032] {2}[Hardware Error]:   device_id: 0000:c9:02.0
[   77.693238] {2}[Hardware Error]:   slot: 25
[   77.693440] {2}[Hardware Error]:   secondary_bus: 0xca
[   77.693641] {2}[Hardware Error]:   vendor_id: 0x8086, device_id: 0x347a
[   77.693853] {2}[Hardware Error]:   class_code: 060400
[   77.694054] {2}[Hardware Error]:   bridge: secondary_status: 0x0800, control: 0x0013
[   77.719115] pci 0000:ca:00.1: AER: can't recover (no error_detected callback)
[   77.719140] pcieport 0000:c9:02.0: AER: device recovery failed
[   77.719216] pcieport 0000:c9:02.0: AER: aer_status: 0x00200000, aer_mask: 0x00100020
[   77.719390] pcieport 0000:c9:02.0:    [21] ACSViol                (First)
[   77.719557] pcieport 0000:c9:02.0: AER: aer_layer=Transaction Layer, aer_agent=Receiver ID
[   77.719723] pcieport 0000:c9:02.0: AER: aer_uncor_severity: 0x00463010

Fixes: 5b246e533d01 ("ice: split probe into smaller functions")
Signed-off-by: Jakub Buchocki <jakubx.buchocki@intel.com>
Reviewed-by: Przemek Kitszel <przemyslaw.kitszel@intel.com>
Tested-by: Pucha Himasekhar Reddy <himasekharx.reddy.pucha@intel.com> (A Contingent worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Reviewed-by: Simon Horman <simon.horman@corigine.com>
Link: https://lore.kernel.org/r/20230612171421.21570-1-anthony.l.nguyen@intel.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ice/ice_main.c | 16 +++++-----------
 1 file changed, 5 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index 0c949ed22a313..98e8ce743fb2e 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -4794,9 +4794,13 @@ static int ice_init_dev(struct ice_pf *pf)
 static void ice_deinit_dev(struct ice_pf *pf)
 {
 	ice_free_irq_msix_misc(pf);
-	ice_clear_interrupt_scheme(pf);
 	ice_deinit_pf(pf);
 	ice_deinit_hw(&pf->hw);
+
+	/* Service task is already stopped, so call reset directly. */
+	ice_reset(&pf->hw, ICE_RESET_PFR);
+	pci_wait_for_pending_transaction(pf->pdev);
+	ice_clear_interrupt_scheme(pf);
 }
 
 static void ice_init_features(struct ice_pf *pf)
@@ -5086,10 +5090,6 @@ int ice_load(struct ice_pf *pf)
 	struct ice_vsi *vsi;
 	int err;
 
-	err = ice_reset(&pf->hw, ICE_RESET_PFR);
-	if (err)
-		return err;
-
 	err = ice_init_dev(pf);
 	if (err)
 		return err;
@@ -5346,12 +5346,6 @@ static void ice_remove(struct pci_dev *pdev)
 	ice_setup_mc_magic_wake(pf);
 	ice_set_wake(pf);
 
-	/* Issue a PFR as part of the prescribed driver unload flow.  Do not
-	 * do it via ice_schedule_reset() since there is no need to rebuild
-	 * and the service task is already stopped.
-	 */
-	ice_reset(&pf->hw, ICE_RESET_PFR);
-	pci_wait_for_pending_transaction(pdev);
 	pci_disable_device(pdev);
 }
 
-- 
2.39.2



