Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C748B2F0661;
	Wed,  9 Sep 2026 14:01:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788962487; cv=none; b=QPcDc7vCt5C+6NA83pRQqCtARoz2dC2kpHEaXLYVka2ijMQwXbMb/rn3ztHQLOM1a+2gwkAYjABrYxZHu/136SkWYJmO5Y8j7NteKYLJkL7uyq5iPokumRwI1MH69oml+fL/OeIQbEPnfiWuZxEyqihximgeJh3i4BntzHxHdQA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788962487; c=relaxed/simple;
	bh=/FRzDD+j3/MbJxdivN/YNtf7ISRNCGtiLkGhCx8aXyk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mDOW+Z76SggMxS0gV9F4r5sBJUDd4oC2uzA+Af7cik3rJyJfxkKYCruNYSX0VmXvBsQ2om4EeH3tFSQiKcP/ptUA9rfp01Z8g5Gtc9tfniPsJipo+uapyYEMTKR703c95C8TYUbfWGnQWmWAlNJPvr1HFSK4USsKhs2KquJjizU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DsnzBy9E; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DsnzBy9E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC4A41F00A3D;
	Wed,  9 Sep 2026 14:01:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788962485;
	bh=eJPXDeE6eWraUb5JBAvQLUuTSK7m8OxVbhxcuFUTqkc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DsnzBy9ETZAGiMjSpylUFE5PshMMjcb92g6uCDAFoKJlxqpFo//nZq3Q/znsNZqDU
	 pigmwwuEEuJJz9XNiDKB+hSJMV0QPKlAbIXK3fJkqJ2TOUPMV3b3tq+f5XwR7aZE9d
	 53lRFixizaDflHygxB2qvO6AuS0ZaISKOdVuxVTk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Matthew Rosato <mjrosato@linux.ibm.com>,
	Claudio Imbrenda <imbrenda@linux.ibm.com>
Subject: [PATCH 7.2 308/556] KVM: s390: Zero initialize data structures for inject_pfault_token
Date: Wed,  9 Sep 2026 15:39:48 +0200
Message-ID: <20260909134241.507490507@linuxfoundation.org>
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

From: Christian Borntraeger <borntraeger@linux.ibm.com>

commit 4e2c7f7cbc27418f9a290399b986c1b85ff93b90 upstream.

__kvm_inject_pfault_token() only sets .type and .u.ext.ext_params2 of
the on-stack struct kvm_s390_irq but the full ext substructure is copied
into the cpu local variable on inject. ext_params and pad contain stale
stack values.

Interrupt delivery only uses ext_params2, so nothing leaks to the guest,
but a host user can use the migration ioctls to get to the data.

Fix by zero-initializing the irq struct.
Do the same for the inti data structure.

Fixes: 383d0b050106 ("KVM: s390: handle pending local interrupts via bitmap")
Cc: stable@vger.kernel.org
Signed-off-by: Christian Borntraeger <borntraeger@linux.ibm.com>
Reviewed-by: Matthew Rosato <mjrosato@linux.ibm.com>
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Message-ID: <20260805110455.7200-3-borntraeger@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/s390/kvm/kvm-s390.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -4477,8 +4477,8 @@ int kvm_s390_try_set_tod_clock(struct kv
 static void __kvm_inject_pfault_token(struct kvm_vcpu *vcpu, bool start_token,
 				     unsigned long token)
 {
-	struct kvm_s390_interrupt inti;
-	struct kvm_s390_irq irq;
+	struct kvm_s390_interrupt inti = {};
+	struct kvm_s390_irq irq = {};
 	struct kvm_s390_interrupt_info *inti_mem = NULL;
 	int ret = 0;
 


