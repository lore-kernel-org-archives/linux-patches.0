Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A3E8377A89;
	Thu, 20 Aug 2026 15:23:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787239389; cv=none; b=ZBIXmH1/lEyjRjnt+jwWtLPOOKcHLxB9E8qykNKxsps7wQukSKLxfRzhK7AUXnUpM5YRhtS5ReEhuNrSnBbwYVSEnW20Hid4ni5vJj7/y1mTIUnDDB0aZRTjFs6dsSybIeM9zvAETMRVKwUxQof45nneRazKmwGsCkFuERdFeNg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787239389; c=relaxed/simple;
	bh=zEvCOBIXMJNnHP/jl42K8kWrsheiyhhWO9O2iY9YSdU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U5ajc5GbaIAcj5nAZas0IFHT1+GGWQLIHtW/zn28T346TCLiPnwxZwXpf8O+Qk9FrXOte75uHHUKdcbCSdtPAGHaJKKl9lTXGqGXUy/cMOH8JceCpwdNZYxKfP8K67O8kHTZ8MlWzyDaldeAn/oWn3un4aiprCPCK/Q9xdy6XRA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dxQGjE9j; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dxQGjE9j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E36ED1F00A3D;
	Thu, 20 Aug 2026 15:23:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787239388;
	bh=wfaEtJpQBpdm6/NTNwCJNaSYWq9f4VJj0dBgzVhofrk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dxQGjE9jb4BP/J06gGinFdz+j/25dN/Y9LcxMr2r1igxLzPWWmexK/YqV9BxQR2i0
	 4eKjWs3c12e8u2f0h0S2rk71E1v+IlLFgansLDGIpUK3m1r/gKrSBeJa54F5kanuYk
	 yaeUYr2UDzTd2gCJU3B/ewaPcn4LGEchrgu+qaU4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Christopherson <seanjc@google.com>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	Ashish Kalra <ashish.kalra@amd.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 015/220] KVM: SVM: Ensure PSP module is initialized if KVM module is built-in
Date: Thu, 20 Aug 2026 16:53:25 +0200
Message-ID: <20260820145223.954560572@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145223.480031205@linuxfoundation.org>
References: <20260820145223.480031205@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sean Christopherson <seanjc@google.com>

[ Upstream commit 44e70718df4fc2fadf1665eb9374df71aeda1f03 ]

The kernel's initcall infrastructure lacks the ability to express
dependencies between initcalls, whereas the modules infrastructure
automatically handles dependencies via symbol loading.  Ensure the
PSP SEV driver is initialized before proceeding in sev_hardware_setup()
if KVM is built-in as the dependency isn't handled by the initcall
infrastructure.

Signed-off-by: Sean Christopherson <seanjc@google.com>
Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
Message-ID: <f78ddb64087df27e7bcb1ae0ab53f55aa0804fab.1739226950.git.ashish.kalra@amd.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/svm/sev.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index bd0344bacaf1e..6a98bfb417ae7 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -2992,6 +2992,16 @@ void __init sev_hardware_setup(void)
 	    WARN_ON_ONCE(!boot_cpu_has(X86_FEATURE_FLUSHBYASID)))
 		goto out;
 
+	/*
+	 * The kernel's initcall infrastructure lacks the ability to express
+	 * dependencies between initcalls, whereas the modules infrastructure
+	 * automatically handles dependencies via symbol loading.  Ensure the
+	 * PSP SEV driver is initialized before proceeding if KVM is built-in,
+	 * as the dependency isn't handled by the initcall infrastructure.
+	 */
+	if (IS_BUILTIN(CONFIG_KVM_AMD) && sev_module_init())
+		goto out;
+
 	/* Retrieve SEV CPUID information */
 	cpuid(0x8000001f, &eax, &ebx, &ecx, &edx);
 
-- 
2.53.0



