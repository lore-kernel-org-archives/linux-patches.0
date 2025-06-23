Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8753223DF0;
	Mon, 23 Jun 2025 22:17:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750717058; cv=none; b=JDph0LLhk68sPSzVfWdvAXfA+H2jh6mlcrApZ8ui7mSrK/tHwsCduOhrsUKh0+VMAVu1uW4LHFMwaRNDaDgDBpmYy44fHyEMFx05AFu9CO4oIoRFHPZJdKt7CpHE67GnXbs8wh2LYiamM+lrogpzTLBzAm48fehFUk+orZIPaXg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750717058; c=relaxed/simple;
	bh=fINyNN2euDq4yOzXAE8Q/tO767/YiKQpTepBK67A2Wc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LAq8r1VYMlinyidikwB+ewRxkTpPQGIh77r5c+fKdKvkZL+HdRdimyczWMJ7dbVsut5VL8vhAtFPIsGmYUvoqQw7q0AdJBhAfcxbkzgwLBrJWuX7AFm6br9TELSZN7e+OQBkbTEQorCmGWBACxpg0xh9p21srbJYg4A8ViTBzfs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qLMOi6eP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qLMOi6eP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81301C4CEEA;
	Mon, 23 Jun 2025 22:17:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750717057;
	bh=fINyNN2euDq4yOzXAE8Q/tO767/YiKQpTepBK67A2Wc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qLMOi6ePzGVvNKAuxIhMvEGtSM0vSWk6Xqe3gdO333hbvsWEg+qRWkr8cQw3Gz8oy
	 m8E3P+flYUsC8fUgmvr7AKvCx7a6W6+UH/I3vE10PfoPFEzwSl87wJB3sj+QG/SGhv
	 1mF9iSl4oTSVxxkKrek5EcxB64T3wGDZG1O2+QWM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	James Morse <james.morse@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Pu Lehui <pulehui@huawei.com>
Subject: [PATCH 5.15 391/411] arm64: proton-pack: Expose whether the platform is mitigated by firmware
Date: Mon, 23 Jun 2025 15:08:55 +0200
Message-ID: <20250623130643.519462687@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130632.993849527@linuxfoundation.org>
References: <20250623130632.993849527@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: James Morse <james.morse@arm.com>

[ Upstream commit e7956c92f396a44eeeb6eaf7a5b5e1ad24db6748 ]

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
Signed-off-by: Pu Lehui <pulehui@huawei.com>
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
+bool is_spectre_bhb_fw_mitigated(void);
 void spectre_bhb_enable_mitigation(const struct arm64_cpu_capabilities *__unused);
 bool try_emulate_el1_ssbs(struct pt_regs *regs, u32 instr);
 #endif	/* __ASSEMBLY__ */
--- a/arch/arm64/kernel/proton-pack.c
+++ b/arch/arm64/kernel/proton-pack.c
@@ -1088,6 +1088,11 @@ void spectre_bhb_enable_mitigation(const
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


