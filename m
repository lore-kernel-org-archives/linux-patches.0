Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7481385D85;
	Tue, 12 May 2026 17:44:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778607887; cv=none; b=CIOPWeaIs+1nrj3QenrOw7ez0d9YjCzuhcYyWQ6zMjleKJTEjLkLAVhS49g2XG9xdufiqBwv7rVtnFkM1UCChvqjLGIGxF17CNKaPLT686d0qVkLOnDQJHwEpZvvhgomPn6seuddjj+gNw1r/x6CAR6jzf+G9QvDzKSNth3roiw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778607887; c=relaxed/simple;
	bh=lHRxPlETwdwhPjwPBk5uOsP/2aYAje0npiLUoIQqeLY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LjBOAHi5gR04OWBRhCulB/KtAWzJHBxnHhFQ0iVsuP5DMwHoL4wYU9VBNjpHkcuK6fx3kTSYB8iN9DgE3miIJjrliMwtvGhEG5sO+BUh1b/zIzdoaU1I/si3iYzDds5Q3Fpe2tIdiFVeM4bDivyTWIcQOFA1tzQq0C6uDRRxL4E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=C8jw76Mz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="C8jw76Mz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56748C2BCB0;
	Tue, 12 May 2026 17:44:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778607887;
	bh=lHRxPlETwdwhPjwPBk5uOsP/2aYAje0npiLUoIQqeLY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=C8jw76MziU4vFCwEsjN5PDQJki/Mh709x9KHZR4u5eKOd+09fkJlh0qFRyBPNf9r2
	 gp1t7pBnYSm4gaQU4M7MYYi+dp+q4l+eaDyf0d7gndY7K+843y+882EybEcMeBOqE6
	 0PU30CK/SnO2n1zvGra2nuRPcmOq7qj8TMnBr+68=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fuad Tabba <tabba@google.com>,
	Marc Zyngier <maz@kernel.org>
Subject: [PATCH 6.12 075/206] KVM: arm64: Fix kvm_vcpu_initialized() macro parameter
Date: Tue, 12 May 2026 19:38:47 +0200
Message-ID: <20260512173934.438384283@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260512173932.810559588@linuxfoundation.org>
References: <20260512173932.810559588@linuxfoundation.org>
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

From: Fuad Tabba <tabba@google.com>

commit d89fdda7dd8a488f922e1175e6782f781ba8a23b upstream.

The macro is defined with parameter 'v' but the body references the
literal token 'vcpu' instead, causing it to silently operate on whatever
'vcpu' resolves to in the caller's scope rather than the value passed by
the caller. All current call sites happen to use a variable named 'vcpu',
so the bug is latent.

Fixes: e016333745c7 ("KVM: arm64: Only reset vCPU-scoped feature ID regs once")
Signed-off-by: Fuad Tabba <tabba@google.com>
Link: https://patch.msgid.link/20260424084908.370776-5-tabba@google.com
Signed-off-by: Marc Zyngier <maz@kernel.org>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/include/asm/kvm_host.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -1390,7 +1390,7 @@ static inline bool __vcpu_has_feature(co
 
 #define vcpu_has_feature(v, f)	__vcpu_has_feature(&(v)->kvm->arch, (f))
 
-#define kvm_vcpu_initialized(v) vcpu_get_flag(vcpu, VCPU_INITIALIZED)
+#define kvm_vcpu_initialized(v) vcpu_get_flag(v, VCPU_INITIALIZED)
 
 int kvm_trng_call(struct kvm_vcpu *vcpu);
 #ifdef CONFIG_KVM


