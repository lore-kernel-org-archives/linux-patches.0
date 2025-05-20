Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE575244682;
	Tue, 20 May 2025 13:52:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747749167; cv=none; b=doaGpi15Sv2UJlJHA8IdJXNKw6eQgAqHvc9w8Mh005qRio/9WP7o98h8oPQulUbrGbQgYyfMbKf187M0H31nn4QdWo9UmuaOeMWMkExidTCP06iljvZDeOInFMwlxmgS00L6AU03rFzScJkG96TxqMftFbMBZ+tdXEHW/0cCPlw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747749167; c=relaxed/simple;
	bh=tVk355Rm1Yh/jp3+4QjF2ip+bss+yrc2MF5sYQdau/k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kLrHkeY5hLpgnSadS2NBrvvc84q+o8IOyCSvL0ZNT9P1fDXiKjqmqFt6gA/pFpZUoW2rD9KR0oiz/lwW4VlRPLPawmb/N6e11WGPWfN1U7dl9wvXy2AIUlKlDbXukJ6Zi4y6baCtBVnHPT01jQejq6iMFKxJJQ+dPWLIJItJMVo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UHfusaio; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UHfusaio"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1A2FC4CEE9;
	Tue, 20 May 2025 13:52:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747749166;
	bh=tVk355Rm1Yh/jp3+4QjF2ip+bss+yrc2MF5sYQdau/k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UHfusaioohb2rVOYmOgq1cyF2cGTXHn8J/tutvjI27fdfG3Jfo1jU3XYHuItv4J5G
	 NjT73MCMybh2ndhcOV1BoYgPSE1FzQZ1zbr1uRB2stTkLiB4O7XHBpFNVyMOep7Es+
	 R5xhpU5Yf/8SjkUB7hyBVqm3oP2nJt7/mGVJvYRw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	Alexandre Chartre <alexandre.chartre@oracle.com>
Subject: [PATCH 5.15 18/59] Documentation: x86/bugs/its: Add ITS documentation
Date: Tue, 20 May 2025 15:50:09 +0200
Message-ID: <20250520125754.574994824@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250520125753.836407405@linuxfoundation.org>
References: <20250520125753.836407405@linuxfoundation.org>
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

From: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>

commit 1ac116ce6468670eeda39345a5585df308243dca upstream.

Add the admin-guide for Indirect Target Selection (ITS).

Signed-off-by: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
Reviewed-by: Josh Poimboeuf <jpoimboe@kernel.org>
Reviewed-by: Alexandre Chartre <alexandre.chartre@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/admin-guide/hw-vuln/index.rst                     |    1 
 Documentation/admin-guide/hw-vuln/indirect-target-selection.rst |  156 ++++++++++
 2 files changed, 157 insertions(+)

--- a/Documentation/admin-guide/hw-vuln/index.rst
+++ b/Documentation/admin-guide/hw-vuln/index.rst
@@ -22,3 +22,4 @@ are configurable at compile, boot or run
    gather_data_sampling.rst
    srso
    reg-file-data-sampling
+   indirect-target-selection
--- /dev/null
+++ b/Documentation/admin-guide/hw-vuln/indirect-target-selection.rst
@@ -0,0 +1,156 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+Indirect Target Selection (ITS)
+===============================
+
+ITS is a vulnerability in some Intel CPUs that support Enhanced IBRS and were
+released before Alder Lake. ITS may allow an attacker to control the prediction
+of indirect branches and RETs located in the lower half of a cacheline.
+
+ITS is assigned CVE-2024-28956 with a CVSS score of 4.7 (Medium).
+
+Scope of Impact
+---------------
+- **eIBRS Guest/Host Isolation**: Indirect branches in KVM/kernel may still be
+  predicted with unintended target corresponding to a branch in the guest.
+
+- **Intra-Mode BTI**: In-kernel training such as through cBPF or other native
+  gadgets.
+
+- **Indirect Branch Prediction Barrier (IBPB)**: After an IBPB, indirect
+  branches may still be predicted with targets corresponding to direct branches
+  executed prior to the IBPB. This is fixed by the IPU 2025.1 microcode, which
+  should be available via distro updates. Alternatively microcode can be
+  obtained from Intel's github repository [#f1]_.
+
+Affected CPUs
+-------------
+Below is the list of ITS affected CPUs [#f2]_ [#f3]_:
+
+   ========================  ============  ====================  ===============
+   Common name               Family_Model  eIBRS                 Intra-mode BTI
+                                           Guest/Host Isolation
+   ========================  ============  ====================  ===============
+   SKYLAKE_X (step >= 6)     06_55H        Affected              Affected
+   ICELAKE_X                 06_6AH        Not affected          Affected
+   ICELAKE_D                 06_6CH        Not affected          Affected
+   ICELAKE_L                 06_7EH        Not affected          Affected
+   TIGERLAKE_L               06_8CH        Not affected          Affected
+   TIGERLAKE                 06_8DH        Not affected          Affected
+   KABYLAKE_L (step >= 12)   06_8EH        Affected              Affected
+   KABYLAKE (step >= 13)     06_9EH        Affected              Affected
+   COMETLAKE                 06_A5H        Affected              Affected
+   COMETLAKE_L               06_A6H        Affected              Affected
+   ROCKETLAKE                06_A7H        Not affected          Affected
+   ========================  ============  ====================  ===============
+
+- All affected CPUs enumerate Enhanced IBRS feature.
+- IBPB isolation is affected on all ITS affected CPUs, and need a microcode
+  update for mitigation.
+- None of the affected CPUs enumerate BHI_CTRL which was introduced in Golden
+  Cove (Alder Lake and Sapphire Rapids). This can help guests to determine the
+  host's affected status.
+- Intel Atom CPUs are not affected by ITS.
+
+Mitigation
+----------
+As only the indirect branches and RETs that have their last byte of instruction
+in the lower half of the cacheline are vulnerable to ITS, the basic idea behind
+the mitigation is to not allow indirect branches in the lower half.
+
+This is achieved by relying on existing retpoline support in the kernel, and in
+compilers. ITS-vulnerable retpoline sites are runtime patched to point to newly
+added ITS-safe thunks. These safe thunks consists of indirect branch in the
+second half of the cacheline. Not all retpoline sites are patched to thunks, if
+a retpoline site is evaluated to be ITS-safe, it is replaced with an inline
+indirect branch.
+
+Dynamic thunks
+~~~~~~~~~~~~~~
+From a dynamically allocated pool of safe-thunks, each vulnerable site is
+replaced with a new thunk, such that they get a unique address. This could
+improve the branch prediction accuracy. Also, it is a defense-in-depth measure
+against aliasing.
+
+Note, for simplicity, indirect branches in eBPF programs are always replaced
+with a jump to a static thunk in __x86_indirect_its_thunk_array. If required,
+in future this can be changed to use dynamic thunks.
+
+All vulnerable RETs are replaced with a static thunk, they do not use dynamic
+thunks. This is because RETs get their prediction from RSB mostly that does not
+depend on source address. RETs that underflow RSB may benefit from dynamic
+thunks. But, RETs significantly outnumber indirect branches, and any benefit
+from a unique source address could be outweighed by the increased icache
+footprint and iTLB pressure.
+
+Retpoline
+~~~~~~~~~
+Retpoline sequence also mitigates ITS-unsafe indirect branches. For this
+reason, when retpoline is enabled, ITS mitigation only relocates the RETs to
+safe thunks. Unless user requested the RSB-stuffing mitigation.
+
+Mitigation in guests
+^^^^^^^^^^^^^^^^^^^^
+All guests deploy ITS mitigation by default, irrespective of eIBRS enumeration
+and Family/Model of the guest. This is because eIBRS feature could be hidden
+from a guest. One exception to this is when a guest enumerates BHI_DIS_S, which
+indicates that the guest is running on an unaffected host.
+
+To prevent guests from unnecessarily deploying the mitigation on unaffected
+platforms, Intel has defined ITS_NO bit(62) in MSR IA32_ARCH_CAPABILITIES. When
+a guest sees this bit set, it should not enumerate the ITS bug. Note, this bit
+is not set by any hardware, but is **intended for VMMs to synthesize** it for
+guests as per the host's affected status.
+
+Mitigation options
+^^^^^^^^^^^^^^^^^^
+The ITS mitigation can be controlled using the "indirect_target_selection"
+kernel parameter. The available options are:
+
+   ======== ===================================================================
+   on       (default)  Deploy the "Aligned branch/return thunks" mitigation.
+	    If spectre_v2 mitigation enables retpoline, aligned-thunks are only
+	    deployed for the affected RET instructions. Retpoline mitigates
+	    indirect branches.
+
+   off      Disable ITS mitigation.
+
+   vmexit   Equivalent to "=on" if the CPU is affected by guest/host isolation
+	    part of ITS. Otherwise, mitigation is not deployed. This option is
+	    useful when host userspace is not in the threat model, and only
+	    attacks from guest to host are considered.
+
+   force    Force the ITS bug and deploy the default mitigation.
+   ======== ===================================================================
+
+Sysfs reporting
+---------------
+
+The sysfs file showing ITS mitigation status is:
+
+  /sys/devices/system/cpu/vulnerabilities/indirect_target_selection
+
+Note, microcode mitigation status is not reported in this file.
+
+The possible values in this file are:
+
+.. list-table::
+
+   * - Not affected
+     - The processor is not vulnerable.
+   * - Vulnerable
+     - System is vulnerable and no mitigation has been applied.
+   * - Vulnerable, KVM: Not affected
+     - System is vulnerable to intra-mode BTI, but not affected by eIBRS
+       guest/host isolation.
+   * - Mitigation: Aligned branch/return thunks
+     - The mitigation is enabled, affected indirect branches and RETs are
+       relocated to safe thunks.
+
+References
+----------
+.. [#f1] Microcode repository - https://github.com/intel/Intel-Linux-Processor-Microcode-Data-Files
+
+.. [#f2] Affected Processors list - https://www.intel.com/content/www/us/en/developer/topic-technology/software-security-guidance/processors-affected-consolidated-product-cpu-model.html
+
+.. [#f3] Affected Processors list (machine readable) - https://github.com/intel/Intel-affected-processor-list


