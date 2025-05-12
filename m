Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE0DE296FB2;
	Mon, 12 May 2025 18:06:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747073212; cv=none; b=EgObicK6LoeIPTPibBPBxiGCiWhm+j60xLfHdgZM691UH+2WigtXbw0pyXpBCrLbLFTEjHS192L87exhtubTk3Bf9FrT7+0ZtJ494s1oHvn6UhIooH7XrD6zcA3Fn2ZAJ79Z+JRllItvmUgn4tM903ybo6Excpui9jnMdgbrD3c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747073212; c=relaxed/simple;
	bh=yUEBbVeFfn8Nc3XwfBjCCUKax7i6NFF+LMeTo/pRlFE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kuW87+NNqSIiIANV23NrCXuUx79ZS9Sg37x2lyU5vkBzFFXBQP/86oYq/RU27kFA9zlKLzn25QRqrlcZEkB67TKMkcb8eps0sPmIxf05Ozcr6pcVZkKeTcxHUNsiJjWwt2IiIynaXxQTIbXPzDhncEda+PD82QCG8VkAKG/AXqU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oewFt2PV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oewFt2PV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FBB1C4CEE7;
	Mon, 12 May 2025 18:06:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747073212;
	bh=yUEBbVeFfn8Nc3XwfBjCCUKax7i6NFF+LMeTo/pRlFE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oewFt2PVdnGVTNm6JJfdYh33pVJsFLhExZMm+5JWfFv6uMpDZhpozJ/7nlhSKXMRk
	 LEHW97/CuGP94jg56uEcg6c7K1D0G0Dlu4yDCKmo7pdNH29KfAbv/sBsQAcnSvxvrW
	 97XemqzNCVg/AkRuBrGnoEjpuTEhY84vAsEGtPfA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	James Morse <james.morse@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>
Subject: [PATCH 6.12 164/184] arm64: proton-pack: Expose whether the branchy loop k value
Date: Mon, 12 May 2025 19:46:05 +0200
Message-ID: <20250512172048.493033698@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250512172041.624042835@linuxfoundation.org>
References: <20250512172041.624042835@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: James Morse <james.morse@arm.com>

commit a1152be30a043d2d4dcb1683415f328bf3c51978 upstream.

Add a helper to expose the k value of the branchy loop. This is needed
by the BPF JIT to generate the mitigation sequence in BPF programs.

Signed-off-by: James Morse <james.morse@arm.com>
Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/include/asm/spectre.h |    1 +
 arch/arm64/kernel/proton-pack.c  |    5 +++++
 2 files changed, 6 insertions(+)

--- a/arch/arm64/include/asm/spectre.h
+++ b/arch/arm64/include/asm/spectre.h
@@ -97,6 +97,7 @@ enum mitigation_state arm64_get_meltdown
 
 enum mitigation_state arm64_get_spectre_bhb_state(void);
 bool is_spectre_bhb_affected(const struct arm64_cpu_capabilities *entry, int scope);
+u8 get_spectre_bhb_loop_value(void);
 bool is_spectre_bhb_fw_mitigated(void);
 void spectre_bhb_enable_mitigation(const struct arm64_cpu_capabilities *__unused);
 bool try_emulate_el1_ssbs(struct pt_regs *regs, u32 instr);
--- a/arch/arm64/kernel/proton-pack.c
+++ b/arch/arm64/kernel/proton-pack.c
@@ -998,6 +998,11 @@ bool is_spectre_bhb_affected(const struc
 	return true;
 }
 
+u8 get_spectre_bhb_loop_value(void)
+{
+	return max_bhb_k;
+}
+
 static void this_cpu_set_vectors(enum arm64_bp_harden_el1_vectors slot)
 {
 	const char *v = arm64_get_bp_hardening_vector(slot);


