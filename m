Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABBC047A0B0;
	Sat, 12 Sep 2026 11:47:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789213645; cv=none; b=L+OXJWoQdLwTODXUHHXwfqGdkAVurzmKOUcccVm6aSd7y0C4qja2l5lwAA8iEJmgcckjUZuHOLrh0HlX28TcevIK5jp9CXhT4sgqFeO+VqqcAz/LrfS92ljYFZn+rrxCh244162otAKv+mYGVI+KagMVterg1Vkv29Vjj4+mxak=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789213645; c=relaxed/simple;
	bh=dadzTb7wsFje3Sz9K6ZAJ5ERWuAfv1LyppUl885iZaU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tpMzXmHa1eupfK5NhIN3ulZkEiKfsEIL3c++Qk1yNkHufvRie0SStZZAkus0nNnbxKe5KqPu0XFrggmZJG29QI165HN/oOXkAJF2hdsso/zCzPSe25Zk620oj6allm0G6vU6fEpNDpHuC6gyXvyZCbfBKXYki8MUliuDFwzJotk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=H+qV807g; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="H+qV807g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 082191F000FF;
	Sat, 12 Sep 2026 11:47:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789213639;
	bh=71aCTmABezeOc/hlnP26eq8+/w6/ujcTXcAQQBNublA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=H+qV807g+Y/iZB8pgxC8F4ma68XQ8u+1FHjrz882zSi4XHpJTGq8g3lUYHuPpsW/n
	 ptMusIbk8eUwKTiBWQgw99+a+uXPSF5KDnmrfp0GtCxcMfXO0V/ZacHNpnXeeCuYiy
	 hWqXtZgs736awlXfEarhj2XHZ0ugpAg3sGCTIHbs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Roth <michael.roth@amd.com>,
	Sean Christopherson <seanjc@google.com>
Subject: [PATCH 6.12 0163/1376] KVM: x86: Ensure runtime reads of disabled_quirks are resolved once
Date: Sat, 12 Sep 2026 08:43:09 +0200
Message-ID: <20260912065611.184349617@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -6553,7 +6553,8 @@ int kvm_vm_ioctl_enable_cap(struct kvm *
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
@@ -357,7 +357,7 @@ static inline void kvm_register_write(st
 
 static inline bool kvm_check_has_quirk(struct kvm *kvm, u64 quirk)
 {
-	return !(kvm->arch.disabled_quirks & quirk);
+	return !(READ_ONCE(kvm->arch.disabled_quirks) & quirk);
 }
 
 void kvm_inject_realmode_interrupt(struct kvm_vcpu *vcpu, int irq, int inc_eip);


