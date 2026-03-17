Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 677383F1652;
	Tue, 17 Mar 2026 16:46:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773765973; cv=none; b=ogOgGRIFyN9UbyBhLvjqOSZ/7vdWNanAvvqLBLP6c/AL8smKQ14lPcKlYkr3OMxZkFWyNDFWykhVkQ7l/XXWaF8HQAsbdwBXNPsA7MP9eU2gasn/TIANVFPqjWZkzHCuRKxxTeaU8rle0vAtNrllWfGpcrlvnwi5ZAnjX/tOHEg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773765973; c=relaxed/simple;
	bh=hhLHFM5gPglT3xFhIIlTH8GVyt2RUpG/WXaN3d910u0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H6JDVld2BUo9KNu8REP7uQlObjxAR5JxCmVdh1qIhOvpTavambGSlxx59iadLT0I+pcO8yW/gAtjnFwYwaYirEAfGKfvz7+ZnEEnXIgtMjrD34aXGPm52PgsnZa5EEY60sHxm2ctff9IMHYLYIepJkDC8rN6JmjKpBHF2GZw4nk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=y7cujY/O; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="y7cujY/O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80F77C2BCAF;
	Tue, 17 Mar 2026 16:46:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773765973;
	bh=hhLHFM5gPglT3xFhIIlTH8GVyt2RUpG/WXaN3d910u0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=y7cujY/OY41hAgBMTxieT/QBvdyr6Lh09lju7c5re8hXnaVr/FjlsIw/Y75cIrYPZ
	 Tq2k3EfIFcV6p3dnRgtFLzdpzUmiy/XE7+AbYbpfX3X+x9WCOeDc98jMIh71svbpeu
	 ESUt/F3zISWr7s34/HTSfNiNqwnOF9xxbDWzJ8Lc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vincent Donnefort <vdonnefort@google.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Marc Zyngier <maz@kernel.org>
Subject: [PATCH 6.19 141/378] KVM: arm64: pkvm: Dont reprobe for ICH_VTR_EL2.TDS on CPU hotplug
Date: Tue, 17 Mar 2026 17:31:38 +0100
Message-ID: <20260317163012.200228346@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260317163006.959177102@linuxfoundation.org>
References: <20260317163006.959177102@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marc Zyngier <maz@kernel.org>

commit a79f7b4aeb8e7562cd6dbf9c223e2c2a04b1a85f upstream.

Hotplugging a CPU off and back on fails with pKVM, as we try to
probe for ICH_VTR_EL2.TDS. In a non-VHE setup, this is achieved
by using an EL2 stub helper. However, the stubs are out of reach
once pKVM has deprivileged the kernel. The CPU never boots.

Since pKVM doesn't allow late onlining of CPUs, we can detect
that protected mode is enforced early on, and return the current
state of the capability.

Fixes: 2a28810cbb8b2 ("KVM: arm64: GICv3: Detect and work around the lack of ICV_DIR_EL1 trapping")
Reported-by: Vincent Donnefort <vdonnefort@google.com>
Tested-by: Vincent Donnefort <vdonnefort@google.com>
Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Link: https://patch.msgid.link/20260310085433.3936742-1-maz@kernel.org
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/kernel/cpufeature.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -2336,6 +2336,15 @@ static bool can_trap_icv_dir_el1(const s
 	if (this_cpu_has_cap(ARM64_HAS_GICV5_LEGACY))
 		return true;
 
+	/*
+	 * pKVM prevents late onlining of CPUs. This means that whatever
+	 * state the capability is in after deprivilege cannot be affected
+	 * by a new CPU booting -- this is garanteed to be a CPU we have
+	 * already seen, and the cap is therefore unchanged.
+	 */
+	if (system_capabilities_finalized() && is_protected_kvm_enabled())
+		return cpus_have_final_cap(ARM64_HAS_ICH_HCR_EL2_TDIR);
+
 	if (is_kernel_in_hyp_mode())
 		res.a1 = read_sysreg_s(SYS_ICH_VTR_EL2);
 	else


