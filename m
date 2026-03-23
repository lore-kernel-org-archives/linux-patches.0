Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FFF1396598;
	Mon, 23 Mar 2026 14:52:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774277567; cv=none; b=mT5jN7+8rieahsdORU2uiXZi+ZVAg5UldhiOH5gOzRv4cOtWBeDHVzmTmUsOJ/NzGKBYOFX9TT6D2V4DacP8gq4G6MR0TuVjBkZPmcAsC100cCFCQAT/ooi6OE3ZrSC88BknJxLroqVLKNfRGS5yihnXR4+JgpfyRIqSutU2I6M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774277567; c=relaxed/simple;
	bh=DkmxhlAbdPbV5eir3oTs36bAwO8smm6H/7wsJEB02RQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HTuiP3OsjO1ZTNsDRLchW3KE22O8yJa3WLLdz2X6DIvAthPai7PcZtfg5Zzva8jQe3YpHsKubF8yti21PaXXsJc3cHepGSlb8rZS6CzoRm3qPOS1+/UZvB97Wo06uSS9N2mVXzoWpa2ONmjXsDFAtPN0kjEwN190AGHtMqY3uNo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jiqkXQVI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jiqkXQVI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03663C4CEF7;
	Mon, 23 Mar 2026 14:52:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774277567;
	bh=DkmxhlAbdPbV5eir3oTs36bAwO8smm6H/7wsJEB02RQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jiqkXQVISzLPRM/NzxHTUuYxdmO/Rkc2XJZ3xDoxPlPtaJdNwS8G99tTC8ZEl8bJh
	 4Fqc1lAWJ3NXBSfzOc8XqrXS0EQXVeV8JueemmaV+xGFtc/AxQKInlKzqgibD7tvBr
	 DnK0Yjj1vOKfLZmJicck8v24sAYNb0xZlfFCqcWM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mathias Krause <minipli@grsecurity.net>,
	Xiaoyao Li <xiaoyao.li@intel.com>,
	Sean Christopherson <seanjc@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 034/567] KVM: x86: Fix KVM_GET_MSRS stack info leak
Date: Mon, 23 Mar 2026 14:39:14 +0100
Message-ID: <20260323134534.630278840@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134533.749096647@linuxfoundation.org>
References: <20260323134533.749096647@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mathias Krause <minipli@grsecurity.net>

[ Upstream commit 3376ca3f1a2075eaa23c5576c47d04d7e8a4adda ]

Commit 6abe9c1386e5 ("KVM: X86: Move ignore_msrs handling upper the
stack") changed the 'ignore_msrs' handling, including sanitizing return
values to the caller. This was fine until commit 12bc2132b15e ("KVM:
X86: Do the same ignore_msrs check for feature msrs") which allowed
non-existing feature MSRs to be ignored, i.e. to not generate an error
on the ioctl() level. It even tried to preserve the sanitization of the
return value. However, the logic is flawed, as '*data' will be
overwritten again with the uninitialized stack value of msr.data.

Fix this by simplifying the logic and always initializing msr.data,
vanishing the need for an additional error exit path.

Fixes: 12bc2132b15e ("KVM: X86: Do the same ignore_msrs check for feature msrs")
Signed-off-by: Mathias Krause <minipli@grsecurity.net>
Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>
Link: https://lore.kernel.org/r/20240203124522.592778-2-minipli@grsecurity.net
Signed-off-by: Sean Christopherson <seanjc@google.com>
Stable-dep-of: 5bb9ac186512 ("KVM: x86: Return "unsupported" instead of "invalid" on access to unsupported PV MSR")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/x86.c | 15 +++++----------
 1 file changed, 5 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 00bbee40dbec2..275dd7dc1d68b 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1719,22 +1719,17 @@ static int do_get_msr_feature(struct kvm_vcpu *vcpu, unsigned index, u64 *data)
 	struct kvm_msr_entry msr;
 	int r;
 
+	/* Unconditionally clear the output for simplicity */
+	msr.data = 0;
 	msr.index = index;
 	r = kvm_get_msr_feature(&msr);
 
-	if (r == KVM_MSR_RET_INVALID) {
-		/* Unconditionally clear the output for simplicity */
-		*data = 0;
-		if (kvm_msr_ignored_check(index, 0, false))
-			r = 0;
-	}
-
-	if (r)
-		return r;
+	if (r == KVM_MSR_RET_INVALID && kvm_msr_ignored_check(index, 0, false))
+		r = 0;
 
 	*data = msr.data;
 
-	return 0;
+	return r;
 }
 
 static bool __kvm_valid_efer(struct kvm_vcpu *vcpu, u64 efer)
-- 
2.51.0



