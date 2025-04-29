Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B087382C60;
	Tue, 29 Apr 2025 17:01:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745946076; cv=none; b=gbLdBA9bvLwc62OBtyu0pAWOLTl74lIPQB6pgkfVxj1k4e4qINIs1DfJm+JyIj59AOQ5OBcCptBfqBKimtTRJAMXbt+4gM/JLED6drKcxg/srvux0N0HiXObqPdMeEupzDT4eOOK3rVSG75iNpzMBEzEoZqHlFLRNX6pT1Fs6Eo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745946076; c=relaxed/simple;
	bh=dxdJB+hQTlzNq2qG+YyS+AnegeHW8rtyF/3Jkmfx++k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g3/PxxYJGS4m8Tnn9T9ZYo7f73u+gzpPNzPnSeBtgXiv8v1DZEiPOTXbGlNmtYiAphaX5ti4E2DQDnXQS5hv4zuGMTMQ3ZUCu54aq/Z74up/nWjOmAcvtcTaY+KcHD4Aane4kHzl+qTGtIQL+Z0IazOQeEaZztrPLlOns8qKPbw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=q5O07jtQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="q5O07jtQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31D22C4CEE9;
	Tue, 29 Apr 2025 17:01:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745946076;
	bh=dxdJB+hQTlzNq2qG+YyS+AnegeHW8rtyF/3Jkmfx++k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=q5O07jtQZFacUCTr3nHN2usk/x0FcTvZDCe/aPfCKSbKsEdaNFdZH9AiurBu7O1T1
	 gaWQ3kHY7S41t2CNZhb9RswuzLemwnzcEjcXgRFzXrahqGLUnKKu6lHM5Md9ODAO/Q
	 cdAn0OSlMeBqCiZLsPGeZi/Wk0GCVitS3atYRqGw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 6.14 145/311] KVM: x86: Explicitly treat routing entry type changes as changes
Date: Tue, 29 Apr 2025 18:39:42 +0200
Message-ID: <20250429161126.974219164@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161121.011111832@linuxfoundation.org>
References: <20250429161121.011111832@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sean Christopherson <seanjc@google.com>

commit bcda70c56f3e718465cab2aad260cf34183ce1ce upstream.

Explicitly treat type differences as GSI routing changes, as comparing MSI
data between two entries could get a false negative, e.g. if userspace
changed the type but left the type-specific data as-is.

Fixes: 515a0c79e796 ("kvm: irqfd: avoid update unmodified entries of the routing")
Cc: stable@vger.kernel.org
Signed-off-by: Sean Christopherson <seanjc@google.com>
Message-ID: <20250404193923.1413163-4-seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/x86.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -13611,7 +13611,8 @@ int kvm_arch_update_irqfd_routing(struct
 bool kvm_arch_irqfd_route_changed(struct kvm_kernel_irq_routing_entry *old,
 				  struct kvm_kernel_irq_routing_entry *new)
 {
-	if (new->type != KVM_IRQ_ROUTING_MSI)
+	if (old->type != KVM_IRQ_ROUTING_MSI ||
+	    new->type != KVM_IRQ_ROUTING_MSI)
 		return true;
 
 	return !!memcmp(&old->msi, &new->msi, sizeof(new->msi));


