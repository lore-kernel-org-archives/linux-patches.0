Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21E9314B06C;
	Tue, 10 Sep 2024 10:26:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725963991; cv=none; b=eOwWfbBT+YR4qPMha5xo3enkkT2Yk8ZQgpitnyUdOh9irEtRG46ZVWnqjiqGRNVteYxocSYayld61B7BEFSoYTxflvcQR1T2d98ZJB65/yxEHQdUlPMA1axEJnlyI2lqFjmeYu6KKGfi+szLNZpo50nRKu1mPFd3fd0zDfdEo3U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725963991; c=relaxed/simple;
	bh=piH3Uis5NjimEm6g0995KB3qE+6bboxPfxUCUcUALYc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T1DWSSNq/uTXrU6CY4wEA7SDpCxsNfwck+XUgvDERKEHbYjByZNueOFD4iseaemOq/tUQUC9PdKIXD/LE13F0GAc6OER2DV9sT6KgxhKktvdZ/6ur+SFQzi7uUhKnuGFAkoAnr2O3arlmB9JQgDZEPaxPoqY1F+6eUTSQ03kcF8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2TOtxc/M; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2TOtxc/M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F104C4CEC3;
	Tue, 10 Sep 2024 10:26:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725963991;
	bh=piH3Uis5NjimEm6g0995KB3qE+6bboxPfxUCUcUALYc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2TOtxc/MZqZfrJ2zlEU+9V8tbCMqmFUvgPZaYmkwxBGqcB6hyhFImbY1Epc17/gqo
	 gz6Rk9KVe9KXEFo7W83QAFaBRk7iMcCGhMgIbCbDdRbwhrfUecpNYQ5i0CMTcxyK4I
	 /kvv7/SRWI+tuuIkH3W/NX2aA2ptK0k/cEF3sePA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jim Mattson <jmattson@google.com>,
	Ravi Bangoria <ravi.bangoria@amd.com>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	Sean Christopherson <seanjc@google.com>
Subject: [PATCH 6.6 006/269] KVM: SVM: Dont advertise Bus Lock Detect to guest if SVM support is missing
Date: Tue, 10 Sep 2024 11:29:53 +0200
Message-ID: <20240910092608.461923717@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092608.225137854@linuxfoundation.org>
References: <20240910092608.225137854@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -5178,6 +5178,9 @@ static __init void svm_set_cpu_caps(void
 
 	/* CPUID 0x8000001F (SME/SEV features) */
 	sev_set_cpu_caps();
+
+	/* Don't advertise Bus Lock Detect to guest if SVM support is absent */
+	kvm_cpu_cap_clear(X86_FEATURE_BUS_LOCK_DETECT);
 }
 
 static __init int svm_hardware_setup(void)


