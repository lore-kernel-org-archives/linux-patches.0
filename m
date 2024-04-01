Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7C921DFF4;
	Mon,  1 Apr 2024 16:57:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711990643; cv=none; b=T+sF5YzpotLG01x5FkdiEZyseQ9Aag3PrnznDigr2glH4+Ph/gFenmmDHqGALRtcQNDE35J7F/2qg212gMuvmntxX2gUWgW08smshkaP9V88Wljr447IJ4yd+xBo1EuV+Izo35Z5x97+fmHjnAHOJwbYaFBBRLuhpgVwsZzPgSs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711990643; c=relaxed/simple;
	bh=BJ9s33zGqxDHmqIRuAsB8dH8hPSitdVPVq4VRgpqkMs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EHVPuuGQSd7JtB6tFZLuDAnWF+zme1aAv3ho58V7xprwyJqChWbAGk4Wfp/dI+KEvgafUYZ1zHzAFkINTMvU/Ya3vRjb/suiytcg8K2FgeemX+1yYFQyyFoWy5rR/DOJiIK5no7cObVA5HIDVaDvgNaikRofkJbWnriEVnVI7ds=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KgvUu3+f; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KgvUu3+f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C057C433F1;
	Mon,  1 Apr 2024 16:57:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711990643;
	bh=BJ9s33zGqxDHmqIRuAsB8dH8hPSitdVPVq4VRgpqkMs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KgvUu3+fcg6nOJWh9D4OwmwcKj5AvH67f46ca8rn59Fk6Ic+O0t933aA47g0lWd/D
	 AvVewST5ZIofTArFJDus7T6t/RBltg185ka1xO3Owq/ZWbaGbX03/xetUVnMwpdMUo
	 lTas2oVmdo0owCtzgymR9Izv7Matur0QjorDdXuk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jim Mattson <jmattson@google.com>,
	Sean Christopherson <seanjc@google.com>
Subject: [PATCH 6.1 005/272] KVM: x86: Use a switch statement and macros in __feature_translate()
Date: Mon,  1 Apr 2024 17:43:15 +0200
Message-ID: <20240401152530.438741679@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152530.237785232@linuxfoundation.org>
References: <20240401152530.237785232@linuxfoundation.org>
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


