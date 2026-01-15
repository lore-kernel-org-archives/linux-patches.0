Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 581E426F288;
	Thu, 15 Jan 2026 17:30:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768498207; cv=none; b=C0/weuxsRGrOC+DPh6VGNsd0DnxhHTzGjUZZLWczNAt+FLcWH3XLJZZyvcucp9613rswT7moinMj07CGKW8ZL7rNCXnwW5/bgZ1hk6wHv2G8fuEgUthbVHSibTwyZDZbDuOVUloe0NtJ2eClpgLLo0jayGjYDI7y43xdpw1M8/w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768498207; c=relaxed/simple;
	bh=R1/1wc2z+AkMGXkX0yZt7g4gyy7AqSR82KczRoGMxpc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ARBsXe9d/2ZTny2N0rknC//AgueO8uosYMsl6JeV2IkNMVEzMrlu3B23xxyoJMIhbNitKgIOoaB2LUg5lqkpk6PFscW8yxT3rXdA3xrG4rjYcpX8dz7D0DRRQHYMOOrICOhC7Gpk88gRJUtcX9VIIRVcP1c2FdtE+eSLGVMkvv8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=n3UUpuaJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="n3UUpuaJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 896A6C16AAE;
	Thu, 15 Jan 2026 17:30:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768498206;
	bh=R1/1wc2z+AkMGXkX0yZt7g4gyy7AqSR82KczRoGMxpc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=n3UUpuaJBhSdShLxXVI74UpU0Z41rALU/XRNrSBv85B0Mf3C2zyHVypS/yUeVGoYW
	 5OyxM8gLhSNOZ6iFQ7xXLcNYkWHWCbhWCgI7iuMVjMADvwBgjBkaHUubbck/ZMooFK
	 RErzhTi3/wDc4XLZaVcei+rpz/3YgtZ4p2snO0uY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matteo Rizzo <matteorizzo@google.com>,
	Yosry Ahmed <yosry.ahmed@linux.dev>,
	Sean Christopherson <seanjc@google.com>
Subject: [PATCH 5.15 317/554] KVM: nSVM: Propagate SVM_EXIT_CR0_SEL_WRITE correctly for LMSW emulation
Date: Thu, 15 Jan 2026 17:46:23 +0100
Message-ID: <20260115164257.704519298@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164246.225995385@linuxfoundation.org>
References: <20260115164246.225995385@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yosry Ahmed <yosry.ahmed@linux.dev>

commit 5674a76db0213f9db1e4d08e847ff649b46889c0 upstream.

When emulating L2 instructions, svm_check_intercept() checks whether a
write to CR0 should trigger a synthesized #VMEXIT with
SVM_EXIT_CR0_SEL_WRITE. For MOV-to-CR0, SVM_EXIT_CR0_SEL_WRITE is only
triggered if any bit other than CR0.MP and CR0.TS is updated. However,
according to the APM (24593—Rev.  3.42—March 2024, Table 15-7):

  The LMSW instruction treats the selective CR0-write
  intercept as a non-selective intercept (i.e., it intercepts
  regardless of the value being written).

Skip checking the changed bits for x86_intercept_lmsw and always inject
SVM_EXIT_CR0_SEL_WRITE.

Fixes: cfec82cb7d31 ("KVM: SVM: Add intercept check for emulated cr accesses")
Cc: stable@vger.kernel.org
Reported-by: Matteo Rizzo <matteorizzo@google.com>
Signed-off-by: Yosry Ahmed <yosry.ahmed@linux.dev>
Link: https://patch.msgid.link/20251024192918.3191141-3-yosry.ahmed@linux.dev
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/svm/svm.c |   18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -4214,20 +4214,20 @@ static int svm_check_intercept(struct kv
 					INTERCEPT_SELECTIVE_CR0)))
 			break;
 
-		cr0 = vcpu->arch.cr0 & ~SVM_CR0_SELECTIVE_MASK;
-		val = info->src_val  & ~SVM_CR0_SELECTIVE_MASK;
-
+		/* LMSW always triggers INTERCEPT_SELECTIVE_CR0 */
 		if (info->intercept == x86_intercept_lmsw) {
-			cr0 &= 0xfUL;
-			val &= 0xfUL;
-			/* lmsw can't clear PE - catch this here */
-			if (cr0 & X86_CR0_PE)
-				val |= X86_CR0_PE;
+			icpt_info.exit_code = SVM_EXIT_CR0_SEL_WRITE;
+			break;
 		}
 
+		/*
+		 * MOV-to-CR0 only triggers INTERCEPT_SELECTIVE_CR0 if any bit
+		 * other than SVM_CR0_SELECTIVE_MASK is changed.
+		 */
+		cr0 = vcpu->arch.cr0 & ~SVM_CR0_SELECTIVE_MASK;
+		val = info->src_val  & ~SVM_CR0_SELECTIVE_MASK;
 		if (cr0 ^ val)
 			icpt_info.exit_code = SVM_EXIT_CR0_SEL_WRITE;
-
 		break;
 	}
 	case SVM_EXIT_READ_DR0:


