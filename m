Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53D6430E832;
	Tue,  2 Sep 2025 13:25:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756819524; cv=none; b=Qk08gcD1lp4JAwOzcOTJO4gpzQ3FLhkhRK8vxKfauWfP7noq78lU0IEBJ9vopOBjwiFZh6NBQaXQLGhTBDISuz0MWLfcJM1Fv/2Z5U/hpwhmUVWMeL/R8dyZ2tRg/JAHuhKUDhe+uGeEFqA1KyabCmwn+a52jNr9vaAfgJAYnJA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756819524; c=relaxed/simple;
	bh=jJ2Hw1muXSj7WrWcSXYRs5Ek8MHMwtUjdbZsWz1MZP0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P1iTi4T6N5+tZY0yu2FmlD6Vb/eZusxqmQZZDW8M4edQcC+cq5/ZwCF7RZIS8SPMjGQgGRdKp/zOy+9Do7U5DetexYkdB8pmWbPpGP8dIdTQf3yDqxM7JyHDI8ncBRL31uFcrHP+SZyx4jZUD7AHZwfmGu4s8Zklegca5qX6fZ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aGSgx7jQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aGSgx7jQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D1AEC4CEED;
	Tue,  2 Sep 2025 13:25:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756819524;
	bh=jJ2Hw1muXSj7WrWcSXYRs5Ek8MHMwtUjdbZsWz1MZP0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aGSgx7jQ0+GywWNP+h5I1GOiSf48lLbf/cOFHy2vxJDruQVo80c8kEvwGFRvPnhUS
	 mMujSFgWKwdXromchCcGaCXex1GY4fxOyMxw5DgXF0J2vCc3cY6BmSQz98h1wvpUrH
	 aziZmq23TXOX3ChYctO/TUZI3JylcV8Kwp8O5jww=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jacob Keller <jacob.e.keller@intel.com>,
	Simon Horman <horms@kernel.org>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	Rinitha S <sx.rinitha@intel.com>
Subject: [PATCH 6.16 058/142] ice: dont leave device non-functional if Tx scheduler config fails
Date: Tue,  2 Sep 2025 15:19:20 +0200
Message-ID: <20250902131950.473891114@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250902131948.154194162@linuxfoundation.org>
References: <20250902131948.154194162@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jacob Keller <jacob.e.keller@intel.com>

[ Upstream commit 86aae43f21cf784c1d7f6a9af93e5116b0f232ab ]

The ice_cfg_tx_topo function attempts to apply Tx scheduler topology
configuration based on NVM parameters, selecting either a 5 or 9 layer
topology.

As part of this flow, the driver acquires the "Global Configuration Lock",
which is a hardware resource associated with programming the DDP package
to the device. This "lock" is implemented by firmware as a way to
guarantee that only one PF can program the DDP for a device. Unlike a
traditional lock, once a PF has acquired this lock, no other PF will be
able to acquire it again (including that PF) until a CORER of the device.
Future requests to acquire the lock report that global configuration has
already completed.

The following flow is used to program the Tx topology:

 * Read the DDP package for scheduler configuration data
 * Acquire the global configuration lock
 * Program Tx scheduler topology according to DDP package data
 * Trigger a CORER which clears the global configuration lock

This is followed by the flow for programming the DDP package:

 * Acquire the global configuration lock (again)
 * Download the DDP package to the device
 * Release the global configuration lock.

However, if configuration of the Tx topology fails, (i.e.
ice_get_set_tx_topo returns an error code), the driver exits
ice_cfg_tx_topo() immediately, and fails to trigger CORER.

While the global configuration lock is held, the firmware rejects most
AdminQ commands, as it is waiting for the DDP package download (or Tx
scheduler topology programming) to occur.

The current driver flows assume that the global configuration lock has been
reset by CORER after programming the Tx topology. Thus, the same PF
attempts to acquire the global lock again, and fails. This results in the
driver reporting "an unknown error occurred when loading the DDP package".
It then attempts to enter safe mode, but ultimately fails to finish
ice_probe() since nearly all AdminQ command report error codes, and the
driver stops loading the device at some point during its initialization.

The only currently known way that ice_get_set_tx_topo() can fail is with
certain older DDP packages which contain invalid topology configuration, on
firmware versions which strictly validate this data. The most recent
releases of the DDP have resolved the invalid data. However, it is still
poor practice to essentially brick the device, and prevent access to the
device even through safe mode or recovery mode. It is also plausible that
this command could fail for some other reason in the future.

We cannot simply release the global lock after a failed call to
ice_get_set_tx_topo(). Releasing the lock indicates to firmware that global
configuration (downloading of the DDP) has completed. Future attempts by
this or other PFs to load the DDP will fail with a report that the DDP
package has already been downloaded. Then, PFs will enter safe mode as they
realize that the package on the device does not meet the minimum version
requirement to load. The reported error messages are confusing, as they
indicate the version of the default "safe mode" package in the NVM, rather
than the version of the file loaded from /lib/firmware.

Instead, we need to trigger CORER to clear global configuration. This is
the lowest level of hardware reset which clears the global configuration
lock and related state. It also clears any already downloaded DDP.
Crucially, it does *not* clear the Tx scheduler topology configuration.

Refactor ice_cfg_tx_topo() to always trigger a CORER after acquiring the
global lock, regardless of success or failure of the topology
configuration.

We need to re-initialize the HW structure when we trigger the CORER. Thus,
it makes sense for this to be the responsibility of ice_cfg_tx_topo()
rather than its caller, ice_init_tx_topology(). This avoids needless
re-initialization in cases where we don't attempt to update the Tx
scheduler topology, such as if it has already been programmed.

There is one catch: failure to re-initialize the HW struct should stop
ice_probe(). If this function fails, we won't have a valid HW structure and
cannot ensure the device is functioning properly. To handle this, ensure
ice_cfg_tx_topo() returns a limited set of error codes. Set aside one
specifically, -ENODEV, to indicate that the ice_init_tx_topology() should
fail and stop probe.

Other error codes indicate failure to apply the Tx scheduler topology. This
is treated as a non-fatal error, with an informational message informing
the system administrator that the updated Tx topology did not apply. This
allows the device to load and function with the default Tx scheduler
topology, rather than failing to load entirely.

Note that this use of CORER will not result in loops with future PFs
attempting to also load the invalid Tx topology configuration. The first PF
will acquire the global configuration lock as part of programming the DDP.
Each PF after this will attempt to acquire the global lock as part of
programming the Tx topology, and will fail with the indication from
firmware that global configuration is already complete. Tx scheduler
topology configuration is only performed during driver init (probe or
devlink reload) and not during cleanup for a CORER that happens after probe
completes.

Fixes: 91427e6d9030 ("ice: Support 5 layer topology")
Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Tested-by: Rinitha S <sx.rinitha@intel.com> (A Contingent worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ice/ice_ddp.c  | 44 ++++++++++++++++-------
 drivers/net/ethernet/intel/ice/ice_main.c | 16 ++++++---
 2 files changed, 43 insertions(+), 17 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_ddp.c b/drivers/net/ethernet/intel/ice/ice_ddp.c
index 351824dc3c624..1d3e1b188d22c 100644
--- a/drivers/net/ethernet/intel/ice/ice_ddp.c
+++ b/drivers/net/ethernet/intel/ice/ice_ddp.c
@@ -2376,7 +2376,13 @@ ice_get_set_tx_topo(struct ice_hw *hw, u8 *buf, u16 buf_size,
  * The function will apply the new Tx topology from the package buffer
  * if available.
  *
- * Return: zero when update was successful, negative values otherwise.
+ * Return:
+ * * 0 - Successfully applied topology configuration.
+ * * -EBUSY - Failed to acquire global configuration lock.
+ * * -EEXIST - Topology configuration has already been applied.
+ * * -EIO - Unable to apply topology configuration.
+ * * -ENODEV - Failed to re-initialize device after applying configuration.
+ * * Other negative error codes indicate unexpected failures.
  */
 int ice_cfg_tx_topo(struct ice_hw *hw, const void *buf, u32 len)
 {
@@ -2409,7 +2415,7 @@ int ice_cfg_tx_topo(struct ice_hw *hw, const void *buf, u32 len)
 
 	if (status) {
 		ice_debug(hw, ICE_DBG_INIT, "Get current topology is failed\n");
-		return status;
+		return -EIO;
 	}
 
 	/* Is default topology already applied ? */
@@ -2496,31 +2502,45 @@ int ice_cfg_tx_topo(struct ice_hw *hw, const void *buf, u32 len)
 				 ICE_GLOBAL_CFG_LOCK_TIMEOUT);
 	if (status) {
 		ice_debug(hw, ICE_DBG_INIT, "Failed to acquire global lock\n");
-		return status;
+		return -EBUSY;
 	}
 
 	/* Check if reset was triggered already. */
 	reg = rd32(hw, GLGEN_RSTAT);
 	if (reg & GLGEN_RSTAT_DEVSTATE_M) {
-		/* Reset is in progress, re-init the HW again */
 		ice_debug(hw, ICE_DBG_INIT, "Reset is in progress. Layer topology might be applied already\n");
 		ice_check_reset(hw);
-		return 0;
+		/* Reset is in progress, re-init the HW again */
+		goto reinit_hw;
 	}
 
 	/* Set new topology */
 	status = ice_get_set_tx_topo(hw, new_topo, size, NULL, NULL, true);
 	if (status) {
-		ice_debug(hw, ICE_DBG_INIT, "Failed setting Tx topology\n");
-		return status;
+		ice_debug(hw, ICE_DBG_INIT, "Failed to set Tx topology, status %pe\n",
+			  ERR_PTR(status));
+		/* only report -EIO here as the caller checks the error value
+		 * and reports an informational error message informing that
+		 * the driver failed to program Tx topology.
+		 */
+		status = -EIO;
 	}
 
-	/* New topology is updated, delay 1 second before issuing the CORER */
+	/* Even if Tx topology config failed, we need to CORE reset here to
+	 * clear the global configuration lock. Delay 1 second to allow
+	 * hardware to settle then issue a CORER
+	 */
 	msleep(1000);
 	ice_reset(hw, ICE_RESET_CORER);
-	/* CORER will clear the global lock, so no explicit call
-	 * required for release.
-	 */
+	ice_check_reset(hw);
+
+reinit_hw:
+	/* Since we triggered a CORER, re-initialize hardware */
+	ice_deinit_hw(hw);
+	if (ice_init_hw(hw)) {
+		ice_debug(hw, ICE_DBG_INIT, "Failed to re-init hardware after setting Tx topology\n");
+		return -ENODEV;
+	}
 
-	return 0;
+	return status;
 }
diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index 0a11b4281092e..d42892c8c5a12 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -4532,17 +4532,23 @@ ice_init_tx_topology(struct ice_hw *hw, const struct firmware *firmware)
 			dev_info(dev, "Tx scheduling layers switching feature disabled\n");
 		else
 			dev_info(dev, "Tx scheduling layers switching feature enabled\n");
-		/* if there was a change in topology ice_cfg_tx_topo triggered
-		 * a CORER and we need to re-init hw
+		return 0;
+	} else if (err == -ENODEV) {
+		/* If we failed to re-initialize the device, we can no longer
+		 * continue loading.
 		 */
-		ice_deinit_hw(hw);
-		err = ice_init_hw(hw);
-
+		dev_warn(dev, "Failed to initialize hardware after applying Tx scheduling configuration.\n");
 		return err;
 	} else if (err == -EIO) {
 		dev_info(dev, "DDP package does not support Tx scheduling layers switching feature - please update to the latest DDP package and try again\n");
+		return 0;
+	} else if (err == -EEXIST) {
+		return 0;
 	}
 
+	/* Do not treat this as a fatal error. */
+	dev_info(dev, "Failed to apply Tx scheduling configuration, err %pe\n",
+		 ERR_PTR(err));
 	return 0;
 }
 
-- 
2.50.1



