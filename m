Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 838571474B0;
	Thu, 11 Apr 2024 10:42:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712832133; cv=none; b=pdJMj6XZ7FtZtnG5rK37J2IZANVWb10kLGUvO4PDaUIrOFW/qpJpGze0L87btX5vy0SuWz9R4bYw+FRTHIZAQHauyORqs8m/8kd+RBXjl5/ftGAgWMVbiek1ty+WFTbXQAQGqRLHKD+Tv18dtTe1zTthvLutiZGGVdBQLg2ZMFs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712832133; c=relaxed/simple;
	bh=H/DI7RwuIdJlRMftocURoonEJsHtqtxaJkocpYEzq9A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jQ/YMo1PxZTlHM94TOWsEfEt40i5diUGeED0HbwtTOsBvrKPJD4Ep1b3zJ4P4+/Sz1Lsh8yXF8nn5DQmrVPfbkHC4DNq3qTA9wES8VQOxzmQ8BtLoZ/VFEs4BdozcuMqDEkgRYrQBDK6oynXz2auI/xipRBg3uFWwCf/pydli3Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TJXC5SpP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TJXC5SpP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07D5BC433C7;
	Thu, 11 Apr 2024 10:42:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712832133;
	bh=H/DI7RwuIdJlRMftocURoonEJsHtqtxaJkocpYEzq9A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TJXC5SpPvV3sQPTOJiQ4+ndMMItGyB7bItWl6oQlGLztxt/pwzmh0swo0n5LUaE+P
	 HLCLrpF5EWv06mTxeQScSqtfub0GyPGY5ufLi/FLsRLN43BXGV4/BIWvE1y/kDzI1R
	 KzVSpWTkBQGSGV1no3Li+I9i/Ft9XLcfb4KDt1IU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sandipan Das <sandipan.das@amd.com>,
	Sean Christopherson <seanjc@google.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Daniel Sneddon <daniel.sneddon@linux.intel.com>
Subject: [PATCH 5.10 241/294] x86/cpufeatures: Add CPUID_LNX_5 to track recently added Linux-defined word
Date: Thu, 11 Apr 2024 11:56:44 +0200
Message-ID: <20240411095442.829808083@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095435.633465671@linuxfoundation.org>
References: <20240411095435.633465671@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sean Christopherson <seanjc@google.com>

commit 8cb4a9a82b21623dbb4b3051dd30d98356cf95bc upstream.

Add CPUID_LNX_5 to track cpufeatures' word 21, and add the appropriate
compile-time assert in KVM to prevent direct lookups on the features in
CPUID_LNX_5.  KVM uses X86_FEATURE_* flags to manage guest CPUID, and so
must translate features that are scattered by Linux from the Linux-defined
bit to the hardware-defined bit, i.e. should never try to directly access
scattered features in guest CPUID.

Opportunistically add NR_CPUID_WORDS to enum cpuid_leafs, along with a
compile-time assert in KVM's CPUID infrastructure to ensure that future
additions update cpuid_leafs along with NCAPINTS.

No functional change intended.

Fixes: 7f274e609f3d ("x86/cpufeatures: Add new word for scattered features")
Cc: Sandipan Das <sandipan.das@amd.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
Acked-by: Dave Hansen <dave.hansen@linux.intel.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Daniel Sneddon <daniel.sneddon@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/include/asm/cpufeature.h |    2 ++
 arch/x86/kvm/cpuid.h              |    2 ++
 2 files changed, 4 insertions(+)

--- a/arch/x86/include/asm/cpufeature.h
+++ b/arch/x86/include/asm/cpufeature.h
@@ -33,6 +33,8 @@ enum cpuid_leafs
 	CPUID_7_EDX,
 	CPUID_8000_001F_EAX,
 	CPUID_8000_0021_EAX,
+	CPUID_LNX_5,
+	NR_CPUID_WORDS,
 };
 
 #ifdef CONFIG_X86_FEATURE_NAMES
--- a/arch/x86/kvm/cpuid.h
+++ b/arch/x86/kvm/cpuid.h
@@ -76,10 +76,12 @@ static const struct cpuid_reg reverse_cp
  */
 static __always_inline void reverse_cpuid_check(unsigned int x86_leaf)
 {
+	BUILD_BUG_ON(NR_CPUID_WORDS != NCAPINTS);
 	BUILD_BUG_ON(x86_leaf == CPUID_LNX_1);
 	BUILD_BUG_ON(x86_leaf == CPUID_LNX_2);
 	BUILD_BUG_ON(x86_leaf == CPUID_LNX_3);
 	BUILD_BUG_ON(x86_leaf == CPUID_LNX_4);
+	BUILD_BUG_ON(x86_leaf == CPUID_LNX_5);
 	BUILD_BUG_ON(x86_leaf >= ARRAY_SIZE(reverse_cpuid));
 	BUILD_BUG_ON(reverse_cpuid[x86_leaf].function == 0);
 }


