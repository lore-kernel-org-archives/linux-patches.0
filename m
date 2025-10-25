Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3776730C60F;
	Sat, 25 Oct 2025 16:22:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761409365; cv=none; b=OVkx8IxgoMf5KxIthmJDP6R/lW1UIzb7jcfcOcopka30E+iQexfGaiZbiTqxMRZVph0PrVHCcDlgYyiSH/NHzcooTUt+6LqJ6w3fLu4Jmdjwmnih9A8yscMJNaQZ/wHSqUZDgpe0r/J9XlnbU4bzw68OiKpQ07XsniBB8YB46rw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761409365; c=relaxed/simple;
	bh=HaMaolU2VTvvQDkKzvyK+NTKERxojYbLs9eI5uyya44=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M18+fpn47nA3YzYT1lEX0b+Q9x91u1efovlUMrHq0ej2K0jrjF6y5+EF05rP1XJTAeYN+lHz2zp4+N+Cr72ya+wUi/3ixx+sRWdSj4LsE7JHtiRfqUJJiutz+IG+aP9wibjF/DrF8TMC1074kueoEPmQFHa4GicxsU3ei5rVc/w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PM1bQWOd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PM1bQWOd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E7ECC4CEFB;
	Sat, 25 Oct 2025 16:22:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761409365;
	bh=HaMaolU2VTvvQDkKzvyK+NTKERxojYbLs9eI5uyya44=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PM1bQWOdTpeiVkM/3rmbXbIpnkZtFcsNzm22szcTJZBOvTnIV9wwZwPcwt9hlhdfV
	 YQH46moSSqXdA9cWKGuZ+tXbU2eG6aOqyXeE8ofHQkJ/ACmIpiS7dUfEnwbtVksnjJ
	 ooOw3teRzSpCQkMdpag3v+DfBMmjE5DJh1KpcW5106Ywgi8bmsabFSh4BLwdDGmRQt
	 MqxqODXfVhFuD19OOw9rt+SHl40FgGSgsrwyQCnGfm2IP13HKdH5kuh+sUg8OkG+jO
	 opbWSuIkKQQtilgGFSHuVNazeReROQdIFnHVA+ZOxQL83R+zoJDOKGmTV2nElDC++W
	 UKNXxBfvrGoaw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Yedidya Ben Shimol <yedidya.ben.shimol@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	johannes.berg@intel.com,
	emmanuel.grumbach@intel.com,
	rotem.kerem@intel.com
Subject: [PATCH AUTOSEL 6.17] wifi: iwlwifi: pcie: remember when interrupts are disabled
Date: Sat, 25 Oct 2025 11:58:42 -0400
Message-ID: <20251025160905.3857885-291-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251025160905.3857885-1-sashal@kernel.org>
References: <20251025160905.3857885-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.17.5
Content-Transfer-Encoding: 8bit

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

LLM Generated explanations, may be completely bogus:

YES

- What changed
  - In MSI-X mode, `_iwl_disable_interrupts()` now also clears the
    software-tracked masks by setting `trans_pcie->fh_mask = 0` and
    `trans_pcie->hw_mask = 0` after masking all causes in hardware
    (`CSR_MSIX_FH_INT_MASK_AD`/`CSR_MSIX_HW_INT_MASK_AD`):
    `drivers/net/wireless/intel/iwlwifi/pcie/gen1_2/internal.h:849` and
    `drivers/net/wireless/intel/iwlwifi/pcie/gen1_2/internal.h:850`.
  - In `iwl_enable_rfkill_int()`, after disabling all FH causes in
    hardware, the driver now records that no FH causes are enabled in
    software with `trans_pcie->fh_mask = 0`:
    `drivers/net/wireless/intel/iwlwifi/pcie/gen1_2/internal.h:1033`.

- Why this fixes a real bug
  - The MSI-X interrupt handler explicitly filters incoming causes using
    the software masks:
    - FH causes: `inta_fh &= trans_pcie->fh_mask;` at
      `drivers/net/wireless/intel/iwlwifi/pcie/gen1_2/rx.c:2314`
    - HW causes: `inta_hw &= trans_pcie->hw_mask;` at
      `drivers/net/wireless/intel/iwlwifi/pcie/gen1_2/rx.c:2416`
  - Before this change, when interrupts were masked in hardware, the
    software masks (`fh_mask`/`hw_mask`) were not reset and could still
    reflect previously enabled causes. If a spurious interrupt arrived
    during shutdown/reset or during rfkill-only mode, the ISR would
    process it because the software masks still allowed it. The ISR even
    logs this mismatch:
    - FH masked interrupt detection:
      `drivers/net/wireless/intel/iwlwifi/pcie/gen1_2/rx.c:2308`
    - HW masked interrupt detection:
      `drivers/net/wireless/intel/iwlwifi/pcie/gen1_2/rx.c:2410`
  - Clearing `fh_mask`/`hw_mask` to 0 on disable makes the ISR ignore
    any such stray causes (due to the AND), preventing unintended NAPI
    scheduling, state transitions, or error handling during device
    teardown, reset, or low-power/rfkill transitions.

- Scope and risk assessment
  - Limited to MSI-X paths; non-MSI-X interrupt handling remains
    unchanged (`inta_mask` path unaffected):
    `drivers/net/wireless/intel/iwlwifi/pcie/gen1_2/internal.h:835-843`.
  - No API or architectural changes; only aligns software state
    variables with the hardware-disabled state.
  - Interactions are straightforward: enabling paths already set
    `fh_mask`/`hw_mask` to the desired enabled causes (e.g.,
    `iwl_enable_interrupts()` sets both masks and writes ~mask to the HW
    registers:
    `drivers/net/wireless/intel/iwlwifi/pcie/gen1_2/internal.h:912-917`;
    `iwl_enable_hw_int_msk_msix()`/`iwl_enable_fh_int_msk_msix()` assign
    the masks as well: `drivers/net/wireless/intel/iwlwifi/pcie/gen1_2/i
    nternal.h:929-943`).
  - The change prevents race-induced misprocessing; it does not open new
    code paths or alter timing beyond ignoring masked causes. It is a
    correctness fix with minimal regression risk.

- Stable backport criteria
  - Fixes a real bug that can affect users during device
    shutdown/reset/rfkill transitions by avoiding processing of
    interrupts that should be ignored.
  - Small, self-contained changes in a single header file within the
    iwlwifi PCIe MSI-X handling.
  - No new features, no ABI changes, no architectural rework.
  - Touches a well-scoped subsystem (iwlwifi PCIe interrupt handling).

Given the clear bug scenario and the minimal, targeted nature of the
fix, this is a good candidate for stable backport.

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

