Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31045746F
	for <patches@lists.linux.dev>; Sun, 17 Sep 2023 20:39:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30271C433C8;
	Sun, 17 Sep 2023 20:39:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694983154;
	bh=AhJvoylanVcXow1DPU/zIzJDM8Oyo7YE7XTE4dEFLXc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Rl5CWczbhwvfwwkjpwJGlYNkmWOTEXBvDKKaWPya838ymHYCjj42oWFwLiuQOl5YR
	 MbBUfSaT6yfnopHyysQvIMOKs7zfrAi25al2ZyY7GD7d6jpoAKKz/S6/uAhYrOatLY
	 /PXwbUsXLVe6FpqlH3+trb0UwBwDRANsxYvmFpeI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Christopherson <seanjc@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 420/511] x86/virt: Drop unnecessary check on extended CPUID level in cpu_has_svm()
Date: Sun, 17 Sep 2023 21:14:07 +0200
Message-ID: <20230917191123.918725168@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230917191113.831992765@linuxfoundation.org>
References: <20230917191113.831992765@linuxfoundation.org>
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

From: Sean Christopherson <seanjc@google.com>

[ Upstream commit 5df8ecfe3632d5879d1f154f7aa8de441b5d1c89 ]

Drop the explicit check on the extended CPUID level in cpu_has_svm(), the
kernel's cached CPUID info will leave the entire SVM leaf unset if said
leaf is not supported by hardware.  Prior to using cached information,
the check was needed to avoid false positives due to Intel's rather crazy
CPUID behavior of returning the values of the maximum supported leaf if
the specified leaf is unsupported.

Fixes: 682a8108872f ("x86/kvm/svm: Simplify cpu_has_svm()")
Link: https://lore.kernel.org/r/20230721201859.2307736-13-seanjc@google.com
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/include/asm/virtext.h | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/arch/x86/include/asm/virtext.h b/arch/x86/include/asm/virtext.h
index 3b12e6b994123..6c2e3ff3cb28f 100644
--- a/arch/x86/include/asm/virtext.h
+++ b/arch/x86/include/asm/virtext.h
@@ -101,12 +101,6 @@ static inline int cpu_has_svm(const char **msg)
 		return 0;
 	}
 
-	if (boot_cpu_data.extended_cpuid_level < SVM_CPUID_FUNC) {
-		if (msg)
-			*msg = "can't execute cpuid_8000000a";
-		return 0;
-	}
-
 	if (!boot_cpu_has(X86_FEATURE_SVM)) {
 		if (msg)
 			*msg = "svm not available";
-- 
2.40.1



