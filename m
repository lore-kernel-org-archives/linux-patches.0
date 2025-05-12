Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE75B296FB2;
	Mon, 12 May 2025 18:06:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747073210; cv=none; b=vDV7wG4UQezK9KIMtzr/FnxUVLz6NPHDTkFqMRuD7tJHOUC38RjGb3bzG+h6eTnF+HDBU8eDeCtNbyl316yvF+rvwTZm1i7L5UFN63/E19Ll2deC9cT9QVcjhfBQjNkpA1sIHNeEp5x0kSbnRMkjz93K0YCkc6h1jAF9XhqXvtA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747073210; c=relaxed/simple;
	bh=JFMkj1CFhqnwOpBlnJ4maVYwpAl0NrkRVZ2xi9sMwBI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SqznrY9hcU7h/V0Pz92R2j2kjVZUfljA//QMJtReZ2yZ2KJeLK2rqHBDVzZFuDIqSJRs5vzAuHjbrlELmNvY3ZRjEIgnAJAT0PXvaoAZJrMrsxIq+WhwQnTGULx8/rCt7npiMeavev0s4LpZbzvHpAXa5lu1eHgSeRvLQXyJVA4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dZymmXwm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dZymmXwm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52E5FC4CEE9;
	Mon, 12 May 2025 18:06:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747073209;
	bh=JFMkj1CFhqnwOpBlnJ4maVYwpAl0NrkRVZ2xi9sMwBI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dZymmXwmcJpEV/G4W8zOaFWzSINyS5IMW8oZAkYqp1wZn58XJ5kwp4hVAYD+4bcTi
	 Con7/FpMOuSxT9e/4QGBFN5gNevqcZjrEu1X8QFuIpOVEUa3QBReQsyiFo59wkJabC
	 MaZRzZZIMHxXwO/MDQ2xOhgn2YQn10gbZJ4UD+9o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	James Morse <james.morse@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>
Subject: [PATCH 6.12 163/184] arm64: proton-pack: Expose whether the platform is mitigated by firmware
Date: Mon, 12 May 2025 19:46:04 +0200
Message-ID: <20250512172048.451431190@linuxfoundation.org>
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
@@ -97,6 +97,7 @@ enum mitigation_state arm64_get_meltdown
 
 enum mitigation_state arm64_get_spectre_bhb_state(void);
 bool is_spectre_bhb_affected(const struct arm64_cpu_capabilities *entry, int scope);
+bool is_spectre_bhb_fw_mitigated(void);
 void spectre_bhb_enable_mitigation(const struct arm64_cpu_capabilities *__unused);
 bool try_emulate_el1_ssbs(struct pt_regs *regs, u32 instr);
 
--- a/arch/arm64/kernel/proton-pack.c
+++ b/arch/arm64/kernel/proton-pack.c
@@ -1093,6 +1093,11 @@ void spectre_bhb_enable_mitigation(const
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


