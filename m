Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A430B333A81;
	Wed, 17 Sep 2025 12:55:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758113711; cv=none; b=IYjoVPSXABxVRdN30VFw4MgVuX9TVOmndtKxPpTpArTvp7RjNUZtkP5kre9Q7Wi74Z9AJAFlNrFmyx2SS9JlDwVKKCCOt1+Dctn+bZpTG3tVO6frl0jORuyoXmqbqu8Xx+WZSmPPDuvJ2TP2me7JaT3LLYZ5lOB744ho9K/XGxs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758113711; c=relaxed/simple;
	bh=p2YpnbW9VWLbHQJsguagyLUMyjz/i0YpaNHGLUb4Ebw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Xyv/k6h3go1Chv8B2x0b/BjpspiCDJeD9S0ZB3qSJNYWopbkrLP//S9534z35QGuIYWw06P3o0BgaGO6EuYoWwqFdX0vPNIPtQ46Td1lAj1rjpCYGFZehu9HSUABGxKWJXJUQy9jxWMU94MZo8YkAOcEK3ofLje8UbpE287FMDY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UH2RkwR/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UH2RkwR/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA7B5C4CEF5;
	Wed, 17 Sep 2025 12:55:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758113711;
	bh=p2YpnbW9VWLbHQJsguagyLUMyjz/i0YpaNHGLUb4Ebw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UH2RkwR/ygkU+LKcJQGBAWWv2/p8HvAb362rVh+A3x+tkdrXJhnlZoA9ydfReB+Uu
	 F1F6NMi0HrcVoAhXM6dd/sxae3suFLW8vVhQednWKy3pjfzqmN5r5FzyZztBmX4lO8
	 9iCaYiTQ8riUQojPRelF0f6TuZ5gvt7cE4WmQqxE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jinpu Wang <jinpu.wang@ionos.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Boris Ostrovsky <boris.ostrovsky@oracle.com>
Subject: [PATCH 6.6 030/101] KVM: SVM: Set synthesized TSA CPUID flags
Date: Wed, 17 Sep 2025 14:34:13 +0200
Message-ID: <20250917123337.580789782@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250917123336.863698492@linuxfoundation.org>
References: <20250917123336.863698492@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Borislav Petkov (AMD) <bp@alien8.de>

commit f3f9deccfc68a6b7c8c1cc51e902edba23d309d4 upstream.

VERW_CLEAR is supposed to be set only by the hypervisor to denote TSA
mitigation support to a guest. SQ_NO and L1_NO are both synthesizable,
and are going to be set by hw CPUID on future machines.

So keep the kvm_cpu_cap_init_kvm_defined() invocation *and* set them
when synthesized.

This fix is stable-only.

Co-developed-by: Jinpu Wang <jinpu.wang@ionos.com>
Signed-off-by: Jinpu Wang <jinpu.wang@ionos.com>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Signed-off-by: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
---
 arch/x86/kvm/cpuid.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -791,10 +791,15 @@ void kvm_set_cpu_caps(void)
 		F(PERFMON_V2)
 	);
 
+	kvm_cpu_cap_check_and_set(X86_FEATURE_VERW_CLEAR);
+
 	kvm_cpu_cap_init_kvm_defined(CPUID_8000_0021_ECX,
 		F(TSA_SQ_NO) | F(TSA_L1_NO)
 	);
 
+	kvm_cpu_cap_check_and_set(X86_FEATURE_TSA_SQ_NO);
+	kvm_cpu_cap_check_and_set(X86_FEATURE_TSA_L1_NO);
+
 	/*
 	 * Synthesize "LFENCE is serializing" into the AMD-defined entry in
 	 * KVM's supported CPUID if the feature is reported as supported by the


