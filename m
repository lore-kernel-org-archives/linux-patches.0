Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73BD9CA5A;
	Tue, 29 Apr 2025 18:13:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745950428; cv=none; b=U5LNLDdoYM/VGXWZcdqPWvPBtDe9RWOKCrPksL1lvrms2WSsoqtUWUzq00mcRfQg9HlUbPHPQc644hz1cjBi+0oxYFf+S3D6tV4b1+AY14EvB1Qhr5ayhgZfRe3RR7JmLVJPfr8SxqeDVaVgpM/Rl51efSogxpO5I46rg0zeA7g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745950428; c=relaxed/simple;
	bh=6C9Hr8suHzeN/USZbq40fB2EKZeI3qwS/6/m3fJDMGA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jv5XHDeAl5AZfYUf49R6G27u1lLvnxMJVg8q5UjiPF0+xDOpRUzjImfGg/cseAly7GOEE/Gdi4+1+2xcPZcO3T5RWNBR6lWaIHuV645YQUXe3ANd6n5RAoG167hByO5uYbkFJl5YiD1LrnZ0TuaDOnFsk2YL0qP1t89xCS600Q0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=D/yxZ/MH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="D/yxZ/MH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89E77C4CEE3;
	Tue, 29 Apr 2025 18:13:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745950427;
	bh=6C9Hr8suHzeN/USZbq40fB2EKZeI3qwS/6/m3fJDMGA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=D/yxZ/MH9NpJF8hBv1Psex1+EyXt1FDjXlnDYaWY4BlDFYy/cHSi7uPP3em8Q6DpQ
	 cV7WV4uTIGbDCMhm66jW9uO7yFWBDlBnP0p5nLQ1miHDdwS5IA04tm1rqKuEae+b6j
	 6CD8Ka8YDn3WJKPqwp+MJRmw5qvbje1gZSRwQva8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 6.6 092/204] KVM: x86: Explicitly treat routing entry type changes as changes
Date: Tue, 29 Apr 2025 18:43:00 +0200
Message-ID: <20250429161103.197286599@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161059.396852607@linuxfoundation.org>
References: <20250429161059.396852607@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -13297,7 +13297,8 @@ int kvm_arch_update_irqfd_routing(struct
 bool kvm_arch_irqfd_route_changed(struct kvm_kernel_irq_routing_entry *old,
 				  struct kvm_kernel_irq_routing_entry *new)
 {
-	if (new->type != KVM_IRQ_ROUTING_MSI)
+	if (old->type != KVM_IRQ_ROUTING_MSI ||
+	    new->type != KVM_IRQ_ROUTING_MSI)
 		return true;
 
 	return !!memcmp(&old->msi, &new->msi, sizeof(new->msi));


