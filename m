Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E35792528E6;
	Mon, 12 May 2025 17:55:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747072541; cv=none; b=cMeHSxgpDTPMjBQFIgD8NSANIq9qX3cOra7zkkJg52qdSiAQMYj9i99wNY7gBPOFM/IvZFAwmU2luiD2eDxlQiBwWBFavzB13RIxxecdN4XXzPS2138KSUz732XwQ/0WrftqwZQ5S1eMut59E06hGXoKqjYTXEAoBvai3yeUbcg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747072541; c=relaxed/simple;
	bh=Uq2vpzuIgFUsvRTSs9kJXPAIepw8L9JqWyEG63sIC54=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Hv1CnZEPioF+l2FoWXsVc6e/dEySBnmz/FqWOD6S90+Qq7ABV1Srt7GUUwV7xEM4HmrsMr+0GSUy3JhoCA2LMwDWNRA5cRsECxFKfudi5HMuCnr4IZP9/BxCTIg50NK++xfSRoFQqHDNSWU1imiohLBTJxpcTn9u/li3xjpknRY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FGpbEDyy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FGpbEDyy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C295C4CEE7;
	Mon, 12 May 2025 17:55:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747072540;
	bh=Uq2vpzuIgFUsvRTSs9kJXPAIepw8L9JqWyEG63sIC54=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FGpbEDyyTqzRBrudPMombMpcvgeL1ywLTfCywAAzw8Jo6kTgSEhScckLoclKkoPMh
	 xD5FBM793hb+sh+nqNNgdYEXrJPrPjPvgM98v3l4T271En6n+7pRuSdObnStQNVgPb
	 rZmUw4ugbiHkhgEGpeUr6c6wjM8nRegwPnV7Twgk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	James Morse <james.morse@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>
Subject: [PATCH 6.1 73/92] arm64: proton-pack: Expose whether the platform is mitigated by firmware
Date: Mon, 12 May 2025 19:45:48 +0200
Message-ID: <20250512172026.097793325@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250512172023.126467649@linuxfoundation.org>
References: <20250512172023.126467649@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: James Morse <james.morse@arm.com>

commit e7956c92f396a44eeeb6eaf7a5b5e1ad24db6748 upstream.

is_spectre_bhb_fw_affected() allows the caller to determine if the CPU
is known to need a firmware mitigation. CPUs are either on the list
of CPUs we know about, or firmware has been queried and reported that
the platform is affected - and mitigated by firmware.

This helper is not useful to determine if the platform is mitigated
by firmware. A CPU could be on the know list, but the firmware may
not be implemented. Its affected but not mitigated.

spectre_bhb_enable_mitigation() handles this distinction by checking
the firmware state before enabling the mitigation.

Add a helper to expose this state. This will be used by the BPF JIT
to determine if calling firmware for a mitigation is necessary and
supported.

Signed-off-by: James Morse <james.morse@arm.com>
Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/include/asm/spectre.h |    1 +
 arch/arm64/kernel/proton-pack.c  |    5 +++++
 2 files changed, 6 insertions(+)

--- a/arch/arm64/include/asm/spectre.h
+++ b/arch/arm64/include/asm/spectre.h
@@ -96,6 +96,7 @@ enum mitigation_state arm64_get_meltdown
 
 enum mitigation_state arm64_get_spectre_bhb_state(void);
 bool is_spectre_bhb_affected(const struct arm64_cpu_capabilities *entry, int scope);
+bool is_spectre_bhb_fw_mitigated(void);
 void spectre_bhb_enable_mitigation(const struct arm64_cpu_capabilities *__unused);
 #endif	/* __ASSEMBLY__ */
 #endif	/* __ASM_SPECTRE_H */
--- a/arch/arm64/kernel/proton-pack.c
+++ b/arch/arm64/kernel/proton-pack.c
@@ -1108,6 +1108,11 @@ void spectre_bhb_enable_mitigation(const
 	update_mitigation_state(&spectre_bhb_state, state);
 }
 
+bool is_spectre_bhb_fw_mitigated(void)
+{
+	return test_bit(BHB_FW, &system_bhb_mitigations);
+}
+
 /* Patched to NOP when enabled */
 void noinstr spectre_bhb_patch_loop_mitigation_enable(struct alt_instr *alt,
 						     __le32 *origptr,


