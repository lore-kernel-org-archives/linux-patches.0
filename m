Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DF683EDE4A;
	Tue, 12 May 2026 18:06:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778609172; cv=none; b=noqxaYSKGjIzksjcRr+ko76E5j/VuUCP93pD475hMNMz2i/PIxO/O8tS0tgVkhs8c57mdXjxbh/Kegi3tPzJl7+LpMUjNkvHEQicS8BKIaU+OlNcE5N6a+7ftDXjijdnLErtrvvBACivCzEpIK4tdtQdU5APQdj7JanK4sy7fe8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778609172; c=relaxed/simple;
	bh=zaj1fQZW4swbpFs0cO6VjTa5etwUv4RTNBBw8HlX1PY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JJTr5GcT/+KT9J5HDVm307zKqZFzcjoQZk2a9BK1UvfhXLPn9FjSM5Nz9MvAAQSHLlnCfoChhjueYhL6P35ZgyEbmz3Iib62wLB+SwrpmWulcuRWonIvsKvD5JyLLsGtGq7zdVW3BsQ9rnpWw0HLsEoMkdZSh3sbtwnWLPoYKjw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pi86e1iT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pi86e1iT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8AE7C2BCB0;
	Tue, 12 May 2026 18:06:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778609172;
	bh=zaj1fQZW4swbpFs0cO6VjTa5etwUv4RTNBBw8HlX1PY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pi86e1iTDFs2Exxenu7q5zbHVLO7RQCghmEI18EwTuM/i3cpDsbslRyttXvi8Y6Cc
	 03KyGaf5l9mdfb1lRUJmXQkptXXaxKCqiCdmXLkSFMBPqLXxgqXg3pc0ldHsAFWiFx
	 AhYjK/RKs+EfbOAPDJf3ssJWtuu7ccTzPZRJAh2c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fuad Tabba <tabba@google.com>,
	Marc Zyngier <maz@kernel.org>
Subject: [PATCH 7.0 093/307] KVM: arm64: Fix kvm_vcpu_initialized() macro parameter
Date: Tue, 12 May 2026 19:38:08 +0200
Message-ID: <20260512173942.090068053@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260512173940.117428952@linuxfoundation.org>
References: <20260512173940.117428952@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1506,7 +1506,7 @@ static inline bool __vcpu_has_feature(co
 #define kvm_vcpu_has_feature(k, f)	__vcpu_has_feature(&(k)->arch, (f))
 #define vcpu_has_feature(v, f)	__vcpu_has_feature(&(v)->kvm->arch, (f))
 
-#define kvm_vcpu_initialized(v) vcpu_get_flag(vcpu, VCPU_INITIALIZED)
+#define kvm_vcpu_initialized(v) vcpu_get_flag(v, VCPU_INITIALIZED)
 
 int kvm_trng_call(struct kvm_vcpu *vcpu);
 #ifdef CONFIG_KVM


