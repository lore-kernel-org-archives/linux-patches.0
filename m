Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B44053FB3B;
	Thu, 13 Feb 2025 15:24:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739460240; cv=none; b=Enwi3JAx/+suoh/m+pCI/FF+IEotZP5iMDVLj1D+9daHaMqbdPiPewvlYTKhaPbnzw2X1ZjlkjbH5HEGgelaACeVsdZBkoLPKJPw3t788zoEXpj70FE2HtfBmco2n97qbs707G4YLOAagI2w832nhPlQjcwo0XcEV9laJepTHDU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739460240; c=relaxed/simple;
	bh=gyOohZ5c8pbIJi3KmmsugaiRekpYyh9Bc20VNY4triM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k6e7ov5wVjtbJLxl7n2NQqIbEywatPlfnMQMsb3QE4obD+/9ivYfwRDXSAbdYLg1HqxCWIR/ghi/PGDbEPxOL956RZZvtvVE2rY6wyzmQb3tEcU/f7Nflz7ow8Itu8hvoNMzfyxWO54mFTMQ4hCFHbFlZOr5cCORNceXeAt3Tl0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YfvVX7d/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YfvVX7d/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FCEEC4CED1;
	Thu, 13 Feb 2025 15:23:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739460240;
	bh=gyOohZ5c8pbIJi3KmmsugaiRekpYyh9Bc20VNY4triM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YfvVX7d/RDpID3cqFJl+igUy/cUl6m41BqrI6vqQQR31ZPGx0bxnvBa2RPpxrBvet
	 Ur76P4m8mHuKFwn2e9trtVimOna50qVBqllUKs9b0JbgB6t2s5G5elEIovrebJ3Aei
	 iq+DPIkJQet5tU83svLr58s2wHHKLzmTMufHcXeA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Christopherson <seanjc@google.com>,
	Dmitry Osipenko <dmitry.osipenko@collabora.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 055/273] KVM: PPC: e500: Mark "struct page" pfn accessed before dropping mmu_lock
Date: Thu, 13 Feb 2025 15:27:07 +0100
Message-ID: <20250213142409.526783170@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142407.354217048@linuxfoundation.org>
References: <20250213142407.354217048@linuxfoundation.org>
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
index 79c6359b18ae3..dc75f025dfe27 100644
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



