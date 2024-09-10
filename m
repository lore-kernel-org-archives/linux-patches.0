Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB0DE18C03D;
	Tue, 10 Sep 2024 09:40:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725961258; cv=none; b=WyFY7qRISXDktN9Hh9eSZEBgt+qzfDrhUYrnWkZb8udpmPx6n2y3QCyWEZfimc+YlLDUMw/9gz1bkW+unU5VcvyURPeF0EP5f91SXgTzRi8bFKP9RpKHIGQMd/bhrHutgtvVoRE+42KNmApK6vinDCss+rr4TTXhkz6ljXIgVXg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725961258; c=relaxed/simple;
	bh=d2WRz4wVUnla3d5wpG3pLbOOJJ9kC0V7Qig4Fbsuvq8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rbjsztEY/jggRiNx02G9UeIrCGNP7TesuMYtNVscYWl1i8MAnqV4y08T//AKSDHfbAwU9y8I9ifPUjB2grhB0vOIxCNaMgo9TgoBBfVlW0E8cEGgu5LfutcUIh1ixKm6g6TSBFAoMfBTvcpL8KWVmKeBT/ROV+ai1fkp0E7cPrg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yNDNxkXC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yNDNxkXC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53916C4CEC6;
	Tue, 10 Sep 2024 09:40:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725961258;
	bh=d2WRz4wVUnla3d5wpG3pLbOOJJ9kC0V7Qig4Fbsuvq8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yNDNxkXCyT8WBZ3EMRQdU4UoyvGJlrSJakB317DJxf4iyntQrE1JzIsoxJnbLLQ4f
	 pkQkDQ/+d58YyIppYn6D54fX/siLtCEN4sKBpSPr18CFkYJ73ec/8wp57Rz+Qu+cz4
	 Li7866ANFk7xUlv2HbvxJAj5PEAMYP7eEc9C7Hlc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jim Mattson <jmattson@google.com>,
	Ravi Bangoria <ravi.bangoria@amd.com>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	Sean Christopherson <seanjc@google.com>
Subject: [PATCH 6.10 010/375] KVM: SVM: Dont advertise Bus Lock Detect to guest if SVM support is missing
Date: Tue, 10 Sep 2024 11:26:47 +0200
Message-ID: <20240910092622.607498977@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092622.245959861@linuxfoundation.org>
References: <20240910092622.245959861@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ravi Bangoria <ravi.bangoria@amd.com>

commit 54950bfe2b69cdc06ef753872b5225e54eb73506 upstream.

If host supports Bus Lock Detect, KVM advertises it to guests even if
SVM support is absent. Additionally, guest wouldn't be able to use it
despite guest CPUID bit being set. Fix it by unconditionally clearing
the feature bit in KVM cpu capability.

Reported-by: Jim Mattson <jmattson@google.com>
Closes: https://lore.kernel.org/r/CALMp9eRet6+v8Y1Q-i6mqPm4hUow_kJNhmVHfOV8tMfuSS=tVg@mail.gmail.com
Fixes: 76ea438b4afc ("KVM: X86: Expose bus lock debug exception to guest")
Cc: stable@vger.kernel.org
Signed-off-by: Ravi Bangoria <ravi.bangoria@amd.com>
Reviewed-by: Jim Mattson <jmattson@google.com>
Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
Link: https://lore.kernel.org/r/20240808062937.1149-4-ravi.bangoria@amd.com
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/svm/svm.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -5223,6 +5223,9 @@ static __init void svm_set_cpu_caps(void
 
 	/* CPUID 0x8000001F (SME/SEV features) */
 	sev_set_cpu_caps();
+
+	/* Don't advertise Bus Lock Detect to guest if SVM support is absent */
+	kvm_cpu_cap_clear(X86_FEATURE_BUS_LOCK_DETECT);
 }
 
 static __init int svm_hardware_setup(void)


