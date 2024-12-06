Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED22D154BF5;
	Fri,  6 Dec 2024 15:14:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733498068; cv=none; b=W7FKCIA6tCj5s/BVC8ye8xcXiF7wCLdJtMabwyvkTiXjC/MShNgfDcmTF+Nr3HR5S9MwK2Vpx/2tc8LWX4sKz7AHZgfOUQH9xCzgUh5zreQh3ie8FgZE4wfpEfz+DAqsGL7FAIQHHN9CBnFTVIKDsCUCS1io244nTfXuj/BrOAM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733498068; c=relaxed/simple;
	bh=s1cYwgjZ7uMaMbPvTFR5BAIrgjqHkn/bQ0ehirf7s2w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=YUKqwmL6j1fYUDZJwdx1M/zeHLSjK+V8mlkqWXdHeW+qllVpmU1MEMDDtaE3EG1Fhmf0H3CPNb44lkbOr07JlY71Pxg5tdkwpzsb/DzdiaNLPahKDHJKKSDtHmXxfIo28XT0MEJ9iYMflEiLlfXSzqo5MUW6GPE5Z+fDOJAZMpc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ew4h+n9V; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ew4h+n9V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00341C4CED1;
	Fri,  6 Dec 2024 15:14:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733498066;
	bh=s1cYwgjZ7uMaMbPvTFR5BAIrgjqHkn/bQ0ehirf7s2w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ew4h+n9VL/jAq2HOK6rr2NKJAXPcnm/Vvk/PvTyY5qBKcTm2Hf7BQ9EbjDUsuggWC
	 /8GqxCJzZxto4xKon4s3yhaKj+c24oHNnxKK/gkAqxALNtfjpaS+hDKifcUTu5kxYE
	 i7V+SwPUzp82+32cI9yWiPBA9YOdDr3L/Wlongt8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	Sean Christopherson <seanjc@google.com>,
	Dmitry Osipenko <dmitry.osipenko@collabora.com>,
	Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 6.6 476/676] KVM: x86/mmu: Skip the "try unsync" path iff the old SPTE was a leaf SPTE
Date: Fri,  6 Dec 2024 15:34:55 +0100
Message-ID: <20241206143711.957581527@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143653.344873888@linuxfoundation.org>
References: <20241206143653.344873888@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -206,12 +206,20 @@ bool make_spte(struct kvm_vcpu *vcpu, st
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


