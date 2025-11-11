Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 390D92D29D6;
	Tue, 11 Nov 2025 01:20:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762824055; cv=none; b=ala+eb8WtA4GX6ArjcWuyXk5k2D9ra1ATR4eqaCUeJlisAwm/HTbo42xzaYbHRRug5SoO6W2zsj8E5lU0j1+y1Ahff6N5VpFXMrGx8b8y61XkJXbA/ykmDRCI/YP9RyOa5UYE5ozz5H+npXF2VBgGDRvbxnbG8wMO1Qi96aoulA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762824055; c=relaxed/simple;
	bh=dZHKEU5/+50oroupJkqJCtm41mdrlarp2f3kao4ulpE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZqYJ6XgBhaHRnMX4cUMqQTIlCJe93c7IEtBwSA1jrigCSfLbuf7Dxq4tDx5z87tmAzTm5FpAG04RseVIvHR/Yp34J2b3VxkKHG4we7v+vQozMSaJaZnFGaF9yT64rhY9WZAhChCQEcaUI3amhEU+hWBiOKfKXYLyWcYoJ5WUMOI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Nq5wzLm0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Nq5wzLm0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCA32C4CEF5;
	Tue, 11 Nov 2025 01:20:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762824055;
	bh=dZHKEU5/+50oroupJkqJCtm41mdrlarp2f3kao4ulpE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Nq5wzLm0sErCD/IOA6NOHwnW0rbMVUr53hTB8zsI2ktHQS5SqknKXQNsR9+HpUSWc
	 wZafDmoAMEMzFJ33yG1MpPpKiI81NoZ5D3Zf0IpnxZEtUaEtAXZwXFQ3rfmOlA3+XI
	 lh5TGJF9YsX83Yib8ButwZWFPZ7lydgiR2a9zCTA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yedidya Ben Shimol <yedidya.ben.shimol@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 410/849] wifi: iwlwifi: pcie: remember when interrupts are disabled
Date: Tue, 11 Nov 2025 09:39:40 +0900
Message-ID: <20251111004546.354618741@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Miri Korenblit <miriam.rachel.korenblit@intel.com>

[ Upstream commit 1a33efe4fc64b8135fe94e22299761cc69333404 ]

trans_pcie::fh_mask and hw_mask indicates what are the interrupts are
currently enabled (unmasked).
When we disable all interrupts, those should be set to 0, so if, for
some reason, we get an interrupt even though it was disabled, we will
know to ignore.

Reviewed-by: Yedidya Ben Shimol <yedidya.ben.shimol@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Link: https://patch.msgid.link/20250828111032.e293d6a8385b.I919375e5ad7bd7e4fee4a95ce6ce6978653d6b16@changeid
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/pcie/gen1_2/internal.h | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/gen1_2/internal.h b/drivers/net/wireless/intel/iwlwifi/pcie/gen1_2/internal.h
index f48aeebb151cc..86edc79ac09f8 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/gen1_2/internal.h
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/gen1_2/internal.h
@@ -818,6 +818,8 @@ static inline void _iwl_disable_interrupts(struct iwl_trans *trans)
 			    trans_pcie->fh_init_mask);
 		iwl_write32(trans, CSR_MSIX_HW_INT_MASK_AD,
 			    trans_pcie->hw_init_mask);
+		trans_pcie->fh_mask = 0;
+		trans_pcie->hw_mask = 0;
 	}
 	IWL_DEBUG_ISR(trans, "Disabled interrupts\n");
 }
@@ -1000,6 +1002,7 @@ static inline void iwl_enable_rfkill_int(struct iwl_trans *trans)
 	} else {
 		iwl_write32(trans, CSR_MSIX_FH_INT_MASK_AD,
 			    trans_pcie->fh_init_mask);
+		trans_pcie->fh_mask = 0;
 		iwl_enable_hw_int_msk_msix(trans,
 					   MSIX_HW_INT_CAUSES_REG_RF_KILL);
 	}
-- 
2.51.0



