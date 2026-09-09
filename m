Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6912585990;
	Wed,  9 Sep 2026 14:25:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788963908; cv=none; b=RfMXFfHgOO1uyYxgJxl4Uc2luew7oxzY7BBpU7JIjDneecqxe+iGuC0zZ3LqMNbwgG+Ta8/6d31vGs4yKrvCtHv8gahZFMRZrdQc/G55SnFpF9PgN/46ZBCxqLbBLYn4BiSK/i+u2vhJ5vGPDdpIYAPBJ4WRNT7ttB0MHIPxYIg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788963908; c=relaxed/simple;
	bh=NMiXWJMGfaY9pEgjuoiUhB+O3zJDyaARedQmZ7Y7z9c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nvVZ5vpRkANV8KW5SFg7e9AaYaU7ZhWTK55F0nonBW8MlusdKAeKZ/GKgymk7zcm+bExlU/ABgV4ZUG03hBoRi89LYnovvc9dFvlaN1GDykhZPJfMxf45t87Ipne4EOdngCE+if3TA27mCx+0EuvwdYWWT0KRmxObTSYFDh6zE0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tjh5Z1LE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tjh5Z1LE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F0E11F00A3A;
	Wed,  9 Sep 2026 14:25:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788963906;
	bh=7NnBZJEgYziuGFJh91fzFp7yZ20+zZ3QkpyVxiQT7Vg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tjh5Z1LExSIL+o/wRvT8P6Vu/S3YwboH0Ng6icsDhUoKcjtObkoB79+S6YKhe6w1o
	 X2v9NZ1rkCkmviLX6GLuX/4wIPmJF9cS7CZmYfR1tcroViFxiQdcLYmM6XOoIiN7Te
	 qZJCHUUI3gX0zgZqROBtKB9Hz0Xbbvk/BO47GK6M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Roth <michael.roth@amd.com>,
	Sean Christopherson <seanjc@google.com>
Subject: [PATCH 6.18 241/583] KVM: x86: Serialize writes to disabled_quirks using kvm->lock
Date: Wed,  9 Sep 2026 15:38:46 +0200
Message-ID: <20260909134246.489708297@linuxfoundation.org>
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

commit ba76b23ed36ab230fc2577aba24f65851114902f upstream.

Protect writes to disabled_quirks with kvm->lock to ensure KVM doesn't
clobber state in the unlikely scenario that userspace disables disparate
quirks from multiple tasks.  More importantly, this will allow wrapping
accesses with {READ,WRITE}_ONCE without "needing" to also guard the writer
with a useless and confusing READ_ONCE (since the RMW wouldn't be atomic
anyways).

Ideally, KVM would disallow disabling quirks once quirks are "live", but
that would be a potentially breaking userspace ABI change, and while all
existing quirks are fully live only after vCPUs have been created, several
MMU-related quirks, IGNORE_GUEST_PAT and SLOT_ZAP_ALL, are partially live
at all times.  Because populating MMUs requires a vCPU, the guest-visible
behavior of IGNORE_GUEST_PAT and SLOT_ZAP_ALL requires a vCPU, but for KVM
itself, processing the quirk (or not) has functional impact, i.e. for all
intents and purposes, KVM can't prevent those quirks from being disabled
after they've been consumed.

Cc: stable@vger.kernel.org # 6.12.x
Reviewed-by: Michael Roth <michael.roth@amd.com>
Link: https://patch.msgid.link/20260709204948.1988414-6-seanjc@google.com
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/x86.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -6774,7 +6774,9 @@ int kvm_vm_ioctl_enable_cap(struct kvm *
 			break;
 		fallthrough;
 	case KVM_CAP_DISABLE_QUIRKS:
+		mutex_lock(&kvm->lock);
 		kvm->arch.disabled_quirks |= cap->args[0] & kvm_caps.supported_quirks;
+		mutex_unlock(&kvm->lock);
 		r = 0;
 		break;
 	case KVM_CAP_SPLIT_IRQCHIP: {


