Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A31B242D6A;
	Tue, 29 Apr 2025 17:30:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745947856; cv=none; b=kszZi2G7uFsSFN+vGBXrpXkMOQxxesx2FdvCQdahYIRd4AG2uvtK6pmgepMBl39iLmJDizxJMWVARKeGmU6O8sh5IQELdFYtO2kGgjfDjhXd5GhNWTDs+MhmUVy4aACLr9YpAmkmITa2rkO0QzHm7SNfVAFpTXpmbHlUoGlTpJI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745947856; c=relaxed/simple;
	bh=Xpg5yPq8HckwW9Eu8Z0EsPgCbNdPP01h0IybCWs8BoI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JBuw2MmS9u5EBPI4BrW4jSfymis70IiBXra4i5Znk35WuJZ9CrwNTIZQfGzzhbvSLpA9e2b/rUj1BXR5855EyOY5UqRK5+UOyBdJ8Y2aqkd1+kKBR9b3N6d43PG/VqEskr9kmKI+F9E5YllttEJqckayycmW4kBIydBP+vQxKhs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qpTspxS9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qpTspxS9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56E59C4CEE3;
	Tue, 29 Apr 2025 17:30:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745947855;
	bh=Xpg5yPq8HckwW9Eu8Z0EsPgCbNdPP01h0IybCWs8BoI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qpTspxS9ZvfsWsRjRcBaZateBi0timb+eC8BBLdPNooT0WGrK1B4DzE22V9XwM+9d
	 s18f9mCz72oPEKbBK9CvXMz9Ts0+KsP/1+3H4hrkfUDNFH4Fnmv+U8uuCDn2kIgLOC
	 QVkp8YA7Ng71xg6OiWLLhIw4P/RwvSL/s1JCMBNE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 6.12 123/280] KVM: x86: Explicitly treat routing entry type changes as changes
Date: Tue, 29 Apr 2025 18:41:04 +0200
Message-ID: <20250429161120.141193717@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161115.008747050@linuxfoundation.org>
References: <20250429161115.008747050@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -13601,7 +13601,8 @@ int kvm_arch_update_irqfd_routing(struct
 bool kvm_arch_irqfd_route_changed(struct kvm_kernel_irq_routing_entry *old,
 				  struct kvm_kernel_irq_routing_entry *new)
 {
-	if (new->type != KVM_IRQ_ROUTING_MSI)
+	if (old->type != KVM_IRQ_ROUTING_MSI ||
+	    new->type != KVM_IRQ_ROUTING_MSI)
 		return true;
 
 	return !!memcmp(&old->msi, &new->msi, sizeof(new->msi));


