Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68EF917A2FE;
	Wed, 19 Feb 2025 09:20:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739956820; cv=none; b=I2s9w8ss1FPGyye/H8oSnMcu+CIw7/cCMAPFYHNCBGH5cp2kiXaBJuO2o7TdzHTh1NpjFrPEIPMEbnosIbXeXljrV8CdnCu+/X0Sr4e4Vs8FgQ1Agoz+4CMpzi16ULCmYdhFU317LurFZZ+2/eG9TkZRNBCWzuCsrBLl7FtG/xY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739956820; c=relaxed/simple;
	bh=q49I7ev2XQVJYXX592a/IhPpMka50/UXutxUd9db264=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YkhDgiawnjAZwp3kzn9vaa7H5mEBj3Zy5KarlcNaiC3EiPFVSZOZE+FQ5O47gpe9x+iSNvuUR4lSO5UVA2qtvKn0LDo35kRVwM2Mse1y5TN/qU641VgtgoId80IK0ZSzIot0BfiI3cgAnAlfFGhxUB2PyEHbgOvs+owj7gicBjs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kCSPuQKQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kCSPuQKQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4B02C4CED1;
	Wed, 19 Feb 2025 09:20:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739956820;
	bh=q49I7ev2XQVJYXX592a/IhPpMka50/UXutxUd9db264=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kCSPuQKQNUjHXNPPpl7MUKGjEF9ILTsuHx3/46ctUOfduxT0grmxDBCjRqqpodJ7d
	 9WOipWERWmbGh6MplADXowPV/vBH7ZeOA2CpRZK8jmhCy5gE/+R7yo7+fkGIHz8lDG
	 KucBis8KPnkOY1gY26OhcDtANgtTHd36S/tYhRw4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Christopherson <seanjc@google.com>,
	Dmitry Osipenko <dmitry.osipenko@collabora.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 310/578] KVM: PPC: e500: Mark "struct page" pfn accessed before dropping mmu_lock
Date: Wed, 19 Feb 2025 09:25:14 +0100
Message-ID: <20250219082705.210203810@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082652.891560343@linuxfoundation.org>
References: <20250219082652.891560343@linuxfoundation.org>
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

[ Upstream commit 84cf78dcd9d65c45ab73998d4ad50f433d53fb93 ]

Mark pages accessed before dropping mmu_lock when faulting in guest memory
so that shadow_map() can convert to kvm_release_faultin_page() without
tripping its lockdep assertion on mmu_lock being held.  Marking pages
accessed outside of mmu_lock is ok (not great, but safe), but marking
pages _dirty_ outside of mmu_lock can make filesystems unhappy.

Signed-off-by: Sean Christopherson <seanjc@google.com>
Tested-by: Dmitry Osipenko <dmitry.osipenko@collabora.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <20241010182427.1434605-54-seanjc@google.com>
Stable-dep-of: 87ecfdbc699c ("KVM: e500: always restore irqs")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/kvm/e500_mmu_host.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/arch/powerpc/kvm/e500_mmu_host.c b/arch/powerpc/kvm/e500_mmu_host.c
index 4a086724db8c4..29f3e3463f400 100644
--- a/arch/powerpc/kvm/e500_mmu_host.c
+++ b/arch/powerpc/kvm/e500_mmu_host.c
@@ -498,11 +498,9 @@ static inline int kvmppc_e500_shadow_map(struct kvmppc_vcpu_e500 *vcpu_e500,
 	kvmppc_mmu_flush_icache(pfn);
 
 out:
-	spin_unlock(&kvm->mmu_lock);
-
 	/* Drop refcount on page, so that mmu notifiers can clear it */
 	kvm_release_pfn_clean(pfn);
-
+	spin_unlock(&kvm->mmu_lock);
 	return ret;
 }
 
-- 
2.39.5



