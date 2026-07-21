Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91A9346D2B9;
	Tue, 21 Jul 2026 17:14:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784654074; cv=none; b=hXg76kmCDz66DJ5J5hSvjj96KfqnjKjh31+ZpnD8CCYdxrB+Y21VPQjarLvKq1zZtCoIiPJpgY4oJ3cYEINyDjiGI0KVhtzC0Zc8Qbx0JVcsvdIpgUxdaJiQryBK81GCGjFxMd4rEgEGqkptLy4abMDp68dgdPWLCxLpDiXdj2g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784654074; c=relaxed/simple;
	bh=wkW/Sxgl5nBW3UMqDIvmimel3z2pYoeOmZH6vA/Hz2A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oHc+/+LxYGr/gQR8/U0r+9FY9mUYrv8V3B1ypk+oySqwI8AjWxWPRWwDN4QqJZKmCcF/5UVChMj1B0Wwn/di09AL9C1ILj7N0BVCmdrvWDHg5huFmXKImgMvBUTh4sl6Qnc/ITPBeZwpbADcpotQCEbQ7QkGzoZ2apTaM/MgoDU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gDL9xBcO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gDL9xBcO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2E9D1F000E9;
	Tue, 21 Jul 2026 17:14:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784654073;
	bh=X/9C7pFaDyxaBPpnhxV3NyY/eB7JcwM49435hNjvCfg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gDL9xBcOBEgz4Pjv2dKIksi1psoEWlxxMmMINp+XZDZlxTf7b1ubAjjNv8E6e+Ipg
	 RLUDD+dmmQVPwt+DE4S5+yKhnBQTxl0eX2sRgFebRigPoB5rkK66TqnnBCB/Hzo7s4
	 OxrT3nzwOle7aDnPU8naiMFM8lBcF7gAyjuiEHUs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Binbin Wu <binbin.wu@linux.intel.com>,
	Xiaoyao Li <xiaoyao.li@intel.com>,
	Thorsten Blum <thorsten.blum@linux.dev>,
	Sean Christopherson <seanjc@google.com>
Subject: [PATCH 7.1 1565/2077] KVM: TDX: Reject concurrent change to CPUID entry count
Date: Tue, 21 Jul 2026 17:20:38 +0200
Message-ID: <20260721152629.693752289@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Binbin Wu <binbin.wu@linux.intel.com>

commit cfbebb55e5127dc162e73fa8956000055a78606c upstream.

Reject KVM_TDX_INIT_VM if userspace changes cpuid.nent between the
initial read and the subsequent copy of the initialization data.

tdx_td_init() first reads user_data->cpuid.nent to size the flexible
kvm_tdx_init_vm copy.  The copied structure also contains cpuid.nent,
and that field can differ from the value used to size the allocation if
userspace modifies the input concurrently.  setup_tdparams_cpuids() later
passes init_vm->cpuid.nent to kvm_find_cpuid_entry2(), which uses it as
the array bound for the copied entries.

Require the copied count to match the value used to size the allocation
so that CPUID parsing cannot access beyond the entries actually copied.

Fixes: 0bd0a4a1428b ("KVM: TDX: Replace kmalloc + copy_from_user with memdup_user in tdx_td_init()")
Reported-by: Sashiko:gemini-3.1-pro-preview
Cc: <stable@vger.kernel.org>
Signed-off-by: Binbin Wu <binbin.wu@linux.intel.com>
Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>
Reviewed-by: Thorsten Blum <thorsten.blum@linux.dev>
Link: https://patch.msgid.link/20260710035324.3170534-1-binbin.wu@linux.intel.com
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/vmx/tdx.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -2725,7 +2725,11 @@ static int tdx_td_init(struct kvm *kvm,
 		goto out;
 	}
 
-	if (init_vm->cpuid.padding) {
+	/*
+	 * Reject the request if userspace changes cpuid.nent between the
+	 * initial read and the subsequent copy.
+	 */
+	if (init_vm->cpuid.padding || init_vm->cpuid.nent != nr_user_entries) {
 		ret = -EINVAL;
 		goto out;
 	}


