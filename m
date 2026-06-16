Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E206F3A16AC;
	Tue, 16 Jun 2026 16:02:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781625777; cv=none; b=pOB0TDYITm49L0vdEbHf3WTnARA1oYnbht5SRDxcICpOZoS5tWZY4Doop/9DtKf51FCe2m122UDVPrSLnaLaLRqjbheFuhVTR6bsoLvtjve1+7yGk1dBszU8zmI8VMzACF6sdx7kYq4d1WeIf2k0QpYnoNs4EtyrSpStg3RGFhE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781625777; c=relaxed/simple;
	bh=wBIgiiaosq+JDkAogFtvjYOLQbKL4XJm3hlGYVfyopo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L67Lq9+FYD4z7ANyPU6zZLgLvUlRaU9A62Von+HFhN9v2EfW8BOnyGSGfXoZqToqE+3RKxgnbu+CedfNvg63Mv8t7CSBXUU+3pRvaofSKIyLBA1lLMvC4aPcx6NZDJ4CEvJfvDhKt+2ibNaN0di6dwm6iYhZB6xCHz+iFArLyPQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zSUCS0il; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zSUCS0il"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BACC61F000E9;
	Tue, 16 Jun 2026 16:02:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781625776;
	bh=JCx/ilaYQz/A6Dp11Fw0tVPN3d0JR7m3i1B3515DOIs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zSUCS0ilYrAsQIfgF41sKKvty2eOQ/mLjpoZxksmeRabOCGAO1AnmJhRtFaw7Ipco
	 XyH5mT5DLrPivyxyuAhgYFHpvhU/tjko0DLh1iAqSM1KN4S/lpPtT2RZXMLOo5YQqr
	 q01aubLkBOZkYBXA7XYZM+e9qtTpluxsg8Gt5am8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>
Subject: [PATCH 6.18 205/325] wifi: iwlwifi: pcie: simplify the resume flow if fast resume is not used
Date: Tue, 16 Jun 2026 20:30:01 +0530
Message-ID: <20260616145108.257211308@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145057.827196531@linuxfoundation.org>
References: <20260616145057.827196531@linuxfoundation.org>
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

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

commit 093305d801fae6ff9b8bb531fd78b579794c4f80 upstream.

In most distributions, NetworkManager shuts the device down before
entering system suspend, so fast suspend is typically not used.

On older devices, resume currently tries to grab NIC access to infer
whether the device was powered off while suspended. That probe is only
meaningful for the fast-suspend path where the device is expected to
remain alive.

Unfortunately, for unclear reasons, grabbing NIC access was harmful as
reported in the bugzilla ticket below.

Workaround this issue by simply not grabbing NIC access if fast suspend
is not used.

Cc: stable@vger.kernel.org
Closes: https://bugzilla.kernel.org/show_bug.cgi?id=221501
Assisted-by: GitHub Copilot:gpt-5.3-codex
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Link: https://patch.msgid.link/20260531133005.e2ed9e0cd44f.If283625983a843933e0c01561a421daff184e9e9@changeid
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/intel/iwlwifi/pcie/drv.c |   56 ++++++++++++++------------
 1 file changed, 32 insertions(+), 24 deletions(-)

--- a/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
@@ -1224,33 +1224,41 @@ static int _iwl_pci_resume(struct device
 	if (!trans->op_mode)
 		return 0;
 
-	/*
-	 * Scratch value was altered, this means the device was powered off, we
-	 * need to reset it completely.
-	 * Note: MAC (bits 0:7) will be cleared upon suspend even with wowlan,
-	 * but not bits [15:8]. So if we have bits set in lower word, assume
-	 * the device is alive.
-	 * Alternatively, if the scratch value is 0xFFFFFFFF, then we no longer
-	 * have access to the device and consider it powered off.
-	 * For older devices, just try silently to grab the NIC.
-	 */
-	if (trans->mac_cfg->device_family >= IWL_DEVICE_FAMILY_BZ) {
-		u32 scratch = iwl_read32(trans, CSR_FUNC_SCRATCH);
-
-		if (!(scratch & CSR_FUNC_SCRATCH_POWER_OFF_MASK) ||
-		    scratch == ~0U)
-			device_was_powered_off = true;
-	} else {
+	if (test_bit(STATUS_DEVICE_ENABLED, &trans->status)) {
 		/*
-		 * bh are re-enabled by iwl_trans_pcie_release_nic_access,
-		 * so re-enable them if _iwl_trans_pcie_grab_nic_access fails.
+		 * Scratch value was altered, this means the device was powered
+		 * off, we need to reset it completely.
+		 * Note: MAC (bits 0:7) will be cleared upon suspend even with
+		 * wowlan, but not bits [15:8]. So if we have bits set in lower
+		 * word, assume the device is alive.
+		 * Alternatively, if the scratch value is 0xFFFFFFFF, then we
+		 * no longer have access to the device and consider it powered
+		 * off.
+		 * For older devices, just try silently to grab the NIC.
 		 */
-		local_bh_disable();
-		if (_iwl_trans_pcie_grab_nic_access(trans, true)) {
-			iwl_trans_pcie_release_nic_access(trans);
+		if (trans->mac_cfg->device_family >= IWL_DEVICE_FAMILY_BZ) {
+			u32 scratch = iwl_read32(trans, CSR_FUNC_SCRATCH);
+
+			if (!(scratch & CSR_FUNC_SCRATCH_POWER_OFF_MASK) ||
+			    scratch == ~0U) {
+				IWL_DEBUG_WOWLAN(trans,
+						 "Scratch 0x%08x indicates device was powered off\n",
+						 scratch);
+				device_was_powered_off = true;
+			}
 		} else {
-			device_was_powered_off = true;
-			local_bh_enable();
+			/*
+			 * bh are re-enabled by iwl_trans_pcie_release_nic_access,
+			 * so re-enable them if _iwl_trans_pcie_grab_nic_access
+			 * fails.
+			 */
+			local_bh_disable();
+			if (_iwl_trans_pcie_grab_nic_access(trans, true)) {
+				iwl_trans_pcie_release_nic_access(trans);
+			} else {
+				device_was_powered_off = true;
+				local_bh_enable();
+			}
 		}
 	}
 


