Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B09AA6FBE
	for <patches@lists.linux.dev>; Wed, 30 Nov 2022 18:30:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF1CDC43470;
	Wed, 30 Nov 2022 18:30:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1669833020;
	bh=Jeh2XS0UkkqGLH0521xHt8uSZz1c9exdDApRmP35a1k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lB7KwUuOGMuF18qt3LnPGFgciZ7TmEdNavQmzmqtf8oJi+GSWx86lzSkNHEn40a4T
	 RXr/LViXAo0PrlMq04pIO3Ll0t8MGSmWDwn4cxyOibX2pz5Ey8eAwpxxYJyGlTtldx
	 Mp3QDLmi/ow513qXVGp1KmRXIM83da0k7C2bFGXQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maxim Levitsky <mlevitsk@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5.10 122/162] KVM: x86: nSVM: leave nested mode on vCPU free
Date: Wed, 30 Nov 2022 19:23:23 +0100
Message-Id: <20221130180531.799215876@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221130180528.466039523@linuxfoundation.org>
References: <20221130180528.466039523@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Maxim Levitsky <mlevitsk@redhat.com>

commit 917401f26a6af5756d89b550a8e1bd50cf42b07e upstream.

If the VM was terminated while nested, we free the nested state
while the vCPU still is in nested mode.

Soon a warning will be added for this condition.

Cc: stable@vger.kernel.org
Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
Message-Id: <20221103141351.50662-2-mlevitsk@redhat.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/svm/svm.c |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -1357,6 +1357,7 @@ static void svm_free_vcpu(struct kvm_vcp
 	 */
 	svm_clear_current_vmcb(svm->vmcb);
 
+	svm_leave_nested(vcpu);
 	svm_free_nested(svm);
 
 	__free_page(pfn_to_page(__sme_clr(svm->vmcb_pa) >> PAGE_SHIFT));


