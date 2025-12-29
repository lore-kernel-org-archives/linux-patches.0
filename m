Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7015233343B;
	Mon, 29 Dec 2025 16:31:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767025891; cv=none; b=fe4A3KXZRVtNvEnuupeXpMJ0DOF+XfoPG0RuHC6dfrlwfpdmDgcC1SmVxZoyuFZv78QxlW4BDoOtUeFAFSvbf0o881STozFfSTjcvShQ1M43kBNztHbRe2Q1RMDvy3O86cgivu2plmNH7xcSafvEsTiW/NxhMqNoXW4W4fYfGiE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767025891; c=relaxed/simple;
	bh=GNhsg9CsVbPm3ErOus944og/LkGag1FPhb+J4cGyD20=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PIWTeXUb2rbUQXH3EYkggiOVJ2XDYnFHrxZgq7Uch6UFRARMhk8XWyk5PiheqhqVn+/P8wcutCZDgGiuUGs0cpSIyO8n+NMJkoU8diFA6gk6w7YvrMSQ4LxJZXGbb+NhwFAVjsQ5Z2EiHeNerzDeiuNkOMDoCUu1fEjqKe41IPA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=R1j2u1sm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="R1j2u1sm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D701C16AAE;
	Mon, 29 Dec 2025 16:31:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767025891;
	bh=GNhsg9CsVbPm3ErOus944og/LkGag1FPhb+J4cGyD20=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=R1j2u1sm+u8toqqkyUfLyq3lM6yRCssWM8gFjCyVVS/XFVARHyAorWWYWmNFDX68x
	 ibburjRj5IFOTc7bD4Jzk0wQ0D8AyAWPZuQFjGXCoUPETwizIoH04M2eksydfJnHnu
	 hK3+uztNWHh26XAMVB4abO1R5UWnIQ4QeXlgwdK4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wanpeng Li <wanpengli@tencent.com>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 6.18 346/430] KVM: Fix last_boosted_vcpu index assignment bug
Date: Mon, 29 Dec 2025 17:12:28 +0100
Message-ID: <20251229160737.060779623@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251229160724.139406961@linuxfoundation.org>
References: <20251229160724.139406961@linuxfoundation.org>
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

From: Wanpeng Li <wanpengli@tencent.com>

commit 32bd348be3fa07b26c5ea6b818a161c142dcc2f2 upstream.

In kvm_vcpu_on_spin(), the loop counter 'i' is incorrectly written to
last_boosted_vcpu instead of the actual vCPU index 'idx'. This causes
last_boosted_vcpu to store the loop iteration count rather than the
vCPU index, leading to incorrect round-robin behavior in subsequent
directed yield operations.

Fix this by using 'idx' instead of 'i' in the assignment.

Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
Reviewed-by: Sean Christopherson <seanjc@google.com>
Message-ID: <20251110033232.12538-7-kernellwp@gmail.com>
Cc: stable@vger.kernel.org
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 virt/kvm/kvm_main.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -4026,7 +4026,7 @@ void kvm_vcpu_on_spin(struct kvm_vcpu *m
 
 		yielded = kvm_vcpu_yield_to(vcpu);
 		if (yielded > 0) {
-			WRITE_ONCE(kvm->last_boosted_vcpu, i);
+			WRITE_ONCE(kvm->last_boosted_vcpu, idx);
 			break;
 		} else if (yielded < 0 && !--try) {
 			break;


