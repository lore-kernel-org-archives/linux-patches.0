Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90656499F0C;
	Wed,  9 Sep 2026 14:25:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788963910; cv=none; b=aIkrf177fUtjB4O9qeUBeJpj+jIiJGL9HMTk1jmQxkxcJjebzPkyoR1bBu6Q3F4xobtxkWShz/e8tHYtuDK6NKVEQmiwrOdr7I1PNCOA6OpcPD100tdYQTcJU++O7JvhuFtLb4HJl97vXbQWAdqQqHuhJnRh8/VLmWTdDq5kytE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788963910; c=relaxed/simple;
	bh=5hKPQ31kPsEIK8torkE6ic+1571BD/9tPqOBKnwuv4s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HH19B3PpbvS/kCrpTOErVqw4SEzxI/I2YpFn1ORwgj0h6hkAyOwju4EF6jlc7W1zFO5yEUag+LsmgC6uVLDS7dRlh8AwUzsxs62uXebAMGZFxNREz08pBPDn7WwHJzI157+PsiAoA/WBuNqKKGZkymznIKqEqIrpPlHKOltQ7ks=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uqpw05A1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uqpw05A1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E84801F00A3A;
	Wed,  9 Sep 2026 14:25:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788963909;
	bh=XheLFyQQHV0WoelUiDUym+KfUeFjEF9JlgV5UFkAjgU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uqpw05A1+WwKZbnax8leQclDUKFVIhM6hJt08YxvhEawMG2kDF5lfNvKcdEh6MLXa
	 Y4eRo+x0ZsFIauEkx7HUJ7B6KJxJn0N5t+U//+n7DUCbXXjrQtHPaPcuWQSvCPRSgL
	 gIJTLPLn027Tsuzs1+uOoil5fPGPhUhH2AgFP9yk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Roth <michael.roth@amd.com>,
	Sean Christopherson <seanjc@google.com>
Subject: [PATCH 6.18 242/583] KVM: x86: Ensure runtime reads of disabled_quirks are resolved once
Date: Wed,  9 Sep 2026 15:38:47 +0200
Message-ID: <20260909134246.522887448@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134237.773280130@linuxfoundation.org>
References: <20260909134237.773280130@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -6775,7 +6775,8 @@ int kvm_vm_ioctl_enable_cap(struct kvm *
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
@@ -417,7 +417,7 @@ static inline void kvm_register_write(st
 
 static inline bool kvm_check_has_quirk(struct kvm *kvm, u64 quirk)
 {
-	return !(kvm->arch.disabled_quirks & quirk);
+	return !(READ_ONCE(kvm->arch.disabled_quirks) & quirk);
 }
 
 void kvm_inject_realmode_interrupt(struct kvm_vcpu *vcpu, int irq, int inc_eip);


