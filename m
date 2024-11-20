Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D9B01A706F;
	Wed, 20 Nov 2024 12:58:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732107526; cv=none; b=J3rjbhkGRErDNsEf41gixZ/8tJKYM5F0HJwuFoAjGpcNx+oclpRhjoJqRtbxrNgR91kEPZKqKCk2UytIqePbmLWdQmDgEKhVbhgiT+P+M5MwjLcG5JDTT5EZklHZoJXjGmP679onhVxvMQGZgTr2BEdxXWJ6P6mXkP58+WNjxdQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732107526; c=relaxed/simple;
	bh=OxTMeCrdfw03CzRm5ZjmZOF8uX889Mux3TmDuAC8n7o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SeA6hN3leAB0BXEAed5AQxSSYlt4WKGxk5fcAuCB+Kyn8D9ZnZoExXwvOoS69XyZPWMOoIMly3KeJh9AJwh7lQ8FygWJfqZeNWNFptdkjIVGSqTM4IuBJJtrnY7U9Ob0KD/mBeGr8RrwqxwzxnG1aQInURu8cJA+MPLq1YdkBvU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Mn61w/pk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Mn61w/pk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2F81C4CECD;
	Wed, 20 Nov 2024 12:58:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1732107526;
	bh=OxTMeCrdfw03CzRm5ZjmZOF8uX889Mux3TmDuAC8n7o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Mn61w/pkZU/RwAld3VK/5VUtxzg2iVIAWUIhUQutih9OIVPFVIadvRSfcq2kAtK47
	 Zn9nTK2aUj0cywfWwrgXaAtsOhWErUWIMWwlNGjgIicmpya2g+0qfZkuKataA0ysl1
	 EUAZsQmGtKRu2GEEuRu7pcidu7VBZBCf2EO1dMOk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Adrian Hunter <adrian.hunter@intel.com>,
	Sean Christopherson <seanjc@google.com>,
	Xiaoyao Li <xiaoyao.li@intel.com>,
	Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 6.11 057/107] KVM: VMX: Bury Intel PT virtualization (guest/host mode) behind CONFIG_BROKEN
Date: Wed, 20 Nov 2024 13:56:32 +0100
Message-ID: <20241120125630.963757771@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241120125629.681745345@linuxfoundation.org>
References: <20241120125629.681745345@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sean Christopherson <seanjc@google.com>

commit aa0d42cacf093a6fcca872edc954f6f812926a17 upstream.

Hide KVM's pt_mode module param behind CONFIG_BROKEN, i.e. disable support
for virtualizing Intel PT via guest/host mode unless BROKEN=y.  There are
myriad bugs in the implementation, some of which are fatal to the guest,
and others which put the stability and health of the host at risk.

For guest fatalities, the most glaring issue is that KVM fails to ensure
tracing is disabled, and *stays* disabled prior to VM-Enter, which is
necessary as hardware disallows loading (the guest's) RTIT_CTL if tracing
is enabled (enforced via a VMX consistency check).  Per the SDM:

  If the logical processor is operating with Intel PT enabled (if
  IA32_RTIT_CTL.TraceEn = 1) at the time of VM entry, the "load
  IA32_RTIT_CTL" VM-entry control must be 0.

On the host side, KVM doesn't validate the guest CPUID configuration
provided by userspace, and even worse, uses the guest configuration to
decide what MSRs to save/load at VM-Enter and VM-Exit.  E.g. configuring
guest CPUID to enumerate more address ranges than are supported in hardware
will result in KVM trying to passthrough, save, and load non-existent MSRs,
which generates a variety of WARNs, ToPA ERRORs in the host, a potential
deadlock, etc.

Fixes: f99e3daf94ff ("KVM: x86: Add Intel PT virtualization work mode")
Cc: stable@vger.kernel.org
Cc: Adrian Hunter <adrian.hunter@intel.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>
Tested-by: Adrian Hunter <adrian.hunter@intel.com>
Message-ID: <20241101185031.1799556-2-seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/vmx/vmx.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -217,9 +217,11 @@ module_param(ple_window_shrink, uint, 04
 static unsigned int ple_window_max        = KVM_VMX_DEFAULT_PLE_WINDOW_MAX;
 module_param(ple_window_max, uint, 0444);
 
-/* Default is SYSTEM mode, 1 for host-guest mode */
+/* Default is SYSTEM mode, 1 for host-guest mode (which is BROKEN) */
 int __read_mostly pt_mode = PT_MODE_SYSTEM;
+#ifdef CONFIG_BROKEN
 module_param(pt_mode, int, S_IRUGO);
+#endif
 
 struct x86_pmu_lbr __ro_after_init vmx_lbr_caps;
 


