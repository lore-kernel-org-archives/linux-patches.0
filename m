Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E9C71FF5EC;
	Wed,  7 May 2025 18:52:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746643925; cv=none; b=AO1WYqi8PRLhgcI4qLZlLK5gM49j3Sj/XKfYaLc3jvfTUy0MZXcWmirKMWIVyjX64IV37kZRMncfn7flR8h4cGrzbE/xCOBMAhmcrQBOYjnvzggowcADEwk2NK/mFapsyzDWHvLbbkPeUOs+Ba2qkkY91PkSTZ0liNYH1IZ2aLw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746643925; c=relaxed/simple;
	bh=aptISNm4DiO5cyI+eCe6Ey6tF15XROU1Y1KkZY/kW+A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Hxo93uS9flAgEuVwwWV3iclJ0o+HKeJ/FScZJDT2+4ijjqqQ1kE95qLvaDSZfZ5iJYH30/ZyRHOfKrGbaupJJF7m2Qf4/X86TVRQQWi929ZFJLpDSDXSUkkizWcVb1txreAMJhjxUubBomkpE92Gf399SxqMk/MxQn/WrX41n88=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nPj6suir; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nPj6suir"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8AA49C4CEE2;
	Wed,  7 May 2025 18:52:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1746643924;
	bh=aptISNm4DiO5cyI+eCe6Ey6tF15XROU1Y1KkZY/kW+A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nPj6suirsJON17g191sHC4iHks88+VwoV/FspY998KeFQQ52bNxBpFi0FDnX2IuRZ
	 JH37ta/Br8IizWYQZ+y9YlSUPaoLJqrkUUD2Vh4/Ytli3HcMwWPEmAWId2r8DCjoM8
	 NCXC0aM2B3Nul0bEArR1TSR2KdfH5i8z/PfmcF/4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 063/183] wifi: iwlwifi: fix the check for the SCRATCH register upon resume
Date: Wed,  7 May 2025 20:38:28 +0200
Message-ID: <20250507183827.249525278@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250507183824.682671926@linuxfoundation.org>
References: <20250507183824.682671926@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

[ Upstream commit a17821321a9b42f26e77335cd525fee72dc1cd63 ]

We can't rely on the SCRATCH register being 0 on platform that power
gate the NIC in S3. Even in those platforms, the SCRATCH register is
still returning 0x1010000.

Make sure that we understand that those platforms have powered off the
device.

Closes: https://bugzilla.kernel.org/show_bug.cgi?id=219597
Fixes: cb347bd29d0d ("wifi: iwlwifi: mvm: fix hibernation")
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Link: https://patch.msgid.link/20250420095642.a7e082ee785c.I9418d76f860f54261cfa89e1f7ac10300904ba40@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/iwl-csr.h  | 1 +
 drivers/net/wireless/intel/iwlwifi/pcie/drv.c | 6 ++++--
 2 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-csr.h b/drivers/net/wireless/intel/iwlwifi/iwl-csr.h
index be9e464c9b7b0..3ff493e920d28 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-csr.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-csr.h
@@ -148,6 +148,7 @@
  * during a error FW error.
  */
 #define CSR_FUNC_SCRATCH_INIT_VALUE		(0x01010101)
+#define CSR_FUNC_SCRATCH_POWER_OFF_MASK		0xFFFF
 
 /* Bits for CSR_HW_IF_CONFIG_REG */
 #define CSR_HW_IF_CONFIG_REG_MSK_MAC_STEP_DASH	(0x0000000F)
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/drv.c b/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
index 89a28e42975cb..d4c1bc20971fb 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
@@ -1702,11 +1702,13 @@ static int _iwl_pci_resume(struct device *device, bool restore)
 	 * Scratch value was altered, this means the device was powered off, we
 	 * need to reset it completely.
 	 * Note: MAC (bits 0:7) will be cleared upon suspend even with wowlan,
-	 * so assume that any bits there mean that the device is usable.
+	 * but not bits [15:8]. So if we have bits set in lower word, assume
+	 * the device is alive.
 	 * For older devices, just try silently to grab the NIC.
 	 */
 	if (trans->trans_cfg->device_family >= IWL_DEVICE_FAMILY_BZ) {
-		if (!iwl_read32(trans, CSR_FUNC_SCRATCH))
+		if (!(iwl_read32(trans, CSR_FUNC_SCRATCH) &
+		      CSR_FUNC_SCRATCH_POWER_OFF_MASK))
 			device_was_powered_off = true;
 	} else {
 		/*
-- 
2.39.5



