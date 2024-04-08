Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6656B7C08B;
	Mon,  8 Apr 2024 13:01:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712581294; cv=none; b=KYgjqtOBMG7YZvRHofHPDEcZ1cfcJTA78gmorGPh49rbF2sY1QlTCa1YkX7iPnaE6p3u4+ctglp5qqBqPQREK2gd/tJ8mLF5xvNWI+6lrOoYDNbXYO50F4mnS6MFBvOUXeZyxodXRyoK6295lP66f5J87nWZaMqf4KSldi4KzOw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712581294; c=relaxed/simple;
	bh=VgMR1rDFEV1y3GJzoQEmQDA38KOg0Wdjm115F+JmlVk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AD4x11bfTZe+tfz5iaEbbxIBvN/Z2oRLceHGe2RIbORaPkSsDJdtU8btVck4IGvv4qydbp7nycRy9hMcJ/Lt9qfwWPYjQCe+w1/LGMuP75y/7jvNp2ng8nNKNukCsWH9JRCxhPWwu/Nxp2DpYI0iLPYPXV4zrsp7c3RHAwAMJGg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TzqCkkx6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TzqCkkx6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D49EC433F1;
	Mon,  8 Apr 2024 13:01:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712581294;
	bh=VgMR1rDFEV1y3GJzoQEmQDA38KOg0Wdjm115F+JmlVk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TzqCkkx6Edb2hrvsrs8O9bHomX/vv21zCXsRI9aaE1H0YeI6DlH+7jlwpebUxsqOo
	 1pm3tr2SLTtdX+V0VIycGdj5HcwmpDvFYJ40ScKgwemcIHzQkD6bIM773BZkq7Crf4
	 6uEe/ge5WVNnCpyk4/pa5iP7JMIe2p2XLZrroCNM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jim Mattson <jmattson@google.com>,
	Sean Christopherson <seanjc@google.com>
Subject: [PATCH 5.15 006/690] KVM: x86: Use a switch statement and macros in __feature_translate()
Date: Mon,  8 Apr 2024 14:47:52 +0200
Message-ID: <20240408125359.778217488@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125359.506372836@linuxfoundation.org>
References: <20240408125359.506372836@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jim Mattson <jmattson@google.com>

commit 80c883db87d9ffe2d685e91ba07a087b1c246c78 upstream.

Use a switch statement with macro-generated case statements to handle
translating feature flags in order to reduce the probability of runtime
errors due to copy+paste goofs, to make compile-time errors easier to
debug, and to make the code more readable.

E.g. the compiler won't directly generate an error for duplicate if
statements

	if (x86_feature == X86_FEATURE_SGX1)
		return KVM_X86_FEATURE_SGX1;
	else if (x86_feature == X86_FEATURE_SGX2)
		return KVM_X86_FEATURE_SGX1;

and so instead reverse_cpuid_check() will fail due to the untranslated
entry pointing at a Linux-defined leaf, which provides practically no
hint as to what is broken

  arch/x86/kvm/reverse_cpuid.h:108:2: error: call to __compiletime_assert_450 declared with 'error' attribute:
                                      BUILD_BUG_ON failed: x86_leaf == CPUID_LNX_4
          BUILD_BUG_ON(x86_leaf == CPUID_LNX_4);
          ^
whereas duplicate case statements very explicitly point at the offending
code:

  arch/x86/kvm/reverse_cpuid.h:125:2: error: duplicate case value '361'
          KVM_X86_TRANSLATE_FEATURE(SGX2);
          ^
  arch/x86/kvm/reverse_cpuid.h:124:2: error: duplicate case value '360'
          KVM_X86_TRANSLATE_FEATURE(SGX1);
          ^

And without macros, the opposite type of copy+paste goof doesn't generate
any error at compile-time, e.g. this yields no complaints:

        case X86_FEATURE_SGX1:
                return KVM_X86_FEATURE_SGX1;
        case X86_FEATURE_SGX2:
                return KVM_X86_FEATURE_SGX1;

Note, __feature_translate() is forcibly inlined and the feature is known
at compile-time, so the code generation between an if-elif sequence and a
switch statement should be identical.

Signed-off-by: Jim Mattson <jmattson@google.com>
Link: https://lore.kernel.org/r/20231024001636.890236-2-jmattson@google.com
[sean: use a macro, rewrite changelog]
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/reverse_cpuid.h |   16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

--- a/arch/x86/kvm/reverse_cpuid.h
+++ b/arch/x86/kvm/reverse_cpuid.h
@@ -97,14 +97,16 @@ static __always_inline void reverse_cpui
  */
 static __always_inline u32 __feature_translate(int x86_feature)
 {
-	if (x86_feature == X86_FEATURE_SGX1)
-		return KVM_X86_FEATURE_SGX1;
-	else if (x86_feature == X86_FEATURE_SGX2)
-		return KVM_X86_FEATURE_SGX2;
-	else if (x86_feature == X86_FEATURE_RRSBA_CTRL)
-		return KVM_X86_FEATURE_RRSBA_CTRL;
+#define KVM_X86_TRANSLATE_FEATURE(f)	\
+	case X86_FEATURE_##f: return KVM_X86_FEATURE_##f
 
-	return x86_feature;
+	switch (x86_feature) {
+	KVM_X86_TRANSLATE_FEATURE(SGX1);
+	KVM_X86_TRANSLATE_FEATURE(SGX2);
+	KVM_X86_TRANSLATE_FEATURE(RRSBA_CTRL);
+	default:
+		return x86_feature;
+	}
 }
 
 static __always_inline u32 __feature_leaf(int x86_feature)


