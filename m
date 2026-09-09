Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80D10530DE5;
	Wed,  9 Sep 2026 14:03:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788962597; cv=none; b=WiWivMzds2hDdzECJhGV/k62J24AvU7A8b0ke3i3Q41Bm6P5VSnzkAiOZRv7svk1auQbkcdBrgMMvqgcq2BZf38sRc8fuq0S+3JCLuXpS0f7+7s2WEad+2sOcHW4QPWlXB7tFeXU4sUrRDX1O+VAEisZVTUIOLW16uyuiwb4tKU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788962597; c=relaxed/simple;
	bh=GtjlVyYRzZnvVW2BaEk7P2x1+qjiRQ8kdjy0IzFcWv0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cQEvWJ3e9JBjH9laBfmtYo3fvzpZiXokhiwFJNq9UNzGJhoxMSg3imM4SMzHi50Gaw4/LW4QHAsHyMgfFTLZchFqy5AoBFHJsUVaJPGXUsgJiHlcD8p44Jc5ZTR5pwYexqUtemNwNjz9QNzHCLAhkKGRECfnTuYob8p0NwtCQgc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iDCxjehd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iDCxjehd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8FD61F00A3A;
	Wed,  9 Sep 2026 14:03:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788962596;
	bh=80KUw97X6WKtN6e0Y89Qm7RfWaNb7g0p2tFDb+g0ICQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iDCxjehdQYDZJOa7NhFf/8z8XkoNf3Q4vfJxQytSItw1XAcC4VAEA2XdFEA0SeigB
	 i1OORLgxOdvBcG4qMFjKlqf3N83hpSKV0GkbBWhL+Z1hLeF3abueZihhHsrNEvsTTb
	 e4wF8KSn7ed2QCm8DZi2QcleqcA3Tytia7xyadJQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Roth <michael.roth@amd.com>,
	Sean Christopherson <seanjc@google.com>
Subject: [PATCH 7.2 301/556] KVM: x86: Ensure runtime reads of disabled_quirks are resolved once
Date: Wed,  9 Sep 2026 15:39:41 +0200
Message-ID: <20260909134241.266985894@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134230.441546314@linuxfoundation.org>
References: <20260909134230.441546314@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sean Christopherson <seanjc@google.com>

commit ed15cb21999217e549414c128b4a0485debf6278 upstream.

Wrap the sole reader of disabled_quirks with READ_ONCE(), and wrap the
post-VM-creation write to disabled_quirks with WRITE_ONCE(), to ensure
checking the status of a quirk doesn't re-read disabled_quirks *if* the
caller needs such a guarantee.  This will allow splitting the "fast" MMU
zap into front and back halves, without potentially skipping the back
half if SLOT_ZAP_ALL were concurrently disabled (which would be "fine" in
the current code base, but far from ideal).

Cc: stable@vger.kernel.org # 6.12.x
Reviewed-by: Michael Roth <michael.roth@amd.com>
Link: https://patch.msgid.link/20260709204948.1988414-7-seanjc@google.com
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/x86.c |    3 ++-
 arch/x86/kvm/x86.h |    2 +-
 2 files changed, 3 insertions(+), 2 deletions(-)

--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -6737,7 +6737,8 @@ int kvm_vm_ioctl_enable_cap(struct kvm *
 		fallthrough;
 	case KVM_CAP_DISABLE_QUIRKS:
 		mutex_lock(&kvm->lock);
-		kvm->arch.disabled_quirks |= cap->args[0] & kvm_caps.supported_quirks;
+		WRITE_ONCE(kvm->arch.disabled_quirks,
+			   kvm->arch.disabled_quirks | (cap->args[0] & kvm_caps.supported_quirks));
 		mutex_unlock(&kvm->lock);
 		r = 0;
 		break;
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -367,7 +367,7 @@ static inline bool vcpu_match_mmio_gpa(s
 
 static inline bool kvm_check_has_quirk(struct kvm *kvm, u64 quirk)
 {
-	return !(kvm->arch.disabled_quirks & quirk);
+	return !(READ_ONCE(kvm->arch.disabled_quirks) & quirk);
 }
 
 static __always_inline void kvm_request_l1tf_flush_l1d(void)


