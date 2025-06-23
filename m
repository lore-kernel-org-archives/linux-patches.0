Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61BB8221DA8;
	Mon, 23 Jun 2025 21:57:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750715851; cv=none; b=IfuecGgMm3kv8VndgVC0wrXFZIn57AJpyOF4ukrrWL6gyH13HzW/MIPrr6lMOn3mSOCcZvEl42SAAotAETKILmwL1f4OQFUr28+jWbKQ/Vk8dl+nUuIEIwKSEH7Mv5kjMi1c5IGre77XPIv2AhuE+H/GUhZGxSF5+tiXig2zXJg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750715851; c=relaxed/simple;
	bh=a1vvDuXNviOC2TKUVnecYnyWfhHhWbWmGTgEKGpuhYc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ojE+JaPHGK0uZQLkNpfFIP70OFk6JMu1quR9eq6Ft232FeAEBfcXEXVAMtaAsm6CeN3uFj/lShCTmdvJDAbaxg3qZTDeX7T1/rGzOeAzv3WDZDNvE1r0sYbnvNH237HBpqKzUrBxXQbRvfTTRp18HsLp6kYnAJGXQnW9Zdm7F4U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qKgmTneV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qKgmTneV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB312C4CEEA;
	Mon, 23 Jun 2025 21:57:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750715851;
	bh=a1vvDuXNviOC2TKUVnecYnyWfhHhWbWmGTgEKGpuhYc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qKgmTneVXzHgG6fvEjMfcFVzNTX6NYB4+qEqpwRNTpuKXyvB2zRyG1+jPWZgSHZOj
	 UIXtSIBkigMLxu5w/5uJM+IErK9H7nIjVpJNv21xjLSADnVbPu0BDEw3sc0D7dDnG5
	 IgKBU3akV+MgXP6jT8bh3aCLBgTmxOyHU7IoGIWc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	James Morse <james.morse@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Pu Lehui <pulehui@huawei.com>
Subject: [PATCH 5.10 326/355] arm64: proton-pack: Expose whether the platform is mitigated by firmware
Date: Mon, 23 Jun 2025 15:08:47 +0200
Message-ID: <20250623130636.556520652@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130626.716971725@linuxfoundation.org>
References: <20250623130626.716971725@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
[The conflicts were due to not include bitmap of mitigations]
Signed-off-by: Pu Lehui <pulehui@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/include/asm/spectre.h |    1 +
 arch/arm64/kernel/proton-pack.c  |    8 ++++++++
 2 files changed, 9 insertions(+)

--- a/arch/arm64/include/asm/spectre.h
+++ b/arch/arm64/include/asm/spectre.h
@@ -32,6 +32,7 @@ void spectre_v4_enable_task_mitigation(s
 
 enum mitigation_state arm64_get_spectre_bhb_state(void);
 bool is_spectre_bhb_affected(const struct arm64_cpu_capabilities *entry, int scope);
+bool is_spectre_bhb_fw_mitigated(void);
 u8 spectre_bhb_loop_affected(int scope);
 void spectre_bhb_enable_mitigation(const struct arm64_cpu_capabilities *__unused);
 bool try_emulate_el1_ssbs(struct pt_regs *regs, u32 instr);
--- a/arch/arm64/kernel/proton-pack.c
+++ b/arch/arm64/kernel/proton-pack.c
@@ -1059,6 +1059,8 @@ static void kvm_setup_bhb_slot(const cha
 static void kvm_setup_bhb_slot(const char *hyp_vecs_start) { }
 #endif /* CONFIG_KVM */
 
+static bool spectre_bhb_fw_mitigated;
+
 void spectre_bhb_enable_mitigation(const struct arm64_cpu_capabilities *entry)
 {
 	enum mitigation_state fw_state, state = SPECTRE_VULNERABLE;
@@ -1103,12 +1105,18 @@ void spectre_bhb_enable_mitigation(const
 			this_cpu_set_vectors(EL1_VECTOR_BHB_FW);
 
 			state = SPECTRE_MITIGATED;
+			spectre_bhb_fw_mitigated = true;
 		}
 	}
 
 	update_mitigation_state(&spectre_bhb_state, state);
 }
 
+bool is_spectre_bhb_fw_mitigated(void)
+{
+	return spectre_bhb_fw_mitigated;
+}
+
 /* Patched to correct the immediate */
 void noinstr spectre_bhb_patch_loop_iter(struct alt_instr *alt,
 				   __le32 *origptr, __le32 *updptr, int nr_inst)


