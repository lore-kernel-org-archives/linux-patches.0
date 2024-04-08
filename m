Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAD987D085;
	Mon,  8 Apr 2024 13:16:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712582201; cv=none; b=bPdBBO+2zoDOIF23oh47hpt6ct4SJgfZJDqCa9Vj3WEdBH1zzICtVZ9EQttGcJZqDIF2ic+CwwXCnf69HlpX08ikrwTn+hsXBJ4e0Qbp8XSEfRgdAQmmZsq2RbroWVzbUP7ZCw6DCdjnp1WUSAGSz6zMk3fa4tA3W9xKouDJ/oQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712582201; c=relaxed/simple;
	bh=RtoX7ZWxTxhUqK8EZ4mZEZ9Mr6eLoydK/C281ciizm0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jomoxJtYMP53NVd8zrU8sTPXp4LUhp2OsJI5RX/HKlF8fuQvIB8uTNksNs+qrZcZsAi5B8eqAWbRBvW286LQUAsfJYGGcU1KLFUAR5kXo87YvQIXdbMknwsjtFsn5MAaJ1cDeGjfU8FP2+BIX/yd4kdz1/t17VlWCanY2Yf+6xk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kDd6GToQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kDd6GToQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE08EC433F1;
	Mon,  8 Apr 2024 13:16:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712582200;
	bh=RtoX7ZWxTxhUqK8EZ4mZEZ9Mr6eLoydK/C281ciizm0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kDd6GToQ8+Ni2Sm+8gSQZsbsm+GGOH23KEHo411EQoFg3MeKKBhwBw96D0OYUAYMB
	 w+pv8T/t6OSSovhAFboK2lV1/Y/vyYbnn6UNl1H/e+QaX+RPgbgdU0FwkI2zDmHdPa
	 b/Zur7/kxlm1lGNMpYopMRH8V11G0OuN77BLX7jA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sandipan Das <sandipan.das@amd.com>,
	Sean Christopherson <seanjc@google.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 6.6 074/252] x86/cpufeatures: Add CPUID_LNX_5 to track recently added Linux-defined word
Date: Mon,  8 Apr 2024 14:56:13 +0200
Message-ID: <20240408125308.928146674@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125306.643546457@linuxfoundation.org>
References: <20240408125306.643546457@linuxfoundation.org>
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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/include/asm/cpufeature.h |    2 ++
 arch/x86/kvm/reverse_cpuid.h      |    2 ++
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
 
 #define X86_CAP_FMT_NUM "%d:%d"
--- a/arch/x86/kvm/reverse_cpuid.h
+++ b/arch/x86/kvm/reverse_cpuid.h
@@ -102,10 +102,12 @@ static const struct cpuid_reg reverse_cp
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


