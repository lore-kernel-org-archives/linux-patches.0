Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FFC6188733;
	Mon, 23 Dec 2024 16:08:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734970083; cv=none; b=lTN0jtoOMcLCNCg3a1OEPBUo0KbrP3hiJyPPA8nyi7q9zKZ4mQL/Oadv/svtxdL1Eqc1Bik/xjI9PJxqrqeq0xrY3OsKRVPb7GglV0kfuHMXolLWxoZ1ccMM5insFOPLkPlR/aExI+MaZaySq6MEC/ZgFT4Z/Lh33Eu0wto6ex4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734970083; c=relaxed/simple;
	bh=Xf+0LZXTkYtwTwUMQ7HZ9pHdK0M6bAH88umBy2nrbws=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ARRjkZzwuNOkd8HtfACBeqO/pQOmZmQ6kbLG2adI75mmZheCPZedqeLXJbjhAdfLw77NZRGjupt0vHJdHAga1VO8PQUoRnWpRnbuCngafnJ18QTA2YZOViuwXRBv/PWHNNMXSE8sJb8HKnkzMokaMlYSOnOI3g6V1/UCG+VXxIw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BroJqypH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BroJqypH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63086C4CED3;
	Mon, 23 Dec 2024 16:08:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734970083;
	bh=Xf+0LZXTkYtwTwUMQ7HZ9pHdK0M6bAH88umBy2nrbws=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BroJqypH78rLg0dfaUwIlCnGLFKESfboowSC7UiULiubRqvAFj7d/qHxYkN26+xHT
	 LFDO1PSVXHU5+I/bkoGXmMUkFQMC6/fxO9oG0w5ew86JTResUMLHjRRCV5sNnup3zw
	 +N/MgwaR4VtlBL8Tukv+xZ+4xvEu/hHfN/3UBy/c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Simon Pilkington <simonp.git@mailbox.org>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	Sean Christopherson <seanjc@google.com>
Subject: [PATCH 6.12 139/160] KVM: SVM: Allow guest writes to set MSR_AMD64_DE_CFG bits
Date: Mon, 23 Dec 2024 16:59:10 +0100
Message-ID: <20241223155414.167746548@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241223155408.598780301@linuxfoundation.org>
References: <20241223155408.598780301@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sean Christopherson <seanjc@google.com>

commit 4d5163cba43fe96902165606fa54e1aecbbb32de upstream.

Drop KVM's arbitrary behavior of making DE_CFG.LFENCE_SERIALIZE read-only
for the guest, as rejecting writes can lead to guest crashes, e.g. Windows
in particular doesn't gracefully handle unexpected #GPs on the WRMSR, and
nothing in the AMD manuals suggests that LFENCE_SERIALIZE is read-only _if
it exists_.

KVM only allows LFENCE_SERIALIZE to be set, by the guest or host, if the
underlying CPU has X86_FEATURE_LFENCE_RDTSC, i.e. if LFENCE is guaranteed
to be serializing.  So if the guest sets LFENCE_SERIALIZE, KVM will provide
the desired/correct behavior without any additional action (the guest's
value is never stuffed into hardware).  And having LFENCE be serializing
even when it's not _required_ to be is a-ok from a functional perspective.

Fixes: 74a0e79df68a ("KVM: SVM: Disallow guest from changing userspace's MSR_AMD64_DE_CFG value")
Fixes: d1d93fa90f1a ("KVM: SVM: Add MSR-based feature support for serializing LFENCE")
Reported-by: Simon Pilkington <simonp.git@mailbox.org>
Closes: https://lore.kernel.org/all/52914da7-a97b-45ad-86a0-affdf8266c61@mailbox.org
Cc: Tom Lendacky <thomas.lendacky@amd.com>
Cc: stable@vger.kernel.org
Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
Link: https://lore.kernel.org/r/20241211172952.1477605-1-seanjc@google.com
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/svm/svm.c |    9 ---------
 1 file changed, 9 deletions(-)

--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -3199,15 +3199,6 @@ static int svm_set_msr(struct kvm_vcpu *
 		if (data & ~supported_de_cfg)
 			return 1;
 
-		/*
-		 * Don't let the guest change the host-programmed value.  The
-		 * MSR is very model specific, i.e. contains multiple bits that
-		 * are completely unknown to KVM, and the one bit known to KVM
-		 * is simply a reflection of hardware capabilities.
-		 */
-		if (!msr->host_initiated && data != svm->msr_decfg)
-			return 1;
-
 		svm->msr_decfg = data;
 		break;
 	}


