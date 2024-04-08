Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 086F36CDA8;
	Mon,  8 Apr 2024 13:05:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712581507; cv=none; b=PRk2puzUhlwHzrXDBk4vDE2rrGIl3V/EYC+HXqCSyiUMw6gi68ITDAWe+GqSYXscTdAll/8tH2H98NSErUyhT9T0VzCeDbfRN79PaYJpI/8bQV6QxF7qqBh8pkW/2TAjfltPJ+kzAUgKW8hkiLdOlFnmaC/vRizZY+VpNBrKMos=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712581507; c=relaxed/simple;
	bh=WyQJSy9ELpF3w/b/U60AMBrNb5iUCaVMwQPWZLMHEo0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ubM9lIDEqrgzgXSvJqD7caGb+euWLBgI8mFebO6OtUXfrbfkoG4v8H1lw8yIXkyHm6zxj+Gfn9CM3EWzh/XvTe8nmwaTcXatNFIDuEWGPpstc0NrDIld0kN4W2t1CQvKJpo6DhciAoWRSyfmUF9wbrH4/B8C4cZfBHyk+npAA8c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jQyPpaCt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jQyPpaCt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A695C433F1;
	Mon,  8 Apr 2024 13:05:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712581506;
	bh=WyQJSy9ELpF3w/b/U60AMBrNb5iUCaVMwQPWZLMHEo0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jQyPpaCtcVxASL2LrlQUuHjPnZpp993ETz0bNiz7hmkK3pFNeKbHlxWWqoxm0s3Z9
	 aDqzbB40janOCvdFLLlYsm9uPTGkYtyJhsGWAJKO+Zbuf3Ko/HZJj1yljGQzQu/zs0
	 WWrOXouWiHTOe99dljOaJn8siIl//bMPP8YQizGk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sandipan Das <sandipan.das@amd.com>,
	Sean Christopherson <seanjc@google.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 6.1 028/138] x86/cpufeatures: Add CPUID_LNX_5 to track recently added Linux-defined word
Date: Mon,  8 Apr 2024 14:57:22 +0200
Message-ID: <20240408125257.101330576@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125256.218368873@linuxfoundation.org>
References: <20240408125256.218368873@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -83,10 +83,12 @@ static const struct cpuid_reg reverse_cp
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


