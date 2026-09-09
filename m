Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E668492E2A;
	Wed,  9 Sep 2026 14:03:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788962606; cv=none; b=iZtcjgkC4yOfrl0d2fztbikamfB/A9ROWMvkH5uW+pcbZ9G66oroJuANCd+DSZqlRmbqphzGkwrxqDyFcCICx4V5eo6qskBQXa+58+f5yR4biXj/dpr/jc2EW8e6MAoeIpVpP/JxZInrbwVWrsqOM4wzUwFhJNdtFeph6b0lYCI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788962606; c=relaxed/simple;
	bh=diPHB0PXiKd7bssCNZfOyPMBIzH66zMe3yDyiPQAjgI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rFSEGsi/XXnzU2tuoEv7cHcuPyFN6Z89ctJ8WaVivcGK9jOYrbyJ3H4qLLRqll7WcrOfAAtP3iZwAI5O4s9LuN2bs4WDOUZPqI2IOAdzliol0HGoj22BVadeUUokTZhkGrMMP0VW+/4/2oh6CelhUzmKWFpTnrqfHGly2KCdn40=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HJfZOUxz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HJfZOUxz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8625C1F00A3A;
	Wed,  9 Sep 2026 14:03:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788962605;
	bh=IbHMNQb6fFdgnpvKzN3AxCXLXgEY3DoL85ZMcDYQxmo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HJfZOUxz0YO+70OqxuWb384Rb7Eh8f7lRcfLvWcC7OT/KWi1JfLeeAI5w8njQg1nQ
	 7zfO2f+gWuw1ySr0cCSZfUcHrmi1U7Kv/LqX7qgKuyzRsfXUL6YUFSjfLKWmZEP9Ft
	 AWntQ2msMyHFZSgJFEDXHltKEyYIcSJjt5u9bfBc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Matthew Rosato <mjrosato@linux.ibm.com>,
	Claudio Imbrenda <imbrenda@linux.ibm.com>
Subject: [PATCH 7.2 304/556] KVM: s390: Fix memory leak in guest debug handling
Date: Wed,  9 Sep 2026 15:39:44 +0200
Message-ID: <20260909134241.374740661@linuxfoundation.org>
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

commit 121ea1de927c8b9bfdf53c31cad27b86d5de0293 upstream.

bp_data is freed only for the error case by kfree(bp_data).
Every successful KVM_SET_GUEST_DEBUG will leak bp_data.

Fixes: 27291e2165b6 ("KVM: s390: hardware support for guest debugging")
Cc: stable@vger.kernel.org
Signed-off-by: Christian Borntraeger <borntraeger@linux.ibm.com>
Reviewed-by: Matthew Rosato <mjrosato@linux.ibm.com>
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Message-ID: <20260805110455.7200-5-borntraeger@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/s390/kvm/guestdbg.c |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/s390/kvm/guestdbg.c
+++ b/arch/s390/kvm/guestdbg.c
@@ -267,6 +267,7 @@ int kvm_s390_import_bp_data(struct kvm_v
 	vcpu->arch.guestdbg.hw_bp_info = bp_info;
 	vcpu->arch.guestdbg.nr_hw_wp = nr_wp;
 	vcpu->arch.guestdbg.hw_wp_info = wp_info;
+	kfree(bp_data);
 	return 0;
 error:
 	kfree(bp_data);


