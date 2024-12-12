Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25C3F21C166;
	Thu, 12 Dec 2024 16:14:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734020063; cv=none; b=CPMt7Im9gVvtagWufgqS1sJy2IF2ELvVsfYDbSd8UOzbG6lHk1QD3Xf0U0MkQty1weI331dt47OvEdFURmHL77BnA2pithlI7akQcNrL1057O7DE+2RGXgEA+vfEv+8XKGXUyGe4Oj+Ya61GSeaRIHUIyT/OcglPw3skwsrZPOM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734020063; c=relaxed/simple;
	bh=8VWOQhOJ57JAbXQlquFhiFRRgCWDQT5OBN79U3klwwo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Iu0VQSIjfDkpcWs+vZEyhhg8HeI3H3ynNhgj9LSpVeb6L9DNqg0T0rdXft3pKIlonemj15GCen8ZCVKE2ktWsF22raa2ehse3uhf307Mjub/Mc5AcjU/9W5mcLzoZ0nrjNIQvd8yEiikS4LxIjwtrfOewrKCTRstq7bnw/ELKO8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vlyYsgxx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vlyYsgxx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D589C4CECE;
	Thu, 12 Dec 2024 16:14:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734020063;
	bh=8VWOQhOJ57JAbXQlquFhiFRRgCWDQT5OBN79U3klwwo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vlyYsgxxamaW3kIoYiolUbNiBqj/bk+T2Jrz/hcuqcFbRXUN0wxbLqNdVmNd2xqq7
	 U080LDlc1bkGBSb2lf/XpjvbhdkWBbcNyUWJp0uFGD7NrGMP1yOf5+WcCWOtIBj1v2
	 /eC1SvXLvzw8UnoC6OVzD7RSmpV46h+JdxbCVafI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	Sean Christopherson <seanjc@google.com>,
	Dmitry Osipenko <dmitry.osipenko@collabora.com>,
	Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 6.1 369/772] KVM: x86/mmu: Skip the "try unsync" path iff the old SPTE was a leaf SPTE
Date: Thu, 12 Dec 2024 15:55:14 +0100
Message-ID: <20241212144405.159922775@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144349.797589255@linuxfoundation.org>
References: <20241212144349.797589255@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sean Christopherson <seanjc@google.com>

commit 2867eb782cf7f64c2ac427596133b6f9c3f64b7a upstream.

Apply make_spte()'s optimization to skip trying to unsync shadow pages if
and only if the old SPTE was a leaf SPTE, as non-leaf SPTEs in direct MMUs
are always writable, i.e. could trigger a false positive and incorrectly
lead to KVM creating a SPTE without write-protecting or marking shadow
pages unsync.

This bug only affects the TDP MMU, as the shadow MMU only overwrites a
shadow-present SPTE when synchronizing SPTEs (and only 4KiB SPTEs can be
unsync).  Specifically, mmu_set_spte() drops any non-leaf SPTEs *before*
calling make_spte(), whereas the TDP MMU can do a direct replacement of a
page table with the leaf SPTE.

Opportunistically update the comment to explain why skipping the unsync
stuff is safe, as opposed to simply saying "it's someone else's problem".

Cc: stable@vger.kernel.org
Tested-by: Alex Bennée <alex.bennee@linaro.org>
Signed-off-by: Sean Christopherson <seanjc@google.com>
Tested-by: Dmitry Osipenko <dmitry.osipenko@collabora.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <20241010182427.1434605-5-seanjc@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/mmu/spte.c |   18 +++++++++++++-----
 1 file changed, 13 insertions(+), 5 deletions(-)

--- a/arch/x86/kvm/mmu/spte.c
+++ b/arch/x86/kvm/mmu/spte.c
@@ -194,12 +194,20 @@ bool make_spte(struct kvm_vcpu *vcpu, st
 		spte |= PT_WRITABLE_MASK | shadow_mmu_writable_mask;
 
 		/*
-		 * Optimization: for pte sync, if spte was writable the hash
-		 * lookup is unnecessary (and expensive). Write protection
-		 * is responsibility of kvm_mmu_get_page / kvm_mmu_sync_roots.
-		 * Same reasoning can be applied to dirty page accounting.
+		 * When overwriting an existing leaf SPTE, and the old SPTE was
+		 * writable, skip trying to unsync shadow pages as any relevant
+		 * shadow pages must already be unsync, i.e. the hash lookup is
+		 * unnecessary (and expensive).
+		 *
+		 * The same reasoning applies to dirty page/folio accounting;
+		 * KVM will mark the folio dirty using the old SPTE, thus
+		 * there's no need to immediately mark the new SPTE as dirty.
+		 *
+		 * Note, both cases rely on KVM not changing PFNs without first
+		 * zapping the old SPTE, which is guaranteed by both the shadow
+		 * MMU and the TDP MMU.
 		 */
-		if (is_writable_pte(old_spte))
+		if (is_last_spte(old_spte, level) && is_writable_pte(old_spte))
 			goto out;
 
 		/*


