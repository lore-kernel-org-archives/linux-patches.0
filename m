Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB8DF2528F1;
	Tue, 29 Apr 2025 18:03:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745949840; cv=none; b=j7UXQpyaK/tKOlPI+cklCx5DSm2K4dw1bOGApMLPaSHuxTvHt01Qc4DPg/ixCuDHrlEr7ElLD2coKqXmGMqPRCG6d35LsHf5SlmkrYRxuxdW4+KrZHUlP40EUCDPU7aRD1uxyk1n8x7/HUfrZmxGTB+2d3eEGJ47KR9yh2eHcLw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745949840; c=relaxed/simple;
	bh=fNI11GfI7rO11Fp7y10BC/aUnvhR7IzcaTedoHsdmpw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YvTXuuDZKcdPxc+TjQrYTtCfzdSE3ufxx34sVBgBT1odFykG8/pXJQfLI8pc0Ulf3Pci1OM807L2i5+nHW91S/kJmqxi8zno4mSnbb8Ou7kJ3jIdaAYv/aO7AxHxTzOF0CVwHwHDZMp6h58zLHL/3GtbUXEBX0CAlpUl9NwLQDk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ws51aToD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ws51aToD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7329BC4CEE3;
	Tue, 29 Apr 2025 18:03:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745949839;
	bh=fNI11GfI7rO11Fp7y10BC/aUnvhR7IzcaTedoHsdmpw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ws51aToDWu3QlskP7AS5CJC7zf7uxzJyrq5WGvE1zVNDSLzDUUGOBUfOP17ktO6uj
	 FsFVjfEm5R9/uuJLKo585aokwQHF6eAQMvLEj4pOxqdB2bQJnY0Kg0vmSMXsR0ZDS5
	 hiM8veT+ENI+KvVTzClnBIIUvVZFw0Pv5UK28stc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 6.1 074/167] KVM: x86: Explicitly treat routing entry type changes as changes
Date: Tue, 29 Apr 2025 18:43:02 +0200
Message-ID: <20250429161054.757250941@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161051.743239894@linuxfoundation.org>
References: <20250429161051.743239894@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -13426,7 +13426,8 @@ int kvm_arch_update_irqfd_routing(struct
 bool kvm_arch_irqfd_route_changed(struct kvm_kernel_irq_routing_entry *old,
 				  struct kvm_kernel_irq_routing_entry *new)
 {
-	if (new->type != KVM_IRQ_ROUTING_MSI)
+	if (old->type != KVM_IRQ_ROUTING_MSI ||
+	    new->type != KVM_IRQ_ROUTING_MSI)
 		return true;
 
 	return !!memcmp(&old->msi, &new->msi, sizeof(new->msi));


