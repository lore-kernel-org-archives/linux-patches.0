Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5BD31EE02F;
	Tue, 30 Sep 2025 15:10:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759245035; cv=none; b=rb2/txy6mDbAqpvx++syr2GAm0ogVu4/FAfEtOL5xx68pnmap5v9cS6dspJqTs7eOXY99KRMfXpRVVgXXk9JEsCirpgHBdJQZX0/xMl2XebJTXXfil0Ukxd5A6vlKTYus33Ldsj8JNOZ335i9DADADfHGCF3KScI7znmAV6/FUU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759245035; c=relaxed/simple;
	bh=gO6fEcPnZYX3i+WiCd0WURlWtGSmOtMRYv+oVZd1tfg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DO3p3tPygmhX7dGrHE6fzfxYL4Z36VHqXj7mHEXVXVqbcO+VYeGmeQhLEBqQXtqRJ8bYAl0XBqyEuNACN9VWTzCXMLPBQipPpw+Bs6wFCXtew+3+2Km303eep2g+1A2ywYveigh6O10lZizePKCW6LQrvTApsw6ooGu49S24fOQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WyBbbMpu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WyBbbMpu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FD14C113D0;
	Tue, 30 Sep 2025 15:10:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759245035;
	bh=gO6fEcPnZYX3i+WiCd0WURlWtGSmOtMRYv+oVZd1tfg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WyBbbMpuTpBJWT8tahwzbyWDDkrgIRL236jhlerRM4tMcakoEkK8ow4pIbmiCa99g
	 7nEPakDiXuJL6/kkcx4DKatdC9l/LTs+pmJJAPoHaXLavBKNITBhz4fE1EI58cptW4
	 XHEQYPF6pGo86gj0FeqH5lFLfp7tmR/YOqZP6IOY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jinpu Wang <jinpu.wang@ionos.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Boris Ostrovsky <boris.ostrovsky@oracle.com>
Subject: [PATCH 5.15 019/151] KVM: SVM: Set synthesized TSA CPUID flags
Date: Tue, 30 Sep 2025 16:45:49 +0200
Message-ID: <20250930143828.377952319@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250930143827.587035735@linuxfoundation.org>
References: <20250930143827.587035735@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Borislav Petkov (AMD)" <bp@alien8.de>

Commit f3f9deccfc68a6b7c8c1cc51e902edba23d309d4 LTS

VERW_CLEAR is supposed to be set only by the hypervisor to denote TSA
mitigation support to a guest. SQ_NO and L1_NO are both synthesizable,
and are going to be set by hw CPUID on future machines.

So keep the kvm_cpu_cap_init_kvm_defined() invocation *and* set them
when synthesized.

This fix is stable-only.

Co-developed-by: Jinpu Wang <jinpu.wang@ionos.com>
Signed-off-by: Jinpu Wang <jinpu.wang@ionos.com>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: <stable@vger.kernel.org> # 5.15.y
Signed-off-by: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/cpuid.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -564,10 +564,15 @@ void kvm_set_cpu_caps(void)
 	if (cpu_feature_enabled(X86_FEATURE_SRSO_NO))
 		kvm_cpu_cap_set(X86_FEATURE_SRSO_NO);
 
+	kvm_cpu_cap_check_and_set(X86_FEATURE_VERW_CLEAR);
+
 	kvm_cpu_cap_init_kvm_defined(CPUID_8000_0021_ECX,
 		F(TSA_SQ_NO) | F(TSA_L1_NO)
 	);
 
+	kvm_cpu_cap_check_and_set(X86_FEATURE_TSA_SQ_NO);
+	kvm_cpu_cap_check_and_set(X86_FEATURE_TSA_L1_NO);
+
 	/*
 	 * Hide RDTSCP and RDPID if either feature is reported as supported but
 	 * probing MSR_TSC_AUX failed.  This is purely a sanity check and


